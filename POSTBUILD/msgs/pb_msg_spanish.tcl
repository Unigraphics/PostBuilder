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
#       ::msgcat::mcset pb_msg_spanish "MC(main,title,Unigraphics)"  "Unigraphics"
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

if { [info exists gPB(LANG_TEST)] } {
  #======================================================
  # Return 1 when this language file is ready to be used
  #======================================================
return 1
}


##############################################################################
# Revisions
#
#   Date      Who       Reason
# 17-Jan-2008 gsl - Revised "MC(isv,spec_command,add_sim,Label)" &
#                           "MC(isv,spec_nccode,Label)"
# 05-Mar-2008 gsl - Added "MC(isv,setup,input,Context)"
#                 - "MC(isv,setup,output,Label)" was "MC(isv,setup,outut,Label)"
#                   "MC(isv,setup,output,Context)" was "MC(isv,setup,outut,Context)"
#                 - Revised "MC(isv,setup,output,Context)"
##############################################################################


##------
## Title
##
::msgcat::mcset pb_msg_spanish "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_spanish "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_spanish "MC(main,title,Post_Builder)"            "Creador virtual de postprocesamientos"

::msgcat::mcset pb_msg_spanish "MC(main,title,Version)"                 "Versión"
::msgcat::mcset pb_msg_spanish "MC(main,default,Status)"                "Seleccionar la opción Nuevo o Abrir en el menú Archivo."
::msgcat::mcset pb_msg_spanish "MC(main,save,Status)"                   "Guardar el postprocesamiento."

##------
## File
##
::msgcat::mcset pb_msg_spanish "MC(main,file,Label)"                    "Archivo"

::msgcat::mcset pb_msg_spanish "MC(main,file,Balloon)"                  "\ Nuevo, Abrir, Guardar,\n Guardar\ como, Cerrar y Salir"

::msgcat::mcset pb_msg_spanish "MC(main,file,Context)"                  "\ Nuevo, Abrir, Guardar,\n                            Guardar\ como, Cerrar y Salir"
::msgcat::mcset pb_msg_spanish "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_spanish "MC(main,file,new,Label)"                "Nuevo ..."
::msgcat::mcset pb_msg_spanish "MC(main,file,new,Balloon)"              "Crear un nuevo postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(main,file,new,Context)"              "Crear un nuevo postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(main,file,new,Busy)"                 "Creando un nuevo postprocesamiento..."

::msgcat::mcset pb_msg_spanish "MC(main,file,open,Label)"               "Abrir ..."
::msgcat::mcset pb_msg_spanish "MC(main,file,open,Balloon)"             "Editar un postprocesamiento existente."
::msgcat::mcset pb_msg_spanish "MC(main,file,open,Context)"             "Editar un postprocesamiento existente."
::msgcat::mcset pb_msg_spanish "MC(main,file,open,Busy)"                "Abriendo el postprocesamiento..."

::msgcat::mcset pb_msg_spanish "MC(main,file,mdfa,Label)"               "Importar MDFA ..."
::msgcat::mcset pb_msg_spanish "MC(main,file,mdfa,Balloon)"             "Crear un nuevo postprocesamiento a partir de MDFA."
::msgcat::mcset pb_msg_spanish "MC(main,file,mdfa,Context)"             "Crear un nuevo postprocesamiento a partir de MDFA."

::msgcat::mcset pb_msg_spanish "MC(main,file,save,Label)"               "Guardar"
::msgcat::mcset pb_msg_spanish "MC(main,file,save,Balloon)"             "Guardar el postprocesamiento en curso."
::msgcat::mcset pb_msg_spanish "MC(main,file,save,Context)"             "Guardar el postprocesamiento en curso."
::msgcat::mcset pb_msg_spanish "MC(main,file,save,Busy)"                "Guardando el postprocesamiento ..."

::msgcat::mcset pb_msg_spanish "MC(main,file,save_as,Label)"            "Guardar como ..."
::msgcat::mcset pb_msg_spanish "MC(main,file,save_as,Balloon)"          "Guardar el postprocesamiento con un nuevo nombre."
::msgcat::mcset pb_msg_spanish "MC(main,file,save_as,Context)"          "Guardar el postprocesamiento con un nuevo nombre."

::msgcat::mcset pb_msg_spanish "MC(main,file,close,Label)"              "Cerrar"
::msgcat::mcset pb_msg_spanish "MC(main,file,close,Balloon)"            "Cerrar el postprocesamiento en curso."
::msgcat::mcset pb_msg_spanish "MC(main,file,close,Context)"            "Cerrar el postprocesamiento en curso."

::msgcat::mcset pb_msg_spanish "MC(main,file,exit,Label)"               "Salir"
::msgcat::mcset pb_msg_spanish "MC(main,file,exit,Balloon)"             "Terminar el constructor virtual de postprocesamientos."
::msgcat::mcset pb_msg_spanish "MC(main,file,exit,Context)"             "Terminar el constructor virtual de postprocesamientos."

::msgcat::mcset pb_msg_spanish "MC(main,file,history,Label)"            "Postprocesamientos recientemente abiertos"
::msgcat::mcset pb_msg_spanish "MC(main,file,history,Balloon)"          "Editar un postprocesamiento visitado con anterioridad."
::msgcat::mcset pb_msg_spanish "MC(main,file,history,Context)"          "Editar un postprocesamiento en las sesiones anteriores del constructor virtual de postprocesamientos."

##---------
## Options
##
::msgcat::mcset pb_msg_spanish "MC(main,options,Label)"                 "Opciones"

::msgcat::mcset pb_msg_spanish "MC(main,options,Balloon)"               " Validar\ Personalizar\ Comandos, Copia de seguridad\ Postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_spanish "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_spanish "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_spanish "MC(main,windows,Balloon)"               "La lista de postprocesamiento de edición"
::msgcat::mcset pb_msg_spanish "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_spanish "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_spanish "MC(main,options,properties,Label)"      "Propiedades"
::msgcat::mcset pb_msg_spanish "MC(main,options,properties,Balloon)"    "Propiedades"
::msgcat::mcset pb_msg_spanish "MC(main,options,properties,Context)"    "Propiedades"

::msgcat::mcset pb_msg_spanish "MC(main,options,advisor,Label)"         "Asesor de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(main,options,advisor,Balloon)"       "Asesor de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(main,options,advisor,Context)"       "Activar o Desactivar el asesor de postprocesamientos."

::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,Label)"       "Validar los comandos personalizados"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,Balloon)"     "Validar los comandos personalizados"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,Context)"     "Selecciona la validación de los comandos personalizados"

::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,syntax,Label)"   "Errores de sintaxis"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,command,Label)"  "Comandos desconocidos"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,block,Label)"    "Bloques desconocidos"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,address,Label)"  "Direcciones desconocidas"
::msgcat::mcset pb_msg_spanish "MC(main,options,cmd_check,format,Label)"   "Formatos desconocidos"

::msgcat::mcset pb_msg_spanish "MC(main,options,backup,Label)"          "Postprocesamiento de la copia de seguridad"
::msgcat::mcset pb_msg_spanish "MC(main,options,backup,Balloon)"        "Método por postprocesamiento de la copia de seguridad"
::msgcat::mcset pb_msg_spanish "MC(main,options,backup,Context)"        "Crear copias de seguridad al guardar el postprocesamiento en curso."

::msgcat::mcset pb_msg_spanish "MC(main,options,backup,one,Label)"      "Original de la copia de seguridad"
::msgcat::mcset pb_msg_spanish "MC(main,options,backup,all,Label)"      "Copia de seguridad con cada acción de guardar"
::msgcat::mcset pb_msg_spanish "MC(main,options,backup,none,Label)"     "Sin copia de seguridad"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_spanish "MC(main,utils,Label)"                   "Utilidades"
::msgcat::mcset pb_msg_spanish "MC(main,utils,Balloon)"                 "\ Seleccionar\ MOM\ Variable, Instalar\ Postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_spanish "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_spanish "MC(main,utils,etpdf,Label)"             "Editar el archivo de datos de postprocesamientos de plantillas"

::msgcat::mcset pb_msg_spanish "MC(main,utils,bmv,Label)"               "Examinar las variables MOM"
::msgcat::mcset pb_msg_spanish "MC(main,utils,blic,Label)"              "Examinar las licencias"


##------
## Help
##
::msgcat::mcset pb_msg_spanish "MC(main,help,Label)"                    "Ayuda"
::msgcat::mcset pb_msg_spanish "MC(main,help,Balloon)"                  "Opciones de ayuda"
::msgcat::mcset pb_msg_spanish "MC(main,help,Context)"                  "Opciones de ayuda"
::msgcat::mcset pb_msg_spanish "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_spanish "MC(main,help,bal,Label)"                "Punta del globo"
::msgcat::mcset pb_msg_spanish "MC(main,help,bal,Balloon)"              "Punta del globo sobre los iconos"
::msgcat::mcset pb_msg_spanish "MC(main,help,bal,Context)"              "Activar o desactivar la visualización de las puntas de las herramientas globo para los iconos."

::msgcat::mcset pb_msg_spanish "MC(main,help,chelp,Label)"              "Ayuda sensible en contexto"
::msgcat::mcset pb_msg_spanish "MC(main,help,chelp,Balloon)"            "Ayuda sensible en contexto sobre ítems de diálogo"
::msgcat::mcset pb_msg_spanish "MC(main,help,chelp,Context)"            "Ayuda sensible en contexto sobre ítems de diálogo"

::msgcat::mcset pb_msg_spanish "MC(main,help,what,Label)"               "¿Qué hacer?"
::msgcat::mcset pb_msg_spanish "MC(main,help,what,Balloon)"             "¿Qué puede hacer aquí?"
::msgcat::mcset pb_msg_spanish "MC(main,help,what,Context)"             "¿Qué puede hacer aquí?"

::msgcat::mcset pb_msg_spanish "MC(main,help,dialog,Label)"             "Ayuda sobre el diálogo"
::msgcat::mcset pb_msg_spanish "MC(main,help,dialog,Balloon)"           "Ayuda sobre este diálogo"
::msgcat::mcset pb_msg_spanish "MC(main,help,dialog,Context)"           "Ayuda sobre este diálogo"

::msgcat::mcset pb_msg_spanish "MC(main,help,manual,Label)"             "Manual del usuario"
::msgcat::mcset pb_msg_spanish "MC(main,help,manual,Balloon)"           "Manual de ayuda del usuario"
::msgcat::mcset pb_msg_spanish "MC(main,help,manual,Context)"           "Manual de ayuda del usuario"

::msgcat::mcset pb_msg_spanish "MC(main,help,about,Label)"              "Acerca del constructor virtual de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(main,help,about,Balloon)"            "Acerca del constructor virtual de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(main,help,about,Context)"            "Acerca del constructor virtual de postprocesamientos"

::msgcat::mcset pb_msg_spanish "MC(main,help,rel_note,Label)"           "Notas sobre la versión"
::msgcat::mcset pb_msg_spanish "MC(main,help,rel_note,Balloon)"         "Notas sobre la versión"
::msgcat::mcset pb_msg_spanish "MC(main,help,rel_note,Context)"         "Notas sobre la versión"

::msgcat::mcset pb_msg_spanish "MC(main,help,tcl_man,Label)"            "Manuales de referencia Tcl/Tk"
::msgcat::mcset pb_msg_spanish "MC(main,help,tcl_man,Balloon)"          "Manuales de referencia Tcl/Tk"
::msgcat::mcset pb_msg_spanish "MC(main,help,tcl_man,Context)"          "Manuales de referencia Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_spanish "MC(tool,new,Label)"                     "Nuevo"
::msgcat::mcset pb_msg_spanish "MC(tool,new,Context)"                   "Crear un nuevo postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(tool,open,Label)"                    "Abrir"
::msgcat::mcset pb_msg_spanish "MC(tool,open,Context)"                  "Editar un postprocesamiento existente."

::msgcat::mcset pb_msg_spanish "MC(tool,save,Label)"                    "Guardar"
::msgcat::mcset pb_msg_spanish "MC(tool,save,Context)"                  "Guardar el postprocesamiento en curso."

::msgcat::mcset pb_msg_spanish "MC(tool,bal,Label)"                     "Punta del globo"
::msgcat::mcset pb_msg_spanish "MC(tool,bal,Context)"                   "Activar o desactivar la visualización de las puntas de las herramientas globo para los iconos."

::msgcat::mcset pb_msg_spanish "MC(tool,chelp,Label)"                   "Ayuda sensible en contexto"
::msgcat::mcset pb_msg_spanish "MC(tool,chelp,Context)"                 "Ayuda sensible en contexto sobre ítems de diálogo"

::msgcat::mcset pb_msg_spanish "MC(tool,what,Label)"                    "¿Qué hacer?"
::msgcat::mcset pb_msg_spanish "MC(tool,what,Context)"                  "¿Qué puede hacer aquí?"

::msgcat::mcset pb_msg_spanish "MC(tool,dialog,Label)"                  "Ayuda sobre el diálogo"
::msgcat::mcset pb_msg_spanish "MC(tool,dialog,Context)"                "Ayuda sobre este diálogo"

::msgcat::mcset pb_msg_spanish "MC(tool,manual,Label)"                  "Manual del usuario"
::msgcat::mcset pb_msg_spanish "MC(tool,manual,Context)"                "Manual de ayuda del usuario"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_spanish "MC(msg,error,title)"                    "Error en el constructor virtual de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(msg,dialog,title)"                   "Mensaje del constructor virtual de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(msg,warning)"                        "Aviso"
::msgcat::mcset pb_msg_spanish "MC(msg,error)"                          "Error"
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_data)"                   "Se han introducido datos no válidos en el parámetro."
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_browser_cmd)"            "Comando del explorador no válido:"
::msgcat::mcset pb_msg_spanish "MC(msg,wrong_filename)"                 "Se ha modificado el nombre del archivo."
::msgcat::mcset pb_msg_spanish "MC(msg,user_ctrl_limit)"                "No se puede utilizar un postprocesamiento con licencia como un controlador\n a fin de crear un nuevo postprocesamiento si usted no es el autor del mismo."
::msgcat::mcset pb_msg_spanish "MC(msg,import_limit)"                   "No es el autor del postprocesamiento con licencia.\n No podrá importar los comandos personalizados."
::msgcat::mcset pb_msg_spanish "MC(msg,limit_msg)"                      "No es el autor de este postprocesamiento con licencia."
::msgcat::mcset pb_msg_spanish "MC(msg,no_file)"                        "Falta el archivo cifrado para el postprocesamiento con licencia."
::msgcat::mcset pb_msg_spanish "MC(msg,no_license)"                     "No tiene la licencia correspondiente para realizar esta función."
::msgcat::mcset pb_msg_spanish "MC(msg,no_license_title)"               "Uso sin licencia del constructor virtual de postprocesamientos de UG"
::msgcat::mcset pb_msg_spanish "MC(msg,no_license_dialog)"              "Puede utilizar el constructor virtual de postprocesamientos de UG\n sin la licencia correspondiente.  Pero, no podrá\n guardar el trabajo posteriormente."
::msgcat::mcset pb_msg_spanish "MC(msg,pending)"                        "Se implementará el servicio de esta opción en una versión futura."
::msgcat::mcset pb_msg_spanish "MC(msg,save)"                           "¿Desea guardar los cambios\nantes de cerrar el postprocesamiento en curso?"
::msgcat::mcset pb_msg_spanish "MC(msg,version_check)"                  "No se puede abrir el postprocesamiento creado con la nueva versión del constructor virtual de postprocesamientos en esta versión."

::msgcat::mcset pb_msg_spanish "MC(msg,file_corruption)"                "Contenido incorrecto en el archivo de sesiones del Constructor virtual de postprocesamientos."
::msgcat::mcset pb_msg_spanish "MC(msg,bad_tcl_file)"                   "Contenido incorrecto en el archivo Tcl de su postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,bad_def_file)"                   "Contenido incorrecto en el archivo de definción de su postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_post)"                   "Deberá especficar por lo menos un conjunto de archivos de Tcl y de definición para su postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_dir)"                    "El directorio no existe."
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_file)"                   "Archivo no encontrado o no válido."
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_def_file)"               "No se puede abrir el archivo de definición"
::msgcat::mcset pb_msg_spanish "MC(msg,invalid_tcl_file)"               "No se puede abrir el archivo manipulador de eventos"
::msgcat::mcset pb_msg_spanish "MC(msg,dir_perm)"                       "No dispone del permiso de escritura con respecto al directorio:"
::msgcat::mcset pb_msg_spanish "MC(msg,file_perm)"                      "No disponde del permiso de escritura con respecto a"

::msgcat::mcset pb_msg_spanish "MC(msg,file_exist)"                     "ya existe.  \n¿Desea reemplazarlos de todos modos?"
::msgcat::mcset pb_msg_spanish "MC(msg,file_missing)"                   "Faltan algunos o todos los archivos de este postprocesamiento.\n No puede abrir este postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,sub_dialog_open)"                "Debe completar la edición de todos los subdiálogos de parámetros antes de guardar el postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,generic)"                        "Se ha implementado el constructor virtual de postprocesamientos solamente para las máquinas de fresado genérico."
::msgcat::mcset pb_msg_spanish "MC(msg,min_word)"                       "Un bloque debe contener por lo menos una palabra."
::msgcat::mcset pb_msg_spanish "MC(msg,name_exists)"                    "ya existe. \n Especifique otro nombre."
::msgcat::mcset pb_msg_spanish "MC(msg,in_use)"                         "Este componente ya está en uso.\n No se puede eliminar."
::msgcat::mcset pb_msg_spanish "MC(msg,do_you_want_to_proceed)"         "Puede considerarlos como elementos de datos existentes y continuar."
::msgcat::mcset pb_msg_spanish "MC(msg,not_installed_properly)"         "no ha sido instalado correctamente."
::msgcat::mcset pb_msg_spanish "MC(msg,no_app_to_open)"                 "No hay ninguna aplicación para abrir"
::msgcat::mcset pb_msg_spanish "MC(msg,save_change)"                    "¿Desea guardar los cambios?"

::msgcat::mcset pb_msg_spanish "MC(msg,external_editor)"                "Editor externo"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_spanish "MC(msg,set_ext_editor)"                 "Puede utilizar la variable de entorno EDITOR para activar su editor de texto preferido."
::msgcat::mcset pb_msg_spanish "MC(msg,filename_with_space)"            "No se admite el espacio que restringe el nombre del archivo."
::msgcat::mcset pb_msg_spanish "MC(msg,filename_protection)"            "No se puede sobrescribir el archivo seleccionado que es utilizado por un postprocesamiento de edición."


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_spanish "MC(msg,parent_win)"                     "Una ventana transitoria requiere una ventana madre definida."
::msgcat::mcset pb_msg_spanish "MC(msg,close_subwin)"                   "Tiene que cerrar todas las subventanas para activar esta pestaña."
::msgcat::mcset pb_msg_spanish "MC(msg,block_exist)"                    "Existe un elemento de la palabra seleccionada en la plantilla de bloques."
::msgcat::mcset pb_msg_spanish "MC(msg,num_gcode_1)"                    "El número de códigos G está restringido a"
::msgcat::mcset pb_msg_spanish "MC(msg,num_gcode_2)"                    "por bloque"
::msgcat::mcset pb_msg_spanish "MC(msg,num_mcode_1)"                    "El número de códigos M está restringido a"
::msgcat::mcset pb_msg_spanish "MC(msg,num_mcode_2)"                    "por bloque"
::msgcat::mcset pb_msg_spanish "MC(msg,empty_entry)"                    "La entrada no debe estar vacía."

::msgcat::mcset pb_msg_spanish "MC(msg,edit_feed_fmt)"                  "Se pueden editar los formatos para la dirección \"F\" en la página parámetros de velocidad de avance"

::msgcat::mcset pb_msg_spanish "MC(msg,seq_num_max)"                    "El valor máximo del número de secuencia no debe exceder la capacidad de la dirección N de"

