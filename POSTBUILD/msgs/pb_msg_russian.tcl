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
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "Имя файла, содержащее специальные символы, не поддерживается"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "Возможно, компонент постпроцессора не выбран"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Файл с предупреждением"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "Вывод программы ЧПУ"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Подавить проверку для текущего постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Сообщения о наладке встроенного постпроцессора "
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Отключить изменение лицензии для текущего постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Управление лицензией"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Включить другие файлы CDL или DEF"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Глубокое нарезание резьбы"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Резьба с ломкой стружки"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Нарезание резьбы компенсирующим патроном"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Глубокое нарезание резьбы"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Резьба с ломкой стружки"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Контроль изменения оси инструмента между отверстиями"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Быстрый размер"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Резание"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Начало траектории дополнительной операции"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Конец траектории дополнительной операции"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Начало контура"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Конец контура"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Разное"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Обдирочный токарный станок"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Свойства столба"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "UDE для обтесанного или обработанного на станке столба можно указать только в категории \"ПЭЭО\"! "

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Определить изменение уровня рабочей плоскости на размещенный ниже"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "Формат не может вместить значение выражений"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Измените формат связанного адреса, прежде чем покидать эту страницу или сохранять данную публикацию!"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Измените формат, прежде чем покидать эту страницу или сохранять данную публикацию!"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Измените формат связанного адреса, прежде чем входить на эту страницу!"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Имена следующих кадров превысили ограничение по длине:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Имена следующих слов превысили ограничение по длине:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Проверка имен кадра и слова"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Некоторые имена кадров или слов превысили ограничение по длине."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "Длина строки превысила ограничение."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Включить другой файл CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Выберите команду \\\"Создать\\\" в контекстном меню (открываемом с помощью щелчка правой кнопкой мыши), чтобы включить другие файлы CDL в данную публикацию."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "Наследовать события, задаваемые пользователем из постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Выберите команду \\\"Создать\\\" в контекстном меню (открываемом с помощью щелчка правой кнопкой мыши), чтобы наследовать все определения UDE и связанные маркеры из публикации."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Вверх"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Вниз"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "Указанный файл CDL уже включен!"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Связать переменные Tcl с переменными C"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Набор часто меняющихся переменных Tcl (например, \\\"mom_pos\\\") можно связать напрямую с переменными C, чтобы повысить скорость последующей обработки. Однако следует учитывать определенные ограничения, чтобы избежать возможных ошибок и различий в результатах числового управления."

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Проверить разрешение при линейном и вращательном перемещении"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "Настройка формата может не вмещать выходные данные для \"Дискретности линейного перемещения\"."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "Настройка формата может не вмещать выходные данные для \"Дискретности вращательного перемещения\"."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Введите описание для экспортированных настраиваемых команд"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Описание"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Удалить все активные элементы в этой строке"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Состояние вывода"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Создать..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Изменить..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Удалить..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Укажите другое имя.  \nКоманда условия вывода должна начинаться с префикса"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Интерполяция линеаризацией"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Угол поворота"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Интерполированные точки будут рассчитаны на основе распределения начальных и конечных углов относительно осей вращения."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Ось инструмента"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Интерполированные точки будут рассчитаны на основе распределения начальных и конечных векторов оси инструмента."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Продолжить"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Прервать"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Допуск по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Допуск на линеаризацию по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "ММ"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Создать новый процессор второстепенных публикаций"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Второстепенная публикация"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Дополнительная публикация только по единицам"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "Для новой второстепенной публикации для альтернативных единицы вывода должно быть указано имя\n путем добавления префикса \"__MM\" или \"__IN\" к имени основной публикации."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Альтернативные единицы вывода"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Основная публикация"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "Для создания новой второстепенной публикации можно использовать только полную основную публикацию!"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "Основная публикация должна быть создана или сохранена\n в Post Builder версии 8.0 или более поздней."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "Необходимо указать основную публикацию для создания второстепенной публикации!"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Единицы вывода дополнительной публикации:"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Параметры единиц"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Подача"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Дополнительная публикация в альтернативных единицах"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "По умолчанию"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "По умолчанию для дополнительной публикации в альтернативных единицах будет использоваться имя: <имя публикации>__MM или <имя публикации>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Задать"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Укажите имя дополнительной публикации в альтернативных единицах"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Выбрать имя"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Можно выбрать только дополнительную публикацию в альтернативных единицах!"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "Выбранная дополнительная публикация не может поддерживать альтернативные единицы вывода для этой публикации!"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Дополнительная публикация в альтернативных единицах"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "Публикация NX будет использовать единицы дополнительной публикации, если таковые указаны, для обработки альтернативных единиц вывода в этой публикации."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Функция контроля ограничения перемещений"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Перемещение по спирали"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "Выражения, использованные в адресах,"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "не будут затронуты при изменении этого параметра!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Это действие восстановит список специальных кодов ЧПУ и\n их обработчиков на момент открытия или создания этого постпроцессора.\n\n Хотите продолжить?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Это действие восстановит список специальных кодов ЧПУ и\n их обработчиков на момент последнего посещения этой страницы.\n\n Хотите продолжить?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "Имя объекта существует...Недопустимая вставка!"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Выберите семейство систем ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Этот файл не содержит новой или другой команды VNC!"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "Этот файл не содержит новой или другой настраиваемой команды!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Имена инструментов не могут повторяться!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "Вы не являетесь автором этого постпроцессора. \nВы не можете переименовать его или изменить его лицензию."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "Должно быть задано имя пользовательского TCL-файла."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "На это странице параметров есть пустые записи."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "Возможно, что строка, которую вы пытаетесь вставить,\n превышает допустимую длину или содержит\n несколько строк или недопустимые символы."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "Первая буква имени кадра не может быть заглавной!\n Задайте другое имя."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Заданный пользователем"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Обработчик"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Этот пользовательский файл не существует!"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Включить виртуальную систему ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Символ равно (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       " NURBS перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Резьба с канавками"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Резьба"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Вложенное группирование не поддерживается!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Значок"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Добавить новый параметр значка, перетащив его мышью в правый список."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Группа"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Добавить новый параметр группы, перетащив его мышью в правый список."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Описание"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Задать информацию о событии"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "Задать URL для описания события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Файл изображения должен иметь формат BMP!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Имя файла значка не должно содержать путь папки!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Имя переменной должно начинаться с буквы."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Имя переменной не должно использовать ключевое слово: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Состояние"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Вектор"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Добавить новый векторный параметр, перетащив его мышью в правый список."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL должен иметь формат \"http://*\" или \"file://*\". Обратная косая черта не допускается."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Необходимо задать описание и URL!"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "Для станка необходимо выбрать конфигурацию оси."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Семейство систем ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Макрос"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Добавить префикс текста"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Изменить префикс текста"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Префикс"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Подавить порядковый номер"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Макрос пользователя"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Макрос пользователя"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Макрос"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "Выражение для параметра макроса не должно быть пустым."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Имя макроса"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Выходное имя"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Список параметров"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Разделитель"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Начальный символ"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Конечный символ"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Выходной атрибут"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Имя выходного параметра"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Символ ссылки"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Параметр"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Выражение"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Создать"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "Имя макроса не должно иметь пробелы!"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "Имя макроса не должно быть пустым!"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "Имя макроса должно содержать буквы, числа и знак подчеркивания!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "Имя узла должно начинаться с заглавной буквы!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "Имя узла может содержать буквы, числа и знак подчеркивания!"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Информация"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Показать информацию об объекте."
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "Нет информации для этого макроса."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Генератор постпроцессоров"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Версия"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "Выберите опцию \"Новый\" или \"Открыть\" в меню \"Файл\"."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "Сохранить постпроцессор."

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Файл"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Новый, Открыть, Сохранить,\n Сохранить\ как, Закрыть и выйти"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Новый, Открыть, Сохранить,\n Сохранить\ как, Закрыть и выйти"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Новый ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Создать новый постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Создать новый постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Создание нового постпроцессора ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Открыть ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Изменить существующий постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Изменить существующий постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Открытие постпроцессора ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "Импорт MDFA ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Создание нового постпроцессора из MDFA."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Создание нового постпроцессора из MDFA."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Сохранении"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "Выполняется сохранение постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "Выполняется сохранение постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "Сохранение постпроцессора ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Сохранить как ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "Сохранить постпроцессор с новым именем."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "Сохранить постпроцессор с новым именем."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Закрыть"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "Выполняется закрытие постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "Выполняется закрытие постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Выход"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Завершить работу генератора постпроцессоров."
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Завершить работу генератора постпроцессоров."

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Ранее открытые постпроцессоры"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Изменить ранее открытый постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Изменить постпроцессор, открытый в предыдущей сессии."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Параметры"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Проверка\ Команды\ пользователя, Резервные копии\ постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "Список изменяемых постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Свойства"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Свойства"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Свойства"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "Экспертная система постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "Экспертная система постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "Разрешить/запретить экспертную систему постпроцессора"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Проверка команд пользователя"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Проверка команд пользователя"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Переключатели для проверки команд пользователя"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Синтаксические ошибки"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Неизвестные команды"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Неизвестные кадры"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Неизвестные адреса"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Неизвестные форматы"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "Резервные копии постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "Метод резервного копирования"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Создание резервных копий в процессе сохранения постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Резервная копия оригинала"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Резервное копирование при сохранении"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Не создавать резервные копии"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Утилиты"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ Выбрать\ MOM\ переменную, Инсталляция\ постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "Изменить файл данных шаблонов постпроцессоров"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "Просмотр MOM переменных"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Просмотр лицензии"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Справка"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Параметры справки"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Параметры справки"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Экранные подсказки"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Экранные подсказки на значках"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Разрешить/ запретить отображение экранных подсказок на значках."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Контекстная справка"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Контекстная справка на элементах меню"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Контекстная справка на элементах меню"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "Что сделать?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "Что можно здесь сделать?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "Что можно здесь сделать?"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Справка по меню"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Справка по этому меню"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Справка по этому меню"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Руководство пользователя"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Справочник пользователя"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Справочник пользователя"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "О генераторе постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "О генераторе постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "О генераторе постпроцессоров"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Замечания по версии"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Замечания по версии"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Замечания по версии"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Справочные руководства по Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Справочные руководства по Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Справочные руководства по Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Создать"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Создать новый постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Открыть"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Изменить существующий постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Сохранении"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "Выполняется сохранение постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Экранные подсказки"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Разрешить/ запретить отображение экранных подсказок на значках."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Контекстная справка"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Контекстная справка на элементах меню"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "Что сделать?"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "Что вы можете здесь сделать?"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Справка по меню"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Справка по этому меню"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Руководство пользователя"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Справочник пользователя"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Ошибка генератора постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Сообщение генератора постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Предупреждение"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Ошибка"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Недопустимые данные были введены для параметра"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Недопустимая команда браузера :"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "Имя файла было изменено!"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "Лицензионный постпроцессор не может использоваться как управляющий\n для создания нового постпроцессора, если вы не автор!"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "Вы не автор этого лицензионного постпроцессора!\n Команды пользователя не могут быть импортированы!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "Вы не автор этого лицензионного постпроцессора!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Зашифрованный файл отсутствует для этого лицензионного постпроцессора!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "У вас нет необходимой лицензии, чтобы выполнить эту функцию!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "Использование NX/Генератора постпроцессора без лицензии"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Вам разрешено использовать NX/Генератор постпроцессора\n без лицензии.  Однако, после этого вы\n не сможете сохранить вашу работу."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "Сервис этого параметра будет реализован в следующих версиях."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "Вы хотите сохранить ваши изменения\n перед закрытием постпроцессора?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "Постпроцессор, созданный в более новой версии генератора постпроцессоров, не может быть открыт в этой версии."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Неправильное содержание файла сеанса генератора постпроцессоров."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Неправильное содержание TCL-файла вашего постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Неправильное содержание файла описания вашего постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Вы должны задать, по крайней мере, один набор, состоящий из файлов TCL и описания для вашего постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "Папка не существует."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Файл не существует или не правильный."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "Невозможно открыть файл описания"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "Невозможно открыть файл обработчика событий"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "У вас нет прав записи в папку:"
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "У вас нет прав записи в"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "уже существует! \nВы точно хотите заменить их?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Некоторые или все файлы потеряны для этого постпроцессора.\n Вы не можете открыть этот постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Вы должны завершить изменение всех параметров подменю прежде, чем сохранить постпроцессор!"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "Генератор постпроцессоров, в настоящее время поддерживает только Общие фрезерные станки."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Кадр должен содержать по крайней мере одно слово."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "уже существует!\n Задайте другое имя."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Этот компонент используется. \n Он не может быть удален."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Вы можете принять их как существующие элементы данных и продолжить."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "не был установлен правильно."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "Нет открытых приложений"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "Вы хотите сохранить изменения?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Внешний редактор"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Вы можете использовать системную переменную EDITOR, чтобы задать ваш текстовый редактор."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "Пробелы в имени файла не поддерживаются!"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "Выбранный файл, используемый одним из изменяемых постпроцессоров, не может быть перезаписан!"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Временное окно требует своего заданного родительского окна."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Вы должны закрыть все подокна, чтобы получить доступ к этой закладке."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "Элемент выбранного слова существует в шаблоне кадра."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "Количество G-кодов - коды ограничены"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "в кадре"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "Количество M-кодов - коды ограничены"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "в кадре"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "Поле ввода не должно быть пустым."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Форматы адреса \"F\" могут быть изменены на странице Подачи"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "Максимальное значение номера кадра не может превышать максимально допустимое значение адреса "

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "Имя постпроцессора должно быть задано!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "Необходимо задать папку! \n И шаблон должен выглядеть как \"\$ UGII_ *\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "Необходимо задать папку! \n И шаблон должен выглядеть как \"\$ UGII_ *\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "Должно быть задано другое имя файла CDL! \n И шаблон должен выглядеть как \"\$UGII_ *\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "Разрешен только файл CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "Разрешен только файл PUI!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "Разрешен только файл CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "Разрешен только файл DEF!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "Разрешен только собственный файл CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "Выбранный постпроцессор не имеет связанного файла CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "Файлы CDL и описания выбранного постпроцессора будут ссылочными (INCLUDE) в файле описания этого постпроцессора. \n И файл TCL выбранного постпроцессора также будет исходным файлом обработчика событий этого постпроцессора во время выполнения."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "Максимальное значение для адреса"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "не должен превышать значение заданное его форматом"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Запись"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "У вас нет необходимой лицензии, чтобы выполнить эту функцию!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Эта кнопка доступна только в подменю. Она позволяет сохранить изменения и закрыть меню."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Отмена"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Эта кнопка доступна в подменю. Она позволяет закрыть меню."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "По умолчанию"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Эта кнопка позволяет восстановить параметры меню существующего компонента до значений, когда постпроцессор был создан или открыт в данной сессии. \n \nОднако, имя компонента в запросе будет восстановлено только в его исходное состояние до того, как вы вошли в меню изменения этого компонента."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Восстановить"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Эта кнопка позволяет восстановить параметры в существующем меню в начальные установки вашего сеанса изменения этого компонента."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Применить"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Эта кнопка позволяет сохранить изменения, не выходя из меню. Она также восстановит начальные значения текущего меню. \n \n(Смотрите \"Восстановить при необходимости начальные значения\")"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Фильтр"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Эта кнопка применяет фильтр папки и выводит список файлов, которые удовлетворяют заданному фильтру."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Да"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Да"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "Нет"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "Нет"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Справка"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Справка"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Открыть"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Эта кнопка позволяет открыть выбранный постпроцессор для изменения."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Сохранении"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Эта кнопка доступна в меню \"Сохранить как\", которое позволяет сохранить постпроцессор под другим именем."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Управление ..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Эта кнопка позволяет управлять историей последних открытых постпроцессоров."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Обновить"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Эта кнопка обновляет список соответственно существующим объектам."

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Вырезать"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Эта кнопка вырезает объект, выбранный в списке."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Копировать"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Эта кнопка копирует выбранный объект."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Вставить"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Эта кнопка вставляет объект из буфера назад в список."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Изменить"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Эта кнопка изменяет объект в буфере!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Использовать внешний редактор"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Создать новый постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Введите имя & выберите параметры для нового постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "Имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Имя постпроцессора, который будет создан"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Описание"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Описание постпроцессора, который будет создан"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "Это фрезерный станок."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "Это токарный станок."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "Это проволочный ЭЭ станок."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "Это 2-осевой проволочный ЭЭ станок."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "Это 4-осевой проволочный ЭЭ станок."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "Это горизонтальный 2-осевой токарный станок."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "Это 4-осевой зависимый токарный станок."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "Это 3-осевой фрезерный станок."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "3-осевой токарно-фрезерный (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "Это 4-осевой фрезерный станок с\n поворотной головкой."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "Это 4-осевой фрезерный станок с\n поворотным столом."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "Это 5-осевой фрезерный станок с\n двумя поворотными осями на столе."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "Это 5-осевой фрезерный станок с\n двумя поворотными осями на головке."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "Это 5-осевой фрезерный станок с\n поворотной головкой и столом."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "Это пробивной штамп."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "Единицы вывода постпроцессора"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Дюймы"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Единицы вывода постпроцессора - дюймы"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Миллиметры"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Единицы вывода постпроцессора - миллиметры"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Станок"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Тип станка, для которого создается данный постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Фрезерование"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Фрезерный станок"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Точение"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Токарный станок"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Проволочная ЭЭО"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Проволочный ЭЭ станок"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Пуансон"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Выбор осей станка"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Количество и тип осей станка"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4-осевая"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Оси станка"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Выберите оси станка"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "3-осевой токарно-фрезерный (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4-осевой с поворотным столом"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4-осевой с поворотной головкой"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4-осевая"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5-осевой с двумя поворотными осями на головке"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5-осевой с двумя поворотными осями на столе"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5-осевой с поворотной головкой и столом"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2-осевой"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4-осевая"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Пуансон"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "Выберите систему ЧПУ для постпроцессора"

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Вспомогательный"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Библиотека"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Пользовательский"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Обзор"

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
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "Изменить постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Выберите файл PUI для открытия"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Файлы сессии генератора постпроцессоров"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Файлы Tcl-скриптов"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Файлы описания"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "Файлы CDL"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Выберите файл"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Экспорт команд пользователя"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Станок"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "Просмотр MOM переменных"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Категория"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Поиск"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Значение по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Допустимые значения"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Тип данных"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Описание"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Изменить template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "Файл данных шаблона постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Изменить строку"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Постпроцессор"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Сохранить как"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "Имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "Имя, под которым будет сохранен постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Введите имя файла нового постпроцессора."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Файлы сессии генератора постпроцессоров"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Запись"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Вы можете задать новое значение в поле ввода."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Закладка журнала"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Вы можете выбрать закладку, чтобы перейди на необходимую страницу параметров. \n \nПараметры на закладке могут быть разделены на группы. К каждой группе параметров можно получить доступ через другую закладку."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Дерево компонент"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Вы можете выбрать компонент для просмотра или изменения его содержания или параметров."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Создать"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Создать новый компонент, копированием выбранной записи."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Вырезать"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Вырезать компонент"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Вставить"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Вставить компонент."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Переименовать"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Список лицензий"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Выбрать лицензию"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Зашифровать вывод"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Лицензия:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Станок"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Задайте параметры кинематики станка."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "Отображение для этой конфигурации станка не доступно."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "Стол с 4-й осью C не позволяется."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "Максимальный предел 4-й оси не может быть равен минимальному пределу!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Оба предела 4-й оси не могут быть отрицательными!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "Плоскость вращения 4-ой оси не может совпадать с плоскостью вращения 5-ой оси."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "Конфигурация с 4-й осью на столе и 5-й - на головке не допустима."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "Максимальный предел 5-й оси не может быть равен минимальному пределу!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Оба предела 5-й оси не могут быть отрицательными!"

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "Информация о постпроцессоре"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Описание"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Тип компьютера"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Кинематика"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Ед.вывода"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "История"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Показать станок"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Эта опция выводит на экран станок в отдельном окне"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Станок"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Общие параметры"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "Единицы вывода постпроцессора:"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Единицы вывода постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Дюйм." 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Метрический"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Пределы перемещения линейных осей"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Пределы перемещения линейных осей"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Задайте пределы перемещения станка вдоль оси X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Задайте пределы перемещения станка вдоль оси Y."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Задайте пределы перемещения станка вдоль оси Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Исходное положение"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Исходное положение"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "Исходное положение оси X станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "Исходное положение оси Y станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "Исходное положение оси Z станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Дискретность линейного перемещения"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Минимум"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Минимальное разрешение"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Подача перехода"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Максимум"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Максимальная подача"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Вывод круговой интерполяции"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Да"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Вывод круговой интерполяции."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "Нет"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Вывод линейной интерполяции."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Другой"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Управление наклоном проволоки"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Углы"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Координаты"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Конфигурировать"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "Когда выбрано две револьверных головки, эта опция позволяет сконфигурировать параметры."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Одна револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Токарный станок с одной револьверной головкой"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Две револьверных головки"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Токарный станок с 2 револьверными головками"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Конфигурация револьверной головки"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Первичная револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Выберите назначение первичной револьверной головки."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Вторичная револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Выберите назначение вторичной револьверной головки."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Обозначение"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "Смещение X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "Задайте смещение по X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Смещение Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Задайте смещение по Z"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "FRONT"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "Сзади"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "RIGHT"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "LEFT"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "Сторона"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "SADDLE"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Множители оси"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Программирование диаметра"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Эти опции позволяют программировать диаметр, удваивая значения выбранного адреса в программе ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Этот переключатель позволяет разрешить программирование диаметра, удваивая координаты оси X в кодах программы ЧПУ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Этот переключатель позволяет разрешить программирование диаметра, удваивая координаты оси Y в кодах программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Этот переключатель позволяет удвоить значения слова I при выводе дуг окружностей, когда используется программирование диаметра."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Этот переключатель позволяет удвоить значения слова J при выводе дуг окружностей, когда используется программирование диаметра."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Зеркальный вывод"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Эти опции позволяют зеркально отразить выбранный адрес, делая их значения отрицательными в программе ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты X при выводе в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты Y при выводе в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты Z при выводе в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова I при выводе записей круговой интерполяции в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова J при выводе записей круговой интерполяции в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова K при выводе записей круговой интерполяции в программу ЧПУ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Метод вывода"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Метод вывода"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "Вершина инструмента"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Вывод относительно вершины инструмента"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Ссылочная точка револьверной головки"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Вывод относительно ссылочной точки револьвера"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "Первичная револьверная головка не может совпадать с вторичной револьверной головкой."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "Изменение этой опции может потребовать прибавления или удаления кадра G92 в событии \"Смена инструмента\"."
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Начальная ориентация оси шпинделя"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "Начальная ориентация оси шпинделя для фрезерного станка, может быть задана или как параллельна оси Z или как перпендикулярна к оси Z. Ось инструмента в операции должна быть совместимой с заданной ориентацией оси шпинделя. Произойдет ошибка, если постпроцессор не может позиционировать инструмент по оси шпинделя.\nЭтот вектор может быть перезадан осью шпинделя, заданной в объекте \"Головка\"."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Положение по оси Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "У станка есть программируемая ось Y, которая может позиционироваться в процессе обработки. Эта опция применима только когда ось шпинделя не параллельна оси Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Режим станка"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "Режим станка может быть или XZC-фрезерный или простой токарно-фрезерный."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Фрезерный XZC"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "У станка в режиме XZC стол, или плоскость патрона работают как поворотная ось C. Все координатные перемещения будут преобразованы в координаты X и C, где X является значением радиуса и C - угол."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Простой токарно-фрезерный"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Этот XZC фрезерный постпроцессор будет связан с токарным постпроцессором, чтобы генерировать программу, которая содержит и фрезерные и токарные операции. Тип операции определяет, какой постпроцессор использовать для вывода программы ЧПУ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Токарный постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Постпроцессор для токарного станка требуется для простого токарно-фрезерного постпроцессора для вывода токарных операций в программу."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Выбрать имя"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Выберите имя токарного постпроцессора для использования в простом токарно-фрезерном постпроцессоре.  Возможно, что этот постпроцессор будет найден в папке \\\$UGII_CAM_POST_DIR, где выполняется NX/Постпроцессор, иначе будет использоваться постпроцессор с тем же именем в папке, где находится фрезерный постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Режим вывода координат по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Эти опции задают начальную настройку для режима вывода координат, которые могут быть полярными (XZC) или декартовыми (XYZ). Этот режим может быть изменен командой задаваемой пользователем \\\"SET/POLAR,ON\\\", которая задается в операциях."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Полярный"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Вывод координат в XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Декартовы"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Вывод координат в XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Режим круговой интерполяции"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Эти опции задают вывод записей круговых перемещений, в полярном (XCR) или декартовом (XYIJ) режимах."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Полярный"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Круговая интерполяция в кодах XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Декартовы"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Круговая интерполяция в кодах XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Начальная ориентация оси шпинделя"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "Начальная ориентация оси шпинделя может быть перезадана осью шпинделя, заданной в объекте \"Головка\".\nВектор не должен быть унифицирован."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "4-я ось"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Вывод радиуса"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Когда ось инструмента направлена вдоль оси Z (0,0,1), у постпроцессора есть выбор выведения радиуса (X) в полярных координатах, чтобы быть \\\"Всегда положительным\\\", \\\"Всегда отрицательным\\\" или \\\"Кратчайшее расстояние\\\"."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Голова"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Таблица"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Пятая ось"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Оси вращения"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Расстояние от нуля станка до центра поворота оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Расстояние от нуля станка до центра 4-й оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Расстояние от центра 4-й оси до центра 5-й оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "Смещение X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "Задайте смещение поворотной оси по оси X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Смещение Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Задайте смещение поворотной оси по оси Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Смещение Z"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Задайте смещение поворотной оси по оси Z"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Вращение оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Нормаль"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Установить направление вращения оси по нормали."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Обратный"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Установить обратное направление вращения оси."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Направление оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Выберите направление оси."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Последовательные перемещения вращения"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Связанные"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Этот переключатель позволяет включить/выключить линеаризацию. Так же он включает/выключает опцию использования допуска."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Допуск"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Эта опция активна только, когда активен переключатель \"Комбинированный\". Задайте допуск."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Обработка превышения предела оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Предупреждение"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Вывод предупреждений при превышении предела перемещения осей"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Отвод / Повторное врезание"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Отвод/Повторное врезание при превышении предела оси. \n \nВ команде пользователя PB_CMD_init_rotaty, следующие параметры должны быть настроены для активации этих перемещений: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Предел оси (градусы)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Минимум"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Задайте минимальный предел поворотной оси (градусы)."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Максимум"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Задайте максимальный предел поворотной оси (градусы)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Эта поворотная ось может программироваться в приращениях"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Дискретность поворотных перемещений (градусы)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Задайте дискретность поворотных перемещений (градусы)"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Угловое смещение (градусы)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Задайте угловое смещение оси (градусы)"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Расстояние до точки вращения"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Задайте расстояние до точки поворота."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Мак. подача (градус/мин)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Задайте максимальную скорость подачи (градус/мин)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Плоскость вращения"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "Выберите XY, YZ, ZX или \"Другая как плоскость поворота\". Опция \\\"\"Другая\"\\\" позволяет задать вектор направления оси."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Вектор нормали плоскости"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Задайте вектор нормали к плоскости как ось поворота. \nВектор не должен быть унифицирован."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "Нормаль плоскости 4-ой оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Задайте вектор нормали к плоскости вращения 4-й оси."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "Нормаль плоскости 5-ой оси"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Задайте вектор нормали к плоскости вращения 5-й оси."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Адрес слова"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Задайте адрес слова"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Конфигурировать"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Эта опция позволяет задать параметры 4-ой и 5-ой осей."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Конфигурация поворотных осей"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "4-я ось"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "5-я ось"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Голова "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Таблица "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Допуск на линеаризацию по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Это значение будет использоваться как значения допуска по умолчанию, для линеаризации поворотных перемещений, когда постпроцессорная команда LINTOL/ON будет задана в текущей или в предыдущей операции. Команда LINTOL/ может также задать различный допуск на линеаризацию."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Программа и траектория инструмента"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Программа"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Задать вывод событий"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Программа -- дерево последовательности"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Программа ЧПУ разделена на пять сегментов: четыре (4) последовательности и тело траектории инструмента: \n \n * Последовательность в начале программы \n * Последовательность в начале операции\n * Траектория инструмента \n * Последовательность в конце операции \n * Последовательность в конце программы \n \nКаждая последовательность состоит из нескольких маркеров. Маркер указывает на событие, которое может программироваться и может произойти на определенной стадии программы ЧПУ. Вы можете присоединить каждый маркер в нужную позицию кодов программы ЧПУ, которые будут выведены, когда программа обрабатывается постпроцессором. \n \nТраектория инструмента создается из множества событий. Они разделены на три (3) группы: \n \n * Управление станком \n * Перемещения \n * Циклы \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Последовательность в начале программы"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Последовательность в конце программы"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Последовательность в начале операции"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Последовательность в конце операции"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Траектория"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Управление станком"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Кинематика"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Встроенные циклы"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Последовательность связанных постпроцессоров"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Последовательность -- добавить кадр"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Вы можете добавить новый кадр в последовательность, нажимая эту кнопку и перемещая кадр под необходимый маркер. Кадры могут быть присоединены рядом, выше или ниже существующего кадра."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Последовательность -- мусорная корзина"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Вы можете удалить любые ненужные кадры из последовательности, перемещая их в мусорную корзину."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Последовательность -- кадр"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Вы можете удалить любой ненужный кадр в последовательности, переместив его в мусорную корзину. \n \nВы можете также открыть всплывающее меню, нажав правую кнопку мыши. Следующие опции доступны в этом меню: \n \n * Изменить \n * Постоянный вывод \n * Вырезать \n * Копировать как \n * Вставить \n * Удалить \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Последовательность -- выбрать кадр"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "Вы можете выбрать тип компонента кадра, который вы хотите добавить к последовательности из этого списка. \n\Aразличные типы компонент включают: \n \n * Новый кадр \n * Существующий кадр ЧПУ \n * Сообщение оператору \n * Команда пользователя \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Выбрать шаблон последовательности"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Добавить кадр"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Отображать кадр в виде кодов системы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Эта кнопка позволяет вывести на экран содержание последовательности в терминах кодов ЧПУ или кадров. \n \nКоды ЧПУ отображаются словами в порядке вывода."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Программа -- переключатель \"Свернуть/Развернуть\""
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Эта кнопка позволяет свернуть или развернуть ветви выбранного в дереве компонента."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Последовательность -- маркер"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Маркеры последовательности указывают возможные события, которые могут быть запрограммированы и могут произойти в последовательности на заданном шаге программы ЧПУ. \n \nВы можете присоединять/упорядочивать кадры, которые выводятся в каждом маркере."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Программа -- события"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Вы можете изменить каждое событие одиночным нажатием левой кнопки мыши."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Программа -- коды ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "Текст в этом блоке представляет код программы ЧПУ, который будет выводится с этим маркером или в этом событии."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Отмена действия"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Новый кадр"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Команда пользователя"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Кадр"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Команда пользователя"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Сообщение оператору"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Изменить"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Обязательный вывод"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Переименовать"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Вы можете задать имя для этого компонента."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Вырезать"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Копировать как"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Ссылочные кадры"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Новый кадр"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Вставить"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Перед"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "По линии"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "После"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Удалить"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Обязательный однократный вывод"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Событие"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Выбрать шаблон события"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Добавить слово"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Круговая интерполяция -- коды плоскостей"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " G-коды плоскости "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Плоскость XY"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Плоскость YZ"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Плоскость ZX"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "От начала дуги к центру"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "От центра дуги к началу"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Без знака от начала дуги к центру"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Абсолютный центр дуги"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Продольный шаг резьбы"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Поперечный шаг резьбы"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Тип диапазона частот вращения шпинделя"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Отдельный М-код диапазона (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Номер диапазона с M-кодом включения шпинделя (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Верхний/нижний пределы диапазона с S-кодом (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "Количество диапазонов шпинделя должно быть больше нуля."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Таблица кодов диапазонов частот вращения шпинделя"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Диапазон"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Код"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Минимум (об/мин)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Максимум (об/мин)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Отдельный М-код диапазона (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Номер диапазона с M-кодом включения шпинделя (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Верхний/нижний пределы диапазона с S-кодом (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Нечетный/четный диапазон с S-кодом"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Номер инструмента и номер корректора длины"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Номер корректора длины и номер инструмента"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Конфигурация кода инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Вывод"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Номер инструмента и номер корректора длины"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Индекс револьверной головки и номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Индекс револьверной головки, номер инструмента и номер корректора длины"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Номер следующего инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Индекс револьверной головки и номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Индекс револьверной головки и номер следующего инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Номер инструмента и номер корректора длины"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Номер следующего инструмента и номер корректора длины"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Номер корректора длины и номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Номер корректора длины и номер следующего инструмента"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Индекс револьверной головки, номер инструмента и номер корректора длины "
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Индекс револьверной головки, номер следующего инструмента и номер корректора длины"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Команда пользователя"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "Режим IPM (дюйм/мин)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "G-коды"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "Задайте G-коды"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "М-коды"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "Задайте М-коды"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Сводная таблица слов"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Задать параметры"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Word"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Вы можете изменить слово нажатием левой кнопки мыши на его имя."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Выноска/код"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Тип данных"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Плюс (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Ведущие нули"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Целое"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Десятичный (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Дробная величина"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Конечные нули"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "Модальный ?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Минимум"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Максимум"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Окончание"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Текст"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Числовое"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "WORD"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Другие элементы данных"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Последовательность слов"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Последовательность слов"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Мастер-последовательность слов"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Вы можете упорядочить порядок вывода слов, в котором они выводятся в кадр программы, перемещением любого слова в нужную позицию. \n \nКогда слово, которое вы перемещаете, будет в фокусе (цвет прямоугольника изменится) другого слова, эти два слова поменяются местами. Если слово будет находится в пределах фокуса разделителя между 2 словами, то слово будет вставлено между этими 2 словами. \n \nВы можете подавить вывод любого слова в кадр программы ЧПУ, выключая вывод этого слова простым нажатием левой кнопки мыши. \n \nВы можете так же манипулировать словами, используя опции всплывающего меню на правой кнопке мыши: \n \n * Новый \n * Изменить \n * Удалить \n * Активировать все \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Вывод - активен     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Вывод - подавлен "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Создать"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Отмена действия"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Изменить"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Удалить"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Активировать все"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "WORD"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "не может быть подавлен. Это может использоваться как одиночный элемент в"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Подавление вывода этого адреса приведет к недопустимому пустому кадру."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Команда пользователя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Задать команду пользователя"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Имя команды"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "Имя, которое вы вводите здесь, будет иметь префикс PB_CMD_, чтобы стать фактическим именем команды."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Процедура"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Вы должны создать TCL-скрипт, чтобы задать функциональные возможности этой команды. \n \n * Заметьте, что содержание скрипта не будет анализироваться генератором постпроцессора, но будет сохранено в TCL-файле. Поэтому вы отвечаете за правильность синтаксиса скрипта."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Недопустимое имя команды пользователя. \n Задайте другое имя."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "зарезервировано для специальных команд пользователя. \n Задайте другое имя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Допустимы только команды пользователя для виртуальной \n системы ЧПУ с именами типа PB_CMD_vnc____*.\n Задайте другое имя"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Импорт"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Импорт команд пользователя из выбранного TCL-файла в постпроцессор."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Экспорт"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Экспорт команд пользователя из постпроцессора в TCL-файл."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Импорт команд пользователя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Этот список содержит специализированные и другие TCL-процедуры, существующие в файле, который вы задали для импорта. Вы можете предварительно просмотреть содержание каждой процедуры, выбирая запись в списке одиночным нажатием левой кнопки мыши. Любая процедура, которая уже существует в постпроцессоре, помечена индикатором <существует>. Двойной щелчок левой кнопкой мыши на записи выводит на экран выключатель рядом с записью. Это позволяет вам выбрать или отменить выбор процедуры для импорта. По умолчанию, все процедуры выбраны для импорта. Вы можете отменить выбор любой записи, чтобы избежать перезаписи существующей процедуры."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Экспорт команд пользователя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Этот список содержит специализированные и другие TCL-процедуры, которые существуют в постпроцессоре. Вы можете предварительно просмотреть содержание каждой процедуры, выбирая запись в списке одиночным нажатием левой кнопки мыши. Двойной щелчок левой кнопкой мыши на записи выводит на экран выключатель рядом с записью. Это позволяет вам выбрать или отменить выбор процедуры для импорта."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Ошибка в команде пользователя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "Опция \"Проверка команд пользователя\" может быть включена или выключена с помощью установки выключателя возле записи в соответствующее положение в главном меню \"\"Параметры\" -> \"Проверка команд пользователя\"\"."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Выбрать все"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Нажмите эту кнопку, чтобы выбрать все отображаемые команды для импорта или экспорта. "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Отменить все"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Нажмите эту кнопку, чтобы отменить выбор всех команд."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Предупреждение импорта / экспорта команды пользователя"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "Никакие записи не выбраны для импорта или экспорта."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Команды : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Кадры : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Адреса : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Форматы : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "упоминается в команде пользователя "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "не были заданы в текущей области действия постпроцессора в процессе."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "не может быть удален"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "Вы хотите сохранить этот постпроцессор?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Текст, который будет отображен как сообщение оператору. Заданные специальные символы для начала сообщения и конца сообщения будут автоматически присоединены постпроцессором для вас. Эти символы задаются в параметрах страницы \"\"Другие элементы данных\"\" на закладке \"\"Определение данных ЧПУ\"\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Имя сообщения"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Сообщение оператору не должно быть пустым."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Связанные постпроцессоры"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Задать связанные постпроцессоры"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Связать другой постпроцессор с этим постпроцессором"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Другие постпроцессоры могут быть связаны с этим постпроцессором, чтобы работать со сложными станками, которые выполняют больше чем одну операцию простого фрезерования и токарной обработки."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Голова"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Сложный станок, который может выполнять определенные операции обработки, используя множество различных кинематических наборов в различных режимах.  Каждый кинематический набор обрабатывается как независимая головка в NX/Постпроцессор.  Операции обработки, которые должны быть выполнены со специфической головкой, будут помещены вместе как группа на виде станка или виде методов обработки.  Затем \\\"Событие пользователя UDEГоловка\\\" будет назначен группе для обозначения имени головки."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Постпроцессор назначен для головы для создания кодов ЧПУ."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Связанный постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Создать"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Создать новую связь."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Изменить"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Изменить связь"

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Удалить"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Удалить связь."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Выбрать имя"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Выберите имя постпроцессора для назначения головке.  Возможно, что этот постпроцессор будет найден в папке, где выполняется главный постпроцессор NX/Постпроцессор, иначе будет использоваться постпроцессор с тем же именем в папке \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Начало процедуры работы головки"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Задайте коды ЧПУ или действия, которые должны быть выполнены в начале процедуры работы головки. "

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Конец процедуры работы головки"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Задайте коды ЧПУ или действия, которые должны быть выполнены в конце процедуры работы головки. "
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Голова"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Связанный постпроцессор"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "Задание данных ЧПУ"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "BLOCK"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Задать шаблоны кадра"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Имя кадра"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Введите имя кадра"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Добавить слово"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Вы можете добавить новое слово в кадр, нажимая эту кнопку и перемещая слово в кадр, который отображается в окне ниже. Тип слова, который будет создан, выбирается из блока списка справа от этой кнопки."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOCK -- Выбор слова"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Вы можете выбрать тип слова, который хотите добавить в кадр из этого списка."

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOCK -- Корзина"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Вы можете удалить любые ненужные слова из кадра, перемещая их в корзину"

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOCK -- Слово"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Вы можете удалить любое ненужное слово в этом кадре, переместив его в корзину. \n \nВы можете также открыть всплывающее меню, нажав правую кнопку мыши. Следующие опции доступны в этом меню: \n \n * Изменить \n * Изменить элемент -> \n * Опционально \n * Без разделителя слов \n * Постоянный вывод \n * Удалить \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOCK -- Проверка слова"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "Это окно отображает представляемый код программы ЧПУ, который будет выведен для слова, выбранного (подавленного) в кадре, который отображается в окне выше."

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Новый адрес"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Текст"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Команда"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Изменить"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Вид"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Сменить элемент"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Выражение, заданное пользователем"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Дополнительно"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Без разделителя слов"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Обязательный вывод"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Удалить"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Отмена действия"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Удалить все активные элементы"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Команда пользователя"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "WORD"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "WORD"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Новый адрес"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Сообщение оператору"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Команда пользователя"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Выражение, заданное пользователем"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Текстовая строка"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Выражение"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Кадр должен содержать по крайней мере одно слово."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Недопустимое имя кадра.\n Задайте другое имя."

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "WORD"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Задать слова"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Имя слова"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Вы можете изменить имя слова."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "WORD -- Проверка"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "Это окно отображает представляемый код программы ЧПУ, который будет выведен для слова."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Символ адреса"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Вы можете ввести любое число символов как лидер для слова или выбрать символ из всплывающего меню, используя правую кнопку мыши."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Формат"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Изменить"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Эта кнопка позволяет изменить формат, используемый в слове."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Создать"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Эта кнопка позволяет создать новый формат."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "WORD -- Выбрать формат"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Эта кнопка позволяет выбрать другой формат для слова."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Окончание"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Вы можете ввести любое число символов как окончание для слова или выбрать символ из всплывающего меню, используя правую кнопку мыши."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "Модальный ?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Эта опция позволяет указать модальность вывода для выбранного слова."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Выкл"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Однократно"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Всегда"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Максимум"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Вы можете задать максимальное значение слова."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Значение"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Обрезанное значение"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Предупреждение пользователя"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Прервать процесс"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Обработка ошибок"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Эта кнопка позволяет задать метод, как обработать ситуацию превышения максимального значения: \n \n * Обрезать значение \n * Предупредить пользователя \n * Прервать процесс \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Минимум"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Вы можете задать минимальное значение слова."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Обработка ошибок"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Эта кнопка позволяет задать метод, как обработать ситуацию превышения минимального значения: \n \n * Обрезать значение \n * Предупредить пользователя \n * Прервать процесс \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Нет"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Выражение"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "Вы можете задать выражение или константу для кадра."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "Выражение для элемента кадра не должно быть пустым."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "Выражение для элемента кадра, которое  использует числовой формат не может содержать только пробелы."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "Специальный символ \n [::msgcat::mc MC(address,exp,spec_char)] \n не может использоваться в выражении для численных данных."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Недопустимое имя слова.\n Задайте другое имя."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "Адреса rapid1, rapid2 и rapid3 зарезервированы для внутреннего использования генератором постпроцессоров.\n Задайте другое имя."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Ускоренное перемещение вдоль продольной оси"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Ускоренное перемещение вдоль поперечной оси"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Ускоренное перемещение вдоль оси шпинделя"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Задать форматы"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMAT -- проверка"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "Это окно отображает представляемый код программы ЧПУ, который будет выведен, используя заданный формат."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Имя формата"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Вы можете изменить имя формата."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Тип данных"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Вы можете задать тип данных для формата."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Числовое"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Эта опция задает тип данных формата как числовой."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMAT -- число цифр целой части"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Эта опция задает количество разрядов для целого числа или целочисленной части вещественного числа."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMAT -- число цифр дробной части"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Эта опция задает количество разрядов для дробной части вещественного числа."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Вывод десятичной точки (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Эта опция позволяет управлять выводом десятичных точек в коде программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Вывод ведущих нулей"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Эта опция позволяет вывод ведущих нулей в кодах программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Вывод конечных нулей"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Эта опция позволяет вывод конечных нулей для вещественных значений в кодах программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Текст"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Эта опция задает тип данных формата как текстовая строка."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Вывод ведущего символа плюс (+)"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Эта опция позволяет управлять выводом знака плюс в коде программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "Невозможно создать копию формата Zero"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "Невозможно удалить формат Zero"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "По крайней мере одна из опций: Десятичная точка, ведущие нули или конечные нули должна быть включена."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "Количество разрядов для целой и дробной части числа не должно быть нулевым."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Недопустимое имя формата.\n Задайте другое имя."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Ошибка формата"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Этот формат используется в адресах"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Другие элементы данных"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Задайте параметры"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Нумерация кадров"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Этот переключатель позволяет включить/выключить вывод номер кадра в файл листинга."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Номер первого кадра"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Задайте номер первого кадра программы."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Приращение номера кадра"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Задайте приращение номера кадра. "
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Частота вывода номера кадра"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Задайте частоту вывода номеров кадра в программу ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Максимальное значение номера кадра"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Задайте максимальное значение номера кадра"

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Специальные символы"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Разделитель слов"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Задайте символ, который будет использоваться как разделитель слов."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Десятичная точка"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Задайте символ, который будет использоваться как десятичная точка."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Конец кадра"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Задайте символ, который будет использоваться как конец кадра."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Начало сообщения"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Задайте символы, которые будут использоваться как начало строки сообщения оператору."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Конец сообщения"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Задайте символы, которые будут использоваться как конец строки сообщения оператору."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Заголовок строки"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "Заголовок строки OPSKIP"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "Вывод кодов G и M в одном кадре"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Количество G-кодов в кадре"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Этот переключатель позволяет включить/выключить разрешенное количество G-кодов в одном кадре программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Количество G-кодов"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Задайте количество G-кодов в одном кадре программы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Количество M-кодов"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Этот переключатель позволяет включить/выключить разрешенное количество M-кодов в одном кадре программы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Количество M-кодов в кадре"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Задайте количество M-кодов в одном кадре программы ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Нет"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Пространство"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Десятичный (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Запятая (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Точка с запятой (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Двоеточие (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Текстовая строка"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Левая круглая скобка ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Правая круглая скобка )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Знак фунта (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Звездочка (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Слеш (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Новая строка (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "События задаваемые пользователем"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Включить другой файл CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Эта опция позволяет постпроцессору включать ссылку на файл CDL в файле описания."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "Имя файл CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "Путь и имя файла CDL, на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH, используемая в сессии UG/NX."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Выбрать имя"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Выберите файл CDL, на который будет ссылаться (INCLUDE) файл описания этого постпроцессора. По умолчанию, выбранное имя файла будет начинаться с \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Вы можете изменить составное имя как необходимо после выбора."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Настройки вывода"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Конфигурировать параметры вывода"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Виртуальная система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Автономный"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Подчиненный"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Выбрать файл  VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "Выбранный файл не соответствует значению по умолчанию для имени файла виртуальной системы ЧПУ. \n Вы хотите повторно задать файл?"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Генерировать виртуальную систему ЧПУ (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Эта опция позволяет генерировать виртуальную систему ЧПУ. Постпроцессор, созданный с виртуальной системой ЧПУ, может использоваться для встроенной симуляции программы."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "Исходная виртуальная система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "Имя исходной виртуальной системы ЧПУ, которое будет исходным для зависимой виртуальной системы ЧПУ. Во время выполнения симуляции, предполагается, что этот постпроцессор будет найден в папке, в котором располагается зависимая виртуальная система ЧПУ, в противном случае, будет использоваться постпроцессор с тем же именем в папке \\\$UGII_CAM_POST_DIR."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Исходная виртуальная система ЧПУ должна быть задана для зависимой виртуальной системы ЧПУ "
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Выбрать имя"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Выберите имя виртуальной системы ЧПУ, которая будет исходной для зависимой виртуальной системы ЧПУ. В процессе работы симуляции, предполагается, что этот постпроцессор будет находится в папке, в котором располагается зависимая виртуальная система ЧПУ, в противном случае будет использоваться постпроцессор с таким же именем из папки \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Режим виртуальной системы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Виртуальная система ЧПУ может быть или автономной или зависимой от родительской виртуальной системы ЧПУ."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Автономная Виртуальная система ЧПУ является встроенной."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Зависимая  Виртуальная система ЧПУ - в значительной степени зависит от родительской  виртуальной системы ЧПУ. Это будет родительская виртуальная система ЧПУ которая работает во время выполнения симуляции."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Виртуальная система ЧПУ, созданная в Генераторе постпроцессора "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Файл листинга"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Задайте параметры файла листинга"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Генерировать файл листинга"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Этот переключатель позволяет включить/выключить вывод в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Элементы файла листинга"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Компоненты"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "X-координата"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты X в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Y-координата"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты Y в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Z-координата"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты Z в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "Угол 4-й оси"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Этот переключатель позволяет включить/выключить вывод угла 4-ой оси в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "Угол 5-й оси"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Этот переключатель позволяет включить/выключить вывод угла 5-ой оси в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Подача"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Этот переключатель позволяет включить/выключить вывод подач в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Скорость"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Этот переключатель позволяет включить/выключить вывод частоты вращения шпинделя в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Расширение файла листинга"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Задайте расширение файла листинга"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "Расширения выходного файла программы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "Задайте расширение файла программы ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Заголовок программы"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Список операций"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Список инструментов"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Примечание программы"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Общее время обработки"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Формат страницы"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Заголовок для печати страницы"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Этот переключатель позволяет включить/выключить вывод заголовка в файл листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Длина страницы (Строки)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Задайте количество строк на странице для файла листинга."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Ширина страницы (Столбцы)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Задайте количество колонок на странице для файла листинга."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Другие параметры"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Вывод элементов управления"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Вывод предупреждений"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Этот переключатель позволяет включить/выключить вывод предупреждений с процессе работы постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "Активировать инструмент отладки"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Этот переключатель позволяет активировать инструмент отладки в процессе вывода на постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Генерировать вывод группы"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Этот переключатель позволяет включить/выключить управление выводом группы в процессе вывода на постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Отображать подробное сообщение об ошибках"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Этот переключатель позволяет отобразить расширенные описания для аварийных ситуаций. При этом постпроцессор будет работать несколько медленнее."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Информация об операции"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Параметры операции"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Параметры инструмента"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Время обработки"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Исходный TCL пользователя"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Исходный TCL-файл пользователя"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Этот переключатель позволяет указать исходный собственный TCL-файл"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Имя файла"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Задайте имя TCL-файла, который хотите использовать как исходный для этого постпроцессора"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Просмотр файлов постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Новый код"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Старый код"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Обработчики событий"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Выберите событие для просмотра кодов процедуры"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Определения"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Выберите элемент для просмотра содержания"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "Экспертная система постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "Экспертная система постпроцессора"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "WORD"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "Составной BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "Post BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "Сообщение оператору"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Нечетное количество аргументов"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Неизвестные параметры"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   "Должна быть одна из:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Начало программы"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Начало траектории"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Перемещение из т. From"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "Первый инструмент"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Автоматическая смена инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Смена инструмента вручную"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Начальное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "Первое перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Перемещение подхода"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Перемещение врезания"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "1-й проход"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "Первое линейное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Начало прохода"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Перемещение включения коррекции"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Перемещение подхода"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Перемещение отвода"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Перемещение возврата"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Перемещение Gohome"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Конец операции"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Перемещение отхода"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Конец прохода"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "Завершение программы"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Смена инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "М-коды"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Смена инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Первичная револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Вторичная револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "Т код"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Конфигурировать"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Индекс первичной револьверной головки"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Индекс вторичной револьверной головки"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Номер инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Минимум"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Максимум"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Время (сек.)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Смена инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Отвод"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Отвод по Z"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Коррекция длины"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Регистр коррекции длины инструмента"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "Т код"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Конфигурировать"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Регистр коррекции длины"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Минимум"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Максимум"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Режим установок"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Режим вывода"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Абсолютно"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Приращение"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "Поворотная ось может программироваться в приращениях"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "ЧВ шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "М-коды направления вращения шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "По часовой стрелке (ПоЧС)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "Против часовой стрелки (ПротивЧС)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Управления диапазоном частот вращения шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Задержка времени при смене диапазона (сек.)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Задайте код диапазона"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "Шпиндель ПСвП"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "G-код шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Код постоянной скорости резания"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Код максимальных оборотов"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Код для отмены режима SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "Максимальные обороты при симуляции постоянной скорости резания"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Всегда включать режим IPR для SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Выключение шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "М-код направления вращения шпинделя"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Выкл"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "СОЖ включена"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "М-коды"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "Вкл"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Полив"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Распыление"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Сквозная"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "нарезание резьбы метчиком"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "СОЖ выключена"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "М-коды"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Выкл"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Режим дюймы/миллиметры"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Английские (дюйм)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Метрические (мм)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Подачи"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "Режим IPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "Режим IPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "Режим DPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "Режим MMPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "Режим MMPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "Режим FRN"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Формат"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Максимум"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Минимум"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Режимы подач"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Линейные"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Только поворотные"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Линейные и поворотные"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Ускоренное только линейные"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Ускоренное только поворотные"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Ускоренное линейное и поворотное"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Режим подачи в цикле"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Цикл"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Включение коррекции"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Влево"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Вправо"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Применяемые плоскости"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Изменить коды плоскостей"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Регистр коррекции"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Минимум"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Максимум"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Выключение коррекции перед изменением"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Выключение коррекции"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Выкл"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Задержка"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Секунды"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Формат"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Режим вывода"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Только секунды"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Только обороты"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Зависимые от подачи"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Инверсное время"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Обороты"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Формат"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Опциональный останов"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Дополнительная функция"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Функция позиционирования"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Загрузка инструмента"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Стоп"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Предварительный выбор инструмента"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Заправка проволоки"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Обрезка проволоки"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Направляющие проволоки"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Линейное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Линейное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Использовать режим ускоренного перемещения при максимальной подаче перехода"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Круговое перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "G-коды перемещений"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "По часовой стрелке (ПоЧС)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "Против часовой стрелки (ПротивЧС)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Запись круговых движений"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Полная окружность"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Квадрант"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "Задание IJK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "Задание IJ"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "Задание IK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Применяемые плоскости"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Изменить коды плоскостей"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Радиус"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Минимум"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Максимум"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Минимальная длина дуги"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Ускоренное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "G-код"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Ускоренное перемещение"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Смена рабочей плоскости "

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Резьба на токарной операции"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "G-код для резьбы"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Постоянный"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Приращение"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "Уменьшение"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "G-код и настройка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Настройка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Этот переключатель позволяет настроить цикл. \n\nПо умолчанию, основная конструкция каждого цикла задана установками общих параметров. Эти общие элементы не могут изменятся в каждом цикле. \n\nВключение этой опции позволяет получить полный контроль над конфигурацией цикла. Изменения, сделанные в общих параметрам, больше не будут воздействовать на цикл."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Начало цикла"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Эта опция может быть включена для станков, которые выполняют циклы, используя кадр начала цикла (G79...) после того, как цикл был задан (G81...)."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Использовать кадр начала цикла, чтобы выполнить цикл"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Ускоренное - в"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Отвод - в"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Управление плоскостью в цикле"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Общие параметры"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Выключение цикла"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Смена плоскости в цикле"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Сверлильный"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Задержка при сверлении"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Сверление - ввод текста"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Сверление - зенковка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Глубокое сверление"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Сверление с ломкой стружки"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "нарезание резьбы метчиком"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Растачивание"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Задержка при расточке"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Расточка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Расточка с ориентацией"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Обратная расточка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Ручная расточка"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Ручная расточка с задержкой"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Глубокое сверление"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Ломка стружки"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Сверление с задержкой (Центровка)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Глубокое сверление (С выводом)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Расточка (развертка)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Расточка с ориентацией"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Ускоренное перемещение"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Линейное перемещение"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Круговая интерполяция по ЧС"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Круговая интерполяция против ЧС"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Задержка (сек.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Задержка (об.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "Плоскость XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "Плоскость ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "Плоскость YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Выключение коррекции"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Коррекция слева"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Коррекция справа"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Положительная коррекция длины инструмента"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Отрицательная коррекция длины инструмента"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Выключение коррекции длины инструмента"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Режим - дюймы"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Режим - метрический"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Код начала цикла"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Выключение цикла"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Цикл сверления"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Цикл сверления с задержкой"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Цикл глубокого сверления"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Цикл сверления с ломкой стружки"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Цикл нарезания резьбы"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Цикл растачивания"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Цикл расточки"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Цикл расточки с ориентацией"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Цикл расточки с задержкой"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Цикл расточки с ручным выводом"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Цикл обратной расточки"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Цикл расточки с ручным выводом и задержкой"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Абсолютный режим"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Режим в приращениях"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Отвод в цикле (Авто)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Отвод в цикле (Вручную)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Сброс"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "Режим подачи IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "Режим подачи IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "Режим подачи FRN"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "Шпиндель ПСвП"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "ЧВ шпинделя"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Возврат в точку Home"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Постоянная резьба"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Приращение резьбы"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Уменьшающаяся резьба"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "Режим подачи IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "Режим подачи IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "Режим подачи MMPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "Режим подачи MMPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "Режим подачи DPM"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Остановка/Смена инструмента вручную"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Стоп"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Опциональный останов"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Конец программы"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Включение шпинделя/По часовой стрелке"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Включение шпинделя против часовой стрелки"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Постоянная резьба"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Приращение резьбы"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Уменьшающаяся резьба"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Выключение шпинделя"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Смена инструмента/отвод"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "СОЖ включена"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Подача СОЖ поливом"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Подача СОЖ туманом"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Подача СОЖ через инструмент"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Подача СОЖ через метчик"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "СОЖ выключена"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Перемотка"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Заправка проволоки"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Обрезка проволоки"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Прокачка включена"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Прокачка выключена"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Включение энергии"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Выключение энергии"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Заправка проволоки"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Обрезка проволоки"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Первичная револьверная головка"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Вторичная револьверная головка"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "Разрешить изменение события задаваемых пользователем"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Как сохранено"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Событие задаваемое пользователем"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "Нет соответствующего события задаваемого пользователем!"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Целое"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Добавить новый целочисленный параметр, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Действительное"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Добавить новый вещественный параметр, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Текст"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Добавить новый текстовый параметр, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Булевая"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Добавить новый булевый параметр, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Параметр"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Добавить новый параметр опции, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Точка"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Добавить новый параметр точки, перетащив его мышью в правый список."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Редактор -- мусорная корзина"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Вы можете удалить любые ненужные параметры из правого списка, перемещая их в мусорную корзину."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Событие"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "Вы можете изменить параметры события в меню с помощью MB1."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Событие -- параметры"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Вы можете изменить любой параметр нажатием на правую кнопку мыши или изменить порядок параметров используя перемещение. \n \nПараметры отображаемые ярко-синим цветом являются системными, и эти параметры не могут быть удалены. \nПараметры, отображаемые цветом старого дерева, являются несистемными, и эти параметры могут быть удалены."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Параметры -- опция"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Нажмите кнопку мыши 1, чтобы выбрать опцию по умолчанию. \n Дважды нажмите на кнопку мыши 1, чтобы изменить опцию."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Тип параметра: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Выбрать"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Отобразить"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Назад"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Отмена"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Метка параметра"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Имя переменной"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Значение по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Задайте метку параметра"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Задайте имя переменной"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Задайте значение по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Переключатель"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Переключатель"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Выберите значение переключателя"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Вкл"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Выкл"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Выберите значение по умолчанию как Вкл."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Выберите значение по умолчанию как Выкл."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Список опций"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Добавить"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Вырезать"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Вставить"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Добавить запись"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Вырезать запись"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Вставить запись"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Параметр"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Введите запись"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Имя события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Задайте имя события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "Имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "Задайте имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "Имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Этот переключатель позволяет задать имя постпроцессора"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Метка события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Задайте метку события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Метка события"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Этот переключатель позволяет задать метку события"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Категория"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Этот переключатель позволяет задать категорию"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Фрезерование"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Сверлильный"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Точение"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Проволочная ЭЭО"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Задание фрезерной категории"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Задание сверлильной категории"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Задание токарной категории"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Задание ЭЭО категории"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Изменить событие"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Создать событие управления станком"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Справка"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Изменить параметры заданные пользователем..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Изменить..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Вид..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Удалить"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Создать новое событие управления станком..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Импорт событий управления станком..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "Имя события не может быть пустым!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "Имя события существует!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "Обработчик событий существует! \nИзмените имя события или постпроцессора, если оно проверено!"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "В этом событии нет параметров!"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "События задаваемые пользователем"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "События управления станком"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Циклы, заданные пользователем"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Системные события управления станком"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Не системные события управления станком"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Системные циклы"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Не системные циклы"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Выберите запись для описания"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "Строка параметра не может быть пустой!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "Строка параметра существует!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "Опция, которую вы вставляете, существует!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Некоторые параметры совпадают!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "В списке нет опций!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "Имя переменной не может быть пустым!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Имя переменной уже существует!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "Это событие является общим с событием задаваемым пользователем \"Частота вращения шпинделя\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "Наследовать события, задаваемые пользователем из постпроцессора"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Эта опция позволяет постпроцессору наследовать определения событий задаваемых пользователем и их обработчики из другого постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Выбрать опору"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Выберите необходимый файл PUI постпроцессора. Рекомендуется, чтобы все связанные с постпроцессором файлы (PUI, Def, Tcl & CDL), были расположены в том же каталоге (папке) в процессе выполнения вывода на постпроцессор."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "Имя файл CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "Путь и имя файла CDL, который связан с выбранным постпроцессором и на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Имя файла описания"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "Путь и имя файла описания выбранного постпроцессора и на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Постпроцессор"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Папка"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Папка"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Включить собственный файл CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Эта опция позволяет постпроцессору включать ссылку на собственный файл CDL в файле описания."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Собственный файл CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "Путь и имя файла CDL, который связан с выбранным постпроцессором и на который создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "Выбрать файл PUI"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "Выбрать файл CDL"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Цикл заданный пользователем"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Создать цикл задаваемый пользователем"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Тип цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Задаваемый пользователем"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Заданное системой"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Метка цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Имя цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Задайте метку цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Задайте имя цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Метка цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Этот переключатель позволяет задать метку цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Изменить параметры заданные пользователем..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "Имя цикла не может быть пустым!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "Имя цикла уже существует!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "Обработчик событий существует!\n Измените имя события цикла!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Имя цикла принадлежит типу системного цикла!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Этот вид системного цикла существует!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Изменить событие цикла"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Создать новый цикл задаваемый пользователем..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Импорт циклов задаваемых пользователем..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "Это событие является общим обработчиком для сверления!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "Это событие - один из способов эмуляции циклов!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "Это событие является общим с циклом задаваемым пользователем "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Виртуальная система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Задайте параметры для встроенной симуляции и проверки."
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "Просмотр команд виртуальной системы ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Конфигурация"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "Команды виртуальной системы ЧПУ"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "Выберите мастер-файл VNC для зависимого VNC."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Станок"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Установка инструмента"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Ссылочная нулевая точка программы"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Компонент"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Задайте компонент как ссылочную базу ZCS. Это должен быть неповоротный элемент, к которому прямо или косвенно крепится деталь в дереве кинематики."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Компонент"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Задайте компонент, к которому будет крепиться инструмент. Это должен быть компонент шпинделя для фрезерного постпроцессора и компонент револьвера для токарного постпроцессора."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Соединение"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Задает соединение для крепления инструмента. Это соединение в центре грани шпинделя для фрезерных постпроцессоров. Это соединение вращения револьвера для токарных постпроцессоров. Это будет точка крепления инструмента, если револьвер не подвижен."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "Ось, заданная на станке"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Задайте имена осей, чтобы согласовать вашу конфигурацию кинематики станка"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "Имена осей станка с ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Вращение в противоположную сторону"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Задайте направление вращения поворотной оси, оно может быть обратным или нормальным. Это применяется только для поворотного стола."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Вращение в противоположную сторону"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Предел вращения"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Задайте, есть ли у этой поворотной оси пределы поворота"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Предел вращения"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Да"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "Нет"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "4-я ось"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "5-я ось"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Таблица "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Система ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Начальная установка"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Другие параметры"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Специальные коды ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Описание программы по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Экспорт программы описания"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Вывод описания программы в файл"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Импорт программы описания"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Вызов программы определения из файла"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "Выбранный файл не соответствует типу файла описания программы по умолчанию, Вы хотите продолжить?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Смещение нуля"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Данные инструмента"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Специальный G-код"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Специальный код ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Кинематика"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Задайте начальное перемещение станка"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Шпиндель"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Форма"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Направление"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Задайте начальные единицы задания оборотов шпинделя и направление вращения"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Режим подачи"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Задайте начальные единицы измерения подачи"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Задать булевою запись"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "Включение энергии РСК  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 указывает, что будет использоваться значение нулевой точки станка по умолчанию\n 1 указывает, что будет использоваться первое заданное пользователем смещение нулевой точки (рабочей системы координат)"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "Используется S"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "Используется F"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Резкое изменение ускоренного перемещения"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "Включение этого параметра задает логическое позиционирование при ускоренных перемещениях; выключение этого параметра задает ускоренное перемещение согласно коду ЧПУ (из точки в точку по прямой)."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Да"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "Нет"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "Задать Включение/Выключение"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Предел хода"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Коррекция"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Регистр коррекции длины инструмента"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "Масштаб"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Макро задания модальности"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "Вращение РСК"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Цикл"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Режим ввода"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Задайте начальный режим работы в абсолютных координатах или в приращениях"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Код остановки программы с перемоткой"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Задайте остановки программы с перемоткой"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Переменные управления"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Символ адреса"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Задайте переменные системы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Символ равно"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Задайте знак для символа Равно"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Символ процента %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Sharp #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Текстовая строка"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Начальный режим"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Абсолютно"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Режим в приращениях"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Приращение"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "G-код"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Используйте команды G90 G91, чтобы включить абсолютный режим или режим в приращениях"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Специальный адрес"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Использовать специальный адрес для абсолютного режима или режима работы в приращениях. Например: Адреса X Y Z указывают на абсолютный режим, адреса U V W, указывает на режим в приращения."
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "4-я ось "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "5-я ось "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Задайте специальный адрес оси X, который используется для вывода координат оси в приращении"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Задайте специальный адрес оси Y, который используется для вывода координат оси в приращении"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Задайте специальный адрес оси Z, который используется для вывода координат оси в приращении"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Задайте специальный адрес четвертой оси, который используется для вывода координат оси в приращении"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Задайте специальный адрес пятой оси, который используется для вывода координат оси в приращении"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "Вывод сообщений виртуальной системы ЧПУ"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "Список сообщений виртуальной системы ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Если эта опция включена, то все сообщения отладки виртуальной системы ЧПУ будут отображаться в процессе симуляции в окне сообщений."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Префикс сообщения"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Описание"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Список кодов"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "Коды ЧПУ / строка"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Смещение нулевой точки станка от\nточки нулевого соединения станка"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Смещение нуля"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Код "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " X-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Y-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Z-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " А-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " B-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " C-смещение  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Система координат"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Задайте номер нулевой точки, которая должна быть добавлена"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Добавить"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Добавьте новую систему координат смещения нуля, задайте ее позицию"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Этот номер системы координат уже существует!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Информация об инструменте"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Введите новое имя инструмента"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Имя       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Инструмент "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Добавить"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Диаметр "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Смещения вершины   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " Идентификатор магазина "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " Идентификатор кармана "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     Коррекция     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Регистр "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Смещение "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Настройка длины "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Тип   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Описание программы по умолчанию"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Описание программы"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Задайте файл описания программы"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Выберите файл описания программы"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Номер инструмента  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Задайте номер инструмента, который должен быть добавлен"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Добавьте новый инструмент, задайте его параметры"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Этот номер инструмента уже существует!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "Имя инструмента не может быть пустым!"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Специальный G-код"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "Задайте специальные G-коды, которые используются в симуляции"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Начало из точки Home"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Возврат в точку Home"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Перемещение СК станка"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Задание локальных координат"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "Специальные команды ЧПУ"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Команды ЧПУ для управления специальными устройствами"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Команды препроцессора"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "Список команд включает все символы или обозначения, который должны быть обработаны прежде, чем кадр будет рассчитан для вывода координат"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Добавить"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Изменить"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Удалить"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Специальная команда для других устройств"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "Добавить команду SIM @Cursor"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Выберите одну команду"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Символ адреса"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Задайте адрес для препроцессорной команды, задаваемой пользователем."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Код"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Задайте адрес для препроцессорной команды, задаваемой пользователем."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Символ адреса"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Задайте адрес для команды, задаваемой пользователем."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Код"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Задайте адрес для команды, задаваемой пользователем."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Добавить новую команду задаваемую пользователем"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Этот символ уже обработан!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Выберите команду"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Предупреждение"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Таблица инструмента"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "Это команда VNC, генерируемая системой. Изменения не будут сохранены."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Язык"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Английский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Французский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Немецкий"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Итальянский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "Японский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "Корейский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "Русский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "Упрощенный китайский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "Испанский"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "Традиционный китайский"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Параметры выхода"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Выход с сохранением всех"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Выход без сохранения"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Выход с сохранением выбранных"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Другой"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Нет"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Ускоренное перемещение & R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Быстрый размер"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Ускоренное перемещение шпинделя"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Выключение цикла при ускоренном перемещении шпинделя"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "ДВМ"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "ДНО"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Авто"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Абсолютные/приращения"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Только абсолютные"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Только приращения"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "Кратчайшее расстояние"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Всегда положительный"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Всегда отрицательный"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Ось Z"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+X ось"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-X ось"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Ось Y"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "Направление задается значением"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "Направление задается знаком"


