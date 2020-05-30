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
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "No se admite un archivo con caracteres especiales."
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "Puede que no se pueda seleccionar el propio componente de Post en esta inclusión."
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Archivo de avisos"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "Salida NC"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Suprima Buscando el Post actual"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Insertar los mensajes de depuración del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Desactive el cambio de licencia del Post actual"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Control de la licencia"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Incluir otros archivos CDL o DEF"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Macho de roscar profundo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Rotura de virutas en macho de roscar"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Macho de roscar, flotante"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Macho de roscar profundo"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Rotura de virutas en macho de roscar"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Detectar el cambio en el eje de la herramienta entre agujeros"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Corte"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Inicio de la trayectoria de la subop"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Fin de la trayectoria de la subop"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Inicio de contorno"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Fin de contorno"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Misceláneo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Desbaste con torno"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Propiedades de Postprocesador"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "No se puede especificar el UDE correspondiente a un post de fresado o de torno solamente con una categoría \"Wedm\"."

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Detectar el cambio en el plano de trabajo en Inferior"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "El formato no puede acomodar el valor de las expresiones"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Cambie el formato de la dirección relacionada antes de salir de esta página o de guardar el post."
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Cambie el formato antes de salir de esta página o de guardar este post."
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Cambie el formato de la dirección relacionada antes de entrar en esta página."

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Los nombres de los bloques siguientes han sobrepasado el límite de la longitud:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Los nombres de las palabras siguientes han sobrepasado el límite de la longitud:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Verificando el nombre del bloque y de la palabra"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Algunos nombres de los bloques siguientes han sobrepasado el límite de la longitud."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "La longitud de la cadena ha sobrepasado el límite."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Incluir otro archivo CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Seleccione la opción \\\"Nuevo\\\" del menú emergente (pulsar con el botón derecho del ratón) para incluir otros archivos CDL con este post."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "Heredar UDE de un postprocesador"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Seleccione la opción \\\"Nuevo\\\" del menú emergente (pulsar con el botón derecho del ratón) para heredar las definiciones de UDE y los manipuladores asociados de un post."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Arriba"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Abajo"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "Ya se incluyó el archivo CDL especificado."

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Enlazar las variables de Tc con las variables de C"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Un conjunto de variables Tcl modificadas frecuentemente (tales como \\\"mom_pos\\\") se pueden enlazar directamente con las variables C a fin de mejorar el rendimiento del postprocesamiento. Pero se deberán observar determinadas restricciones para evitar errores y una diferencia en la salida de NC."

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Verificar la resolución del movimiento Lineal/Rotatorio"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "Puede que el ajuste del formato no acomode la salida de la \"Resolución de movimiento lineal\"."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "Puede que el ajuste del formato no acomode la salida de la \"Resolución de movimiento rotatorio\"."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Descripción de entrada para los comandos personalizados exportados"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Descripción"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Eliminar los elementos activos de esta fila"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Condición de salida"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Nuevo..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Editar..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Quitar..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Especifique otro nombre.  \nEl comando de la condición de salida debe tener un prefijo con"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Interpolación con la linearización"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Ángulo rotatorio"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Se calcularán los puntos interpolados en base a la distribución de los ángulos de inicio y final de los ejes rotatorios."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Eje de la hta"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Se calcularán los puntos interpolados en base a la distribución de los ángulos de inicio y final del eje de la herramienta."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Continuar"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Anular"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Tolerancia predeterminada"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Tolerancia de la linearización predeterminada"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "PLG"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "mm"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Crear un postprocesador subordinado nuevo"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Postprocesador subordinado"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Subpostprocesador de unidades solamente"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "Se debe definir el postprocesador subordinado correspondiente a las unidades de salida alternas \n agregando un posfijo\"__MM\" o \"__IN\" al nombre del postprocesador principal."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Unidad de salida alterna"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Postprocesador principal"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "Se puede usar solamente un postprocesador principal completo para crear un postprocesador subordinado."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "Se debe crear o guardar el postprocesador principal \n en la aplicación Post Builder, versión 8.0 o posterior."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "Se debe especificar un postprocesador para crear un postprocesador subordinado. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Unidades de salida del subpostprocesador:"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Parámetros de las unidades"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Subpostprocesador de unidades alternas opcional"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "Valor predeterminado"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "El nombre predeterminado del subpostprocesador de unidades alternas será <post name>__MM o <post name>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Especificar"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Especifique el nombre de un subpostprocesador de unidades alternas"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Seleccionar el nombre"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Se puede seleccionar solamente un subpostprocesador de unidades alternas."
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "El subpostprocesador seleccionado no puede admitir las unidades de salida alternas correspondientes a este postprocesador."

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Subpostprocesador de unidades alternas"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "El postprocesador de NX usará el subpostprocesador de unidades, si es provisto, para manejar las unidades de salida alterna correspondientes a este postprocesador."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Acción definida por el usuario correspondiente a Transgresión del límite del eje"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Movimiento de la hélice"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "Las expresiones usadas en Direcciones"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "no serán afectadas por el cambio de esta opción."
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Esta acción restaurará la lista de códigos especiales de NC al igual\n que los manipuladores al estado que tenían cuando se abrió o se creó el postprocesador.\n\n ¿Desea continuar?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Esta acción restaurará la lista de códigos especiales de NC al igual\n que los manipuladores al estado que tenían cuando se visitó esta página por última vez.\n\n ¿Desea continuar?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "El nombre del objeto existe. Pegado no válido."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Seleccionar una familia de controladores"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "El archivo no contiene ningún comando VNC nuevo ni diferente."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "El archivo no contiene ningún comando personalizado nuevo ni diferente."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Los nombres de la herramienta no deben ser iguales."
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "No es el autor de este postprocesador. \nNo dispondrá del permiso para cambiar el nombre ni cambiar la licencia."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "Se debe especificar el nombre del archivo TCL del usuario."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "Hay entradas vacías en esta página de parámetros."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "Puede que la cadena que está intentando pegar haya sobrepasado \nel límite de la longitud o que contenga \nlíneas múltiples o caracteres no válidos."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "La primer letra del nombre del bloque no puede ser una mayúscula.\n Indique otro nombre."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Definido por el usuario"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Manipulador"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Este archivo de usuario no existe."
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Incluir el controlador virtual de NC"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Signo igual (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "Movimiento de NURBS"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Macho de roscar, flotar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Rosca"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "La agrupación anidada no es compatible."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Mapa de bits"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Para agregar un parámetro de mapa de bits nuevo arrástrelo a la lista de la derecha."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Grupo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Para agregar un parámetro de agrupación nuevo arrástrelo a la lista de la derecha."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Descripción"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Especificar la información sobre el evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "Dirección URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "Especificar la dirección URL correspondiente a la descripción del evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "El archivo de imagen debe tener el formato BMP."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "El nombre del archivo del mapa de bits no debe contener una ruta de acceso al directorio."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "El nombre de la variable debe empezar por una letra."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "El nombre de la variable no debe incluir una palabra clave: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Estatus"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Vector"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Para agregar un parámetro vectorial nuevo arrástrelo a la lista de la derecha."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "La dirección URL debe tener el formato \"http://*\" o \"archivo://*\" y no usar ninguna barra invertida."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Se deben especificar la descripción y la dirección URL."
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "Se debe seleccionar una configuración de eje para una máquina herramienta."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Familia de controladores"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Macro"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Agregar un texto de prefijo"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Editar el texto de prefijo"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Prefijo"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Suprimir el número de la secuencia"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Macro personalizada"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Macro personalizada"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Macro"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "La expresión de un parámetro de la macroinstrucción no debe estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Nombre de la macro"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Nombre de salida"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Lista de parámetros"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Separador"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Carácter de inicio"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Carácter final"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Atributo de salida"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Nombre del parámetro de salida"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Enlazar con el carácter"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Parámetro"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Expresión"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Nuevo"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "El nombre de la macro no debe contener ningún espacio."
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "El nombre de la macro no debe estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "El nombre macro debe contener solamente caracteres alfabéticos, dígitos y guiones bajos."
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "El nombre del nodo debe comenzar por una letra mayúscula."
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "El nombre del nodo solamente acepta un carácter alfabético, un dígito o un guión bajo."
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Información"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Mostrar la información sobre el objeto."
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "No se proporciona ninguna información sobre esta macro."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Versión"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "Seleccione la opción Nuevo o Abrir en el menú Archivo."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "Guarde el postprocesador."

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Archivo"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Nuevo, Abrir, Guardar,\n                            Guardar\ como, Cerrar y Salir"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Nuevo, Abrir, Guardar,\n                            Guardar\ como, Cerrar y Salir"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Nuevo ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Crear un postprocesador nuevo."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Crear un postprocesador nuevo."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Creando un postprocesador nuevo..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Abrir ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Editar un postprocesador existente."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Editar un postprocesador existente."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Abriendo el postprocesador..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "Importar MDFA ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Crear un postprocesador nuevo a partir de MDFA."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Crear un postprocesador nuevo a partir de MDFA."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Guardar"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "Guardar el postprocesador en curso."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "Guardar el postprocesador en curso."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "Guardando el postprocesador ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Guardar como ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "Guardar el postprocesador con un nombre nuevo."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "Guardar el postprocesador con un nombre nuevo."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Cerrar"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "Cerrar el postprocesador en curso."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "Cerrar el postprocesador en curso."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Salir"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Terminar la aplicación Post Builder."
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Terminar la aplicación Post Builder."

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Postprocesadores recientemente abiertos"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Editar un postprocesador visitado con anterioridad."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Editar un postprocesador en las sesiones anteriores de la aplicación Post Builder."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Opciones"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Validar los comandos \ Personalizar\ , Copia de seguridad\ Postprocesador"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "La lista de postprocesadores de edición"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Propiedades"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Propiedades"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Propiedades"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "Asesor de postprocesadores"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "Asesor de postprocesadores"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "Activar o Desactivar el asesor de postprocesadores."

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Validar los comandos personalizados"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Validar los comandos personalizados"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Selecciona la validación de los comandos personalizados"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Errores de sintaxis"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Comandos desconocidos"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Bloques desconocidos"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Direcciones desconocidas"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Formatos desconocidos"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "Postprocesador de copias de seguridad"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "Método por postprocesador de copias de seguridad"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Crear copias de seguridad al guardar el postprocesador en curso."

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Original de la copia de seguridad"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Copia de seguridad con cada acción de guardar"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Sin copia de seguridad"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Utilidades"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ Seleccionar\ MOM\ Variable, Instalar\ Postprocesador "
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "Editar el archivo de datos de postprocesadores de plantillas"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "Examinar las variables MOM"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Examinar las licencias"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Ayuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Opciones de ayuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Opciones de ayuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Punta del globo"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Punta del globo sobre los iconos"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Activar o desactivar la visualización de las puntas de las herramientas globo para los iconos."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Ayuda sensible en contexto"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Ayuda sensible en contexto sobre ítems de diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Ayuda sensible en contexto sobre ítems de diálogo"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "¿Qué hacer?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "¿Qué puede hacer aquí?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "¿Qué puede hacer aquí?"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Ayuda sobre el cuadro de diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Ayuda sobre este cuadro de diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Ayuda sobre este cuadro de diálogo"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Manual del usuario"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Manual de ayuda del usuario"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Manual de ayuda del usuario"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "Acerca de la aplicación Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "Acerca de la aplicación Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "Acerca de la aplicación Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Notas sobre la versión"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Notas sobre la versión"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Notas sobre la versión"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Manuales de referencia Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Manuales de referencia Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Manuales de referencia Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Nuevo"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Crear un postprocesador nuevo."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Abrir"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Editar un postprocesador existente."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Guardar"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "Guardar el postprocesador en curso."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Punta del globo"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Activar o desactivar la visualización de las puntas de las herramientas globo para los iconos."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Ayuda sensible en contexto"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Ayuda sensible en contexto sobre ítems de diálogo"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "¿Qué hacer?"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "¿Qué puede hacer aquí?"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Ayuda sobre el cuadro de diálogo"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Ayuda sobre este cuadro de diálogo"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Manual del usuario"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Manual de ayuda del usuario"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Error en la aplicación Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Mensaje de la aplicación Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Aviso"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Error"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Se han introducido datos correspondientes al parámetro que no son válidos."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Comando del explorador no válido:"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "Se ha modificado el nombre del archivo."
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "No se puede utilizar un postprocesador con licencia como un controlador\n a fin de crear un postprocesador nuevo si usted no es el autor del mismo."
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "No es el autor del postprocesador con licencia.\n No podrá importar los comandos personalizados."
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "No es el autor de este postprocesador con licencia."
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Falta el archivo cifrado para el postprocesador con licencia."
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "No dispone de la licencia correspondiente para realizar esta función."
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "Uso sin licencia de la aplicación Post Builder de NX"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Puede utilizar la aplicación Post Builder de NX\n sin la licencia correspondiente.  Pero, no podrá\n guardar el trabajo posteriormente."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "Se implementará el servicio de esta opción en una versión futura."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "¿Desea guardar los cambios\nantes de cerrar el postprocesador en curso?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "No se puede abrir el postprocesador creado con la versión nueva de la aplicación Post Builder en esta versión."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Contenido incorrecto en el archivo de sesiones de la aplicación Post Builder."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Contenido incorrecto en el archivo Tcl del postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Contenido incorrecto en el archivo de definición del postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Deberá especificar por lo menos un conjunto de archivos de Tcl y de definición del postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "El directorio no existe."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Archivo no encontrado o no válido."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "No se puede abrir el archivo de definición"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "No se puede abrir el archivo de manipulador de eventos"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "No dispone del permiso de escritura con respecto al directorio:"
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "No dispone del permiso de escritura con respecto a"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "ya existe.  \n¿Desea reemplazarlos de todos modos?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Faltan algunos o todos los archivos de este postprocesador.\n No puede abrir este postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Debe completar la edición de todos los subcuadros de diálogo de parámetros antes de guardar el postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "Se ha implementado la aplicación Post Builder solamente para las máquinas de fresado genérico."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Un bloque debe contener por lo menos una palabra."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "ya existe. \n Especifique otro nombre."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Este componente ya está en uso.\n No se puede eliminar."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Puede considerarlos como elementos de datos existentes y continuar."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "no ha sido instalado correctamente."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "No hay ninguna aplicación para abrir"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "¿Desea guardar los cambios?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Editor externo"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Puede utilizar la variable de entorno EDITOR para activar su editor de texto preferente."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "No se admite el espacio que restringe el nombre del archivo."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "No se puede sobrescribir el archivo seleccionado que es utilizado por un postprocesador de edición."


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Una ventana transitoria requiere una ventana madre definida."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Tiene que cerrar todas las subventanas para activar esta pestaña."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "Existe un elemento de la palabra seleccionada en la plantilla de bloques."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "El número de códigos G está restringido a"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "por bloque"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "El número de códigos M está restringido a"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "por bloque"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "La entrada no debe estar vacía."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Se pueden editar los formatos para la dirección \"F\" en la página parámetros de velocidad de avance"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "El valor máximo del número de secuencia no debe exceder la capacidad de la dirección N de"

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "Se debe especificar el nombre del postprocesador."
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "Se debe especificar la carpeta. \n Y el patrón debe ser como \"\$UGII_*\"."
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "Se debe especificar la carpeta. \n Y el patrón debe ser como \"\$UGII_*\"."
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "Se debe especificar el nombre del archivo CDL. \n Y el patrón debe ser como \"\$UGII_*\"."
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "Solamente se permite el archivo CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "Solamente se permite el archivo PUI."
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "Solamente se permite el archivo CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "Solamente se permite el archivo DEF."
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "Solamente se permite el propio archivo CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "El postprocesador seleccionado no tiene un archivo asociado CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "El archivo CDL y los archivos de definición del postprocesador seleccionado serán referenciados (INCLUIR) en el archivo de definición de este postprocesador.\n Y el archivo Tcl del postprocesador seleccionado también será originado por el archivo de manipuladores de este postprocesador en el tiempo de ejecución."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "El valor máximo de la dirección"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "no debe exceder la capacidad del formato de"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Entrada"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "No dispone de la licencia correspondiente para realizar esta función."

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "Aceptar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Este botón se halla disponible solamente en un subcuadro de diálogo. Le permitirá guardar los cambios y cancelar el cuadro de diálogo."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Cancelar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Este botón se halla disponible en un subcuadro de diálogo. Le permite cancelar el cuadro de diálogo."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "Valor predeterminado"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Este botón le permite restaurar los parámetros en el cuadro de diálogo actual de un componente a una condición cuando se creó o abrió por primera vez un postprocesador en la sesión. \n \nSin embargo, el nombre del componente en cuestión, si hubiere, será restaurado solamente al estado inicial cuando abra dicho componente."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Restaurar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Este botón le permite restaurar los parámetros del cuadro de diálogo actual a los ajustes iniciales cuando abra dicho componente."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Aplicar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Este botón le permite guardar los cambios sin cancelar el cuadro de diálogo actual. Esto le permitirá restablecer la condición inicial del presente diálogo. \n \n(Consulte Restaurar con respecto a la condición inicial)"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Filtro"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Este botón aplicará el filtro del directorio y listará los archivos que satisfacen la condición."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Sí"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Sí"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "No"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "No"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Ayuda"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Ayuda"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Abrir"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Este botón le permitirá abrir el postprocesador seleccionado para editarlo."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Guardar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Este botón se halla disponible en el cuadro de diálogo Guardar como que le permite guardar el postprocesador en curso."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Gestionar ..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Este botón le permite gestionar el historial de los postprocesadores recientemente visitados."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Actualizar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Este botón actualizará la lista según la existencia de los objetos"

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Cortar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Este botón cortará el objeto seleccionado de la lista."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Copiar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Este botón copiará el objeto seleccionado."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Pegar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Este botón pegará el objeto en el búfer y lo devolverá a la lista."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Editar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Este botón editará el objeto en el búfer."

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Utilizar el editor externo"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Crear un postprocesador nuevo"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Escribir el nombre y seleccionar el parámetro del postprocesador nuevo."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "Nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Nombre del postprocesador que desea crear"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Descripción"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Descripción del postprocesador que desea crear"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "Esta es una máquina fresadora."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "Esta es una máquina torneadora."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "Esta es una máquina de electroerosión por hilo."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "Esta es una máquina de electroerosión por hilo con 2 ejes."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "Esta es una máquina de electroerosión por hilo con 4 ejes."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "Esta es una máquina torneadora horizontal con 2 ejes."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "Esta es una máquina torneadora dependiente con 4 ejes."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "Esta es una máquina fresadora con 3 ejes. "
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "Torno fresador con 3 ejes (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "Esta es una máquina fresadora con 4 ejes y con un cabezal rotatorio."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "Esta es una máquina fresadora con 4 ejes y con una mesa rotatoria."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y con dos mesas rotatorias."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y dos cabezales rotatorios."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "Esta es una máquina fresadora con 5 ejes y con un cabezal y una mesa rotatorios."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "Esta es una máquina punzonadora."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "Unidad de salida del postprocesador"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Pulgadas"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Unidades en pulgadas del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Milímetros"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Unidades en milímetros de salida del postprocesador"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Tipo de máquina herramienta para la cual se creará el postprocesador."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Fresar"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Máquina fresadora"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Torno"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Máquina torneadora"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Electroerosión por hilo"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Máquina de electroerosión por hilo"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Punzón"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Selección de los ejes de la máquina"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Número y tipo de ejes de la máquina"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Eje de la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Seleccione el eje de la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "Torno fresador con 3 ejes (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 ejes con tabla rotatoria"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 ejes con un cabezal rotatorio"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 ejes con cabezales dobles rotatorios"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 ejes con tablas dobles rotatorias"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 ejes con un cabezal y una tabla rotatorios"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4 ejes"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Punzón"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Controlador"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "Seleccione el controlador del postprocesador."

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Genérico"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Biblioteca"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Del usuario"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Examinar"

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
::msgcat::mcset $gPB(LANG) "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "Editar el postprocesador"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Seleccionar un archivo PUI para abrir."
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Archivos de la sesión de la aplicación Post Builder"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Archivos de secuencias de comandos Tcl"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Archivos de definición"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "Archivos CDL"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Seleccione un archivo"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Exportar los comandos personalizados"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Máquina herramienta"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "Explorador de variables MOM"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Categoría"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Buscar"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Valor predeterminado"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Valores posibles"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Tipo de dato"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Descripción"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Editar template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "Archivo de datos de postprocesadores de plantillas"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Editar una línea"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Post"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Guardar como"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "Nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "El nombre que el postprocesador guardará como."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Introduzca el nombre del archivo de postprocesador nuevo."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Archivos de la sesión de la aplicación Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Entrada"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Especificará un valor nuevo en el campo entrada."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Pestaña del cuaderno"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Podrá seleccionar una pestaña para ir a la página de los parámetros deseados. \n \nPodrá dividir los parámetros de la pestaña en grupos. Podrá acceder a cada grupo de parámetros mediante otra pestaña."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Árbol de componentes"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Podrá seleccionar un componente para ver o editar el contenido o los parámetros."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Crear"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Para crear un componente nuevo copie el ítem seleccionado."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Cortar"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Cortar un componente."
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Pegar"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Pegar un componente."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Cambiar de nombre"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Lista de licencias"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Seleccionar una licencia"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Salida cifrada"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Licencia:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Especifique los parámetros cinemáticos de la máquina."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "La imagen correspondiente a la configuración máquina herramienta no se halla disponible."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "No se permite la tabla C del cuarto eje."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "El límite del eje máximo del cuarto eje no puede ser igual al límite del eje mínimo."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Los dos límites del cuarto eje no pueden ser negativos."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "El plano del cuarto eje no puede ser el mismo que el plano del quinto eje."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "No se permiten una tabla del cuarto eje ni un cabezal del quinto eje."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "El límite del eje máximo del quinto eje no puede ser igual al límite del eje mínimo."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Los dos límites del quinto eje no pueden ser negativos."

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "Información sobre el postprocesador"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Descripción"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Tipo de máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Cinemática"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Unidades de salida"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Controlador"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "Historial"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Visualizar la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Esta opción visualizar la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Máquina herramienta"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Parámetros generales"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "Unidad de salida del postprocesador:"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Unidad de salida del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Pulgada" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Métrico"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Límites del recorrido del eje lineal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Límites del recorrido del eje lineal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje Y."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Especifique el límite del recorrido de la máquina a lo largo del eje Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Posición de inicio"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Posición de inicio"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "La posición de inicio de la máquina del eje X con respecto a la posición física cero del eje. La máquina vuelve a esta posición para que pueda realizar el cambio automático en la herramienta."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "La posición de inicio de la máquina del eje Y con respecto a la posición física cero del eje. La máquina vuelve a esta posición para que pueda realizar el cambio automático en la herramienta."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "La posición de inicio de la máquina del eje Z con respecto a la posición física cero del eje. La máquina vuelve a esta posición para que pueda realizar el cambio automático en la herramienta."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Resolución del movimiento lineal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Resolución mínima"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Velocidad de avance transversal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Máximo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Velocidad máxima de avance"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Registro circular de salida"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Sí"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Registro circular de salida."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "No"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Registro lineal de salida."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Otros"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Control de inclinación del alambre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Ángulo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Coordenadas"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Configurar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "Al seleccionar dos torretas esta opción le permitirá configurar los parámetros."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Una torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Una máquina con torno de torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Dos torretas"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Máquina torneadora con dos torretas"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Configuración de la torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Torreta primaria"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Seleccione la designación de la torreta primaria."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Torreta secundaria"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Seleccione la designación de la torreta secundaria."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Designación"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "Desplazamiento X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "Especifique el desplazamiento X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Desplazamiento Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Especifique el desplazamiento Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "ALZADO"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "POSTERIOR"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "DERECHO"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "IZQUIERDO"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "LADO"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "ASIENTO"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Multiplicadores de ejes"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Programación del diámetro"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Estas opciones le permiten activar la programación del diámetro al duplicar los valores de las direcciones seleccionadas en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Este selector le permite activar la programación del diámetro al duplicar las coordenadas del eje X en la salida N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Este selector le permite activar la programación del diámetro al duplicar las coordenadas del eje Y en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Este selector le permite duplicar los valores de I correspondientes a los registros circulares cuando se utiliza la programación del diámetro."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Este selector le permite duplicar los valores de J correspondientes a los registros circulares cuando se utiliza la programación del diámetro."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Salida simétrica"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Estas opciones le permiten hacer una simetría de las direcciones seleccionadas al denegar los valores en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Estas opciones le permiten denegar las coordenadas del eje X en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Estas opciones le permiten denegar las coordenadas del eje Y en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Estas opciones le permiten denegar las coordenadas del eje Z en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Este selector le permite denegar los valores de I correspondientes a los registros circulares en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Este selector le permite denegar los valores de J correspondientes a los registros circulares en la salida N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Este selector le permite denegar los valores de K correspondientes a los registros circulares en la salida N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Método por salida"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Método por salida"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "Punta de herramienta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Salida con respecto a la punta de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Referencia a la torreta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Salida con respecto a la referencia de la torreta"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "La designación de la torreta primera no puede ser la misma que la de la torreta secundaria."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "Para modificar esta opción puede que sea necesario agregar o eliminar el bloque G92 en los eventos Cambio en la herramienta. "
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Eje del husillo inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "Se puede especificar el eje del husillo inicial designado para la herramienta fresadora en vivo como paralelo al eje Z o perpendicular al eje Z.  El eje de la herramienta de la operación debe ser consistente con el eje del husillo especificado. Se producirá un error si el postprocesador no puede posicionarse con el eje del husillo especificado. \nSe podrá invalidar este vector mediante el eje del husillo especificado con un objeto Cabezal."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Posición en el eje Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "La máquina tiene un eje programable Y que se puede posicionar durante el contorneado. Esta opción se aplica solamente cuando el eje del husillo no está a lo largo del eje Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Modo máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "El modo de máquina puede ser Fresado XZC o torneado fresado simple."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fresado XZC"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Un fresado XZC tendrá una mesa o una cara de mandril de sujeción bloqueado en una máquina fresadora torneadora como el eje rotatorio X. Se convertirán todos los movimientos XY en X y C donde X es un valor de radio y C el valor del ángulo."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Torneado fresado simple"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Se enlazará este postprocesador de fresado XZC con un postprocesador de torno para procesar un programa que contenga las operaciones de fresado y torneado. El tipo de operación determinará el postprocesador a utilizar para producir las salidas N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Postprocesador de torno"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Es necesario un postprocesador de torno para un postprocesador de torneado fresado simple para postprocesar las operaciones de torneado en un programa."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Seleccionar el nombre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Seleccione el nombre de un postprocesador de torno para usar en un postprocesador de torneado fresado. Podrá encontrar este postprocesador en el directorio \\\$UGII_CAM_POST_DIR en el tiempo de ejecución de NX/Post, de lo contrario se utilizará un postprocesador con el mismo nombre en el directorio donde se encuentra el postprocesador de fresado."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Modo predeterminado de coordenadas"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Esta opción define el ajuste inicial del modo de salida de las coordenadas como polar (XZC) o cartesiano (XYZ).  Se puede modificar este modo \\\"CONFIGURAR/POLAR,ACTIVADO\\\" con las operaciones programadas UDE."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Salida de las coordenadas en XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Cartesiano"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Salida de las coordenadas en XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Modo de registro circular"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Esta opción define la salida de los registros circulares en el modo polar (XCR) o cartesiano (XYIJ)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Salida circular en XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartesiano"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Salida circular en XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Eje del husillo inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "El eje del husillo inicial puede ser invalidado por el eje del husillo especificado con un objeto Cabezal. \nNo es necesario unificar el vector."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "Cuarto eje"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Salida del radio"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Cuando el eje de la herramienta se extiende a lo largo del eje Z (0,0,1), el postprocesador puede optar por producir el radio (X) de las coordenadas polares para que sean \\\"Siempre positivo\\\", \\\"Siempre negativo\\\" o \\\"La distancia más corta\\\"."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Cabezal"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Tabla"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Quinto eje"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Eje rotatorio"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Posición cero de la máquina al centro del eje rotatorio"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Posición cero de la máquina al centro del cuarto eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Centro del cuarto eje al centro del quinto eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "Desplazamiento X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "Especifique el desplazamiento X del eje rotatorio."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Desplazamiento Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Especifique el desplazamiento Y del eje rotatorio."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Desplazamiento Z"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Especifique el desplazamiento Z del eje rotatorio."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Rotación del eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Configure la dirección de rotación del eje a la normal."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Inverso"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Configure la dirección de rotación del eje a la inversa."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Dirección del eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Seleccione la dirección de eje."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Movimientos rotatorios consecutivos"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Combinado"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Este selector le permite activar o desactivar la linearización. Se activará o desactivará la opción Tolerancia."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Tolerancia"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Esta opción se activa solamente cuando se activa el selector Combinado. Especifique la tolerancia."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Manejo de la transgresión del límite del eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Aviso"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Avisos de salida en la transgresión del límite del eje."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Retroceso o entrada nueva"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Retroceso o entrada nueva en la transgresión del límite del eje. \n \nEn el comando personalizado PB_CMD_init_rotaty, se pueden ajustar los siguientes parámetros para lograr los movimientos deseados: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Límites del eje (grado)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Especifique el límite mínimo del eje rotatorio (grado)."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Máximo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Especifique el límite máximo del eje rotatorio (grado)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Este eje rotatorio puede ser incremental"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Resolución del movimiento rotatorio (grado)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Especifique la resolución del movimiento rotatorio (grado)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Desplazamiento angular (grado)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Especifique el desplazamiento angular del eje (grado)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Distancia del punto pivote"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Especifique la distancia pivote."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Velocidad de avance máxima (grado/min)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Especifique la velocidad de avance máxima (grado/min)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Plano de rotación"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "Seleccione XY, YZ, ZX u otro como el plano de rotación. \\\"Otra\\\" opción le permite especificar un vector arbitrario."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Vector normal al plano"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Especifique el vector normal al plano como el eje de rotación. \n                                                     No es necesario utilizar el vector.                                                  "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "Normal al plano del cuarto eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Especifique un vector normal del plano correspondiente a la rotación del cuarto eje."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "Normal al plano del quinto eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Especifique un vector normal al plano correspondiente a la rotación del quinto eje."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Llamada de palabra"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Especifique la llamada de la palabra."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Configurar"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Esta opción le permite definir los parámetros del cuarto y quinto ejes."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Configuración del eje rotatorio"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "4to eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "5to eje"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Cabezal "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Tabla "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Tolerancia de la linearización predeterminada"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Se utilizará este valor como la tolerancia predeterminada para linearizar los movimientos rotatorios cuando se indique el comando Postprocesador de LINTOL/Activado con las operaciones actuales o precedentes. El comando LINTOL/ también puede especificar una tolerancia diferente de linearización."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Programa y trayectoria para herramientas"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Programa"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Definir la salida de eventos"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Programa -- Árbol de secuencias"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Un programa N/C está dividido en cinco segmentos: cuatro (4) secuencias y el cuerpo de la trayectoria para herramientas: \n \n * Secuencia inicial del programa \n * Secuencia inicial de la operación \n * Trayectoria para herramientas \n * Secuencia final de la operación \n * Secuencia final del programa \n \nCada secuencia consiste en una serie de marcadores. Un marcador indica un evento que se puede programar y puede ocurrir en una determinada etapa del programa N/C. Puede asociar cada marcador con un ordenamiento en particular de los códigos N/C que se producirán al postprocesar el programa. \n \nLa trayectoria para herramientas está compuesta por numerosos eventos. Además, están divididas en tres (3) grupos: \n \n * Control de la máquina \n * Movimientos \n * Ciclos \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Secuencia inicial del programa"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Secuencia final del programa"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Secuencia inicial de la operación"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Secuencia final de la operación"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Trayectoria para herramientas"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Control de máquina"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Movimiento"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Ciclos preconfigurados"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Secuencia de postprocesadores enlazados"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Secuencia -- Agregar un bloque"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Puede agregar un bloque nuevo a una secuencia si presiona este botón y lo arrastra al marcador deseado. También se pueden asociar los bloques próximos a, por arriba o debajo de un bloque existente."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Secuencia - Papelera de reciclaje"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Puede disponer de los bloques no deseados de la secuencia arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Secuencia -- Bloque"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Podrá eliminar todas las palabras no deseadas en este bloque simplemente arrastrándolas a la papelera de reciclaje. \n \nTambién podrá activar un menú emergente al presionar el botón derecho del ratón. Hay varios servicios disponibles en el menú: \n \n * Editar \n * Forzar la salida \n * Cortar \n * Copiar como\n * Pegar \n * Eliminar \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Secuencia -- Selección del bloque"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "Podrá seleccionar un tipo de componente de bloque que desee agregar a la secuencia desde esta lista. \nLos tipos de componentes \Adisponibles son: \n \n * Bloque nuevo \n * Bloque existente N/C \n * Mensaje del operador \n * Comando personalizado \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Seleccionar una plantilla de secuencias"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Agregar un bloque"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Visualizar los bloques combinados de N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Este botón le permite visualizar el contenido de una secuencia en función de los bloques o los códigos N/C. \n \nLos códigos N/C visualizarán las palabras en el orden adecuado."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Programa -- Contraer o expandir el selector"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Este botón le permite contraer o expandir las bifurcaciones de este componente."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Secuencia -- Marcador"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Los marcadores de una secuencia indican los eventos posibles que se pueden programar y que pueden ocurrir en secuencia en una etapa en particular de un programa N/C. \n \nPuede asociar u ordenar los bloques para producir en cada marcador."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Programa -- Evento"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Podrá editar cada evento con una sola pulsación mediante el botón izquierdo del ratón."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Programa -- Código N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "El texto de este cuadro mostrará el código representativo N/C para producir en este marcador o de este evento."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Deshacer"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Bloque nuevo"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Comando personalizado"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Bloque"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Mensaje del operador"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Editar"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Forzar la salida"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Cambiar de nombre"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Podrá especificar el nombre de este componente."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Cortar"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Copiar como"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Bloques referenciados"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Bloques nuevos"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Pegar"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Antes"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "En línea"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "Después"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Eliminar"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Forzar la salida una vez"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Evento"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Seleccionar una plantilla de eventos"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Agregar una palabra"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMATO"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Movimiento circular -- Códigos de planos"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " Códigos G de planos "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Plano XY"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Plano YZ"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Plano ZX"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "Inicio del arco al centro"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "Centro del arco al inicio"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Inicio del arco no asignado al centro"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Centro del arco absoluto"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Guía de rosca longitudinal"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Guía de rosca transversal"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Tipo de rango del husillo"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Separar el código M de rangos (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Número de rangos con el código M de husillos (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Rango alto o bajo con el código S (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "El número de rangos de husillos debe ser mayor que cero."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Tabla de códigos de rangos de husillos"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Rango"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Código"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Mínimo (RPM)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Máximo (RPM)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Separar el código M de rangos (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Número de rangos con el código de husillos M (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Rango alto o bajo con el código S (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Rango par o impar con el código S"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Número de la herramienta y número del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Número del desplazamiento de la longitud y número de la herramienta"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Configuración del código de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Salida"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Número de la herramienta y número del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Índice de torretas y número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Índice de torretas, número de la herramienta y número del desplazamiento de la longitud"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Número de la herramienta siguiente"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Índice de torretas y número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Índice de torretas y número de la herramienta siguiente"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Número de la herramienta y número del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Número de la herramienta siguiente y número del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Número del desplazamiento de la longitud y número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Número del desplazamiento de la longitud y número de la herramienta siguiente"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Índice de torretas, número de la herramienta y número del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Índice de torretas, número de la herramienta siguiente y número del desplazamiento de la longitud"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Comando personalizado"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "Modo IPM (pulgada o min)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "Códigos G"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "Especificar los códigos G"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "Códigos M"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "Especificar los códigos M"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Resumen de palabras"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Especificar los parámetros"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Word"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Puede editar una dirección con palabras si pulsa el botón izquierdo del ratón sobre la misma."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Llamada o Código"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Tipo de dato"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Más (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Cero a la izquierda"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Número entero"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Decimal (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Fracción"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Cero a la derecha"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "¿Modal?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Máximo"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Rastreador"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Texto"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Numérico"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "PALABRA"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Otros elementos de datos"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Control secuencial de las palabras"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Secuenciar las palabras"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Secuencia de palabras maestras"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Podrá realizar la secuencia del orden de las palabras que aparezcan en la salida N/C al arrastrar cualquier palabra hasta la posición deseada. \n \nCuando la palabra que está arrastrando está en foco (cambia el color del rectángulo) con la otra palabra, se intercambiarán las posiciones de estas dos palabras. Si se arrastra una palabra dentro del foco de un separador entre dos palabras, se insertará la palabra entre estas dos palabras. \n \nPodrá suprimir cualquier palabra de la salida al archivo N/C al seleccionarla con una simple pulsación con el botón izquierdo del ratón. \n \nTambién podrá manipular esta palabras usando las opciones del menú emergente: \n \n * Nuevo \n * Editar \n * Eliminar \n * Activar todo \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Salida: Activa     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Salida: Suprimida "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Nuevo"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Deshacer"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Editar"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Eliminar"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Activar todo"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "PALABRA"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "no se puede suprimir. Ha sido usada como un elemento único en"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Si suprime la salida de esta dirección tendrá bloques vacíos."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Definir los comandos personalizados"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Nombre del comando"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "El nombre que introdujo aquí tendrá un prefijo PB_CMD_ para que pueda ser el nombre real del comando."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Procedimiento"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Introducirá una secuencia de comandos Tcl para definir la funcionalidad de este comando. \n \n * Observe que el contenido de la secuencia de comandos no será analizado sintácticamente por la aplicación Post Builder, pero se guardará en el archivo Tcl. Por lo tanto, usted será responsable de la corrección sintáctica de la secuencia de comandos."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Nombre del comando personalizado no válido.\n Especifique otro nombre"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "está reservado para los comandos especiales personalizados.\n Indique otro nombre."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Solamente se permiten nombres de comandos personalizados VNC como por ejemplo \n PB_CMD_vnc____* .\nEspecifique otro nombre"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Importar"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Importar los comandos personalizados de una archivo seleccionado Tcl al postprocesador en curso."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Exportar"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Exportar los comandos personalizados del postprocesador en curso a un archivo Tcl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Importar los comandos personalizados"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Esta lista contiene los procedimientos personalizados del comando y otros procedimientos de Tcl que existen en el archivo indicado para la importación.  Puede ver la vista preliminar del contenido de cada procedimiento si selecciona el ítem de la lista mediante una simple pulsación con el botón izquierdo del ratón.  Todo procedimiento que ya existe en el postprocesador en curso está identificado con el identificador <existe>.  Si pulsa dos veces con el botón izquierdo del ratón un ítem, marcará la casilla de selección próxima al ítem.  Ello le permitirá seleccionar o deseleccionar un procedimiento que desea importar. Se seleccionan automáticamente todos los procedimientos que desea importar. Podrá deseleccionar cualquier ítem para evitar sobrescribir un procedimiento existente."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Exportar los comandos personalizados"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Esta lista contiene los procedimientos del comando personalizado y otros procedimientos Tcl que existen en el postprocesador en curso. Puede ver la vista preliminar del contenido de cada procedimiento si selecciona el ítem de la lista mediante una simple pulsación con el botón izquierdo del ratón. Si pulsa dos veces un ítem, se seleccionará la casilla de selección próxima al ítem. Ello le permitirá seleccionar solamente los procedimientos que desea exportar."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Error en el comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "Podrá activar o desactivar la validación de los comandos personalizados al configurar los selectores en el ítem del menú principal desplegable  \"Opciones -> Validar los comandos personalizados\"."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Seleccionar todo"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Pulse este botón para seleccionar todos los comandos visualizados para importar o exportar."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Deseleccionar todo"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Pulse este botón para deseleccionar todos los comandos."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Aviso de importación o exportación del comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "No se ha seleccionado ningún ítem para importar o exportar."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Comandos: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Bloques: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Direcciones: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Formatos: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "referenciado en el comando personalizado "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "no han sido definidos en el ámbito actual del postprocesador en curso."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "no se puede eliminar."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "¿Desea guardar este postprocesador de todos modos?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Texto que será visualizado como un mensaje del operador. Se adjuntarán automáticamente estos caracteres especiales necesarios para el inicio y el final del mensaje mediante la aplicación Post Builder.  La página de parámetros \"Otros elementos de datos\" en la pestaña \"Definiciones de datos N/C\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Nombre del mensaje"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Un mensaje del operador no debe estar vacío."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Postprocesadores enlazados"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Definir los postprocesadores enlazados"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Enlazar otros postprocesadores con este postprocesador"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Se pueden enlazar otros postprocesadores con este postprocesador para manejar máquinas herramienta complejas que realizan más de una combinación de modos de fresado y torneado simples."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Cabezal"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Una máquina herramienta compleja puede realizar las operaciones de maquinado usando conjuntos diferentes de cinemática en varios modos de maquinado. Se trata cada conjunto de cinemática como un cabezal independiente en NX/Post.  Se colocarán las operaciones de maquinado que se deben realizar con un cabezal específico como un grupo en la vista Máquina herramienta o Método por maquinado. A continuación se asignará un \\\"Cabezal\\\" UDE al grupo para designar el nombre correspondiente."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Post"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Se asigna un postprocesador a un cabezal para producir los códigos N/C."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Postprocesador con enlaces"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Nuevo"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Cree un enlace nuevo."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Editar"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Edite un enlace."

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Eliminar"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Elimine un enlace."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Seleccionar el nombre"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Seleccione el nombre de un postprocesador para asignarlo a un cabezal.  Supuestamente se encontrará este postprocesador en el directorio donde se encuentra el postprocesador principal en el tiempo de ejecución de NX/Post, de lo contrario se utilizará un postprocesador con el mismo nombre en el directorio \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Inicio del cabezal"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Especifique los códigos o las acciones N/C que se ejecutarán al inicio de este cabezal."

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Fin del cabezal"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Especifique los códigos o las acciones N/C que se ejecutarán al final de este cabezal."
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Cabezal"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Post"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Postprocesador con enlaces"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "Definiciones de los datos de N/C"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "BLOQUE"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Definir las plantillas de bloques"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Nombre del bloque"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Introducir el nombre del bloque"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Agregar una palabra"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Para agregar una palabra nueva a un bloque, pulse este botón y arrástrelo al bloque visualizado en la ventana que sigue. Se selecciona el tipo de palabra que creará a partir de la lista desplegable ubicada a la derecha de este botón."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOQUE -- Selección de palabras"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Debe seleccionar de la lista el tipo de palabra que desee agregar al bloque. "

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOQUE -- Papelera de reciclaje"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Puede disponer de las palabras no deseadas de un bloque arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOQUE -- Palabra"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Podrá eliminar todas las palabras no deseadas en este bloque simplemente arrastrándolas a la papelera de reciclaje. \n \nTambién podrá activar un menú emergente al presionar el botón derecho del ratón. Hay varios servicios disponibles en el menú: \n \n * Editar \n * Modificar el elemento -> \n * Opcional \n * Sin separador de palabras\n * Forzar la salida \n * Eliminar \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOQUE -- Verificación de palabras "
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "Esta ventana mostrará el código representativo N/C para que sea la salida de una palabra seleccionada (al soltar la tecla) en el bloque mostrado en la ventana que se encuentra arriba."

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Dirección nueva"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Texto"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Comando"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Editar"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Vista"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Modificar el elemento"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Expresión definida por el usuario"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Opcional"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Sin separador de palabras"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Forzar la salida"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Eliminar"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Deshacer"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Eliminar todos los elementos activos"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "PALABRA"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "PALABRA"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Dirección nueva"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Mensaje del operador"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Comando personalizado"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Expresión definida por el usuario"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Cadena de texto"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Expresión"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Un bloque debe contener por lo menos una palabra."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Nombre del bloque no válido.\n Especifique otro nombre."

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "PALABRA"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Definir las palabras"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Nombre de la palabra"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Puede editar el nombre de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "PALABRA --  Verificación"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "Esta ventana muestra el código representativo N/C para que sea la salida de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Llamada"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Podrá introducir cualquier número de caracteres como la llamada de una palabra o seleccionar un carácter de un menú emergente mediante el botón derecho del ratón."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Formato"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Editar"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Este botón le permitirá editar el formato usado por una palabra."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Nuevo"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Este botón le permite crear un formato nuevo."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "PALABRA -- Seleccionar el formato"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Este botón le permite seleccionar un formato diferente de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Rastreador"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Podrá introducir cualquier número de caracteres como el rastreador de una palabra o seleccionar un carácter de un menú emergente mediante el botón derecho del ratón."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "¿Modal?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Esta opción le permitirá configurar la modalidad de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Apagar"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Una vez"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Siempre"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Máximo"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Deberá especificar el valor máximo de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Valor"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Truncar el valor"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Avisar al usuario"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Interrumpir el proceso"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Manejo de la transgresión"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Este botón le permite especificar el método para manejar la transgresión al valor máximo: \n \n * Truncar el valor \n * Avisar al usuario \n * Interrumpir el proceso \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Deberá especificar un valor mínimo de una palabra."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Manejo de la transgresión"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Este botón le permite especificar el método para manejar la transgresión al valor mínimo: \n \n * Truncar el valor \n * Avisar al usuario \n * Interrumpir el proceso \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMATO "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Ninguno"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Expresión"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "Puede especificar una expresión o una constante en un bloque."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "La expresión de un elemento de bloque no debe estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "La expresión de un elemento de bloque usando un formato numérico no puede contener solamente espacios."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "No se pueden utilizar los caracteres especiales \n [::msgcat::mc MC(address,exp,spec_char)] \n en una expresión correspondiente a datos numéricos."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Nombre de la palabra no válido.\n Especifique otro."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 y rapid3 están reservados para la aplicación Post Builder.\n Especifique otro nombre."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Posicionamiento rápido a lo largo del eje longitudinal"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Posicionamiento rápido a lo largo del eje transversal"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Posicionamiento rápido a lo largo del eje del husillo"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMATO"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Definir los formatos"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMATO -- Verificación"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "Esta ventana muestra el código representativo de N/C que se generará usando el formato especificado."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Nombre del formato"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Puede editar el nombre de un formato."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Tipo de dato"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Debe especificar el tipo de dato correspondiente a un formato."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Numérico"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Esta opción define el tipo de dato de un formato como un valor numérico."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMATO -- Dígitos de un número entero"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Esta opción especifica el número de dígitos de un número entero o la parte de un número entero de un número real."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMATO -- Dígitos de una fracción"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Esta opción especifica el número de dígitos de la parte de una fracción de un número real."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Punto decimal de salida (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Esta opción le permite producir puntos decimales en el código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Ceros a la izquierda a la salida"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Esta opción activa el relleno de los ceros a la izquierda en los números del código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Ceros a la derecha de la salida"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Esta opción activa el relleno de los ceros a la derecha en los números reales en el código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Texto"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Esta opción define el tipo de dato de un formato como una cadena de texto."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Signo de más (+) anterior a la salida"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Esta opción le permite producir un signo más en el código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "No puede hacer una copia del formato cero"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "No puede eliminar un formato cero"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "Será necesario verificar por lo menos una de las opciones Punto decimal, Cero a la izquierda o Cero a la derecha."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "El número de dígitos para los números enteros y las fracciones no debe ser cero."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Nombre del formato no válido.\n Especifique otro nombre."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Error de formato"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Se ha utilizado este formato en las Direcciones"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Otros elementos de datos"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Especificar los parámetros"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Número de la secuencia"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Este selector le permite activar o desactivar la salida de los números de la secuencia en el código N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Inicio de los números de la secuencia"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Especifique el inicio de los números de la secuencia."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Incremento de los números de la secuencia"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Especifique el incremento de los números de la secuencia."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Frecuencia del número de la secuencia."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Especifique la frecuencia de los números de la secuencia que aparecen en el código N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Valor máximo de los números de la secuencia"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Especifique el valor máximo de los números de la secuencia."

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Caracteres especiales"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Separador de palabras"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Especifique un carácter que se utilizará como el separador de palabras."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Punto decimal"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Especifique un carácter que se utilizará como un punto decimal."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Fin del bloque"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Especifique un carácter que se utilizará como el fin del bloque."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Inicio del mensaje"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Especifique los caracteres que utilizará como inicio de un renglón del mensaje del operador."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Fin del mensaje"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Especifique los caracteres que utilizará como fin de un renglón del mensaje del operador."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "SALTAR LA OPCIÓN (OPSKIP)"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Llamada de línea"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "Llamada de la línea SALTAR OPCIÓN"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "Salida de los códigos G y M por bloque"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Número de códigos G por bloque"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Este selector le permite activar o desactivar el control del número de códigos G por bloque de salida N/C."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Número de códigos G"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Especifique el número de códigos M por bloque de salida N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Número de códigos M"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Este selector le permite activar o desactivar el control del número de códigos M por bloque de salida N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Número de códigos M por bloque"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Especifique el número de códigos M por bloque de salida N/C."

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Ninguno"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Espacio"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Decimal (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Coma (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Punto y coma (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Dos puntos (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Cadena de texto"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Paréntesis izquierdo ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Paréntesis derecho )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Signo de libra (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Asterisco (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Barra inclinada (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Línea nueva (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "Eventos definidos por el usuario"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Incluir otro archivo CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Esta opción permite al postprocesador incluir una referencia a un archivo CDL en el archivo de definición."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "Nombre del archivo CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "La ruta de acceso y el nombre del archivo de un archivo CDL serán referenciados (INCLUIR) en el archivo de definición del postprocesador.  El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, UGII_CAM_FILE_SEARCH_PATH se utilizará para ubicar el archivo de UG/NX en el tiempo de ejecución."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Seleccionar el nombre"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Seleccione un archivo CDL que será referenciado (INCLUIR) en el archivo de definición de este postprocesador. Se añadirá automáticamente el nombre del archivo seleccionado al inicio de la lista con\\\$UGII_CAM_USER_DEF_EVENT_DIR/.  Podrá editar el nombre de la ruta según desee al finalizar la selección."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Ajustes de salida"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Configurar los parámetros de salida"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Controlador virtual N/C "
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Independiente"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Subordinado"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Seleccione un archivo VNC (Computación en red virtual)."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "El archivo seleccionado no concuerda con el nombre predeterminado del archivo VNC (Computación en red virtual). \n ¿Desea volver a seleccionar el archivo? "
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Generar un controlador virtual N/C (VNC, Computación en red virtual). "
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Esta opción le permite generar un controlador Virtual N/C de la Computación en red virtual (VNC por su sigla en inglés). Podrá utilizar un postprocesador creado con la Computación en red virtual activado para ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "Computación en red virtual maestra"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "El nombre de la Computación en red virtual maestra que se originará mediante una Computación en red virtual subordinada.  Probablemente en el tiempo de ejecución de ISV, se encontrará este postprocesador en el directorio donde se encuentra la Computación en red virtual subordinada, de lo contrario, se utilizará un postprocesador con el mismo nombre en el directorio \\\$UGII_CAM_POST_DIR."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Deberá especificar una Computación en red virtual maestra correspondiente a una Computación en red virtual subordinada."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Seleccionar el nombre"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Seleccione el nombre de una Computación en red virtual que se originará mediante una computación en red virtual subordinada. En el tiempo de ejecución del ISV se encontrará este postprocesador en el directorio donde se encuentra la Computación en red virtual, de lo contrario, se utilizará un postprocesador con el mismo nombre en el directorio \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Modo de controlador virtual N/C "
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Un controlador virtual N/C puede ser independiente o estar subordinado a una VNC (Computación en red virtual) maestra."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Una VNC independiente es autocontenida."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Una VNC (Computación en red virtual) dependen en mayor grado de la VNC maestra. Originará la VNC maestra en el tiempo de ejecución ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Controlador virtual N/C creado con la aplicación Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Archivo de listados"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Especificar los parámetros del archivo de listados"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Generar el archivo de listados"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Este selector le permite activar o desactivar la salida al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Elementos del archivo de listados"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Componentes"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "Coordenada X"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada X al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Coordenada Y"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada Y al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Coordenada Z"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Este selector le permite activar o desactivar la salida de la coordenada Z al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "Ángulo del cuarto eje"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Este selector le permite activar o desactivar la salida del ángulo del cuarto eje al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "Ángulo del quinto eje"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Este selector le permite activar o desactivar la salida del ángulo del quinto eje al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Avance"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Este selector le permite activar o desactivar la salida de la velocidad de avance al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Velocidad"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Este selector le permite activar o desactivar la salida de la velocidad del husillo al archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Extensión del archivo de listados"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Especificar la extensión del archivo de listados"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "Extensión del archivo de salida N/C"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "Especificar la extensión del archivo de salida N/C"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Cabecera del programa"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Lista de operaciones"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Lista de herramientas"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Pie de página del programa "
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Hora total de maquinado"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Formato de la página"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Imprimir el encabezamiento de la página "
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Este selector le permite activar o desactivar la salida del encabezamiento de la página al archivo de listas."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Longitud de la página (renglones)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Especifique el número de renglones por página correspondiente a este archivo de listados."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Anchura de la página (columnas)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Especifique el número de columnas por página correspondiente a este archivo de listados."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Otras opciones"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Elementos de control de salida"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Mensajes de aviso de salida"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Este selector le permite activar o desactivar la salida de los mensajes de avisos durante el postprocesador."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "Activar la herramienta de revisión"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Este selector le permite activar la herramienta de revisión durante el postprocesador."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Generar la salida del grupo"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Este selector le permite activar o desactivar el control de la salida del grupo durante el postprocesador."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Visualizar los mensajes de error verbosos"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Este selector le permite visualizar las descripciones extendidas de las condiciones de error. Desacelerará la velocidad del postprocesador."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Información sobre la operación"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Parámetros operativos"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Parámetros de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Hora del maquinado"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Fuente Tcl del usuario"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Archivo fuente Tcl del usuario"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Este selector le permite originar su propio archivo Tcl"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Nombre del archivo"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Especifique el nombre de un archivo Tcl que desee originar para este postprocesador."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Vista preliminar de los archivos de postprocesadores"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Código nuevo"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Código antiguo"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Manipuladores de evento"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Seleccione el evento para ver el procedimiento"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Definiciones"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Seleccionar el ítem para ver el contenido"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "Asesor de postprocesadores"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "Asesor de postprocesadores"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUIR"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMATO"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "PALABRA"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "BLOQUE"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "BLOQUE compuesto"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "BLOQUE de postprocesador"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "Mensaje del operador"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Número impar de argumentos de opción"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Opciones desconocidas"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   ". Debe ser uno de:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Inicio del programa"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Inicio de la trayectoria"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Movimiento desde"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "Primera herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Cambio automático en la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Cambio manual en la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Movimiento inicial"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "Primer movimiento"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Movimiento de aproximación"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Movimiento de entrada"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "Primer corte"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "Primer movimiento lineal"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Inicio de la pasada"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Movimiento de la compensación de cortador"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Guía en movimiento"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Movimiento de retroceso"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Movimiento de retorno"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Movimiento Ir a inicio"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Fin de la trayectoria"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Movimiento exterior de la guía"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Fin de la pasada"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "fin del programa"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Cambio en la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Cambio en la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Torreta primaria"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Torreta secundaria"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "Código T"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Configurar"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Torreta primaria "
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Índice de torretas secundarias"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Número de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Hora (seg)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Cambio en la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Retroceso"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Retroceso a Z de"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Compensación de la longitud"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Ajuste de la longitud de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "Código T"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Configurar"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Registro del desplazamiento de la longitud"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Máximo"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Configurar los modos"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Modo de salida"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Absoluto"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Incremental"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "El eje rotatorio puede ser incremental"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "RPM del husillo"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "Husillo "
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "En sentido horario (CW por su sigla en inglés)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "En sentido antihorario (CCW por su sigla en inglés)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Control del rango de husillos"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Intervalo de reposo de modificación de rangos (seg)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Especificar el código de rangos"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "CSS del husillo"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "Código G de husillos"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Código de superficies constantes"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Código de RMP máximo"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Código para cancelar SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "RMP máximo durante CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Tener siempre un modo IPM para SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Husillo desactivado"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "Código M de dirección del husillo "
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Apagar"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "Refrigerante activado"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "ACTIVADO"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Flujo"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Niebla"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Pasante"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "Macho de roscar"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "Refrigerante desactivado"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Apagar"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Modo métrico pulgadas"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Inglés (pulgadas)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Métrico (milímetros)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "Modo IPM (pulgadas por minuto)"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "Modo IPR (pulgadas por revolución) "
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "Modo DPM (grados por minuto)"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "Modo MMPM (milímetros por minuto)"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "Modo MMPR (milímetros por revolución)"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "Modo FRN (número de la velocidad de avance)"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Formato"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Modos de velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Solo lineal"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Solamente rotatorio"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Lineal y rotatorio"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Solamente rápido lineal"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Solamente rápido rotatorio"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Solamente rápido lineal y rotatorio"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Modo de ciclo de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Ciclo"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Compensación de cortador activado"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Lado izquierdo"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Lado derecho"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Planos aplicables"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Editar los códigos del plano"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Registro de compensación de cortador"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Compensación de cortador desactivada antes de la modificación"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Compensación de cortador desactivada"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Apagar"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Retardo"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Segundos"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Formato"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Modo de salida"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Solamente segundos"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Solamente revoluciones"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Depende de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Tiempo inverso"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Revoluciones"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Formato"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Parada en operación"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Cargar la herramienta"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Parar"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Preselección de la herramienta"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Alambre de rosca"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Cortar el alambre"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Guías del alambre"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Movimiento lineal"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Movimiento lineal"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Modo rápido asumido en la velocidad máxima transversal"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Movimiento circular"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "Código G de movimientos"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "En sentido horario (CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "En sentido antihorario (CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Registro circular"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Círculo completo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Cuadrante"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "Definición de IJK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "Definición de IJ"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "Definición de IK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Planos aplicables"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Editar los códigos del plano"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Radio"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Longitud mínima del arco"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Movimiento rápido"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "Cógido G"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Movimiento rápido"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Modificación del plano de trabajo"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Rosca de torno"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "Código G de roscas"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Constante"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Incremental"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "No incremental"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "Código G y personalización"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Personalizar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Este selector le permite personalizar un ciclo. \n\nLa construcción básica de cada ciclo se define automáticamente mediante los ajustes de los parámetros compartidos. Estos elementos compartidos de cada ciclo están restringidos a cualquier modificación. \n\nAl seleccionar este botón obtendrá un control total sobre la configuración de un ciclo.  Las modificaciones realizadas en los parámetros compartidos no afectarán los ciclos personalizados."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Inicio del ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Se puede cambiar esta opción en las máquinas herramienta que ejecutan ciclos con un bloque de inicio de ciclo (G79...) una vez definido el ciclo (G81...)."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Utilizar un bloque de inicio de ciclo para ejecutar el ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Rápido - A"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Retroceso - A"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Control del plano del ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Parámetros comunes"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Ciclo desactivado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Modificación en el plano del ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Taladrado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Intervalo de reposo del taladrado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Texto del taladrado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Broca avellanada"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Taladrado de profundidad"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Virutas resultantes del taladrado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "Macho de roscar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Mandrinado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Intervalo de reposo del mandrinado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Mandrinado con arrastre"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Mandrinado sin arrastre"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Mandrinado de retroceso"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Mandrinado manual"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Intervalo de reposo del mandrinado manual"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Punteado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Rotura de virutas"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Intervalo de reposo del taladrado (cara de puntos)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Punteado de profundidad"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Mandrinado (escariado)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Mandarinado sin arrastre"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Movimiento rápido"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Movimiento lineal"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Interpelación circular en sentido horario"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Interpelación circular en antihoraria"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Demora (seg)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Demora (rev)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "Plano XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "Plano ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "Plano YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Compensación de cortador desactivada"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Compensación de cortador izquierda"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Compensación de cortador derecha"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Ajuste positivo de la longitud de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Ajuste negativo de la longitud de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Ajuste desactivado de la longitud de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Modo de pulgada"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Modo de sistema métrico"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Código de inicio del ciclo"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Ciclo desactivado"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Ciclo de taladrado"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Intervalo de reposo en el ciclo de taladrado"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Ciclo de taladrado de profundidad"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Ciclo de rotura de las virutas resultantes del taladrado"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Ciclo de machuelado"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Ciclo de madrinado"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Ciclo de mandrinado con arrastre"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Ciclo del mandrinado sin arrastre"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Intervalo de reposo del ciclo del mandrinado"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Ciclo del mandrinado manual"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Ciclo del mandrinado de retroceso"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Intervalo de reposo del manual"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Modo absoluto"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Modo incremental"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Retroceso del ciclo (AUTOMÁTICO)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Retroceso del ciclo (MANUAL)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Restablecer"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "Modo IPM (pulgadas por minuto) de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "Modo IPR de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "Modo FRN de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "CSS del husillo"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "RPM del husillo"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Volver a la Página de inicio"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Rosca constante"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Rosca incremental"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Rosca no incremental"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "Modo IPM (pulgadas por minuto) de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "Modo IPR de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "Modo MMPM (milímetros por minuto) de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "Modo MMPR (milímetros por revolución) de la velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "DPM del modo de velocidad de avance"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Cambio en la herramienta manual/Parada"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Parar"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Parada en operación"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Fin del programa"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Husillo activado/sentido horario "
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Husillo en el sentido contrahorario"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Rosca constante"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Rosca incremental"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Rosca no incremental"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Husillo desactivado"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Cambio o retroceso de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "Refrigerante activado"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Inundación de refrigerante"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Neblina del refrigerante"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Refrigerante pasante"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Macho de roscar del refrigerante"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "Refrigerante desactivado"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Rebobinar"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Alambre de rosca"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Cortar el alambre"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Descarga activada"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Descarga desactivada"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Potencia activada"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Potencia desactivada"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Alambre activado"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Alambre desactivado"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Torreta primaria"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Torreta secundaria"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "Activar el editor de UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Según lo guardado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Eventos definidos por el usuario"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "No hay ningún UDE de relevancia."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Número entero"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Para agregar un parámetro de número entero nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Real"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Para agregar un parámetro real nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Texto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Para agregar un parámetro de cadena nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Booleano"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Para agregar un parámetro booleano nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Opción"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Para agregar un parámetro de opción nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Punto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Para agregar un parámetro de punto nuevo arrástrelo a la lista de la derecha."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Editor -- Papelera de reciclaje"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Puede disponer de los parámetros no deseados de la lista a la derecha arrastrándolos a esta papelera de reciclaje."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "No puede editar los parámetros del evento aquí con el B1R."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Evento -- Parámetros"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Puede editar cada parámetro si pulsa el botón derecho del ratón o modifica el orden de los parámetros con la función arrastrar y soltar.\n \nEl parámetro en color celeste es un parámetro definido por el sistema, por lo tanto, no se puede eliminar. El parámetro en color madera no es un parámetro definido por el sistema, por lo tanto, se puede modificar o eliminar."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Parámetros -- Opción"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Pulse el botón 1 del ratón para seleccionar la opción predeterminada. \nPulse dos veces el botón 1 del ratón (B1R) para editar la opción."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Tipo de parámetro: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Seleccionar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Visualizar"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "Aceptar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Atrás"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Cancelar"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Etiqueta de parámetro"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Nombre de la variable"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Valor predeterminado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Especificar la etiqueta del parámetro"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Especificar el nombre de la variable"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Especificar el valor predeterminado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Alternar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Alternar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Seleccionar el valor Alternar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Encender"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Apagar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Seleccionar el valor predeterminado como ACTIVADO"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Seleccionar el valor predeterminado como DESACTIVADO"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Lista de opciones"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Agregar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Cortar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Pegar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Agregar un ítem"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Cortar un ítem"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Pegar un ítem"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Opción"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Introducir un ítem"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Nombre del evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Especificar el nombre del evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "Nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "Especificar el nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Este selector le permite configurar el nombre del postprocesador"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Etiqueta de evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Especificar la etiqueta de evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Etiqueta de evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Este selector le permite configurar la etiqueta de evento"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Categoría"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Este selector le permite configurar la categoría"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fresar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Taladrado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Torno"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Electroerosión por hilo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Configurar la categoría del fresado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Configurar la categoría del taladrado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Configurar la categoría del torno"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Configurar la categoría de la electroerosión por hilo"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Editar el evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Crear un evento de control de máquina"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Ayuda"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Editar los parámetros definidos por el usuario..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Editar..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Vista..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Eliminar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Crear un evento de control de máquina nuevo..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Importar los eventos de control de máquina..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "El nombre del evento no puede estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "El nombre del evento ya existe."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "El manipulador del evento ya existe. \nModifique el nombre del evento o el nombre del postprocesador si ya ha sido verificado."
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "No hay ningún parámetro en este evento."
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "Eventos definidos por el usuario"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "Eventos de control de la máquina"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Ciclos definidos por el usuario"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Eventos de control de la máquina del sistema"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Sin eventos de control de la máquina del sistema"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Ciclos del sistema"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Sin ciclos del sistema"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Seleccionar el ítem para la definición"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "La cadena de opción no puede estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "Ya existe esta cadena de opción."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "Ya existe la opción que acaba de pegar."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Algunas opciones son idénticas."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "No hay ninguna opción en la lista."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "El nombre de la variable no puede estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "El nombre de la variable ya existe."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "Este evento comparte el UDE con \"RPM del husillo\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "Heredar UDE de un postprocesador"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Esta opción activa un postprocesador para que herede la definición UDE y los manipuladores a partir de un postprocesador."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Seleccionar el postprocesador"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Seleccione el archivo PUI del postprocesador deseado. Se recomienda que todos los archivos (PUI, Def, Tcl y CDL) asociados con el postprocesador heredado sean colocados en el mismo directorio (carpeta) para utilizarlos en el tiempo de ejecución."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "Nombre del archivo CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "La ruta y el nombre del archivo CDL asociado con el postprocesador seleccionado serán referenciados (INCLUIR) en el archivo de definición del postprocesador. El nombre de la ruta debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Nombre del archivo de definición"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "La ruta y el nombre del archivo del archivo de definición del postprocesador seleccionado serán referenciados (INCLUIR) en el archivo de definición de este postprocesador. El nombre de la ruta de acceso debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Post"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Carpeta"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Carpeta"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Incluir su propio archivo CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Esta opción permite al postprocesador incluir la referencia a su propio archivo CDL en el archivo de definición."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Archivo CDL propio"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "La ruta de acceso y el nombre del archivo CDL asociado con este postprocesador serán referenciados (INCLUIR) en el archivo de definición del postprocesador.  Se determinará el nombre real del archivo al guardar el postprocesador.  El nombre de la ruta de acceso debe comenzar por una variable de entorno de UG (\\\$UGII) o ninguna.  Si no se especifica ninguna ruta, se utilizará UGII_CAM_FILE_SEARCH_PATH para ubicar el archivo de UG/NX en el tiempo de ejecución."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "Seleccionar un archivo PUI"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "Seleccionar un archivo CDL"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Ciclo definido por el usuario"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Crear un ciclo definido por el usuario"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Tipo de ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Definido por el usuario"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Sistema definido"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Etiqueta de ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Nombre del ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Especificar la etiqueta del ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Especificar el nombre del ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Etiqueta de ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Este selector le permite configurar la etiqueta del ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Editar los parámetros definidos por el usuario..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "El nombre del ciclo no puede estar en blanco."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "Ya existe el nombre del ciclo."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "Ya existe el manipulador del evento.\n Modifique el nombre del evento del ciclo."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "El nombre del ciclo pertenece al tipo de ciclo del sistema."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Ya existe esta clase de ciclo de sistema."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Editar el evento de ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Crear un ciclo nuevo definido por el usuario..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Importar los ciclos definidos por el usuario..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "Este evento comparte el manipulador con el taladrado."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "Este evento es único en los ciclos simulados."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "Este evento comparte el ciclo definido por el usuario con "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Controlador virtual N/C "
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Especificar los parámetros de ISV"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "Revisar los comandos VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Configuración"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "Comandos VNC"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "Seleccione el archivo maestro VNC para un VNC subordinado."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Montaje de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Referencia cero del programa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Componente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Especifique un componente como una base de referencia ZCS. Debe ser un componente sin rotacón al cual se conecta la pieza directa o indirectamente en el árbol Cinemática."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Componente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Especifique un componente sobre el cual se montarán las herramientas. Debe ser un componente de husillo para un postprocesador de taladrado y el componente de torreta para un postprocesador de torno."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Unión"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Defina una unión para montar las herramientas. Es la unión en el centro de la cara del husillo correspondiente a un postprocesador de fresado. Es la unión de rotación de la torreta correspondiente a un postprocesador de torno. Será la unión del montaje de la herramienta, si la torreta es fija."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "Eje especificado en la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Especifique los nombres del eje para que concuerde con la configuración cinemática de la máquina herramienta."




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "Nombres del eje NC"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Rotación inversa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Especifique la dirección rotatoria del eje. Puede ser inversa o normal. Solamente se aplica a una tabla rotatoria."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Rotación inversa"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Límite rotatorio"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Especificar si este eje rotatorio tiene límites"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Límite rotatorio"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Sí"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "No"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "4to eje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "5to eje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Tabla "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Controlador"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Ajuste inicial"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Otras opciones"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Códigos especiales NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Definición del programa predeterminado"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Exportar el programa de exportación"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Guardar la definición del programa en un archivo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Importar el programa de definición"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Recuperar la definición del programa de un archivo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "El archivo seleccionado no concuerda con el tipo de archivo de definición de programas predeterminados. ¿Desea continuar?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Fijaciones desplazadas"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Datos sobre la herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Código especial G"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Código especial NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Movimiento"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Especificar el movimiento inicial de la máquina herramienta"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Husillo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Modo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Dirección"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Especificar la unidad inicial de velocidad del husillo y la dirección de la rotación"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Modo Velocidad de avance"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Especificar la unidad de velocidad de avance inicial"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Definición del ítem Booleano"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "Potencia en el sistema de coordenadas de trabajo (STC por su sigla en español)  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 indica que se utilizará la coordenada predeterminada cero de la máquina\n 1 indica que el primer usuario definirá la fijación desplazada (offset) (coordenada de trabajo)"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "S usado"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "F usado"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Rápido del codo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "ACTIVADO recorrerá los movimientos rápidos en la forma de un codo; DESACTIVADO recorrerá los movimientos rápidos según el código NC (punto a punto)."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Sí"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "No"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "Definir ACTIVADO o DESACTIVADO"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Límite de recorrido"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Compensación de cortador"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Ajuste de la longitud de la herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "Escala"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Modal de macro"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "Rotación del SCT"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Ciclo"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Modo de entrada"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Especifique el modo de entrada inicial como absoluto o incremental"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Código de parada/rebobinado"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Especificar el código de parada/rebobinado"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Variables de control"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Llamada"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Especificar la variable del controlador"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Signo igual"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Especificar el signo igual de control"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Signo de porcentaje %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Afilado"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Cadena de texto"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Modo inicial"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Absoluto"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Modo incremental"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "Código G"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Uso de G90 G91 para diferenciar entre el modo absoluto y el modo incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Llamada especial"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Al usar una llamada especial para diferenciar entre el modo absoluto y el modo incremental. Por ejemplo, la llamada X Y Z indica que es el modo absoluto, mientras que la llamada UVW indica que es el modo incremental."
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "Cuarto eje "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "Quinto eje "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Especifique la llamada especial del eje X utilizada en el estilo incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Especifique la llamada especial del eje Y utilizada en el estilo incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Especifique la llamada especial del eje Z utilizada en el estilo incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Especifique la llamada especial del cuarto eje utilizada en el estilo incremental "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Especifique la llamada especial del quinto eje utilizada en el estilo incremental "
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "Mensaje VNC de salida"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "Mensaje VNC de la lista"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Si se marca esta opción, se visualizarán todos los mensajes de depuración de VNC en la ventana de mensajes de operaciones durante la simulación."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Prefijo del mensaje"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Descripción"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Lista de códigos"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "Cadena o código NC"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Desplazamientos cero de la máquina a partir de\nla unión cero de la máquina herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Desplazamientos de la fijación"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Código "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " Desplazamiento X  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Desplazamiento Y  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Desplazamiento Y  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " Desplazamiento A  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " Desplazamiento B  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " Desplazamiento C  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Sistema de coordenadas"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Especifique el número de desplazamiento de la fijación que es necesario agregar"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Agregar"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Agregar un sistema de coordenadas de offset de fijación, especificar la posición"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Ya existe el número del sistema de coordenadas."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Información sobre la herramienta"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Introducir un nombre de herramienta nuevo"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Nombre       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Herramienta "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Agregar"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Diámetro "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Desplazamientos de la punta   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " Id del transportador "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " Id de la cajera "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     COMPENSACIÓN DEL  CORTADOR     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Registro "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Desplazamiento "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Ajuste de la longitud "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Tipo   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Definición del programa predeterminado"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Definición del programa"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Especifique el archivo de definición del programa"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Seleccione el archivo de definición del programa"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Número de la herramienta  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Especifique el número de herramienta que es necesario agregar"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Agregar una herramienta nueva, especificar los parámetros"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Ya existe este número de herramienta."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "El nombre de la herramienta no puede estar vacío."

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Código especial G"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "Especifique los códigos especiales G utilizados en la simulación"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Desde la página de inicio"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Volver a Pn de inicio"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Movimiento del datum de la máquina"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Configurar la coordenada local"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "Comandos especiales NC"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Comandos especiales NC especificados para los dispositivos especiales"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Comandos de preprocesamiento"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "La lista de comandos incluye todos los valores simbólicos que es necesario procesar antes de someter a un bloque al análisis sintáctico de las coordenadas."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Agregar"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Editar"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Eliminar"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Comandos especiales para otros dispositivos"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "Agregar el comando SIM en el cursor"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Seleccione un comando"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Llamada"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Especifique una llamada del comando preprocesado definido por el usuario."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Código"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Especifique una llamada del comando preprocesado definido por el usuario."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Llamada"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Especifique la llamada del comando definido por el usuario."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Código"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Especifique la llamada del comando definido por el usuario."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Agregue un comando nuevo definido por el usuario."
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Ya se ha manipulado este valor simbólico."
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Seleccione un comando"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Aviso"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Tabla de herramientas"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "Este es un comando generado por el sistema VNC. No se guardarán las modificaciones."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Idioma"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Inglés"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Francés"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Alemán"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Italiano"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "Japonés"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "Coreano"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "Ruso"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "Chino simplificado"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "Español"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "Chino tradicional"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Salir de Opciones"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Salir con Guardar todo"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Salir sin Guardar"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Salir con Guardar la selección"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Otros"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Ninguno"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Recorrido rápido y R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Husillo rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Ciclo y a continuación husillo rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Auto"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Absoluto o Incremental"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Solamente absoluto"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Solamente incremental"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "La distancia más corta"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Siempre positivo"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Siempre negativo"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Eje Z"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "Eje +X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "Eje -X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Eje Y"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "La magnitud determina la dirección"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "La señal determina la dirección"