::msgcat::mcset pb_msg_spanish "MC(msg,no_cdl_name)"                    "Se debe especificar el nombre del postprocesamiento."
::msgcat::mcset pb_msg_spanish "MC(msg,no_def_name)"                    "Se debe especificar la carpeta. \n Y el patrón debe ser como \"\$UGII_*\"."
::msgcat::mcset pb_msg_spanish "MC(msg,no_own_name)"                    "Se debe especificar la carpeta. \n Y el patrón debe ser como \"\$UGII_*\"."
::msgcat::mcset pb_msg_spanish "MC(msg,no_oth_ude_name)"                "Se debe especificar el nombre del archivo CDL. \n Y el patrón debe ser como \"\$UGII_*\"!"
::msgcat::mcset pb_msg_spanish "MC(msg,not_oth_cdl_file)"               "Solamente se permite el archivo CDL."
::msgcat::mcset pb_msg_spanish "MC(msg,not_pui_file)"                   "Solamente se permite el archivo PUI."
::msgcat::mcset pb_msg_spanish "MC(msg,not_cdl_file)"                   "Solamente se permite el archivo CDL."
::msgcat::mcset pb_msg_spanish "MC(msg,not_def_file)"                   "Solamente se permite el archivo DEF."
::msgcat::mcset pb_msg_spanish "MC(msg,not_own_cdl_file)"               "Solamente se permite el propio archivo CDL."
::msgcat::mcset pb_msg_spanish "MC(msg,no_cdl_file)"                    "El postprocesamiento seleccionado no tiene un archivo asociado CDL."
::msgcat::mcset pb_msg_spanish "MC(msg,cdl_info)"                       "El archivo CDL y los archivos de definición del postprocesamiento seleccionado serán referenciados (INCLUIR) en el archivo de definición de este postprocesamiento.\n Y el archivo Tcl del postprocesamiento seleccionado también será originado por el archivo de manipuladores de este postprocesamiento en el tiempo de ejecución."

::msgcat::mcset pb_msg_spanish "MC(msg,add_max1)"                       "El valor máximo de la dirección"
::msgcat::mcset pb_msg_spanish "MC(msg,add_max2)"                       "no debe exceder la capcidad del formato de"


::msgcat::mcset pb_msg_spanish "MC(com,text_entry_trans,title,Label)"   "Entrada"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_spanish "MC(nav_button,no_license,Message)"      "No tiene la licencia correspondiente para realizar esta función."

::msgcat::mcset pb_msg_spanish "MC(nav_button,ok,Label)"                "Aceptar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,ok,Context)"              "Este botón está disponible solamente en un subdiálogo. Le permitirá guardar los cambios y cancelar el diálogo."
::msgcat::mcset pb_msg_spanish "MC(nav_button,cancel,Label)"            "Cancelar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,cancel,Context)"          "Este botón está disponible en un subdiálogo. Le permite cancelar el diálogo."
::msgcat::mcset pb_msg_spanish "MC(nav_button,default,Label)"           "Predeterminado"
::msgcat::mcset pb_msg_spanish "MC(nav_button,default,Context)"         "Este botón. \n \nHowever, the name of the component in question, if present, will only be restored to its initial state of the current visit to this component."
::msgcat::mcset pb_msg_spanish "MC(nav_button,restore,Label)"           "Restaurar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,restore,Context)"         "Este botón le permite restaurar los parámetros del diálogo actual a los ajustes iniciales de la visita actual a este componente."
::msgcat::mcset pb_msg_spanish "MC(nav_button,apply,Label)"             "Aplicar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,apply,Context)"           "Este botón le permite guardar los cambios sin cancelar el diálogo actual. Esto le permitirá restablecer la condición inicial del presente diálogo. \n \n(Consulte Restaurar con respecto a la condición inicial)"
::msgcat::mcset pb_msg_spanish "MC(nav_button,filter,Label)"            "Filtro"
::msgcat::mcset pb_msg_spanish "MC(nav_button,filter,Context)"          "Este botón aplicará el filtro del directorio y listará los archivos que satisfacen la condición."
::msgcat::mcset pb_msg_spanish "MC(nav_button,yes,Label)"               "Sí"
::msgcat::mcset pb_msg_spanish "MC(nav_button,yes,Context)"             "Sí"
::msgcat::mcset pb_msg_spanish "MC(nav_button,no,Label)"                "No"
::msgcat::mcset pb_msg_spanish "MC(nav_button,no,Context)"              "No"
::msgcat::mcset pb_msg_spanish "MC(nav_button,help,Label)"              "Ayuda"
::msgcat::mcset pb_msg_spanish "MC(nav_button,help,Context)"            "Ayuda"

::msgcat::mcset pb_msg_spanish "MC(nav_button,open,Label)"              "Abrir"
::msgcat::mcset pb_msg_spanish "MC(nav_button,open,Context)"            "Este botón le permitirá abrir el postprocesamiento seleccionado para editarlo."

::msgcat::mcset pb_msg_spanish "MC(nav_button,save,Label)"              "Guardar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,save,Context)"            "Este botón está disponible en el diálogo Guardar como que le permite guardar el postprocesamiento en curso."

::msgcat::mcset pb_msg_spanish "MC(nav_button,manage,Label)"            "Gestionar ..."
::msgcat::mcset pb_msg_spanish "MC(nav_button,manage,Context)"          "Este botón le permite gestionar el historial de los postprocesamientos recientemente visitados."

::msgcat::mcset pb_msg_spanish "MC(nav_button,refresh,Label)"           "Actualizar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,refresh,Context)"         "Este botón actualizará la lista según la existencia de los objetos"

::msgcat::mcset pb_msg_spanish "MC(nav_button,cut,Label)"               "Cortar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,cut,Context)"             "Este botón cortará el objeto seleccionado de la lista."

::msgcat::mcset pb_msg_spanish "MC(nav_button,copy,Label)"              "Copiar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,copy,Context)"            "Este botón copiará el objeto seleccionado."

::msgcat::mcset pb_msg_spanish "MC(nav_button,paste,Label)"             "Pegar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,paste,Context)"           "Este botón pegará el objeto en el búfer y lo devolverá a la lista."

::msgcat::mcset pb_msg_spanish "MC(nav_button,edit,Label)"              "Editar"
::msgcat::mcset pb_msg_spanish "MC(nav_button,edit,Context)"            "Este botón editará el objeto en el búfer."

::msgcat::mcset pb_msg_spanish "MC(nav_button,ex_editor,Label)"         "Utilizar el editor externo"

##------------
## New dialog
##
::msgcat::mcset pb_msg_spanish "MC(new,title,Label)"                    "Crear un nuevo postprocesador"
::msgcat::mcset pb_msg_spanish "MC(new,Status)"                         "Escribir el nombre y seleccionar el parámetro del nuevo postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(new,name,Label)"                     "Nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(new,name,Context)"                   "Nombre del postprocesador que se creará"

::msgcat::mcset pb_msg_spanish "MC(new,desc,Label)"                     "Descripción"
::msgcat::mcset pb_msg_spanish "MC(new,desc,Context)"                   "Descripción del postprocesador que se creará"

#Description for each selection
::msgcat::mcset pb_msg_spanish "MC(new,mill,desc,Label)"                "Esta es una máquina fresadora."
::msgcat::mcset pb_msg_spanish "MC(new,lathe,desc,Label)"               "Esta es una máquina torneadora."
::msgcat::mcset pb_msg_spanish "MC(new,wedm,desc,Label)"                "Esta es una máquina de electroerosión por hilo."

::msgcat::mcset pb_msg_spanish "MC(new,wedm_2,desc,Label)"              "Esta es una máquina de electroerosión por hilo con 2 ejes."
::msgcat::mcset pb_msg_spanish "MC(new,wedm_4,desc,Label)"              "Esta es una máquina de electroerosión por hilo con 4 ejes."
::msgcat::mcset pb_msg_spanish "MC(new,lathe_2,desc,Label)"             "Esta es una máquina torneadora horizontal con 2 ejes."
::msgcat::mcset pb_msg_spanish "MC(new,lathe_4,desc,Label)"             "Esta es una máquina torneadora dependiente con 4 ejes."
::msgcat::mcset pb_msg_spanish "MC(new,mill_3,desc,Label)"              "Esta es una máquina fresadora con 3 ejes. "
::msgcat::mcset pb_msg_spanish "MC(new,mill_3MT,desc,Label)"            "Torno fresador con 3 ejes (XZC)"
::msgcat::mcset pb_msg_spanish "MC(new,mill_4H,desc,Label)"             "Esta es una máquina fresadora con 4 ejes y con un cabezal rotatorio."
::msgcat::mcset pb_msg_spanish "MC(new,mill_4T,desc,Label)"             "Esta es una máquina fresadora con 4 ejes y con una mesa rotatoria."
::msgcat::mcset pb_msg_spanish "MC(new,mill_5TT,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y con dos mesas rotatorias."
::msgcat::mcset pb_msg_spanish "MC(new,mill_5HH,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y dos cabezales rotatorios."
::msgcat::mcset pb_msg_spanish "MC(new,mill_5HT,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y con un cabezal y una mesa rotatorios."
::msgcat::mcset pb_msg_spanish "MC(new,punch,desc,Label)"               "Esta es una máquina punzonadora."

::msgcat::mcset pb_msg_spanish "MC(new,post_unit,Label)"                "Unidad de salida del postprocesador"

::msgcat::mcset pb_msg_spanish "MC(new,inch,Label)"                     "Pulgadas"
::msgcat::mcset pb_msg_spanish "MC(new,inch,Context)"                   "Unidades en pulgadas del postprocesador"
::msgcat::mcset pb_msg_spanish "MC(new,millimeter,Label)"               "Milímetros"
::msgcat::mcset pb_msg_spanish "MC(new,millimeter,Context)"             "Unidades en milímetros de salida del postprocesador"

::msgcat::mcset pb_msg_spanish "MC(new,machine,Label)"                  "Máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(new,machine,Context)"                "Tipo de máquina herramienta para la cual se creará el postprocesador."

::msgcat::mcset pb_msg_spanish "MC(new,mill,Label)"                     "Fresado"
::msgcat::mcset pb_msg_spanish "MC(new,mill,Context)"                   "Máquina fresadora"
::msgcat::mcset pb_msg_spanish "MC(new,lathe,Label)"                    "Torno"
::msgcat::mcset pb_msg_spanish "MC(new,lathe,Context)"                  "Máquina torneadora"
::msgcat::mcset pb_msg_spanish "MC(new,wire,Label)"                     "Electroerosión por hilo"
::msgcat::mcset pb_msg_spanish "MC(new,wire,Context)"                   "Máquina de electroerosión por hilo"
::msgcat::mcset pb_msg_spanish "MC(new,punch,Label)"                    "Punzón"

::msgcat::mcset pb_msg_spanish "MC(new,axis,Label)"                     "Selección de los ejes de la máquina"
::msgcat::mcset pb_msg_spanish "MC(new,axis,Context)"                   "Número y tipo de ejes de la máquina"

#Axis Number
::msgcat::mcset pb_msg_spanish "MC(new,axis_2,Label)"                   "2 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,axis_3,Label)"                   "3 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,axis_4,Label)"                   "4 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,axis_5,Label)"                   "5 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_spanish "MC(new,mach_axis,Label)"                "Eje de la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(new,mach_axis,Context)"              "Seleccionar el eje de la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(new,lathe_2,Label)"                  "2 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,mill_3,Label)"                   "3 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,mill_3MT,Label)"                 "Torno fresador con 3 ejes (XZC)"
::msgcat::mcset pb_msg_spanish "MC(new,mill_4T,Label)"                  "4 ejes con tabla rotatoria"
::msgcat::mcset pb_msg_spanish "MC(new,mill_4H,Label)"                  "4 ejes con un cabezal rotatorio"
::msgcat::mcset pb_msg_spanish "MC(new,lathe_4,Label)"                  "4 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,mill_5HH,Label)"                 "5 ejes con cabezales dobles rotatorios"
::msgcat::mcset pb_msg_spanish "MC(new,mill_5TT,Label)"                 "5 ejes con tablas dobles rotatorias"
::msgcat::mcset pb_msg_spanish "MC(new,mill_5HT,Label)"                 "5 ejes con un cabezal y una tabla rotatorios"
::msgcat::mcset pb_msg_spanish "MC(new,wedm_2,Label)"                   "2 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,wedm_4,Label)"                   "4 ejes"
::msgcat::mcset pb_msg_spanish "MC(new,punch,Label)"                    "Punzón"

::msgcat::mcset pb_msg_spanish "MC(new,control,Label)"                  "Controlador"
::msgcat::mcset pb_msg_spanish "MC(new,control,Context)"                "Seleccionar el postprocesamiento controlador."

#Controller Type
::msgcat::mcset pb_msg_spanish "MC(new,generic,Label)"                  "Genérico"
::msgcat::mcset pb_msg_spanish "MC(new,library,Label)"                  "Biblioteca"
::msgcat::mcset pb_msg_spanish "MC(new,user,Label)"                     "Del usuario"
::msgcat::mcset pb_msg_spanish "MC(new,user,browse,Label)"              "Examinar"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_spanish "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_spanish "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_spanish "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_spanish "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_spanish "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_spanish "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_spanish "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_spanish "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_spanish "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_spanish "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_spanish "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_spanish "MC(new,seimens,Label)"                  "Seimens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_spanish "MC(open,title,Label)"                   "Editar el postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(open,Status)"                        "Seleccionar un archivo PUI para abrir."
::msgcat::mcset pb_msg_spanish "MC(open,file_type_pui)"                 "Archivos de la sesión del constructor virtual de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(open,file_type_tcl)"                 "Archivos de comandos Tcl"
::msgcat::mcset pb_msg_spanish "MC(open,file_type_def)"                 "Archivos de definición"
::msgcat::mcset pb_msg_spanish "MC(open,file_type_cdl)"                 "Archivos CDL"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_spanish "MC(open_save,dlg,title,Label)"          "Seleccione un archivo"
::msgcat::mcset pb_msg_spanish "MC(exp_cc,dlg,title,Label)"             "Exportar los comandos personalizados"
::msgcat::mcset pb_msg_spanish "MC(show_mt,title,Label)"                "Máquina herramienta"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_spanish "MC(mvb,title,Label)"                    "Explorador de variables MOM"
::msgcat::mcset pb_msg_spanish "MC(mvb,cat,Label)"                      "Categoría"
::msgcat::mcset pb_msg_spanish "MC(mvb,search,Label)"                   "Buscar"
::msgcat::mcset pb_msg_spanish "MC(mvb,defv,Label)"                     "Valor predeterminado"
::msgcat::mcset pb_msg_spanish "MC(mvb,posv,Label)"                     "Valores posibles"
::msgcat::mcset pb_msg_spanish "MC(mvb,data,Label)"                     "Tipo de dato"
::msgcat::mcset pb_msg_spanish "MC(mvb,desc,Label)"                     "Descripción"

::msgcat::mcset pb_msg_spanish "MC(inposts,title,Label)"                "Instalar los postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(tpdf,text,Label)"                    "Archivo de datos de postprocesamientos de plantillas"
::msgcat::mcset pb_msg_spanish "MC(inposts,edit,title,Label)"           "Editar una línea"
::msgcat::mcset pb_msg_spanish "MC(inposts,edit,post,Label)"            "Postprocesamiento"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_spanish "MC(save_as,title,Label)"                "Guardar como"
::msgcat::mcset pb_msg_spanish "MC(save_as,name,Label)"                 "Nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(save_as,name,Context)"               "El nombre que el postprocesador guardará como."
::msgcat::mcset pb_msg_spanish "MC(save_as,Status)"                     "Introducir el nuevo nombre del archivo de postprocesamientos."
::msgcat::mcset pb_msg_spanish "MC(save_as,file_type_pui)"              "Archivos de la sesión del constructor virtual de postprocesamientos"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_spanish "MC(common,entry,Label)"                 "Entrada"
::msgcat::mcset pb_msg_spanish "MC(common,entry,Context)"               "Especificará un nuevo valor en el campo entrada."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_spanish "MC(nbook,tab,Label)"                    "Pestaña del cuaderno"
::msgcat::mcset pb_msg_spanish "MC(nbook,tab,Context)"                  "Podrá seleccionar una pestaña para ir a la página de los parámetros deseados. \n \nPodrá dividir los parámetros en la pestaña en grupos. Podrá acceder a cada grupo de parámetros mediante otra pestaña."

##------
## Tree
##
::msgcat::mcset pb_msg_spanish "MC(tree,select,Label)"                  "Árbol de componentes"
::msgcat::mcset pb_msg_spanish "MC(tree,select,Context)"                "Podrá seleccionar un componente para ver o editar el contenido o los parámetros."
::msgcat::mcset pb_msg_spanish "MC(tree,create,Label)"                  "Crear"
::msgcat::mcset pb_msg_spanish "MC(tree,create,Context)"                "Crear un nuevo componente al copiar el ítem seleccionado."
::msgcat::mcset pb_msg_spanish "MC(tree,cut,Label)"                     "Cortar"
::msgcat::mcset pb_msg_spanish "MC(tree,cut,Context)"                   "Cortar un componente."
::msgcat::mcset pb_msg_spanish "MC(tree,paste,Label)"                   "Pegar"
::msgcat::mcset pb_msg_spanish "MC(tree,paste,Context)"                 "Pegar un componente."
::msgcat::mcset pb_msg_spanish "MC(tree,rename,Label)"                  "Cambiar el nombre"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_spanish "MC(encrypt,browser,Label)"              "Lista de licencias"
::msgcat::mcset pb_msg_spanish "MC(encrypt,title,Label)"                "Seleccionar una licencia"
::msgcat::mcset pb_msg_spanish "MC(encrypt,output,Label)"               "Salida cifrada"
::msgcat::mcset pb_msg_spanish "MC(encrypt,license,Label)"              "Licencia:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(machine,tab,Label)"                  "Máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(machine,Status)"                     "Especifique los parámetros cinemáticos de la máquina."

::msgcat::mcset pb_msg_spanish "MC(msg,no_display)"                     "La imagen correspondiente a la configuración máquina herramienta no está disponible."
::msgcat::mcset pb_msg_spanish "MC(msg,no_4th_ctable)"                  "No se permite la tabla C del cuarto eje."
::msgcat::mcset pb_msg_spanish "MC(msg,no_4th_max_min)"                 "El límite del eje máximo del cuarto eje no puede ser igual al límite del eje mínimo."
::msgcat::mcset pb_msg_spanish "MC(msg,no_4th_both_neg)"                "Los dos límites del cuarto eje no pueden ser negativos."
::msgcat::mcset pb_msg_spanish "MC(msg,no_4th_5th_plane)"               "El plano del cuarto eje no puede ser el mismo que el plano del quinto eje."
::msgcat::mcset pb_msg_spanish "MC(msg,no_4thT_5thH)"                   "No se permiten una tabla del cuarto eje ni un cabezal del quinto eje."
::msgcat::mcset pb_msg_spanish "MC(msg,no_5th_max_min)"                 "El límite del eje máximo del quinto eje no puede ser igual al límite del eje mínimo."
::msgcat::mcset pb_msg_spanish "MC(msg,no_5th_both_neg)"                "Los dos límites del quinto eje no pueden ser negativos."

##---------
# Post Info
##
::msgcat::mcset pb_msg_spanish "MC(machine,info,title,Label)"           "Información sobre el postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(machine,info,desc,Label)"            "Descripción"
::msgcat::mcset pb_msg_spanish "MC(machine,info,type,Label)"            "Tipo de máquina"
::msgcat::mcset pb_msg_spanish "MC(machine,info,kinematics,Label)"      "Cinemática"
::msgcat::mcset pb_msg_spanish "MC(machine,info,unit,Label)"            "Unidades de salida"
::msgcat::mcset pb_msg_spanish "MC(machine,info,controller,Label)"      "Controlador"
::msgcat::mcset pb_msg_spanish "MC(machine,info,history,Label)"         "Historial"

##---------
## Display
##
::msgcat::mcset pb_msg_spanish "MC(machine,display,Label)"              "Visualizar la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(machine,display,Context)"            "Esta opción visualizar la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(machine,display_trans,title,Label)"  "Máquina herramienta"


##---------------
## General parms
##
::msgcat::mcset pb_msg_spanish "MC(machine,gen,Label)"                      "Parámetros generales"
    
::msgcat::mcset pb_msg_spanish "MC(machine,gen,out_unit,Label)"             "Unidad de salida del postprocesamiento:"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,out_unit,Context)"           "Unidad de salida del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,out_unit,inch,Label)"        "Pulgada" 
::msgcat::mcset pb_msg_spanish "MC(machine,gen,out_unit,metric,Label)"      "Métrico"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,Label)"         "Límites del recorrido del eje lineal"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,Context)"       "Límites del recorrido del eje lineal"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,x,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje X."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,y,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje Y."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,travel_limit,z,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje Z."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,Label)"             "Posición de inicio"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,Context)"           "Posición de inicio"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,x,Context)"         "La posición de inicio de la máquina del eje X con respecto a la posición física cero del eje. La máquina vuelve a esta posición para la modificación automática de la herramienta."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,y,Context)"         "La posición de inicio de la máquina del eje Y con respecto a la posición física cero del eje. La máquina vuelve a esta posición para la modificación automática de la herramienta."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,home_pos,z,Context)"         "La posición de inicio de la máquina del eje Z con respecto a la posición física cero del eje. La máquina vuelve a esta posición para la modificación automática de la herramienta."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,step_size,Label)"            "Resolución del movimiento lineal"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,step_size,min,Label)"        "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,step_size,min,Context)"      "Resolución mínima"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,traverse_feed,Label)"        "Velocidad de avance transversal"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,traverse_feed,max,Label)"    "Máximo"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,traverse_feed,max,Context)"  "Velocidad máxima de avance"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,circle_record,Label)"        "Registro circular de salida"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,circle_record,yes,Label)"    "Sí"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,circle_record,yes,Context)"  "Registro circular de salida."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,circle_record,no,Label)"     "No"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,circle_record,no,Context)"   "Registro lineal de salida."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,config_4and5_axis,oth,Label)"    "Otros"

# Wire EDM parameters
::msgcat::mcset pb_msg_spanish "MC(machine,gen,wedm,wire_tilt)"             "Control de inclinación del hilo"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,wedm,angle)"                 "Ángulo"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,wedm,coord)"                 "Coordenadas"

# Lathe parameters
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,Label)"               "Torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,Context)"             "Torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,conf,Label)"          "Configurar"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,conf,Context)"        "Al seleccionar dos torretas esta opción le permitirá configurar los parámetros."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,one,Label)"           "Una torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,one,Context)"         "Máquina torneadora con una torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,two,Label)"           "Dos torretas"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,two,Context)"         "Máquina torneadora con dos torretas"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,conf_trans,Label)"    "Configuración de la torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,prim,Label)"          "Torreta primaria"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,prim,Context)"        "Seleccione la designación de la torreta primaria."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,sec,Label)"           "Torreta secundaria"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,sec,Context)"         "Seleccione la designación de la torreta secundaria."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,designation,Label)"   "Designación"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,xoff,Label)"          "Offset X"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,xoff,Context)"        "Especifique el offset X."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,zoff,Label)"          "Offset Z"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,zoff,Context)"        "Especifique el offset Z."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,front,Label)"         "ALZADO"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,rear,Label)"          "POSTERIOR"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,right,Label)"         "DERECHA"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,left,Label)"          "IZQUIERDA"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,side,Label)"          "LADO"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret,saddle,Label)"        "ASIENTO"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,Label)"           "Multiplicadores de ejes"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,dia,Label)"       "Programación del diámetro"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,dia,Context)"     "Estas opciones le permiten activar la programación del diámetro al duplicar los valores de las direcciones seleccionadas en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2x,Context)"      "Este selector le permite activar la programación del diámetro al duplicar las coordenadas del eje X en la salida N/C."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2y,Context)"      "Este selector le permite activar la programación del diámetro al duplicar las coordenadas del eje Y en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2i,Context)"      "Este selector le permite duplicar los valores de I correspondientes a los registros circulares cuando se utiliza la programación del diámetro."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,2j,Context)"      "Este selector le permite duplicar los valores de J correspondientes a los registros circulares cuando se utiliza la programación del diámetro."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,mir,Label)"       "Salida simétrica"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,mir,Context)"     "Estas opciones le permiten hacer una simetría de las direcciones seleccionadas al denegar los valores en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,x,Context)"       "Estas opciones le permiten denegar las coordenadas del eje X en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,y,Context)"       "Estas opciones le permiten denegar las coordenadas del eje Y en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,z,Context)"       "Estas opciones le permiten denegar las coordenadas del eje Z en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,i,Context)"       "Este selector le permite denegar los valores de I correspondientes a los registros circulares en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,j,Context)"       "Este selector le permite denegar los valores de J correspondientes a los registros circulares en la salida N/C."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,axis_multi,k,Context)"       "Este selector le permite denegar los valores de K correspondientes a los registros circulares en la salida N/C."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,Label)"               "Método por salida"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,Context)"             "Método por salida"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,tool_tip,Label)"      "Punta de herramienta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,tool_tip,Context)"    "Salida con respecto a la punta de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,turret_ref,Label)"    "Referencia a la torreta"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,output,turret_ref,Context)"  "Salida con respecto a la referencia de la torreta"

::msgcat::mcset pb_msg_spanish "MC(machine,gen,lathe_turret,msg)"           "La designación de la torreta primera no puede ser la misma que la de la torreta secundaria."
::msgcat::mcset pb_msg_spanish "MC(machine,gen,turret_chg,msg)"             "Para modificar esta opción puede que sea necesario agregar o eliminar el bloque G92 en los eventos Modificación de la herramienta. "
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_spanish "MC(machine,gen,spindle_axis,Label)"             "Eje del husillo inicial"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,spindle_axis,Context)"           "Se puede especificar el eje del husillo inicial designado para la herramienta fresadora en vivo como paralelo al eje Z o perpendicular al eje Z.  El eje de la herramienta de la operación debe ser consistente con el eje del husillo especificado. Se producirá un error si el postprocesador no puede posicionarse con el eje del husillo especificado. \nSe podrá invalidar este vector mediante el eje del husillo especificado con un objeto Cabezal."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,position_in_yaxis,Label)"        "Posición en el eje Y"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,position_in_yaxis,Context)"      "La máquina tiene un eje programable Y que se puede posicionar durante el contorneado. Esta opción se aplica solamente cuando el eje del husillo no está a lo largo del eje Z."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,Label)"                "Modo de máquina"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,Context)"              "El modo de máquina puede ser Fresado XZC o torneado fresado simple."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fresado XZC"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Un fresado XZC tendrá una mesa o una cara de mandril de sujeción bloqueado en una máquina fresadora torneadora como el eje rotatorio X. Se convertirán todos los movimientos XY en X y C donde X es un valor de radio y C el valor del ángulo."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,mill_turn,Label)"      "Torneado fresado simple"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,mach_mode,mill_turn,Context)"    "Se enlazará este postprocesamiento de fresado XZC con un postprocesamiento de torno para procesar un programa que contenga las operaciones de fresado y torneado. El tipo de operación determinará el postprocesamiento a utilizar para producir las salidas N/C."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,mill_turn,lathe_post,Label)"     "Postprocesamiento de torno"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,mill_turn,lathe_post,Context)"   "Es necesario un postprocesamiento de torno para un postprocesamiento de torneado fresado simple para postprocesar las operaciones de torneado en un programa."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,lathe_post,select_name,Label)"   "Seleccionar el nombre"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,lathe_post,select_name,Context)" "Seleccione el nombre de un postprocesamiento de torno para usar en un postprocesamiento torneado fresado. Podrá encontrar este postprocesamiento en el directorio \\\$UGII_CAM_POST_DIR en el tiempo de ejecución de UG/Post, de lo contrario se utilizará un postprocesamiento con el mismo nombre en el directorio donde se encuentra el postprocesamiento de fresado."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,Label)"               "Modo predeterminado de coordenadas"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,Context)"             "Esta opción define el ajuste inicial del modo de salida de las coordenadas como polar (XZC) o cartesiano (XYZ).  Se puede modificar este modo \\\"CONFIGURAR/POLAR,ACTIVADO\\\" con las operaciones programadas UDE."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,polar,Context)"       "Salida de las coordenadas en XZC."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,cart,Label)"          "Cartesiano"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,coord_mode,cart,Context)"        "Salida de las coordenadas en XYZ."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,Label)"             "Modo de registro circular"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,Context)"           "Esta opción define la salida de los registros circulares en el modo polar (XCR) o cartesiano (XYIJ)."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Salida circular en XCR."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartesiano"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Salida circular en XYIJ."

::msgcat::mcset pb_msg_spanish "MC(machine,gen,def_spindle_axis,Label)"         "Eje del husillo inicial"
::msgcat::mcset pb_msg_spanish "MC(machine,gen,def_spindle_axis,Context)"       "El eje del husillo inicial puede ser invalidado por el eje del husillo especificado con un objeto Cabezal. \nNo es necesario unificar el vector."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_spanish "MC(machine,axis,fourth,Label)"              "Cuarto eje"

::msgcat::mcset pb_msg_spanish "MC(machine,axis,radius_output,Label)"       "Salida del radio"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,radius_output,Context)"     "Cuando el eje de la herramienta se encuentra a lo largo del eje Z (0,0,1), el postprocesador puede optar por producir el radio (X) de las coordenadas polares para que sean \\\"Siempre positivo\\\", \\\"Siempre negativo\\\" o \\\"La distancia más corta\\\"."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,type_head,Label)"           "Cabezal"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,type_table,Label)"          "Tabla"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_spanish "MC(machine,axis,fifth,Label)"               "Quinto eje"

::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotary,Label)"              "Eje rotatorio"

::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,Label)"              "Posición cero de la máquina al centro del eje rotatorio"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,4,Label)"            "Posición cero de la máquina al centro del cuarto eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,5,Label)"            "Centro del cuarto eje al centro del quinto eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,x,Label)"            "Offset X"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,x,Context)"          "Especifique el offset X del eje rotatorio."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,y,Label)"            "Offset Y"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,y,Context)"          "Especifique el offset Y del eje rotatorio."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,z,Label)"            "Offset Z"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,offset,z,Context)"          "Especifique el offset Z del eje rotatorio."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotation,Label)"            "Rotación del eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotation,norm,Context)"     "Configure la dirección de rotación del eje a la normal."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotation,rev,Label)"        "Inversa"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotation,rev,Context)"      "Configure la dirección de rotación del eje a la inversa."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,direction,Label)"           "Dirección del eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,direction,Context)"         "Seleccione la dirección de eje."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,con_motion,Label)"              "Movimientos rotatorios consecutivos"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,con_motion,combine,Label)"      "Combinado"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,con_motion,combine,Context)"    "Este selector le permite activar o desactivar la linearización. Se activará o desactivará la opción Tolerancia."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,con_motion,tol,Label)"      "Tolerancia"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,con_motion,tol,Context)"    "Esta opción se activa solamente cuando se activa el selector Combinado. Especifique la tolerancia."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,violation,Label)"           "Manipulación de la transgresión del límite del eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,violation,warn,Label)"      "Aviso"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,violation,warn,Context)"    "Avisos de salida en la transgresión del límite del eje."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,violation,ret,Label)"       "Retroceso o Nueva entrada"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,violation,ret,Context)"     "Retroceso o nueva entrada en la transgresión del límite del eje. \n \nEn el comando personalizado PB_CMD_init_rotaty, se pueden ajustar los siguientes parámetros para lograr los movimientos deseados: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_spanish "MC(machine,axis,limits,Label)"              "Límites del eje (grado)"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,limits,min,Label)"          "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,limits,min,Context)"        "Especifique el límite mínimo del eje rotatorio (grado)."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,limits,max,Label)"          "Máximo"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,limits,max,Context)"        "Especifique el límite máximo del eje rotatorio (grado)."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,incr_text)"                 "Este eje rotatorio puede ser incremental"

::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotary_res,Label)"          "Resolución del movimiento rotatorio (grado)"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotary_res,Context)"        "Especifique la resolución del movimiento rotatorio (grado)."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,ang_offset,Label)"          "Desplazamiento (offset) angular (grado)"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,ang_offset,Context)"        "Especifique el desplazamiento (offset) angular del eje (grado)."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,pivot,Label)"               "Distancia del punto pivote"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,pivot,Context)"             "Especifique la distancia pivote."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,max_feed,Label)"            "Velocidad de avance máxima (grado/min)"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,max_feed,Context)"          "Especifique la velocidad de avance máxima (grado/min)."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,Label)"               "Plano de rotación"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,Context)"             "Seleccione XY, YZ, ZX u otro como el plano de rotación. \\\"Otra\\\" opción le permite especificar un vector arbitrario."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,normal,Label)"        "Vector normal al plano"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,normal,Context)"      "Especifique el vector normal al plano como el eje de rotación. \n                                                     No es necesario utilizar el vector.                                                  "
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,4th,Label)"           "Normal al plano del cuarto eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,4th,Context)"         "Especifique un vector normal del plano correspondiente a la rotación del cuarto eje."
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,5th,Label)"           "Normal al plano del quinto eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,plane,5th,Context)"         "Especifique un vector normal al plano correspondiente a la rotación del quinto eje."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,leader,Label)"              "Llamada de palabra"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,leader,Context)"            "Especifique la llamada de la palabra."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,config,Label)"              "Configurar"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,config,Context)"            "Esta opción le permite definir los parámetros del cuarto y quinto ejes."

::msgcat::mcset pb_msg_spanish "MC(machine,axis,r_axis_conf_trans,Label)"   "Configuración del eje rotatorio"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,4th_axis,Label)"            "4to eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,5th_axis,Label)"            "5to eje"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,head,Label)"                " Cabezal "
::msgcat::mcset pb_msg_spanish "MC(machine,axis,table,Label)"               " Tabla "

::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotary_lintol,Label)"       "Tolerancia de la linearización predeterminada"
::msgcat::mcset pb_msg_spanish "MC(machine,axis,rotary_lintol,Context)"     "Se utilizará este valor como la tolerancia predeterminada para linearizar los movimientos rotatorios cuando se indique el comando Postprocesamiento de LINTOL/Activado con las operaciones actuales o precedentes. El comando LINTOL/ también puede especificar una tolerancia diferente de linearización."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(progtpth,tab,Label)"                 "Programa y trayectoria para herramientas"

##---------
## Program
##
::msgcat::mcset pb_msg_spanish "MC(prog,tab,Label)"                     "Programa"
::msgcat::mcset pb_msg_spanish "MC(prog,Status)"                        "Definir la salida de eventos"

::msgcat::mcset pb_msg_spanish "MC(prog,tree,Label)"                    "Programa -- Árbol de secuencias"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,Context)"                  "Un programa N/C está dividido en cinco segmentos: cuatro (4) secuencias y el cuerpo de la trayectoria para herramientas: \n \n * Secuencia inicial del programa \n * Secuencia inicial de la operación \n * Trayectoria para herramientas \n * Secuencia final de la operación \n * Secuencia final del programa \n \nCada secuencia consiste en una serie de marcadores. Un marcador indica un evento que se puede programa y puede ocurrir en una determinada etapa del programa N/C. Puede asociar cada marcador con un ordenamiento en particular de los códigos N/C que se producirán al postprocesar el programa. \n \nLa trayectoria para herramientas está compuesta por numerosos eventos. Además, están divididas en tres (3) grupos: \n \n * Control de la máquina \n * Movimientos \n * Ciclos \n"

::msgcat::mcset pb_msg_spanish "MC(prog,tree,prog_strt,Label)"          "Secuencia inicial del programa"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,prog_end,Label)"           "Secuencia final del programa"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,oper_strt,Label)"          "Secuencia inicial de la operación"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,oper_end,Label)"           "Secuencia final de la operación"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,tool_path,Label)"          "Trayectoria para herramientas"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,tool_path,mach_cnt,Label)" "Control de máquina"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,tool_path,motion,Label)"   "Movimiento"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,tool_path,cycle,Label)"    "Ciclos conservados"
::msgcat::mcset pb_msg_spanish "MC(prog,tree,linked_posts,Label)"       "Secuencia de postprocesamientos enlazados"

::msgcat::mcset pb_msg_spanish "MC(prog,add,Label)"                     "Secuencia -- Agregar un bloque"
::msgcat::mcset pb_msg_spanish "MC(prog,add,Context)"                   "Puede agregar un nuevo bloque a una secuencia si presiona este botón y lo arrastra al marcador deseado. También se pueden asociar los bloques próximos a, por arriba o debajo de un bloque existente."

::msgcat::mcset pb_msg_spanish "MC(prog,trash,Label)"                   "Secuencia - Papelera de reciclaje"
::msgcat::mcset pb_msg_spanish "MC(prog,trash,Context)"                 "Puede disponer de los bloques no deseados de la secuencia arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset pb_msg_spanish "MC(prog,block,Label)"                   "Secuencia -- Bloque"
::msgcat::mcset pb_msg_spanish "MC(prog,block,Context)"                 "Podrá eliminar todas las palabras no deseadas en este bloque simplemente arrastrándolas a la papelera de reciclaje. \n \nTambién podrá activar un menú emergente al presionar el botón derecho del ratón. Hay varios servicios disponibles en el menú: \n \n * Editar \n * Forzar la salida \n * Cortar \n * Copiar como\n * Pegar \n * Eliminar \n"

::msgcat::mcset pb_msg_spanish "MC(prog,select,Label)"                  "Secuencia -- Selección del bloque"
::msgcat::mcset pb_msg_spanish "MC(prog,select,Context)"                "Podrá seleccionar un tipo de componente de bloque que desee agregar a la secuencia desde esta lista. \nLos tipos de componentes \Adisponibles son: \n \n * Bloque nuevo \n * Bloque existente N/C \n * Mensaje del operador \n * Comando personalizado \n"

::msgcat::mcset pb_msg_spanish "MC(prog,oper_temp,Label)"               "Seleccionar una plantilla de secuencias"
::msgcat::mcset pb_msg_spanish "MC(prog,add_block,Label)"               "Agregar un bloque"
::msgcat::mcset pb_msg_spanish "MC(prog,seq_comb_nc,Label)"             "Visualizar los bloques combinados de N/C"
::msgcat::mcset pb_msg_spanish "MC(prog,seq_comb_nc,Context)"           "Este botón le permite visualizar el contenido de una secuencia en función de los bloques o los códigos N/C. \n \nLos códigos N/C visualizarán las palabras en el orden adecuado."

::msgcat::mcset pb_msg_spanish "MC(prog,plus,Label)"                    "Programa -- Contraer o expandir el selector"
::msgcat::mcset pb_msg_spanish "MC(prog,plus,Context)"                  "Este botón le permite contraer o expandir las bifurcaciones de este componente."

::msgcat::mcset pb_msg_spanish "MC(prog,marker,Label)"                  "Secuencia -- Marcador"
::msgcat::mcset pb_msg_spanish "MC(prog,marker,Context)"                "Los marcadores de una secuencia indican los eventos posibles que se pueden programa y que pueden ocurrir en secuencia en una etapa en particular de un programa N/C. \n \nPuede asociar u ordenar los bloques para producir en cada marcador."

::msgcat::mcset pb_msg_spanish "MC(prog,event,Label)"                   "Programa -- Evento"
::msgcat::mcset pb_msg_spanish "MC(prog,event,Context)"                 "Podrá editar cada evento con una sola pulsación mediante el botón izquierdo del ratón."

::msgcat::mcset pb_msg_spanish "MC(prog,nc_code,Label)"                 "Programa -- Código N/C"
::msgcat::mcset pb_msg_spanish "MC(prog,nc_code,Context)"               "El texto de este cuadro mostrará el código representativo N/C para producir en este marcador o de este evento."
::msgcat::mcset pb_msg_spanish "MC(prog,undo_popup,Label)"              "Deshacer"

## Sequence
##
::msgcat::mcset pb_msg_spanish "MC(seq,combo,new,Label)"                "Bloque nuevo"
::msgcat::mcset pb_msg_spanish "MC(seq,combo,comment,Label)"            "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(seq,combo,custom,Label)"             "Comando personalizado"

::msgcat::mcset pb_msg_spanish "MC(seq,new_trans,title,Label)"          "Bloque"
::msgcat::mcset pb_msg_spanish "MC(seq,cus_trans,title,Label)"          "Comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(seq,oper_trans,title,Label)"         "Mensaje del operador"

::msgcat::mcset pb_msg_spanish "MC(seq,edit_popup,Label)"               "Editar"
::msgcat::mcset pb_msg_spanish "MC(seq,force_popup,Label)"              "Forzar la salida"
::msgcat::mcset pb_msg_spanish "MC(seq,rename_popup,Label)"             "Cambiar el nombre"
::msgcat::mcset pb_msg_spanish "MC(seq,rename_popup,Context)"           "Podrá especificar el nombre de este componente."
::msgcat::mcset pb_msg_spanish "MC(seq,cut_popup,Label)"                "Cortar"
::msgcat::mcset pb_msg_spanish "MC(seq,copy_popup,Label)"               "Copiar como"
::msgcat::mcset pb_msg_spanish "MC(seq,copy_popup,ref,Label)"           "Bloques referenciados"
::msgcat::mcset pb_msg_spanish "MC(seq,copy_popup,new,Label)"           "Bloques nuevos"
::msgcat::mcset pb_msg_spanish "MC(seq,paste_popup,Label)"              "Pegar"
::msgcat::mcset pb_msg_spanish "MC(seq,paste_popup,before,Label)"       "Antes"
::msgcat::mcset pb_msg_spanish "MC(seq,paste_popup,inline,Label)"       "En la línea"
::msgcat::mcset pb_msg_spanish "MC(seq,paste_popup,after,Label)"        "Después"
::msgcat::mcset pb_msg_spanish "MC(seq,del_popup,Label)"                "Eliminar"

::msgcat::mcset pb_msg_spanish "MC(seq,force_trans,title,Label)"        "Forzar la salida una vez"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_spanish "MC(tool,event_trans,title,Label)"       "Evento"

::msgcat::mcset pb_msg_spanish "MC(tool,event_seq,button,Label)"        "Seleccionar una plantilla de eventos"
::msgcat::mcset pb_msg_spanish "MC(tool,add_word,button,Label)"         "Agregar una palabra"

::msgcat::mcset pb_msg_spanish "MC(tool,format_trans,title,Label)"      "FORMATO"

::msgcat::mcset pb_msg_spanish "MC(tool,circ_trans,title,Label)"        "Movimiento circular -- Códigos de planos"
::msgcat::mcset pb_msg_spanish "MC(tool,circ_trans,frame,Label)"        " Códigos G de planos "
::msgcat::mcset pb_msg_spanish "MC(tool,circ_trans,xy,Label)"           "Plano XY"
::msgcat::mcset pb_msg_spanish "MC(tool,circ_trans,yz,Label)"           "Plano YZ"
::msgcat::mcset pb_msg_spanish "MC(tool,circ_trans,zx,Label)"           "Plano ZX"

::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,arc_start,Label)"          "Inicio del arco al centro"
::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,arc_center,Label)"         "Centro del arco al inicio"
::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,u_arc_start,Label)"        "Inicio del arco no asignado al centro"
::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,absolute,Label)"           "Centro del arco absoluto"
::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,long_thread_lead,Label)"   "Guía de rosca longitudinal"
::msgcat::mcset pb_msg_spanish "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Guía de rosca transversal"

::msgcat::mcset pb_msg_spanish "MC(tool,spindle,range,type,Label)"              "Tipo de rango del husillo"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle,range,range_M,Label)"           "Separar el código M de rangos (M41)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle,range,with_spindle_M,Label)"    "Número de rangos con el código M de husillos (M13)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Rango alto o bajo con el código S (S+100)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle,range,nonzero_range,msg)"       "El número de rangos de husillos debe ser mayor que cero."

::msgcat::mcset pb_msg_spanish "MC(tool,spindle_trans,title,Label)"         "Tabla de códigos de rangos de husillos"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_trans,range,Label)"         "Rango"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_trans,code,Label)"          "Código"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_trans,min,Label)"           "Mínimo (RPM)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_trans,max,Label)"           "Máximo (RPM)"

::msgcat::mcset pb_msg_spanish "MC(tool,spindle_desc,sep,Label)"            " Separar el código M de rangos (M41, M42 ...) "
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_desc,range,Label)"          " Número de rangos con el código de husillos M (M13, M23 ...)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_desc,high,Label)"           " Rango alto o bajo con el código S (S+100/S-100)"
::msgcat::mcset pb_msg_spanish "MC(tool,spindle_desc,odd,Label)"            " Rango par o impar con el código S"


::msgcat::mcset pb_msg_spanish "MC(tool,config,mill_opt1,Label)"            "Número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,config,mill_opt2,Label)"            "Número de la herramienta y número del offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(tool,config,mill_opt3,Label)"            "Número del offset de longitud y número de la herramienta"

::msgcat::mcset pb_msg_spanish "MC(tool,config,title,Label)"                "Configuración del código de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,config,output,Label)"               "Salida"

::msgcat::mcset pb_msg_spanish "MC(tool,config,lathe_opt1,Label)"           "Número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,config,lathe_opt2,Label)"           "Número de la herramienta y número del offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(tool,config,lathe_opt3,Label)"           "Índice de torretas y número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,config,lathe_opt4,Label)"           "Índice de torretas, número de la herramienta y número del offset de longitud"

::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,num,Label)"               "Número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,next_num,Label)"          "Número de la herramienta siguiente"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,index_num,Label)"         "Índice de torretas y número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,index_next_num,Label)"    "Índice de torretas y número de la herramienta siguiente"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,num_len,Label)"           "Número de la herramienta y número del offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,next_num_len,Label)"      "Número de la herramienta siguiente y número del offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,len_num,Label)"           "Número del offset de longitud y número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,len_next_num,Label)"      "Número del offset de longitud y número de la herramienta siguiente"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,index_num_len,Label)"     "Índice de torretas, número de la herramienta y número del offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(tool,conf_desc,index_next_num_len,Label)"    "Índice de torretas, número de la herramienta siguiente y número del offset de longitud"

::msgcat::mcset pb_msg_spanish "MC(tool,oper_trans,title,Label)"            "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(tool,cus_trans,title,Label)"             "Comando personalizado"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_spanish "MC(event,feed,IPM_mode)"                "Modo IPM (pulgada o min)"

##---------
## G Codes
##
::msgcat::mcset pb_msg_spanish "MC(gcode,tab,Label)"                    "Códigos G"
::msgcat::mcset pb_msg_spanish "MC(gcode,Status)"                       "Especificar los códigos G"

##---------
## M Codes
##
::msgcat::mcset pb_msg_spanish "MC(mcode,tab,Label)"                    "Códigos M"
::msgcat::mcset pb_msg_spanish "MC(mcode,Status)"                       "Especificar los códigos M"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_spanish "MC(addrsum,tab,Label)"                  "Resumen de palabras"
::msgcat::mcset pb_msg_spanish "MC(addrsum,Status)"                     "Especificar los parámetros"

::msgcat::mcset pb_msg_spanish "MC(addrsum,col_addr,Label)"             "Palabra"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_addr,Context)"           "Puede editar una dirección con palabras si pulsa el botón izquierdo del ratón sobre la misma."
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_lead,Label)"             "Llamada o Código"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_data,Label)"             "Tipo de dato"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_plus,Label)"             "Más (+)"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_lzero,Label)"            "Cero a la izquierda"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_int,Label)"              "Número entero"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_dec,Label)"              "Decimal (.)"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_frac,Label)"             "Fracción"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_tzero,Label)"            "Cero a la derecha"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_modal,Label)"            "¿Modal?"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_min,Label)"              "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_max,Label)"              "Máximo"
::msgcat::mcset pb_msg_spanish "MC(addrsum,col_trail,Label)"            "Rastreador"

::msgcat::mcset pb_msg_spanish "MC(addrsum,radio_text,Label)"           "Texto"
::msgcat::mcset pb_msg_spanish "MC(addrsum,radio_num,Label)"            "Numérico"

::msgcat::mcset pb_msg_spanish "MC(addrsum,addr_trans,title,Label)"     "PALABRA"
::msgcat::mcset pb_msg_spanish "MC(addrsum,other_trans,title,Label)"    "Otros elementos de datos"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_spanish "MC(wseq,tab,Label)"                     "Control secuencial de las palabras"
::msgcat::mcset pb_msg_spanish "MC(wseq,Status)"                        "Secuenciar las palabras"

::msgcat::mcset pb_msg_spanish "MC(wseq,word,Label)"                    "Secuencia de palabras maestras"
::msgcat::mcset pb_msg_spanish "MC(wseq,word,Context)"                  "Podrá realizar la secuencia del orden de las palabras que aparezcan en la salida N/C al arrastrar cualquier palabra hasta la posición deseada. \n \nCuando la palabra que está arrastrando está en foco (cambia el color del rectángulo) con la otra palabra, se intercambiarán las posiciones de estas dos palabras. Si se arrastra una palabra dentro del foco de un separador entre dos palabras, se insertará la palabra entre estas dos palabras. \n \nPodrá suprimir cualquier palabra de la salida al archivo N/C al seleccionarla con una simple pulsación con el botón izquierdo del ratón. \n \nTambién podrá manipular esta palabras usando las opciones del menú emergente: \n \n * Nuevo \n * Editar \n * Eliminar \n * Activar todo \n"

::msgcat::mcset pb_msg_spanish "MC(wseq,active_out,Label)"              " Salida: Activa     "
::msgcat::mcset pb_msg_spanish "MC(wseq,suppressed_out,Label)"          " Salida: Suprimida "

::msgcat::mcset pb_msg_spanish "MC(wseq,popup_new,Label)"               "Nuevo"
::msgcat::mcset pb_msg_spanish "MC(wseq,popup_undo,Label)"              "Deshacer"
::msgcat::mcset pb_msg_spanish "MC(wseq,popup_edit,Label)"              "Editar"
::msgcat::mcset pb_msg_spanish "MC(wseq,popup_delete,Label)"            "Eliminar"
::msgcat::mcset pb_msg_spanish "MC(wseq,popup_all,Label)"               "Activar todo"
::msgcat::mcset pb_msg_spanish "MC(wseq,transient_win,Label)"           "PALABRA"
::msgcat::mcset pb_msg_spanish "MC(wseq,cannot_suppress_msg)"           "no se puede suprimir. Ha sido usada como un elemento único en"
::msgcat::mcset pb_msg_spanish "MC(wseq,empty_block_msg)"               "Si suprime la salida de esta dirección tendrá bloques vacíos."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,tab,Label)"                 "Comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,Status)"                    "Definir los comandos personalizados"

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,name,Label)"                "Nombre del comando"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,name,Context)"              "El nombre que introdujo aquí tendrá un prefijo PB_CMD_ para que pueda ser el nombre real del comando."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,proc,Label)"                "Procedimiento"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,proc,Context)"              "Introducirá un comando Tcl para definir la funcionalidad de este comando. \n \n * Observe que el contenido del comando no será analizado sintácticamente por el constructor virtual de postprocesamientos pero se guardará en el archivo Tcl. Por lo tanto, usted será responsable de la corrección sintáctica del comando."

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,name_msg)"                  "Nombre del comando personalizado no válido.\n Especifique otro nombre"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,name_msg_1)"                "está reservado para los comandos especiales personalizados.\n Indique otro nombre."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,name_msg_2)"                "Solamente se permiten nombres de comandos personalizados VNC como por ejemplo \n PB_CMD_vnc____* .\nEspecifique otro nombre"

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,Label)"              "Importar"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,Context)"            "Importar los comandos personalizados de una archivo seleccionado Tcl al postprocesamiento en curso."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,export,Label)"              "Exportar"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,export,Context)"            "Exportar los comandos personalizados del postprocesamiento en curso a un archivo Tcl."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,tree,Label)"         "Importar los comandos personalizados"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,tree,Context)"       "Esta lista contiene los procedimientos del comando personalizados y otros procedimientos Tcl que existen en el archivo que ha indicado para la importación.  Puede ver la vista preliminar del contenido de cada procedimiento si selecciona el ítem de la lista mediante una simple pulsación con el botón izquierdo del ratón.  Todo procedimiento que ya existe en el postprocesamiento en curso está identificado con el identificador <exists>.  Si pulsa dos veces con el botón izquierdo del ratón sobre un ítem, marcará la casilla de selección próxima al ítem.  Ello le permitirá seleccionar o deseleccionar un procedimiento que desea importar. Se seleccionan automáticamente todos los procedimientos que desea importar. Podrá deseleccionar cualquier ítem para evitar sobrescribir un procedimiento existente."

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,export,tree,Label)"         "Exportar los comandos personalizados"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,export,tree,Context)"       "Esta lista contiene los procedimientos del comando personalizado y otros procedimientos Tcl que existen en el postprocesamiento en curso. Puede ver la vista preliminar del contenido de cada procedimiento si selecciona el ítem de la lista mediante una simple pulsación con el botón izquierdo del ratón. Si pulsa dos veces sobre un ítem se seleccionará la casilla de selección próxima al ítem. Ello le permitirá seleccionar solamente los procedimientos que desea exportar."

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,error,title)"               "Error en el comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,error,msg)"                 "Podrá activar o desactivar la validación de los comandos personalizados al configurar los selectores en el ítem del menú principal desplegable  \"Opciones -> Validar los comandos personalizados\"."

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,select_all,Label)"          "Seleccionar todo"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,select_all,Context)"        "Pulse este botón para seleccionar todos los comandos visualizados para importar o exportar."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,deselect_all,Label)"        "Deseleccionar todo"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,deselect_all,Context)"      "Pulse este botón para deseleccionar todos los comandos."

::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,warning,title)"      "Aviso de importación o exportación del comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,import,warning,msg)"        "No se ha seleccionado ningún ítem para importar o exportar."



::msgcat::mcset pb_msg_spanish "MC(cust_cmd,cmd,msg)"                   "Comandos: "
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,blk,msg)"                   "Bloques: "
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,add,msg)"                   "Direcciones: "
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,fmt,msg)"                   "Formatos: "
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,referenced,msg)"            "referenciado en el comando personalizado "
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,not_defined,msg)"           "no han sido definidos en el ámbito actual del postprocesamiento en curso."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,cannot_delete,msg)"         "no se puede eliminar."
::msgcat::mcset pb_msg_spanish "MC(cust_cmd,save_post,msg)"             "¿Desea guardar este postprocesamiento de todos modos?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_spanish "MC(opr_msg,text,Label)"                 "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(opr_msg,text,Context)"               "Texto que será visualizado como un mensaje del operador. Se adjuntarán automáticamente estos caracteres especiales necesarios para el inicio y el final del mensaje mediante el constructor de postprocesamientos.  La ágina de parámetros \"Otros elementos de datos\" en la pestaña \"Definiciones de datos N/C\"."

::msgcat::mcset pb_msg_spanish "MC(opr_msg,name,Label)"                 "Nombre del mensaje"
::msgcat::mcset pb_msg_spanish "MC(opr_msg,empty_operator)"             "Un mensaje del operador no debe estar vacío."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_spanish "MC(link_post,tab,Label)"                "Postprocesamientos enlazados"
::msgcat::mcset pb_msg_spanish "MC(link_post,Status)"                   "Definir los postprocesamientos enlazados"

::msgcat::mcset pb_msg_spanish "MC(link_post,toggle,Label)"             "Enlazar otros postprocesamientos con este postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(link_post,toggle,Context)"           "Se pueden enlazar otros postprocesamientos con este postprocesamiento para manejar máquinas herramienta complejas que realizan más de una combinación de modos de fresado y torneado simples."

::msgcat::mcset pb_msg_spanish "MC(link_post,head,Label)"               "Cabezal"
::msgcat::mcset pb_msg_spanish "MC(link_post,head,Context)"             "Una máquina herramienta compleja puede realizar las operaciones de maquinado usando conjuntos diferentes de cinemática en varios modos de maquinado. Se trata cada conjunto de cinemática como un cabezal independiente en UG/Post.  Se colocarán las operaciones de maquinado que se deben realizar con un cabezal específico como un grupo en la vista Máquina herramienta o Método por maquinado. A continuación se asignará un \\\"Cabezal\\\" UDE al grupo para designar el nombre correspondiente."

::msgcat::mcset pb_msg_spanish "MC(link_post,post,Label)"               "Postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(link_post,post,Context)"             "Se asigna un postprocesamiento a una cabeza para producir los códigos N/C."

::msgcat::mcset pb_msg_spanish "MC(link_post,link,Label)"               "Un postprocesamiento con enlaces"
::msgcat::mcset pb_msg_spanish "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_spanish "MC(link_post,new,Label)"                "Nuevo"
::msgcat::mcset pb_msg_spanish "MC(link_post,new,Context)"              "Cree un nuevo enlace."

::msgcat::mcset pb_msg_spanish "MC(link_post,edit,Label)"               "Editar"
::msgcat::mcset pb_msg_spanish "MC(link_post,edit,Context)"             "Edite un enlace."

::msgcat::mcset pb_msg_spanish "MC(link_post,delete,Label)"             "Eliminar"
::msgcat::mcset pb_msg_spanish "MC(link_post,delete,Context)"           "Elimine un enlace."

::msgcat::mcset pb_msg_spanish "MC(link_post,select_name,Label)"        "Seleccionar el nombre"
::msgcat::mcset pb_msg_spanish "MC(link_post,select_name,Context)"      "Seleccione el nombre de un paso para asignarlo a un cabezal.  Supuestamente se encontrará este paso en el directorio donde se encuentra el postprocesador principal en el tiempo de ejecución de UG/Post, de lo contrario se utilizará un paso con el mismo nombre en el directorio \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_spanish "MC(link_post,start_of_head,Label)"      "Inicio de la cabeza"
::msgcat::mcset pb_msg_spanish "MC(link_post,start_of_head,Context)"    "Especifique los códigos o las acciones N/C que se ejecutarán al inicio de esta cabeza."

::msgcat::mcset pb_msg_spanish "MC(link_post,end_of_head,Label)"        "Fin de la cabeza"
::msgcat::mcset pb_msg_spanish "MC(link_post,end_of_head,Context)"      "Especifique los códigos o las acciones N/C que se ejecutarán al final de esta cabeza."
::msgcat::mcset pb_msg_spanish "MC(link_post,dlg,head,Label)"           "Cabezal"
::msgcat::mcset pb_msg_spanish "MC(link_post,dlg,post,Label)"           "Postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(link_post,dlg,title,Label)"          "Postprocesamiento con enlaces"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(nc_data,tab,Label)"                  "Definiciones de los datos de N/C"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_spanish "MC(block,tab,Label)"                    "BLOQUE"
::msgcat::mcset pb_msg_spanish "MC(block,Status)"                       "Definir las plantillas de bloques"

::msgcat::mcset pb_msg_spanish "MC(block,name,Label)"                   "Nombre del bloque"
::msgcat::mcset pb_msg_spanish "MC(block,name,Context)"                 "Introducir el nombre del bloque"

::msgcat::mcset pb_msg_spanish "MC(block,add,Label)"                    "Agregar una palabra"
::msgcat::mcset pb_msg_spanish "MC(block,add,Context)"                  "Para agregar una palabra nueva a un bloque pulse este botón y arrástrelo al bloque visualizado en la ventana que sigue. Se selecciona el tipo de palabra que creará a partir del cuadro de listas ubicado a la derecha de este botón."

::msgcat::mcset pb_msg_spanish "MC(block,select,Label)"                 "BLOQUE -- Selección de palabras"
::msgcat::mcset pb_msg_spanish "MC(block,select,Context)"               "Debe seleccionar de la lista el tipo de palabra que desee agregar al bloque. "

::msgcat::mcset pb_msg_spanish "MC(block,trash,Label)"                  "BLOQUE -- Papelera de reciclaje"
::msgcat::mcset pb_msg_spanish "MC(block,trash,Context)"                "Puede disponer de las palabras no deseadas de un bloque arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset pb_msg_spanish "MC(block,word,Label)"                   "BLOQUE -- Palabra"
::msgcat::mcset pb_msg_spanish "MC(block,word,Context)"                 "Podrá eliminar todas las palabras no deseadas en este bloque simplemente arrastrándolas a la papelera de reciclaje. \n \nTambién podrá activar un menú emergente al presionar el botón derecho del ratón. Hay varios servicios disponibles en el menú: \n \n * Editar \n * Modificar el elemento -> \n * Opcional \n * Sin separador de palabras\n * Forzar la salida \n * Eliminar \n"

::msgcat::mcset pb_msg_spanish "MC(block,verify,Label)"                 "BLOQUE -- Verificación de palabras "
::msgcat::mcset pb_msg_spanish "MC(block,verify,Context)"               "Esta ventana mostrará el código representativo N/C para que sea la salida de una palabra seleccionada (al soltar la tecla) en el bloque mostrado en la ventana que se encuentra arriba."

::msgcat::mcset pb_msg_spanish "MC(block,new_combo,Label)"              "Dirección nueva"
::msgcat::mcset pb_msg_spanish "MC(block,text_combo,Label)"             "Texto"
::msgcat::mcset pb_msg_spanish "MC(block,oper_combo,Label)"             "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(block,comm_combo,Label)"             "Comando"

::msgcat::mcset pb_msg_spanish "MC(block,edit_popup,Label)"             "Editar"
::msgcat::mcset pb_msg_spanish "MC(block,view_popup,Label)"             "Vista"
::msgcat::mcset pb_msg_spanish "MC(block,change_popup,Label)"           "Modificar el elemento"
::msgcat::mcset pb_msg_spanish "MC(block,user_popup,Label)"             "Expresión definida por el usuario"
::msgcat::mcset pb_msg_spanish "MC(block,opt_popup,Label)"              "Opcional"
::msgcat::mcset pb_msg_spanish "MC(block,no_sep_popup,Label)"           "Sin separador de palabras"
::msgcat::mcset pb_msg_spanish "MC(block,force_popup,Label)"            "Forzar la salida"
::msgcat::mcset pb_msg_spanish "MC(block,delete_popup,Label)"           "Eliminar"
::msgcat::mcset pb_msg_spanish "MC(block,undo_popup,Label)"             "Deshacer"
::msgcat::mcset pb_msg_spanish "MC(block,delete_all,Label)"             "Eliminar todos los elementos activos"

::msgcat::mcset pb_msg_spanish "MC(block,cmd_title,Label)"              "Comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(block,oper_title,Label)"             "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(block,addr_title,Label)"             "PALABRA"

::msgcat::mcset pb_msg_spanish "MC(block,new_trans,title,Label)"        "PALABRA"

::msgcat::mcset pb_msg_spanish "MC(block,new,word_desc,Label)"          "Dirección nueva"
::msgcat::mcset pb_msg_spanish "MC(block,oper,word_desc,Label)"         "Mensaje del operador"
::msgcat::mcset pb_msg_spanish "MC(block,cmd,word_desc,Label)"          "Comando personalizado"
::msgcat::mcset pb_msg_spanish "MC(block,user,word_desc,Label)"         "Expresión definida por el usuario"
::msgcat::mcset pb_msg_spanish "MC(block,text,word_desc,Label)"         "Cadena de texto"

::msgcat::mcset pb_msg_spanish "MC(block,user,expr,Label)"              "Expresión"

::msgcat::mcset pb_msg_spanish "MC(block,msg,min_word)"                 "Un bloque debe contener por lo menos una palabra."

::msgcat::mcset pb_msg_spanish "MC(block,name_msg)"                     "Nombre del bloque no válido.\n Especifique otro nombre."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_spanish "MC(address,tab,Label)"                  "PALABRA"
::msgcat::mcset pb_msg_spanish "MC(address,Status)"                     "Definir las palabras"

::msgcat::mcset pb_msg_spanish "MC(address,name,Label)"                 "Nombre de la palabra"
::msgcat::mcset pb_msg_spanish "MC(address,name,Context)"               "Puede editar el nombre de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,verify,Label)"               "PALABRA --  Verificación"
::msgcat::mcset pb_msg_spanish "MC(address,verify,Context)"             "Esta ventana muestra el código representativo N/C para que sea la salida de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,leader,Label)"               "Llamada"
::msgcat::mcset pb_msg_spanish "MC(address,leader,Context)"             "Podrá introducir cualquier número de caracteres como la llamada de una palabra o seleccionar un carácter de un menú emergente mediante el botón derecho del ratón."

::msgcat::mcset pb_msg_spanish "MC(address,format,Label)"               "Formato"
::msgcat::mcset pb_msg_spanish "MC(address,format,edit,Label)"          "Editar"
::msgcat::mcset pb_msg_spanish "MC(address,format,edit,Context)"        "Este botón le permitirá editar el formato usado por una palabra."
::msgcat::mcset pb_msg_spanish "MC(address,format,new,Label)"           "Nuevo"
::msgcat::mcset pb_msg_spanish "MC(address,format,new,Context)"         "Este botón le permite crear un nuevo formato."

::msgcat::mcset pb_msg_spanish "MC(address,format,select,Label)"        "PALABRA -- Seleccionar el formato"
::msgcat::mcset pb_msg_spanish "MC(address,format,select,Context)"      "Este botón le permite seleccionar un formato diferente de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,trailer,Label)"              "Rastreador"
::msgcat::mcset pb_msg_spanish "MC(address,trailer,Context)"            "Podrá introducir cualquier número de caracteres como el rastreador de una palabra o seleccionar un carácter de un menú emergente mediante el botón derecho del ratón."

::msgcat::mcset pb_msg_spanish "MC(address,modality,Label)"             "¿Modal?"
::msgcat::mcset pb_msg_spanish "MC(address,modality,Context)"           "Esta opción le permitirá configurar la modalidad de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,modal_drop,off,Label)"       "Desactivado"
::msgcat::mcset pb_msg_spanish "MC(address,modal_drop,once,Label)"      "Una vez"
::msgcat::mcset pb_msg_spanish "MC(address,modal_drop,always,Label)"    "Siempre"

::msgcat::mcset pb_msg_spanish "MC(address,max,value,Label)"            "Máximo"
::msgcat::mcset pb_msg_spanish "MC(address,max,value,Context)"          "Deberá especificar un valor máximo de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,value,text,Label)"           "Valor"

::msgcat::mcset pb_msg_spanish "MC(address,trunc_drop,Label)"           "Truncar el valor"
::msgcat::mcset pb_msg_spanish "MC(address,warn_drop,Label)"            "Avisar al usuario"
::msgcat::mcset pb_msg_spanish "MC(address,abort_drop,Label)"           "Interrumpir el proceso"

::msgcat::mcset pb_msg_spanish "MC(address,max,error_handle,Label)"     "Manejo de la transgresión"
::msgcat::mcset pb_msg_spanish "MC(address,max,error_handle,Context)"   "Este botón le permite especificar el método para manejar la transgresión al valor máximo: \n \n * Truncar el valor \n * Avisar al usuario \n * Interrumpir el proceso \n"

::msgcat::mcset pb_msg_spanish "MC(address,min,value,Label)"            "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(address,min,value,Context)"          "Deberá especificar un valor mínimo de una palabra."

::msgcat::mcset pb_msg_spanish "MC(address,min,error_handle,Label)"     "Manejo de la transgresión"
::msgcat::mcset pb_msg_spanish "MC(address,min,error_handle,Context)"   "Este botón le permite especificar el método para manejar la transgresión al valor mínimo: \n \n * Truncar el valor \n * Avisar al usuario \n * Interrumpir el proceso \n"

::msgcat::mcset pb_msg_spanish "MC(address,format_trans,title,Label)"   "FORMATO "
::msgcat::mcset pb_msg_spanish "MC(address,none_popup,Label)"           "Ninguno"

::msgcat::mcset pb_msg_spanish "MC(address,exp,Label)"                  "Expresión"
::msgcat::mcset pb_msg_spanish "MC(address,exp,Context)"                "Puede especificar una expresión o una constante en un bloque."
::msgcat::mcset pb_msg_spanish "MC(address,exp,msg)"                    "La expresión de un elemento de bloque no debe estar en blanco."
::msgcat::mcset pb_msg_spanish "MC(address,exp,space_only)"             "La expresión de un elemento de bloque usando un formato numérico no puede contener solamente espacios."

## No translation is needed for this string.
::msgcat::mcset pb_msg_spanish "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_spanish "MC(address,exp,spec_char_msg)"          "No se pueden utilizar los caracteres especiales \n [::msgcat::mc MC(address,exp,spec_char)] \n en una expresión correspondiente a datos numéricos."



::msgcat::mcset pb_msg_spanish "MC(address,name_msg)"                   "Nombre de la palabra no válido.\n Especifique otro."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_spanish "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 y rapid3 están reservados para el constructor virtual de postprocesamientos.\n Especifique otro nombre."

::msgcat::mcset pb_msg_spanish "MC(address,rapid1,desc)"                "Posición del rápido a lo largo del eje longitudinal"
::msgcat::mcset pb_msg_spanish "MC(address,rapid2,desc)"                "Posición del rápido a lo largo del eje transversal"
::msgcat::mcset pb_msg_spanish "MC(address,rapid3,desc)"                "Posición del rápido a lo largo del eje del husillo"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_spanish "MC(format,tab,Label)"                   "FORMATO"
::msgcat::mcset pb_msg_spanish "MC(format,Status)"                      "Definir los formatos"

::msgcat::mcset pb_msg_spanish "MC(format,verify,Label)"                "FORMATO -- Verificación"
::msgcat::mcset pb_msg_spanish "MC(format,verify,Context)"              "Esta ventana muestra el código representativo de N/C que se producirá usando el formato especificado."

::msgcat::mcset pb_msg_spanish "MC(format,name,Label)"                  "Nombre del formato"
::msgcat::mcset pb_msg_spanish "MC(format,name,Context)"                "Puede editar el nombre de un formato."

::msgcat::mcset pb_msg_spanish "MC(format,data,type,Label)"             "Tipo de dato"
::msgcat::mcset pb_msg_spanish "MC(format,data,type,Context)"           "Debe especificar el tipo de datos correspondiente a un formato."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,Label)"              "Numérico"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,Context)"            "Esta opción define el tipo de dato de un formato como un valor numérico."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,integer,Label)"      "FORMATO -- Dígitos de un número entero"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,integer,Context)"    "Esta opción especifica el número de dígitos de un número entero o la parte de un número entero de un número real."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,fraction,Label)"     "FORMATO -- Dígitos de una fracción"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,fraction,Context)"   "Esta opción especifica el número de dígitos de la parte de una fracción de un número real."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,decimal,Label)"      "Punto decimal de salida (.)"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,decimal,Context)"    "Esta opción le permite producir puntos decimales en el código N/C."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,lead,Label)"         "Ceros a la izquierda a la salida"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,lead,Context)"       "Esta opción activa el relleno de los ceros a la izquierda en los números del código N/C."
::msgcat::mcset pb_msg_spanish "MC(format,data,num,trail,Label)"        "Ceros a la derecha de la salida"
::msgcat::mcset pb_msg_spanish "MC(format,data,num,trail,Context)"      "Esta opción activa el relleno de los ceros a la derecha en los números reales en el código N/C."
::msgcat::mcset pb_msg_spanish "MC(format,data,text,Label)"             "Texto"
::msgcat::mcset pb_msg_spanish "MC(format,data,text,Context)"           "Esta opción define el tipo de dato de un formato como una cadena de texto."
::msgcat::mcset pb_msg_spanish "MC(format,data,plus,Label)"             "Signo de más (+) anterior a la salida"
::msgcat::mcset pb_msg_spanish "MC(format,data,plus,Context)"           "Esta opción le permite producir un signo más en el código N/C."
::msgcat::mcset pb_msg_spanish "MC(format,zero_msg)"                    "No puede hacer una copia del formato cero"
::msgcat::mcset pb_msg_spanish "MC(format,zero_cut_msg)"                "No puede eliminar un formato cero"

::msgcat::mcset pb_msg_spanish "MC(format,data,dec_zero,msg)"           "Será necesario verificar por lo menos una de las opciones Punto decimal, Cero a la izquierda o Cero a la derecha."

::msgcat::mcset pb_msg_spanish "MC(format,data,no_digit,msg)"           "El número de dígitos para los números enteros y las fracciones no debe ser cero."

::msgcat::mcset pb_msg_spanish "MC(format,name_msg)"                    "Nombre del formato no válido.\n Especifique otro nombre."
::msgcat::mcset pb_msg_spanish "MC(format,error,title)"                 "Error de formato"
::msgcat::mcset pb_msg_spanish "MC(format,error,msg)"                   "Se ha utilizado este formato en las Direcciones"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_spanish "MC(other,tab,Label)"                    "Otros elementos de datos"
::msgcat::mcset pb_msg_spanish "MC(other,Status)"                       "Especificar los parámetros"

::msgcat::mcset pb_msg_spanish "MC(other,seq_num,Label)"                "Número de la secuencia"
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,Context)"              "Este selector le permite activar o desactivar la salida de los números de la secuencia en el código N/C."
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,start,Label)"          "Inicio de los números de la secuencia"
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,start,Context)"        "Especifique el inicio de los números de la secuencia."
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,inc,Label)"            "Incremento de los números de la secuencia"
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,inc,Context)"          "Especifique el incremento de los números de la secuencia."
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,freq,Label)"           "Frecuencia del número de la secuencia."
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,freq,Context)"         "Especifique la frecuencia de los números de la secuencia que aparecen en el código N/C."
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,max,Label)"            "Valor máximo de los números de la secuencia"
::msgcat::mcset pb_msg_spanish "MC(other,seq_num,max,Context)"          "Especifique el valor máximo de los números de la secuencia."

::msgcat::mcset pb_msg_spanish "MC(other,chars,Label)"                  "Caracteres especiales"
::msgcat::mcset pb_msg_spanish "MC(other,chars,word_sep,Label)"         "Separador de palabras"
::msgcat::mcset pb_msg_spanish "MC(other,chars,word_sep,Context)"       "Especifique un carácter que se utilizará como el separador de palabras."
::msgcat::mcset pb_msg_spanish "MC(other,chars,decimal_pt,Label)"       "Punto decimal"
::msgcat::mcset pb_msg_spanish "MC(other,chars,decimal_pt,Context)"     "Especifique un carácter que se utilizará como un punto decimal."
::msgcat::mcset pb_msg_spanish "MC(other,chars,end_of_block,Label)"     "Fin del bloque"
::msgcat::mcset pb_msg_spanish "MC(other,chars,end_of_block,Context)"   "Especifique un carácter que se utilizará como el fin del bloque."
::msgcat::mcset pb_msg_spanish "MC(other,chars,comment_start,Label)"    "Inicio del mensaje"
::msgcat::mcset pb_msg_spanish "MC(other,chars,comment_start,Context)"  "Especifique los caracteres que utilizará como inicio de un renglón del mensaje del operador."
::msgcat::mcset pb_msg_spanish "MC(other,chars,comment_end,Label)"      "Fin del mensaje"
::msgcat::mcset pb_msg_spanish "MC(other,chars,comment_end,Context)"    "Especifique los caracteres que utilizará como fin de un renglón del mensaje del operador."

::msgcat::mcset pb_msg_spanish "MC(other,opskip,Label)"                 "SALTAR LA OPCIÓN (OPSKIP)"
::msgcat::mcset pb_msg_spanish "MC(other,opskip,leader,Label)"          "Llamada de línea"
::msgcat::mcset pb_msg_spanish "MC(other,opskip,leader,Context)"        "Llamada de la línea SALTAR OPCIÓN"

::msgcat::mcset pb_msg_spanish "MC(other,gm_codes,Label)"               "Salida de los códigos G y M por bloque"
::msgcat::mcset pb_msg_spanish "MC(other,g_codes,Label)"                "Número de códigos G por bloque"
::msgcat::mcset pb_msg_spanish "MC(other,g_codes,Context)"              "Este selector le permite activar o desactivar el control del número de códigos G por bloque de salida N/C."
::msgcat::mcset pb_msg_spanish "MC(other,g_codes,num,Label)"            "Número de códigos G"
::msgcat::mcset pb_msg_spanish "MC(other,g_codes,num,Context)"          "Especifique el número de códigos M por bloque de salida N/C."
::msgcat::mcset pb_msg_spanish "MC(other,m_codes,Label)"                "Número de códigos M"
::msgcat::mcset pb_msg_spanish "MC(other,m_codes,Context)"              "Este selector le permite activar o desactivar el control del número de códigos M por bloque de salida N/C."
::msgcat::mcset pb_msg_spanish "MC(other,m_codes,num,Label)"            "Número de códigos M por bloque"
::msgcat::mcset pb_msg_spanish "MC(other,m_codes,num,Context)"          "Especifique el número de códigos M por bloque de salida N/C."

::msgcat::mcset pb_msg_spanish "MC(other,opt_none,Label)"               "Ninguno"
::msgcat::mcset pb_msg_spanish "MC(other,opt_space,Label)"              "Espacio"
::msgcat::mcset pb_msg_spanish "MC(other,opt_dec,Label)"                "Decimal (.)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_comma,Label)"              "Coma (,)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_semi,Label)"               "Punto y coma (;)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_colon,Label)"              "Dos puntos (:)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_text,Label)"               "Cadena de texto"
::msgcat::mcset pb_msg_spanish "MC(other,opt_left,Label)"               "Paréntesis izquierdo ("
::msgcat::mcset pb_msg_spanish "MC(other,opt_right,Label)"              "Paréntesis derecho )"
::msgcat::mcset pb_msg_spanish "MC(other,opt_pound,Label)"              "Signo de libra (\#)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_aster,Label)"              "Asterisco (*)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_slash,Label)"              "Barra inclinada (/)"
::msgcat::mcset pb_msg_spanish "MC(other,opt_new_line,Label)"           "Nueva línea (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_spanish "MC(other,ude,Label)"                    "Eventos definidos por el usuario"
::msgcat::mcset pb_msg_spanish "MC(other,ude_include,Label)"            "Incluir otro archivo CDL"
::msgcat::mcset pb_msg_spanish "MC(other,ude_include,Context)"          "Esta opción le permite al postprocesamiento incluir una referencia a un archivo CDL en el archivo de definición."

::msgcat::mcset pb_msg_spanish "MC(other,ude_file,Label)"               "Nombre del archivo CDL"
::msgcat::mcset pb_msg_spanish "MC(other,ude_file,Context)"             "La ruta y el nombre del archivo de un archivo CDL serán referenciados (INCLUIR) en el archivo de definición de este postprocesamiento.  El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, UGII_CAM_FILE_SEARCH_PATH se utilizará para ubicar el archivo de UG/NX en el tiempo de ejecución."
::msgcat::mcset pb_msg_spanish "MC(other,ude_select,Label)"             "Seleccionar el nombre"
::msgcat::mcset pb_msg_spanish "MC(other,ude_select,Context)"           "Seleccione un archivo CDL que será referenciado (INCLUIR) en el archivo de definición de este postprocesamiento. Se añadirá automáticamente el nombre del archivo seleccionado al inicio de la lista con\\\$UGII_CAM_USER_DEF_EVENT_DIR/.  Podrá editar el nombre de la ruta según desee al finalizar la selección."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(output,tab,Label)"                   "Ajustes de salida"
::msgcat::mcset pb_msg_spanish "MC(output,Status)"                      "Configurar los parámetros de salida"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(output,vnc,Label)"                   "Controlador virtual N/C "
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,std,Label)"          "Independiente"
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,sub,Label)"          "Subordinado"
::msgcat::mcset pb_msg_spanish "MC(output,vnc,status,Label)"            "Seleccionar un archivo VNC (Computación en red virtual)."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mis_match,Label)"         "El archivo seleccionado no concueda con el nombre predeterminado del archivo VNC (Computación en red virtual). \n ¿Desea volver a seleccionar el archivo? "
::msgcat::mcset pb_msg_spanish "MC(output,vnc,output,Label)"            "Generar un controlador virtual N/C (VNC, Computación en red virtual). "
::msgcat::mcset pb_msg_spanish "MC(output,vnc,output,Context)"          "Esta opción le permite generar un controlador de la Computación en red virtual de N/C. Se podrá utilizar un postprocesamiento creado con la Computación en red virtual activado para ISV."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,main,Label)"              "Computación en red virtual maestra"
::msgcat::mcset pb_msg_spanish "MC(output,vnc,main,Context)"            "El nombre de la Computación en red virtual maestra que se originará mediante una Computación en red virtual subordinada.  Probablemente en el tiempo de ejecución de ISV, se encontrará este postprocesamiento en el directorio donde se encuentra la Computación en red virtual subordinada, de lo contrario, se utilizará un postprocesamiento con el mismo nombre en el directorio \\\$UGII_CAM_POST_DIR."


::msgcat::mcset pb_msg_spanish "MC(output,vnc,main,err_msg)"                 "Deberá especificar una Computación en red virtual maestra correspondiente a una Computación en red virtual subordinada."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,main,select_name,Label)"       "Seleccionar el nombre"
::msgcat::mcset pb_msg_spanish "MC(output,vnc,main,select_name,Context)"     "Seleccione el nombre de una Computación en red virtual que se originará mediante una computación en red virtual subordinada. En el tiempo de ejecución del ISV se encontrará este postprocesamiento en el directorio donde se encuentra la Computación en red virtual, de lo contrario, se utilizará un postprocesamiento con el msmo nombre en el directorio \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,Label)"                   "Modo del controlador virtual N/C "
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,Context)"                 "Un controlador virtual N/C puede ser independiente o estar subordinado a una VNC (Computación en red virtual) maestra."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,std,Context)"             "Una VNC independiente es autocontenida."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,mode,sub,Context)"             "Una VNC (Computación en red virtual) es principalmente dependiente de la VNC maestra. Originará la VNC maestra en el tiempo de ejecución ISV."
::msgcat::mcset pb_msg_spanish "MC(output,vnc,pb_ver,msg)"                   "Controlador virtual N/C creado con el constructor virtual de postprocesamientos "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(listing,tab,Label)"                  "Archivo de listados"
::msgcat::mcset pb_msg_spanish "MC(listing,Status)"                     "Especificar los parámetros del archivo de listados"

::msgcat::mcset pb_msg_spanish "MC(listing,gen,Label)"                  "Generar el archivo de listados"
::msgcat::mcset pb_msg_spanish "MC(listing,gen,Context)"                "Este selector le permite activar o desactivar la salida al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,Label)"                      "Elementos del archivo de listados"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,Label)"                "Componentes"

::msgcat::mcset pb_msg_spanish "MC(listing,parms,x,Label)"              "Coordenada X"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,x,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada X al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,y,Label)"              "Coordenada Y"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,y,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada Y al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,z,Label)"              "Coordenada Z"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,z,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada Z al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,4,Label)"              "Ángulo del cuarto eje"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,4,Context)"            "Este selector le permite activar o desactivar la salida del ángulo del cuarto eje al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,5,Label)"              "Ángulo del quinto eje"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,5,Context)"            "Este selector le permite activar o desactivar la salida del ángulo del quinto eje al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,feed,Label)"           "Avance"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,feed,Context)"         "Este selector le permite activar o desactivar la salida de la velocidad de avance al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,parms,speed,Label)"          "Velocidad"
::msgcat::mcset pb_msg_spanish "MC(listing,parms,speed,Context)"        "Este selector le permite activar o desactivar la salida de la velocidad del husillo al archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,extension,Label)"            "Extensión del archivo de listados"
::msgcat::mcset pb_msg_spanish "MC(listing,extension,Context)"          "Especificar la extensión del archivo de listados"

::msgcat::mcset pb_msg_spanish "MC(listing,nc_file,Label)"              "Extensión del archivo de salida N/C"
::msgcat::mcset pb_msg_spanish "MC(listing,nc_file,Context)"            "Especificar la extensión del archivo de salida N/C"

::msgcat::mcset pb_msg_spanish "MC(listing,header,Label)"               "Cabecera del programa"
::msgcat::mcset pb_msg_spanish "MC(listing,header,oper_list,Label)"     "Lista de operaciones"
::msgcat::mcset pb_msg_spanish "MC(listing,header,tool_list,Label)"     "Lista de herramientas"

::msgcat::mcset pb_msg_spanish "MC(listing,footer,Label)"               "Pie de página del programa "
::msgcat::mcset pb_msg_spanish "MC(listing,footer,cut_time,Label)"      "Hora total de maquinado"

::msgcat::mcset pb_msg_spanish "MC(listing,format,Label)"                   "Formato de la página"
::msgcat::mcset pb_msg_spanish "MC(listing,format,print_header,Label)"      "Imprimir el encabezamiento de la página "
::msgcat::mcset pb_msg_spanish "MC(listing,format,print_header,Context)"    "Este selector le permite activar o desactivar la salida del encabezamiento de la página al archivo de listas."

::msgcat::mcset pb_msg_spanish "MC(listing,format,length,Label)"        "Longitud de la página (filas)"
::msgcat::mcset pb_msg_spanish "MC(listing,format,length,Context)"      "Especifique el número de filas por página correspondiente a este archivo de listados."
::msgcat::mcset pb_msg_spanish "MC(listing,format,width,Label)"         "Anchura de la página (columnas)"
::msgcat::mcset pb_msg_spanish "MC(listing,format,width,Context)"       "Especifique el número de columnas por página correspondiente a este archivo de listados."

::msgcat::mcset pb_msg_spanish "MC(listing,other,tab,Label)"            "Otras opciones"
::msgcat::mcset pb_msg_spanish "MC(listing,output,Label)"               "Elementos de control de salida"

::msgcat::mcset pb_msg_spanish "MC(listing,output,warning,Label)"       "Mensajes de aviso de salida"
::msgcat::mcset pb_msg_spanish "MC(listing,output,warning,Context)"     "Este selector le permite activar o desactivar la salida de los mensajes de avisos durante el postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(listing,output,review,Label)"        "Activar la herramienta de revisión"
::msgcat::mcset pb_msg_spanish "MC(listing,output,review,Context)"      "Este selector le permite activar la herramienta de revisión durante el postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(listing,output,group,Label)"         "Generar la salida del grupo"
::msgcat::mcset pb_msg_spanish "MC(listing,output,group,Context)"       "Este selector le permite activar o desactivar el control de la salida del grupo durante el postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(listing,output,verbose,Label)"       "Visualizar los mensajes de error verbosos"
::msgcat::mcset pb_msg_spanish "MC(listing,output,verbose,Context)"     "Este selector le permite visualizar las descripciones extendidas de las condiciones de error. Desacelerará la velocidad del postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(listing,oper_info,Label)"            "Información sobre la operación"
::msgcat::mcset pb_msg_spanish "MC(listing,oper_info,parms,Label)"      "Parámetros operativos"
::msgcat::mcset pb_msg_spanish "MC(listing,oper_info,tool,Label)"       "Parámetros de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(listing,oper_info,cut_time,,Label)"  "Hora del maquinado"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_spanish "MC(listing,user_tcl,frame,Label)"       "Fuente Tcl del usuario"
::msgcat::mcset pb_msg_spanish "MC(listing,user_tcl,check,Label)"       "Archivo fuente Tcl del usuario"
::msgcat::mcset pb_msg_spanish "MC(listing,user_tcl,check,Context)"     "Este selector le permite originar su propio archivo Tcl"
::msgcat::mcset pb_msg_spanish "MC(listing,user_tcl,name,Label)"        "Nombre del archivo"
::msgcat::mcset pb_msg_spanish "MC(listing,user_tcl,name,Context)"      "Especifique el nombre de un archivo Tcl que desee originar para este postprocesamiento."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(preview,tab,Label)"                  "Vista preliminar de los archivos de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(preview,new_code,Label)"             "Código nuevo"
::msgcat::mcset pb_msg_spanish "MC(preview,old_code,Label)"             "Código antiguo"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_spanish "MC(event_handler,tab,Label)"            "Manipulador de eventos"
::msgcat::mcset pb_msg_spanish "MC(event_handler,Status)"               "Seleccione el evento para ver el procedimiento"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_spanish "MC(definition,tab,Label)"               "Definiciones"
::msgcat::mcset pb_msg_spanish "MC(definition,Status)"                  "Seleccionar el ítem para ver el contenido"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_spanish "MC(advisor,tab,Label)"                  "Asesor de postprocesamientos"
::msgcat::mcset pb_msg_spanish "MC(advisor,Status)"                     "Asesor de postprocesamientos"

::msgcat::mcset pb_msg_spanish "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_spanish "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_spanish "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_spanish "MC(definition,include,Label)"           "INCLUIR"
::msgcat::mcset pb_msg_spanish "MC(definition,format_txt,Label)"        "FORMATO"
::msgcat::mcset pb_msg_spanish "MC(definition,addr_txt,Label)"          "PALABRA"
::msgcat::mcset pb_msg_spanish "MC(definition,block_txt,Label)"         "BLOQUE"
::msgcat::mcset pb_msg_spanish "MC(definition,comp_txt,Label)"          "BLOQUE compuesto"
::msgcat::mcset pb_msg_spanish "MC(definition,post_txt,Label)"          "BLOQUE de postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(definition,oper_txt,Label)"          "Mensaje del operador"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_spanish "MC(msg,odd)"                            "Número impar de los argumentos de la opción"
::msgcat::mcset pb_msg_spanish "MC(msg,wrong_list_1)"                   "Opciones desconocidas"
::msgcat::mcset pb_msg_spanish "MC(msg,wrong_list_2)"                   ". Debe ser uno de:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_spanish "MC(event,start_prog,name)"              "Inicio del programa"

### Operation Start
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,start_path,name)"    "Inicio de la trayectoria"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,from_move,name)"     "Movimiento desde"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,fst_tool,name)"      "Primera herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,auto_tc,name)"       "Modificación automática de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,manual_tc,name)"     "Modificación manual de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,init_move,name)"     "Movimiento inicial"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,fst_move,name)"      "Primer movimiento"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,appro_move,name)"    "Movimiento de aproximación"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,engage_move,name)"   "Movimiento de entrada"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,fst_cut,name)"       "Primer corte"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,fst_lin_move,name)"  "Primer movimiento lineal"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,start_pass,name)"    "Inicio de la pasada"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,cutcom_move,name)"   "Movimiento de la compensación de cortador"
::msgcat::mcset pb_msg_spanish "MC(event,opr_start,lead_move,name)"     "Guía en movimiento"

### Operation End
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,ret_move,name)"        "Movimiento de retroceso"
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,rtn_move,name)"        "Movimiento de retorno"
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,goh_move,name)"        "Movimiento Ir a inicio"
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,end_path,name)"        "Fin de la trayectoria"
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,lead_move,name)"       "Movimiento exterior de la guía"
::msgcat::mcset pb_msg_spanish "MC(event,opr_end,end_pass,name)"        "Fin de la pasada"

### Program End
::msgcat::mcset pb_msg_spanish "MC(event,end_prog,name)"                "Fin del programa"


### Tool Change
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,name)"             "Modificación de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,m_code)"           "Código M"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,m_code,tl_chng)"   "Modificación de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,m_code,pt)"        "Torreta primaria"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,m_code,st)"        "Torreta secundaria"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,t_code)"           "Código T"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,t_code,conf)"      "Configurar"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,t_code,pt_idx)"    "Torreta primaria "
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,t_code,st_idx)"    "Índice de torretas secundarias"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,tool_num)"         "Número de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,tool_num,min)"     "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,tool_num,max)"     "Máximo"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,time)"             "Hora (seg)"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,time,tl_chng)"     "Modificación de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,retract)"          "Retroceso"
::msgcat::mcset pb_msg_spanish "MC(event,tool_change,retract_z)"        "Retroceso a Z de"

### Length Compensation
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,name)"            "Compensación de la longitud"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,g_code)"          "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,g_code,len_adj)"  "Ajuste de la longitud de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,t_code)"          "Código T"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,t_code,conf)"     "Configurar"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,len_off)"         "Registro de offset de longitud"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,len_off,min)"     "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(event,length_compn,len_off,max)"     "Máximo"

### Set Modes
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,name)"               "Configurar los modos"
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,out_mode)"           "Modo de salida"
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,g_code)"             "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,g_code,absolute)"    "Absoluto"
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,g_code,incremental)" "Incremental"
::msgcat::mcset pb_msg_spanish "MC(event,set_modes,rotary_axis)"        "El eje rotatorio puede ser incremental"

### Spindle RPM
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,name)"                     "RPM del husillo"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,dir_m_code)"               "Husillo "
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,dir_m_code,cw)"            "En sentido horario (CW por su sigla en inglés)"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,dir_m_code,ccw)"           "En sentido antihorario (CCW por su sigla en inglés)"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,range_control)"            "Control del rango de husillos"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,range_control,dwell_time)" "Intervalo de reposo de modificación de rangos (seg)"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_rpm,range_control,range_code)" "Especificar el código de rangos"

### Spindle CSS
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,name)"             "CSS del husillo"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,g_code)"           "Código G de husillos"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,g_code,const)"     "Código de superficies constantes"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,g_code,max)"       "Código de RMP máximo"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,g_code,sfm)"       "Código para cancelar SFM"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,max)"              "RMP máximo durante CSS"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_css,sfm)"              "Tener siempre un modo IPM para SFM"

### Spindle Off
::msgcat::mcset pb_msg_spanish "MC(event,spindle_off,name)"             "Husillo desactivado"
::msgcat::mcset pb_msg_spanish "MC(event,spindle_off,dir_m_code)"       "Código M de dirección del husillo "
::msgcat::mcset pb_msg_spanish "MC(event,spindle_off,dir_m_code,off)"   "Desactivado"

### Coolant On
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,name)"              "Refrigerante activado"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code)"            "Código M"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code,on)"         "ACTIVADO"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code,flood)"      "Flujo"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code,mist)"       "Niebla"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code,thru)"       "Pasante"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_on,m_code,tap)"        "Macho de roscar"

### Coolant Off
::msgcat::mcset pb_msg_spanish "MC(event,coolant_off,name)"             "Refrigerante desactivado"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_off,m_code)"           "Código M"
::msgcat::mcset pb_msg_spanish "MC(event,coolant_off,m_code,off)"       "Desactivado"

### Inch Metric Mode
::msgcat::mcset pb_msg_spanish "MC(event,inch_metric_mode,name)"            "Modo métrico pulgadas"
::msgcat::mcset pb_msg_spanish "MC(event,inch_metric_mode,g_code)"          "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,inch_metric_mode,g_code,english)"  "Inglés (pulgadas)"
::msgcat::mcset pb_msg_spanish "MC(event,inch_metric_mode,g_code,metric)"   "Métrico (milímetros)"

### Feedrates
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,name)"               "Velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,ipm_mode)"           "Modo IPM (pulgadas por minuto)"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,ipr_mode)"           "Modo IPR (pulgadas por revolución) "
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,dpm_mode)"           "Modo DPM (grados por minuto)"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mmpm_mode)"          "Modo MMPM (milímetros por minuto)"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mmpr_mode)"          "Modo MMPR (milímetros por revolución)"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,frn_mode)"           "Modo FRN (número de la velocidad de avance)"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,g_code)"             "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,format)"             "Formato"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,max)"                "Máximo"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,min)"                "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,label)"         "Modos de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,lin)"           "Solamente lineal"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,rot)"           "Solamente rotatorio"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,lin_rot)"       "Lineal y rotatorio"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,rap_lin)"       "Solamente rápido lineal"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,rap_rot)"       "Solamente rápido rotatorio"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,mode,rap_lin_rot)"   "Solamente rápido lineal y rotatorio"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,cycle_mode)"         "Modo del ciclo de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(event,feedrates,cycle)"              "Ciclo"

### Cutcom On
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,name)"               "Compensación de cortador activado"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,g_code)"             "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,left)"               "Lado izquierdo"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,right)"              "Lado derecho"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,app_planes)"         "Planos aplicables"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,edit_planes)"        "Editar los códigos del plano"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,reg)"                "Registro de compensación de cortador"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,min)"                "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,max)"                "Máximo"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_on,bef)"                "Compensación de cortador desactivada antes de la modificación"

### Cutcom Off
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_off,name)"              "Compensación de cortador desactivada"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_off,g_code)"            "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,cutcom_off,off)"               "Desactivado"

### Delay
::msgcat::mcset pb_msg_spanish "MC(event,delay,name)"                   "Retardo"
::msgcat::mcset pb_msg_spanish "MC(event,delay,seconds)"                "Segundos"
::msgcat::mcset pb_msg_spanish "MC(event,delay,seconds,g_code)"         "Código G"
::msgcat::mcset pb_msg_spanish "MC(event,delay,seconds,format)"         "Formato"
::msgcat::mcset pb_msg_spanish "MC(event,delay,out_mode)"               "Modo de salida"
::msgcat::mcset pb_msg_spanish "MC(event,delay,out_mode,sec)"           "Solamente segundos"
::msgcat::mcset pb_msg_spanish "MC(event,delay,out_mode,rev)"           "Solamente revoluciones"
::msgcat::mcset pb_msg_spanish "MC(event,delay,out_mode,feed)"          "Depende de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(event,delay,out_mode,ivs)"           "Tiempo inverso"
::msgcat::mcset pb_msg_spanish "MC(event,delay,revolution)"             "Revoluciones"
::msgcat::mcset pb_msg_spanish "MC(event,delay,revolution,g_code)"      "Código G"
::msgcat::mcset pb_msg_spanish "MC(event,delay,revolution,format)"      "Formato"

### Option Stop
::msgcat::mcset pb_msg_spanish "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_spanish "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_spanish "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_spanish "MC(event,loadtool,name)"                "Cargar la herramienta"

### Stop
::msgcat::mcset pb_msg_spanish "MC(event,stop,name)"                    "Parar"

### Tool Preselect
::msgcat::mcset pb_msg_spanish "MC(event,toolpreselect,name)"           "Preselección de la herramienta"

### Thread Wire
::msgcat::mcset pb_msg_spanish "MC(event,threadwire,name)"              "Hilo de la rosca"

### Cut Wire
::msgcat::mcset pb_msg_spanish "MC(event,cutwire,name)"                 "Cortar el hilo"

### Wire Guides
::msgcat::mcset pb_msg_spanish "MC(event,wireguides,name)"              "Guías del hilo"

### Linear Move
::msgcat::mcset pb_msg_spanish "MC(event,linear,name)"                  "Movimiento lineal"
::msgcat::mcset pb_msg_spanish "MC(event,linear,g_code)"                "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,linear,motion)"                "Movimiento lineal"
::msgcat::mcset pb_msg_spanish "MC(event,linear,assume)"                "Modo rápido asumido en la velocidad máxima transversal"

### Circular Move
::msgcat::mcset pb_msg_spanish "MC(event,circular,name)"                "Movimiento circular"
::msgcat::mcset pb_msg_spanish "MC(event,circular,g_code)"              "Código G de movimientos"
::msgcat::mcset pb_msg_spanish "MC(event,circular,clockwise)"           "En sentido horario (CLW)"
::msgcat::mcset pb_msg_spanish "MC(event,circular,counter-clock)"       "En sentido antihorario (CCLW)"
::msgcat::mcset pb_msg_spanish "MC(event,circular,record)"              "Registro circular"
::msgcat::mcset pb_msg_spanish "MC(event,circular,full_circle)"         "Círculo completo"
::msgcat::mcset pb_msg_spanish "MC(event,circular,quadrant)"            "Cuadrante"
::msgcat::mcset pb_msg_spanish "MC(event,circular,ijk_def)"             "Definición de IJK"
::msgcat::mcset pb_msg_spanish "MC(event,circular,ij_def)"              "Definición de IJ"
::msgcat::mcset pb_msg_spanish "MC(event,circular,ik_def)"              "Definición de IK"
::msgcat::mcset pb_msg_spanish "MC(event,circular,planes)"              "Planos aplicables"
::msgcat::mcset pb_msg_spanish "MC(event,circular,edit_planes)"         "Editar los códigos del plano"
::msgcat::mcset pb_msg_spanish "MC(event,circular,radius)"              "Radio"
::msgcat::mcset pb_msg_spanish "MC(event,circular,min)"                 "Mínimo"
::msgcat::mcset pb_msg_spanish "MC(event,circular,max)"                 "Máximo"
::msgcat::mcset pb_msg_spanish "MC(event,circular,arc_len)"             "Longitud mínima del arco"

### Rapid Move
::msgcat::mcset pb_msg_spanish "MC(event,rapid,name)"                   "Movimiento rápido"
::msgcat::mcset pb_msg_spanish "MC(event,rapid,g_code)"                 "Cógido G"
::msgcat::mcset pb_msg_spanish "MC(event,rapid,motion)"                 "Movimiento rápido"
::msgcat::mcset pb_msg_spanish "MC(event,rapid,plane_change)"           "Modificación del plano de trabajo"

### Lathe Thread
::msgcat::mcset pb_msg_spanish "MC(event,lathe,name)"                   "Rosca de torno"
::msgcat::mcset pb_msg_spanish "MC(event,lathe,g_code)"                 "Código G de roscas"
::msgcat::mcset pb_msg_spanish "MC(event,lathe,cons)"                   "Constante"
::msgcat::mcset pb_msg_spanish "MC(event,lathe,incr)"                   "Incremental"
::msgcat::mcset pb_msg_spanish "MC(event,lathe,decr)"                   "No incremental"

### Cycle
::msgcat::mcset pb_msg_spanish "MC(event,cycle,g_code)"                 "Código G y personalización"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,customize,Label)"        "Personalizar"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,customize,Context)"      "Este selector le permite personalizar un ciclo. \n\nLa construcción básica de cada ciclo se define automáticamente mediante los ajustes de los parámetros comunes Estos elementos comunes de cada ciclo están restringidos a cualquier modificación. \n\nAl seleccionar este botón obtendrá un control total sobre la configuración de un ciclo.  Las modificaciones realizadas en los parámetros comunes no afectarán los ciclos personalizados."
::msgcat::mcset pb_msg_spanish "MC(event,cycle,start,Label)"            "Inicio del ciclo"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,start,Context)"          "Se puede cambiar esta opción en las máquinas herramientas que ejecutan ciclos con un bloque de inicio de ciclo (G79...) una vez definido el ciclo (G81...)."
::msgcat::mcset pb_msg_spanish "MC(event,cycle,start,text)"             "Utilizar un bloque de inicio de ciclo para ejecutar el ciclo"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,rapid_to)"               "Rápido - A"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,retract_to)"             "Retroceso - A"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,plane_control)"          "Control del plano del ciclo"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,com_param,name)"         "Parámetros comunes"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,cycle_off,name)"         "Ciclo desactivado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,plane_chng,name)"        "Modificación en el plano del ciclo"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill,name)"             "Taladrado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_dwell,name)"       "Intervalo de reposo del taladrado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_text,name)"        "Texto del taladrado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_csink,name)"       "Broca avellanada"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_deep,name)"        "Taladrado de profundidad"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_brk_chip,name)"    "Virutas resultantes del taladrado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,tap,name)"               "Macho de roscar"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore,name)"              "Mandrinado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_dwell,name)"        "Intervalo de reposo del mandrinado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_drag,name)"         "Mandrinado con arrastre"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_no_drag,name)"      "Mandrinado sin arrastre"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_back,name)"         "Mandrinado de retroceso"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_manual,name)"       "Mandrinado manual"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_manual_dwell,name)" "Intervalo de reposo del mandrinado manual"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,peck_drill,name)"        "Punteado"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,break_chip,name)"        "Romper las virutas"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_dwell_sf,name)"    "Intervalo de reposo del taladrado (cara de puntos)"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,drill_deep_peck,name)"   "Punteado de profundidad"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_ream,name)"         "Mandrinado (escariado)"
::msgcat::mcset pb_msg_spanish "MC(event,cycle,bore_no-drag,name)"      "Mandarinado sin arrastre"

##------------
## G Code
##
::msgcat::mcset pb_msg_spanish "MC(g_code,rapid,name)"                  "Movimiento rápido"
::msgcat::mcset pb_msg_spanish "MC(g_code,linear,name)"                 "Movimiento lineal"
::msgcat::mcset pb_msg_spanish "MC(g_code,circular_clw,name)"           "Interpelación circular en sentido horario"
::msgcat::mcset pb_msg_spanish "MC(g_code,circular_cclw,name)"          "Interpelación circular en antihoraria"
::msgcat::mcset pb_msg_spanish "MC(g_code,delay_sec,name)"              "Demora (seg)"
::msgcat::mcset pb_msg_spanish "MC(g_code,delay_rev,name)"              "Demora (rev)"
::msgcat::mcset pb_msg_spanish "MC(g_code,pln_xy,name)"                 "Plano XY"
::msgcat::mcset pb_msg_spanish "MC(g_code,pln_zx,name)"                 "Plano ZX"
::msgcat::mcset pb_msg_spanish "MC(g_code,pln_yz,name)"                 "Plano YZ"
::msgcat::mcset pb_msg_spanish "MC(g_code,cutcom_off,name)"             "Compensación de cortador desactivada"
::msgcat::mcset pb_msg_spanish "MC(g_code,cutcom_left,name)"            "Compensación de cortador izquierda"
::msgcat::mcset pb_msg_spanish "MC(g_code,cutcom_right,name)"           "Compensación de cortador derecha"
::msgcat::mcset pb_msg_spanish "MC(g_code,length_plus,name)"            "Ajuste positivo de la longitud de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(g_code,length_minus,name)"           "Ajuste negativo de la longitud de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(g_code,length_off,name)"             "Ajuste desactivado de la longitud de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(g_code,inch,name)"                   "Modo de pulgada"
::msgcat::mcset pb_msg_spanish "MC(g_code,metric,name)"                 "Modo métrico"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_start,name)"            "Código de inicio del ciclo"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_off,name)"              "Ciclo desactivado"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_drill,name)"            "Ciclo de taladrado"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_drill_dwell,name)"      "Intervalo de reposo del ciclo de taladrado"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_drill_deep,name)"       "Ciclo del taladrado de profundidad"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_drill_bc,name)"         "Ciclo de las virantes resultantes del taladrado"
::msgcat::mcset pb_msg_spanish "MC(g_code,tap,name)"                    "Ciclo del roscado"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore,name)"                   "Ciclo del madrinado"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_drag,name)"              "Ciclo del mandrinado con arrastre"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_no_drag,name)"           "Ciclo del mandrinado sin arrastre"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_dwell,name)"             "Intervalo de reposo del ciclo del mandrinado"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_manual,name)"            "Ciclo del mandrinado manual"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_back,name)"              "Ciclo del mandrinado de retroceso"
::msgcat::mcset pb_msg_spanish "MC(g_code,bore_manual_dwell,name)"      "Intervalo de reposo del manual"
::msgcat::mcset pb_msg_spanish "MC(g_code,abs,name)"                    "Modo absoluto"
::msgcat::mcset pb_msg_spanish "MC(g_code,inc,name)"                    "Modo incremental"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_retract_auto,name)"     "Retroceso del ciclo (AUTOMÁTICO)"
::msgcat::mcset pb_msg_spanish "MC(g_code,cycle_retract_manual,name)"   "Retroceso del ciclo (MANUAL)"
::msgcat::mcset pb_msg_spanish "MC(g_code,reset,name)"                  "Resetear"
::msgcat::mcset pb_msg_spanish "MC(g_code,fr_ipm,name)"                 "Modo IPM (pulgadas por minuto) de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,fr_ipr,name)"                 "Modo IPR de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,fr_frn,name)"                 "Modo FRN de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,spindle_css,name)"            "CSS del husillo"
::msgcat::mcset pb_msg_spanish "MC(g_code,spindle_rpm,name)"            "RPM del husillo"
::msgcat::mcset pb_msg_spanish "MC(g_code,ret_home,name)"               "Volver a la Página de inicio"
::msgcat::mcset pb_msg_spanish "MC(g_code,cons_thread,name)"            "Rosca constante"
::msgcat::mcset pb_msg_spanish "MC(g_code,incr_thread,name)"            "Rosca incremental"
::msgcat::mcset pb_msg_spanish "MC(g_code,decr_thread,name)"            "Rosca no incremental"
::msgcat::mcset pb_msg_spanish "MC(g_code,feedmode_in,pm)"              "Modo IPM (pulgadas por minuto) de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,feedmode_in,pr)"              "Modo IPR de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,feedmode_mm,pm)"              "Modo MMPM (milímetros por minuto) de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,feedmode_mm,pr)"              "Modo MMPR (milímetros por revolución) de la velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(g_code,feedmode,dpm)"                "DPM modo de velocidad de avance"

##------------
## M Code
##
::msgcat::mcset pb_msg_spanish "MC(m_code,stop_manual_tc,name)"         "Modificación de la herramienta manual/Detención"
::msgcat::mcset pb_msg_spanish "MC(m_code,stop,name)"                   "Parar"
::msgcat::mcset pb_msg_spanish "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_spanish "MC(m_code,prog_end,name)"               "Fin del programa"
::msgcat::mcset pb_msg_spanish "MC(m_code,spindle_clw,name)"            "Husillo activado/sentido horario "
::msgcat::mcset pb_msg_spanish "MC(m_code,spindle_cclw,name)"           "Husillo en el sentido contrahorario"
::msgcat::mcset pb_msg_spanish "MC(m_code,lathe_thread,type1)"          "Rosca constante"
::msgcat::mcset pb_msg_spanish "MC(m_code,lathe_thread,type2)"          "Rosca incremental"
::msgcat::mcset pb_msg_spanish "MC(m_code,lathe_thread,type3)"          "Rosca no incremental"
::msgcat::mcset pb_msg_spanish "MC(m_code,spindle_off,name)"            "Husillo desactivado"
::msgcat::mcset pb_msg_spanish "MC(m_code,tc_retract,name)"             "Modificación o retroceso de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_on,name)"             "Refrigerante activado"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_fld,name)"            "Inundación de refrigerante"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_mist,name)"           "Neblina del refrigerante"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_thru,name)"           "Refrigerante pasante"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_tap,name)"            "Macho de roscar del refrigerante"
::msgcat::mcset pb_msg_spanish "MC(m_code,coolant_off,name)"            "Refrigerante desactivado"
::msgcat::mcset pb_msg_spanish "MC(m_code,rewind,name)"                 "Rebobinar"
::msgcat::mcset pb_msg_spanish "MC(m_code,thread_wire,name)"            "Hilo de la rosca"
::msgcat::mcset pb_msg_spanish "MC(m_code,cut_wire,name)"               "Cortar el hilo"
::msgcat::mcset pb_msg_spanish "MC(m_code,fls_on,name)"                 "Descarga activada"
::msgcat::mcset pb_msg_spanish "MC(m_code,fls_off,name)"                "Descarga desactivada"
::msgcat::mcset pb_msg_spanish "MC(m_code,power_on,name)"               "Potencia activada"
::msgcat::mcset pb_msg_spanish "MC(m_code,power_off,name)"              "Potencia desactivada"
::msgcat::mcset pb_msg_spanish "MC(m_code,wire_on,name)"                "Hilo activado"
::msgcat::mcset pb_msg_spanish "MC(m_code,wire_off,name)"               "Hilo desactivado"
::msgcat::mcset pb_msg_spanish "MC(m_code,pri_turret,name)"             "Torreta primaria"
::msgcat::mcset pb_msg_spanish "MC(m_code,sec_turret,name)"             "Torreta secundaria"

##------------
## UDE
##
::msgcat::mcset pb_msg_spanish "MC(ude,editor,enable,Label)"            "Activar el editor de UDE"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,enable,as_saved,Label)"   "Según lo guardado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,TITLE)"                   "Eventos definidos por el usuario"

::msgcat::mcset pb_msg_spanish "MC(ude,editor,no_ude)"                  "No hay ningún UDE de relevancia."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,int,Label)"               "Número entero"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,int,Context)"             "Agregar un nuevo parámetro de número entero arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,real,Label)"              "Real"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,real,Context)"            "Agregar un nuevo parámetro real arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,txt,Label)"               "Texto"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,txt,Context)"             "Agregar un nuevo parámetro de cadena arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,bln,Label)"               "Booleano"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,bln,Context)"             "Agregar un nuevo parámetro booleano arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,Label)"               "Opción"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,Context)"             "Agregar un nuevo parámetro de opción arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,pnt,Label)"               "Punto"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,pnt,Context)"             "Agregar un nuevo parámetro de punto arrastrándolo a la lista de la derecha."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,trash,Label)"             "Editor -- Papelera de reciclaje"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,trash,Context)"           "Puede disponer de los parámetros no deseados de la lista a la derecha arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,event,Label)"             "Evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,event,Context)"           "No puede editar los parámetros del evento aquí con el B1R."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,Label)"             "Evento -- Parámetros"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,Context)"           "Puede editar cada parámetro pulsando el botón derecho del ratón o modificando el orden de los parámetros con la función arrastrar y soltar.\n \nEl parámetro en color celeste es un parámetro definido por el sistema, por lo tanto, no se puede eliminar.El parámetro en color madera no es un parámetro definido por el sistema, por lo tanto, se puede modificar o eliminar."

::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,edit,Label)"        "Parámetros -- Opción"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,edit,Context)"      "Pulse el botón 1 del ratón para seleccionar la opción predeterminada. \nPulse dos veces el botón 1 del ratón (B1R) para editar la opción."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,editor,Label)"      "Tipo de parámetro: "

::msgcat::mcset pb_msg_spanish "MC(ude,editor,pnt,sel,Label)"           "Seleccionar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,pnt,dsp,Label)"           "Visualizar"

::msgcat::mcset pb_msg_spanish "MC(ude,editor,dlg,ok,Label)"            "Aceptar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,dlg,bck,Label)"           "Atrás"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,dlg,cnl,Label)"           "Cancelar"

::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,PL,Label)"       "Etiqueta de parámetro"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,VN,Label)"       "Nombre de la variable"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,DF,Label)"       "Valor predeterminado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,PL,Context)"     "Especificar la etiqueta del parámetro"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,VN,Context)"     "Especificar el nombre de la variable"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,DF,Context)"     "Especificar el valor predeterminado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,TG)"             "Botón selector"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,TG,B,Label)"     "Botón selector"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,TG,B,Context)"   "Seleccionar el valor Botón selector"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ON,Label)"       "Activado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,OFF,Label)"      "Desactivado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ON,Context)"     "Seleccionar el valor predeterminado como ACTIVADO"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,OFF,Context)"    "Seleccionar el valor predeterminado como DESACTIVADO"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,OL)"             "Lista de opciones"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ADD,Label)"      "Agregar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,CUT,Label)"      "Cortar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,PASTE,Label)"    "Pegar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ADD,Context)"    "Agregar un ítem"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,CUT,Context)"    "Cortar un ítem"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,PASTE,Context)"  "Pegar un ítem"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ENTRY,Label)"    "Opción"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,paramdlg,ENTRY,Context)"  "Introducir un ítem"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EN,Label)"       "Nombre del evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EN,Context)"     "Especificar el nombre del evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,PEN,Label)"      "Nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,PEN,Context)"    "Especificar el nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,PEN,C,Context)"  "Este selector le permite configurar el nombre del postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EL,Label)"       "Etiqueta de evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EL,Context)"     "Especificar la etiqueta de evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EL,C,Label)"     "Etiqueta de evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EL,C,Context)"   "Este selector le permite configurar la etiqueta de evento"

::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC,Label)"           "Categoría"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC,Context)"         "Este selector le permite configurar la categoría"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fresado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Taladrado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Torno"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Electroerosión por hilo"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Configurar la categoría del fresado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Configurar la categoría del taladrado"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Configurar la categoría del torno"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Configurar la categoría de la electroerosión por hilo"

::msgcat::mcset pb_msg_spanish "MC(ude,editor,EDIT)"                    "Editar el evento"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,CREATE)"                  "Crear un evento de control de máquina"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,HELP)"              "Ayuda"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,EDIT)"              "Editar los parámetros definidos por el usuario..."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,EDIT)"              "Editar..."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,VIEW)"              "Vista..."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,DELETE)"            "Eliminar"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,CREATE)"            "Crear un nuevo evento de control de máquina..."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,IMPORT)"            "Importar los eventos de control de máquina..."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,MSG_BLANK)"         "El nombre del evento no puede estar en blanco."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,MSG_SAMENAME)"      "El nombre del evento ya existe."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,popup,MSG_SameHandler)"   "El manipulador del evento ya existe. \nModifique el nombre del evento o el nombre del postprocesamiento si ya ha sido verificado."
::msgcat::mcset pb_msg_spanish "MC(ude,validate)"                       "No hay ningún parámetro en este evento."
::msgcat::mcset pb_msg_spanish "MC(ude,prev,tab,Label)"                 "Eventos definidos por el usuario"
::msgcat::mcset pb_msg_spanish "MC(ude,prev,ude,Label)"                 "Eventos de control de máquina"
::msgcat::mcset pb_msg_spanish "MC(ude,prev,udc,Label)"                 "Ciclos definidos por el usuario"
::msgcat::mcset pb_msg_spanish "MC(ude,prev,mc,Label)"                  "Eventos de control de la máquina del sistema"
::msgcat::mcset pb_msg_spanish "MC(ude,prev,nmc,Label)"                 "Sin eventos de control de la máquina del sistema"
::msgcat::mcset pb_msg_spanish "MC(udc,prev,sys,Label)"                 "Ciclos del sistema"
::msgcat::mcset pb_msg_spanish "MC(udc,prev,nsys,Label)"                "Sin ciclos del sistema"
::msgcat::mcset pb_msg_spanish "MC(ude,prev,Status)"                    "Seleccionar el ítem para la definición"
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,MSG_BLANK)"           "La cadena de opción no puede estar en blanco."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,MSG_SAME)"            "Ya existe esta cadena de opción."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,MSG_PST_SAME)"        "Ya existe la opción que acaba de pegar."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,MSG_IDENTICAL)"       "Algunas opciones son idénticas."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,opt,NO_OPT)"              "No hay ninguna opción en la lista."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,MSG_NO_VNAME)"      "El nombre de la variable no puede estar en blanco."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,param,MSG_EXIST_VNAME)"   "El nombre de la variable ya existe."
::msgcat::mcset pb_msg_spanish "MC(ude,editor,spindle_css,INFO)"        "Este evento comparte el UDE con \"RPM del husillo\""
::msgcat::mcset pb_msg_spanish "MC(ude,import,ihr,Label)"               "Heredar UDE de un postprocesamiento"

::msgcat::mcset pb_msg_spanish "MC(ude,import,ihr,Context)"             "Esta opción activa un postprocesamiento para que herede la definición UDE y los manipuladores a partir de un postprocesamiento."

::msgcat::mcset pb_msg_spanish "MC(ude,import,sel,Label)"               "Seleccionar el postprocesamiento"

::msgcat::mcset pb_msg_spanish "MC(ude,import,sel,Context)"             "Seleccione el archivo PUI del postprocesamiento deseado. Se recomienda que todos los archivos (PUI, Def, Tcl y CDL) asociados con el postprocesamiento heredado sean colocados en el mismo directorio (carpeta) para utilizarlos en el tiempo de ejecución."

::msgcat::mcset pb_msg_spanish "MC(ude,import,name_cdl,Label)"          "Nombre del archivo CDL"

::msgcat::mcset pb_msg_spanish "MC(ude,import,name_cdl,Context)"        "La ruta y el nombre del archivo CDL asociado con el postprocesamiento seleccionado serán referenciados (INCLUIR) en el archivo de definción de este postprocesamiento. El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset pb_msg_spanish "MC(ude,import,name_def,Label)"          "Nombre del archivo de definición"
::msgcat::mcset pb_msg_spanish "MC(ude,import,name_def,Context)"        "La ruta y el nombre del archivo del archivo de definición del postprocesamiento seleccionado serán referenciados (INCLUIR) en el archivo de definción de este postprocesamiento. El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII)  o ninguna.  Si no se especifica ninguna ruta, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset pb_msg_spanish "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_spanish "MC(ude,import,ihr_pst,Label)"           "Postprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(ude,import,ihr_folder,Label)"        "Carpeta"
::msgcat::mcset pb_msg_spanish "MC(ude,import,own_folder,Label)"        "Carpeta"
::msgcat::mcset pb_msg_spanish "MC(ude,import,own,Label)"               "Incluir su propio archivo CDL"

::msgcat::mcset pb_msg_spanish "MC(ude,import,own,Context)"             "Esta opción le permite a este postprocesamiento incluir la referencia a su propio archivo CDL en su archivo de definición."

::msgcat::mcset pb_msg_spanish "MC(ude,import,own_ent,Label)"           "Archivo CDL propio"

::msgcat::mcset pb_msg_spanish "MC(ude,import,own_ent,Context)"         "La ruta y el nombre del archivo del archivo CDL asociado con este postprocesamiento serán referenciados (INCLUIR) en el archivo de definición de este postprocesamiento.  Se determinará el nombre real del archivo al guardar este postprocesamiento.  El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ningún archivo, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset pb_msg_spanish "MC(ude,import,sel,pui,status)"          "Seleccionar un archivo PUI"
::msgcat::mcset pb_msg_spanish "MC(ude,import,sel,cdl,status)"          "Seleccionar un archivo CDL"

##---------
## UDC
##
::msgcat::mcset pb_msg_spanish "MC(udc,editor,TITLE)"                   "Ciclo definido por el usuario"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CREATE)"                  "Crear un ciclo definido por el usuario"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,TYPE)"                    "Tipo de ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,type,UDC)"                "Definido por el usuario"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,type,SYSUDC)"             "Sistema definido"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCLBL,Label)"            "Etiqueta de ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCNAME,Label)"           "Nombre del ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCLBL,Context)"          "Especificar la etiqueta del ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCNAME,Context)"         "Especificar el nombre del ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCLBL,C,Label)"          "Etiqueta de ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,CYCLBL,C,Context)"        "Este selector le permite configurar la etiqueta del ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,EDIT)"              "Editar los parámetros definidos por el usuario..."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,MSG_BLANK)"         "El nombre del ciclo no puede estar en blanco."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,MSG_SAMENAME)"      "Ya existe el nombre del ciclo."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,MSG_SameHandler)"   "Ya existe el manipulador del evento.\n Modifique el nombre del evento del ciclo."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,MSG_ISSYSCYC)"      "El nombre del ciclo pertenece al tipo de ciclo del sistema."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Ya existe esta clase de ciclo de sistema."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,EDIT)"                    "Editar el evento de ciclo"
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,CREATE)"            "Crear un nuevo ciclo definido por el usuario..."
::msgcat::mcset pb_msg_spanish "MC(udc,editor,popup,IMPORT)"            "Importar los ciclos definidos por el usuario..."
::msgcat::mcset pb_msg_spanish "MC(udc,drill,csink,INFO)"               "Este evento comparte el manipulador con el taladrado."
::msgcat::mcset pb_msg_spanish "MC(udc,drill,simulate,INFO)"            "Este evento es único en los ciclos simulados."
::msgcat::mcset pb_msg_spanish "MC(udc,drill,dwell,INFO)"               "Este evento comparte el ciclo definido por el usuario con "


#######
# IS&V
#######
::msgcat::mcset pb_msg_spanish "MC(isv,tab,label)"                      "Controlador virtual N/C "
::msgcat::mcset pb_msg_spanish "MC(isv,Status)"                         "Especificar los parámetros de ISV"
::msgcat::mcset pb_msg_spanish "MC(isv,review,Status)"                  "Revisar los comandos VNC"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,Label)"                    "Configuración"
::msgcat::mcset pb_msg_spanish "MC(isv,vnc_command,Label)"              "Comandos VNC"
####################
# General Definition
####################
::msgcat::mcset pb_msg_spanish "MC(isv,select_Main)"                    "Seleccionar el archivo maestro VNC para un VNC subordinado."
::msgcat::mcset pb_msg_spanish "MC(isv,setup,machine,Label)"            "Máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,component,Label)"          "Montaje de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,mac_zcs_frame,Label)"      "Referencia cero del programa"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,mac_zcs,Label)"            "Componente"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,mac_zcs,Context)"          "Especifique un componente como una base de referencia ZCS. Debe ser un componente sin rotacón al cual se conecta la pieza directa o indirectamente en el árbol Cinemática.."
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spin_com,Label)"           "Componente"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spin_com,Context)"         "Especifique un componente sobre el cual se montarán las herramientas. Debe ser un componente de husillo para un postprocesamiento de taladrado y el componente de torreta para un postprocesamiento de torno."

::msgcat::mcset pb_msg_spanish "MC(isv,setup,spin_jct,Label)"           "Unión"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spin_jct,Context)"         "Defina una unión para montar las herramientas. Es la unión en el centro de la cara del husillo correspondiente a un postprocesamiento de fresado. Es la unión de rotación de la torreta correspondiente a un postprocesamiento de torno. Será la unión del montaje de la herramienta, si la torreta es fija."

::msgcat::mcset pb_msg_spanish "MC(isv,setup,axis_name,Label)"          "Eje especificado en la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,axis_name,Context)"        "Especifique los nombres del eje para que concuerde con la configuración cinemática de la máquina herramienta."




::msgcat::mcset pb_msg_spanish "MC(isv,setup,axis_frm,Label)"           "Nombres del eje NC"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,rev_fourth,Label)"         "Rotación inversa"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,rev_fourth,Context)"       "Especifique la dirección rotatoria del eje. Puede ser inversa o normal. Solamente se aplica a una tabla rotatoria."
::msgcat::mcset pb_msg_spanish "MC(isv,setup,rev_fifth,Label)"          "Rotación inversa"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,fourth_limit,Label)"       "Límite rotatorio"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,fourth_limit,Context)"     "Especificar si este eje rotatorio tiene límites"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,fifth_limit,Label)"        "Límite rotatorio"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,limiton,Label)"            "Sí"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,limitoff,Label)"           "No"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,fourth_table,Label)"       "4to eje"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,fifth_table,Label)"        "5to eje"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,header,Label)"             " Tabla "
::msgcat::mcset pb_msg_spanish "MC(isv,setup,intialization,Label)"      "Controlador"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,general_def,Label)"        "Ajuste inicial"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,advanced_def,Label)"       "Otras opciones"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,InputOutput,Label)"        "Códigos especiales NC"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,program,Label)"            "Definición del programa predeterminado"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,output,Label)"             "Exportar el programa de exportación"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,output,Context)"           "Guardar la definición del programa en un archivo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,input,Label)"              "Importar el programa de definición"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,input,Context)"            "Recuperar la definición del programa de un archivo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,file_err,Msg)"             "El archivo seleccionado no concuerda con el tipo de archivo de definición de programas predeterminados. ¿Desea continuar?"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,wcs,Label)"                "Fijaciones desplazadas (offsets)"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,tool,Label)"               "Datos sobre la herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,g_code,Label)"             "Código especial G"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,special_vnc,Label)"        "Código especial NC"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_spanish "MC(isv,setup,initial_motion,Label)"     "Movimiento"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,initial_motion,Context)"   "Especificar el movimiento inicial de la máquina herramienta"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,spindle,frame,Label)"      "Husillo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spindle_mode,Label)"       "Modo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spindle_direction,Label)"  "Dirección"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,spindle,frame,Context)"    "Especificar la unidad inicial de velocidad del husillo y la dirección de la rotación"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,feedrate_mode,Label)"      "Modo Velocidad de avance"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,feedrate_mode,Context)"    "Especificar la unidad de velocidad de avance inicial"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,boolean,frame,Label)"      "Definición del ítem Booleano"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,power_on_wcs,Label)"       "Potencia en el sistema de coordenadas de trabajo (STC por su sigla en español)  "
::msgcat::mcset pb_msg_spanish "MC(isv,setup,power_on_wcs,Context)"     "0 indica que se utilizará la coordenada predeterminada cero de la máquina\n 1 indica que el primer usuario definirá la fijación desplazada (offset) (coordenada de trabajo)"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,use_s_leader,Label)"       "S usado"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,use_f_leader,Label)"       "F usado"


::msgcat::mcset pb_msg_spanish "MC(isv,setup,dog_leg,Label)"            "Rápido del codo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,dog_leg,Context)"          "ACTIVADO recorrerá los movimientos rápidos en la forma de un codo; DESACTIVADO recorrerá los movimientos rápidos según el código NC (punto a punto)."

::msgcat::mcset pb_msg_spanish "MC(isv,setup,dog_leg,yes)"              "Sí"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,dog_leg,no)"               "No"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,on_off_frame,Label)"       "Definir ACTIVADO o DESACTIVADO"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,stroke_limit,Label)"       "Límite del trazo"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,cutcom,Label)"             "Compensación de cortador"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,tl_adjust,Label)"          "Ajuste de la longitud de la herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,scale,Label)" "Escala"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,macro_modal,Label)"        "Modal de macro"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,wcs_rotate,Label)"         "Rotación del SCT"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,cycle,Label)"              "Ciclo"

::msgcat::mcset pb_msg_spanish "MC(isv,setup,initial_mode,frame,Label)"     "Modo de entrada"
::msgcat::mcset pb_msg_spanish "MC(isv,setup,initial_mode,frame,Context)"   "Especificar el modo de entrada inicial como absoluto o incremental"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,rewindstop,Label)"   "Rebobinar el código para la detención"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,rewindstop,Context)" "Especificar Rebobinar el código para la detención"

::msgcat::mcset pb_msg_spanish "MC(isv,control_var,frame,Label)"        "Variables de control"

::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,convarleader,Label)"     "Llamada"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,convarleader,Context)"   "Especificar la variable del controlador"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,conequ,Label)"           "Signo igual"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,conequ,Context)"         "Especificar el signo igual de control"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,percent,Label)"          "Signo de porcentaje %"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,leaderjing,Label)"       "Afilado"
::msgcat::mcset pb_msg_spanish "MC(isv,sign_define,text_string,Label)"      "Cadena de texto"

::msgcat::mcset pb_msg_spanish "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_spanish "MC(isv,input_mode,Label)"               "Modo inicial"
::msgcat::mcset pb_msg_spanish "MC(isv,absolute_mode,Label)"            "Absoluto"
::msgcat::mcset pb_msg_spanish "MC(isv,incremental_style,frame,Label)"  "Modo incremental"

::msgcat::mcset pb_msg_spanish "MC(isv,incremental_mode,Label)"         "Incremental"
::msgcat::mcset pb_msg_spanish "MC(isv,incremental_gcode,Label)"        "Código G"
::msgcat::mcset pb_msg_spanish "MC(isv,incremental_gcode,Context)"      "Uso de G90 G91 para diferenciar entre el modo absoluto y el modo incremental"
::msgcat::mcset pb_msg_spanish "MC(isv,incremental_uvw,Label)"          "Llamada especial"
::msgcat::mcset pb_msg_spanish "MC(isv,incremental_uvw,Context)"        "Al usar una llamada especial para diferencia entre el modo absoluto y el modo incremental. Por ejemplo, la llamada X Y Z indica que es el modo absoluto, mientras que la llamada UVW indica que es el modo incremental."
::msgcat::mcset pb_msg_spanish "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_spanish "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_spanish "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_spanish "MC(isv,incr_a,Label)"                   "Cuarto eje "
::msgcat::mcset pb_msg_spanish "MC(isv,incr_b,Label)"                   "Quinto eje "

::msgcat::mcset pb_msg_spanish "MC(isv,incr_x,Context)"                 "Especifique la llamada especial del eje X utilizada en el estilo incremental"
::msgcat::mcset pb_msg_spanish "MC(isv,incr_y,Context)"                 "Especifique la llamada especial del eje Y utilizada en el estilo incremental"
::msgcat::mcset pb_msg_spanish "MC(isv,incr_z,Context)"                 "Especifique la llamada especial del eje Z utilizada en el estilo incremental"
::msgcat::mcset pb_msg_spanish "MC(isv,incr_a,Context)"                 "Especifique la llamada especial del cuarto eje utilizada en el estilo incremental "
::msgcat::mcset pb_msg_spanish "MC(isv,incr_b,Context)"                 "Especifique la llamada especial del quinto eje utilizada en el estilo incremental "
::msgcat::mcset pb_msg_spanish "MC(isv,vnc_mes,frame,Label)"            "Mensaje VNC de salida"

::msgcat::mcset pb_msg_spanish "MC(isv,vnc_message,Label)"              "Mensaje VNC de la lista"
::msgcat::mcset pb_msg_spanish "MC(isv,vnc_message,Context)"            "Si se marca esta opción, se visualizarán todos los mensajes de depuración de VNC en la ventana de mensajes de operaciones durante la simulación."

::msgcat::mcset pb_msg_spanish "MC(isv,vnc_mes,prefix,Label)"           "Prefijo del mensaje"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_desc,Label)"                "Descripción"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_codelist,Label)"            "Lista de códigos"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_nccode,Label)"              "Cadena o código NC"

################
# WCS Definition
################
::msgcat::mcset pb_msg_spanish "MC(isv,machine_zero,offset,Label)"      "Offsets cero de la máquina a partir de\nla unión cero de la máquina herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,frame,Label)"         "Fijaciones desplazadas (offsets)"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_leader,Label)"               " Código "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,origin_x,Label)"      " Offset X  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,origin_y,Label)"      " Offset Y  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,origin_z,Label)"      " Offset Y  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,a_offset,Label)"      " Offset A  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,b_offset,Label)"      " Offset B  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,c_offset,Label)"      " Offset C  "
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,wcs_num,Label)"       "Sistema de coordenadas"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,wcs_num,Context)"     "Especifique el número de offset de fijación que es necesario agregar"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,wcs_add,Label)"       "Agregar"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,wcs_add,Context)"     "Agregar un sistema de coordenadas de offset de fijación, especificar la posición"
::msgcat::mcset pb_msg_spanish "MC(isv,wcs_offset,wcs_err,Msg)"         "Ya existe el número del sistema de coordenadas."
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,frame,Label)"          "Información sobre la herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,tool_entry,Label)"     "Introducir un nuevo nombre de herramienta"
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,tool_name,Label)"      "       Nombre       "

::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,tool_num,Label)"       " Herramienta "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,add_tool,Label)"       "Agregar"
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,tool_diameter,Label)"  " Diámetro "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,offset_usder,Label)"   "   Offsets de punta   "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,carrier_id,Label)"     " ID del transportador "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,pocket_id,Label)"      " ID de la cajera "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,cutcom_reg,Label)"     "     COMPENSACIÓN DE CORTADOR     "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,cutreg,Label)"         "Registro "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,cutval,Label)"         "Offset "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,adjust_reg,Label)"     " Ajuste de la longitud "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,tool_type,Label)"      "   Tipo   "
::msgcat::mcset pb_msg_spanish "MC(isv,prog,setup,Label)"               "Definición del programa predeterminado"
::msgcat::mcset pb_msg_spanish "MC(isv,prog,setup_right,Label)"         "Definición del programa"
::msgcat::mcset pb_msg_spanish "MC(isv,output,setup_data,Label)"        "Especifique el archivo de definición del programa"
::msgcat::mcset pb_msg_spanish "MC(isv,input,setup_data,Label)"         "Seleccione el archivo de definición del programa"

::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,toolnum,Label)"        "Número de la herramienta  "
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,toolnum,Context)"      "Especifique el número de herramienta que es necesario agregar"
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,add_tool,Context)"     "Agregar una nueva herramienta, especificar los parámetros"
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,add_err,Msg)"          "Ya existe este número de herramienta."
::msgcat::mcset pb_msg_spanish "MC(isv,tool_info,name_err,Msg)"         "El nombre de la herramienta no puede estar vacio."

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_spanish "MC(isv,g_code,frame,Label)"             "Código especial G"
::msgcat::mcset pb_msg_spanish "MC(isv,g_code,frame,Context)"           "Especifique los códigos especiales G utilizados en la simulación"
::msgcat::mcset pb_msg_spanish "MC(isv,g_code,from_home,Label)"         "Desde la página de inicio"
::msgcat::mcset pb_msg_spanish "MC(isv,g_code,return_home,Label)"       "Volver a la Página de inicio"
::msgcat::mcset pb_msg_spanish "MC(isv,g_code,mach_wcs,Label)"          "Movimiento del datum de la máquina"
::msgcat::mcset pb_msg_spanish "MC(isv,g_code,set_local,Label)"         "Configurar la coordenada local"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,frame,Label)"       "Comandos especiales NC"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,frame,Context)"     "Comandos especiales NC especificados para los dispositivos especiales"


::msgcat::mcset pb_msg_spanish "MC(isv,spec_pre,frame,Label)"           "Comandos de preprocesamiento"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_pre,frame,Context)"         "La lista de comandos incluye todos los símbolos identificacores que es necesario procesar antes de que un bloque esté sujeto al análisis sintáctico de las coordenadas."

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,add,Label)"         "Agregar"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,edit,Label)"        "Editar"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,delete,Label)"      "Eliminar"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,title,Label)"       "Comandos especiales para otros dispositivos"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,add_sim,Label)"     "Agregar el comando SIM en el cursor"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,init_sim,Label)"    "Seleccione un comando"

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,preleader,Label)"   "Llamada"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,preleader,Context)" "Especifique una llamada del comando preprocesado definido por el usuario."

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,precode,Label)"     "Código"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,precode,Context)"   "Especifique una llamada del comando preprocesado definido por el usuario."

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,leader,Label)"      "Llamada"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,leader,Context)"    "Especifique la llamada del comando definido por el usuario."

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,code,Label)"        "Código"
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,code,Context)"      "Especifique la llamada del comando definido por el usuario."

::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,add,Context)"       "Agregar un nuevo comando definido por el usuario."
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,add_err,Msg)"       "Ya se ha manipulado este símbolo identificador."
::msgcat::mcset pb_msg_spanish "MC(isv,spec_command,sel_err,Msg)"       "Seleccione un comando"
::msgcat::mcset pb_msg_spanish "MC(isv,export,error,title)"             "Aviso"

::msgcat::mcset pb_msg_spanish "MC(isv,tool_table,title,Label)"         "Tabla de herramientas"
::msgcat::mcset pb_msg_spanish "MC(isv,ex_editor,warning,Msg)"          "Este es un comando generado por el sistema VNC. No se guardarán las modificaciones."


# - Languages
#
::msgcat::mcset pb_msg_spanish "MC(language,Label)"                     "Idioma"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_english)"                     "Inglés"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_french)"                      "Francés"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_german)"                      "Alemán"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_italian)"                     "Italiano"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_japanese)"                    "Japonés"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_korean)"                      "Coreano"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_russian)"                     "Ruso"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_simple_chinese)"              "Chino simplificado"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_spanish)"                     "Español"
::msgcat::mcset pb_msg_spanish "MC(pb_msg_traditional_chinese)"         "Chino tradicional"

### Exit Options Dialog
::msgcat::mcset pb_msg_spanish "MC(exit,options,Label)"                 "Salir de Opciones"
::msgcat::mcset pb_msg_spanish "MC(exit,options,SaveAll,Label)"         "Salir con Guardar todo"
::msgcat::mcset pb_msg_spanish "MC(exit,options,SaveNone,Label)"        "Salir sin Guardar"
::msgcat::mcset pb_msg_spanish "MC(exit,options,SaveSelect,Label)"      "Salir con Guardar la selección"

### OptionMenu Items
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Other)"       "Otros"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,None)"        "Ninguno"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,RT_R)"        "Recorrido rápido y R"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Rapid)"       "Rápido"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,RS)"          "Husillo rápido"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,C_off_RS)"    "Ciclo y a continuación husillo rápido"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Auto)"        "Auto"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Abs_Inc)"     "Absoluto o Incremental"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Abs_Only)"    "Solamente absoluto"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Inc_Only)"    "Solamente incremental"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,SD)"          "La distancia más corta"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,AP)"          "Siempre positivo"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,AN)"          "Siempre negativo"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Z_Axis)"      "Eje Z"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,+X_Axis)"     "Eje +X"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,-X_Axis)"     "Eje -X"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,Y_Axis)"      "Eje Y"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,MDD)"         "La magnitud determina la dirección"
::msgcat::mcset pb_msg_spanish "MC(optionMenu,item,SDD)"         "La señal determina la dirección"
