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
#       ::msgcat::mcset pb_msg_english "MC(main,title,Unigraphics)"  "Unigraphics"
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


#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset pb_msg_russian "MC(event,misc,subop_start,name)"      "Начало траектории дополнительной операции"
::msgcat::mcset pb_msg_russian "MC(event,misc,subop_end,name)"        "Конец траектории дополнительной операции"
::msgcat::mcset pb_msg_russian "MC(event,misc,contour_start,name)"    "Начало контура"
::msgcat::mcset pb_msg_russian "MC(event,misc,contour_end,name)"      "Конец контура"
::msgcat::mcset pb_msg_russian "MC(prog,tree,misc,Label)"             "Разное"
::msgcat::mcset pb_msg_russian "MC(event,cycle,lathe_rough,name)"     "Обдирочный токарный станок"
::msgcat::mcset pb_msg_russian "MC(main,file,properties,Label)"       "Свойства столба"

::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_CATEGORY)"    "UDE для обтесанного или обработанного на станке столба можно указать только в категории \"ПЭЭО\"! "

::msgcat::mcset pb_msg_russian "MC(event,cycle,plane_change,label)"   "Определить изменение уровня рабочей плоскости на размещенный ниже"
::msgcat::mcset pb_msg_russian "MC(format,check_1,error,msg)"         "Формат не может вместить значение выражений"

::msgcat::mcset pb_msg_russian "MC(format,check_4,error,msg)"         "Измените формат связанного адреса, прежде чем покидать эту страницу или сохранять данную публикацию!"
::msgcat::mcset pb_msg_russian "MC(format,check_5,error,msg)"         "Измените формат, прежде чем покидать эту страницу или сохранять данную публикацию!"
::msgcat::mcset pb_msg_russian "MC(format,check_6,error,msg)"         "Измените формат связанного адреса, прежде чем входить на эту страницу!"

::msgcat::mcset pb_msg_russian "MC(msg,old_block,maximum_length)"     "Имена следующих кадров превысили ограничение по длине:"
::msgcat::mcset pb_msg_russian "MC(msg,old_address,maximum_length)"   "Имена следующих слов превысили ограничение по длине:"
::msgcat::mcset pb_msg_russian "MC(msg,block_address,check,title)"    "Проверка имен кадра и слова"
::msgcat::mcset pb_msg_russian "MC(msg,block_address,maximum_length)" "Некоторые имена кадров или слов превысили ограничение по длине."

::msgcat::mcset pb_msg_russian "MC(address,maximum_name_msg)"         "Длина строки превысила ограничение."

::msgcat::mcset pb_msg_russian "MC(ude,import,oth_list,Label)"        "Включить другой файл CDL"
::msgcat::mcset pb_msg_russian "MC(ude,import,oth_list,Context)"      "Выберите команду \\\"Создать\\\" в контекстном меню (открываемом с помощью щелчка правой кнопкой мыши), чтобы включить другие файлы CDL в данную публикацию."
::msgcat::mcset pb_msg_russian "MC(ude,import,ihr_list,Label)"        "Наследовать события, задаваемые пользователем из постпроцессора"
::msgcat::mcset pb_msg_russian "MC(ude,import,ihr_list,Context)"      "Выберите команду \\\"Создать\\\" в контекстном меню (открываемом с помощью щелчка правой кнопкой мыши), чтобы наследовать все определения UDE и связанные маркеры из публикации."
::msgcat::mcset pb_msg_russian "MC(ude,import,up,Label)"              "Вверх"
::msgcat::mcset pb_msg_russian "MC(ude,import,down,Label)"            "Вниз"
::msgcat::mcset pb_msg_russian "MC(msg,exist_cdl_file)"               "Указанный файл CDL уже включен!"

::msgcat::mcset pb_msg_russian "MC(listing,link_var,check,Label)"     "Связать переменные Tcl с переменными C"
::msgcat::mcset pb_msg_russian "MC(listing,link_var,check,Context)"   "Набор часто меняющихся переменных Tcl (например, \\\"mom_pos\\\") можно связать напрямую с переменными C, чтобы повысить скорость последующей обработки. Однако следует учитывать определенные ограничения, чтобы избежать возможных ошибок и различий в результатах числового управления."

::msgcat::mcset pb_msg_russian "MC(msg,check_resolution,title)"       "Проверить дискретность поступательного и вращательного перемещения"
::msgcat::mcset pb_msg_russian "MC(msg,check_resolution,linear)"      "Настройка формата может не вмещать выходные данные для \"Дискретности линейного перемещения\"."
::msgcat::mcset pb_msg_russian "MC(msg,check_resolution,rotary)"      "Настройка формата может не вмещать выходные данные для \"Дискретности вращательного перемещения\"."

::msgcat::mcset pb_msg_russian "MC(cmd,export,desc,label)"            "Введите описание для экспортированных настраиваемых команд"
::msgcat::mcset pb_msg_russian "MC(cmd,desc_dlg,title)"               "Описание"
::msgcat::mcset pb_msg_russian "MC(block,delete_row,Label)"           "Удалить все активные элементы в этой строке"
::msgcat::mcset pb_msg_russian "MC(block,exec_cond,set,Label)"        "Состояние вывода"
::msgcat::mcset pb_msg_russian "MC(block,exec_cond,new,Label)"        "Новый..."
::msgcat::mcset pb_msg_russian "MC(block,exec_cond,edit,Label)"       "Изменить..."
::msgcat::mcset pb_msg_russian "MC(block,exec_cond,remove,Label)"     "Удалить..."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,name_msg_for_cond)"       "Укажите другое имя.  \nКоманда условия вывода должна начинаться с префикса"

::msgcat::mcset pb_msg_russian "MC(machine,linearization,Label)"         "Интерполяция линеаризацией"
::msgcat::mcset pb_msg_russian "MC(machine,linearization,angle,Label)"   "Угол поворота"
::msgcat::mcset pb_msg_russian "MC(machine,linearization,angle,Context)" "Интерполированные точки будут рассчитаны на основе распределения начальных и конечных углов относительно осей вращения."
::msgcat::mcset pb_msg_russian "MC(machine,linearization,axis,Label)"    "Ось инструмента"
::msgcat::mcset pb_msg_russian "MC(machine,linearization,axis,Context)"  "Интерполированные точки будут рассчитаны на основе распределения начальных и конечных векторов оси инструмента."
::msgcat::mcset pb_msg_russian "MC(machine,resolution,continue,Label)"   "Продолжить"
::msgcat::mcset pb_msg_russian "MC(machine,resolution,abort,Label)"      "Прервать"

::msgcat::mcset pb_msg_russian "MC(machine,axis,def_lintol,Label)"       "Допуск по умолчанию"
::msgcat::mcset pb_msg_russian "MC(machine,axis,def_lintol,Context)"     "Допуск на линеаризацию по умолчанию"
::msgcat::mcset pb_msg_russian "MC(sub_post,inch,Lable)"                 " ДЮЙМ"
::msgcat::mcset pb_msg_russian "MC(sub_post,metric,Lable)"               "ММ"
::msgcat::mcset pb_msg_russian "MC(new_sub,title,Label)"                 "Создать новый процессор второстепенных публикаций"
::msgcat::mcset pb_msg_russian "MC(new,sub_post,toggle,label)"           "Второстепенная публикация"
::msgcat::mcset pb_msg_russian "MC(new,sub_post,toggle,tmp_label)"       "Дополнительная публикация только по единицам"
::msgcat::mcset pb_msg_russian "MC(new,unit_post,filename,msg)"          "Для новой второстепенной публикации для альтернативных единицы вывода должно быть указано имя\n путем добавления префикса \"__MM\" или \"__IN\" к имени основной публикации."
::msgcat::mcset pb_msg_russian "MC(new,alter_unit,toggle,label)"         "Альтернативные единицы вывода"
::msgcat::mcset pb_msg_russian "MC(new,main_post,label)"                 "Основная публикация"
::msgcat::mcset pb_msg_russian "MC(new,main_post,warning_1,msg)"         "Для создания новой второстепенной публикации можно использовать только полную основную публикацию!"
::msgcat::mcset pb_msg_russian "MC(new,main_post,warning_2,msg)"         "Основная публикация должна быть создана или сохранена\n в Post Builder версии 8.0 или более поздней."
::msgcat::mcset pb_msg_russian "MC(new,main_post,specify_err,msg)"       "Необходимо указать основную публикацию для создания второстепенной публикации!"
::msgcat::mcset pb_msg_russian "MC(machine,gen,alter_unit,Label)"        "Единицы вывода дополнительной публикации:"
::msgcat::mcset pb_msg_russian "MC(unit_related_param,tab,Label)"        "Параметры единиц"
::msgcat::mcset pb_msg_russian "MC(unit_related_param,feed_rate,Label)"  "Подача"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,frame,Label)"        "Дополнительная публикация в альтернативных единицах"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,default,Label)"      "По умолчанию"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,default,Context)"    "По умолчанию для дополнительной публикации в альтернативных единицах будет использоваться имя: <имя публикации>__MM или <имя публикации>__IN"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,specify,Label)"      "Задать"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,specify,Context)"    "Укажите имя дополнительной публикации в альтернативных единицах"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,select_name,Label)"  "Выбрать имя"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,warning_1,msg)"      "Можно выбрать только дополнительную публикацию в альтернативных единицах!"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,warning_2,msg)"      "Выбранная дополнительная публикация не может поддерживать альтернативные единицы вывода для этой публикации!"

::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,post_name,Label)"    "Дополнительная публикация в альтернативных единицах"
::msgcat::mcset pb_msg_russian "MC(listing,alt_unit,post_name,Context)"  "Публикация NX будет использовать единицы дополнительной публикации, если таковые указаны, для обработки альтернативных единиц вывода в этой публикации."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,user,evt_title)"  "Функция контроля ограничения перемещений"
::msgcat::mcset pb_msg_russian "MC(event,helix,name)"                       "Перемещение по спирали"
::msgcat::mcset pb_msg_russian "MC(event,circular,ijk_param,prefix,msg)"    "Выражения, использованные в адресах,"
::msgcat::mcset pb_msg_russian "MC(event,circular,ijk_param,postfix,msg)"   "не будут затронуты при изменении этой опции!"
::msgcat::mcset pb_msg_russian "MC(isv,spec_codelist,default,msg)"          "Это действие восстановит список специальных кодов ЧПУ и\n их обработчиков на момент открытия или создания этого постпроцессора.\n\n Хотите продолжить?"
::msgcat::mcset pb_msg_russian "MC(isv,spec_codelist,restore,msg)"          "Это действие восстановит список специальных кодов ЧПУ и\n их обработчиков на момент последнего посещения этой страницы.\n\n Хотите продолжить?"
::msgcat::mcset pb_msg_russian "MC(msg,block_format_command,paste_err)"     "Имя объекта существует...Недопустимая вставка!"
::msgcat::mcset pb_msg_russian "MC(main,file,open,choose_cntl_type)"        "Выберите семейство систем ЧПУ"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Этот файл не содержит новой или другой команды VNC!"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,no_cmd,msg)"             "Этот файл не содержит новой или другой настраиваемой команды!"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,name_same_err,Msg)"        "Имена инструментов не могут повторяться!"
::msgcat::mcset pb_msg_russian "MC(msg,limit_to_change_license)"            "Вы не являетесь автором этого постпроцессора. \nВы не можете переименовать его или изменить его лицензию."
::msgcat::mcset pb_msg_russian "MC(output,other_opts,validation,msg)"       "Должно быть задано имя пользовательского TCL-файла."
::msgcat::mcset pb_msg_russian "MC(machine,empty_entry_err,msg)"            "На это странице параметров есть пустые записи."
::msgcat::mcset pb_msg_russian "MC(msg,control_v_limit)"                    "Возможно, что строка, которую вы пытаетесь вставить,\n превышает допустимую длину или содержит\n несколько строк или недопустимые символы."
::msgcat::mcset pb_msg_russian "MC(block,capital_name_msg)"                 "Первая буква имени кадра не может быть заглавной!\n Задайте другое имя."
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,user,Label)"      "Задаваемый пользователем"
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,user,Handler)"    "Обработчик"
::msgcat::mcset pb_msg_russian "MC(new,user,file,NOT_EXIST)"                "Этот пользовательский файл не существует!"
::msgcat::mcset pb_msg_russian "MC(new,include_vnc,Label)"                  "Включить виртуальную систему ЧПУ"
::msgcat::mcset pb_msg_russian "MC(other,opt_equal,Label)"                  "Символ равно (=)"
::msgcat::mcset pb_msg_russian "MC(event,nurbs,name)"                       " NURBS перемещение"
::msgcat::mcset pb_msg_russian "MC(event,cycle,tap_float,name)"             "Резьба с канавками"
::msgcat::mcset pb_msg_russian "MC(event,cycle,thread,name)"                "Резьба"
::msgcat::mcset pb_msg_russian "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Вложенное группирование не поддерживается!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,bmp,Label)"                   "Значок"
::msgcat::mcset pb_msg_russian "MC(ude,editor,bmp,Context)"                 "Добавить новый параметр значка, перетащив его мышью в правый список."
::msgcat::mcset pb_msg_russian "MC(ude,editor,group,Label)"                 "Группа"
::msgcat::mcset pb_msg_russian "MC(ude,editor,group,Context)"               "Добавить новый параметр группы, перетащив его мышью в правый список."
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,DESC,Label)"         "Описание"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,DESC,Context)"       "Задать информацию о событии"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,URL,Context)"        "Задать URL для описания события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Файл изображения должен иметь формат BMP!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Имя файла значка не должно содержать путь папки!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Имя переменной должно начинаться с буквы."
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Имя переменной не должно использовать ключевое слово: "
::msgcat::mcset pb_msg_russian "MC(ude,editor,status_label)"                "Состояние"
::msgcat::mcset pb_msg_russian "MC(ude,editor,vector,Label)"                "Вектор"
::msgcat::mcset pb_msg_russian "MC(ude,editor,vector,Context)"              "Добавить новый векторный параметр, перетащив его мышью в правый список."
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL должен иметь формат \"http://*\" или \"file://*\". Обратная косая черта не допускается."
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Необходимо задать описание и URL!"
::msgcat::mcset pb_msg_russian "MC(new,MSG_NO_AXIS)"                        "Для станка необходимо выбрать конфигурацию оси."
::msgcat::mcset pb_msg_russian "MC(machine,info,controller_type,Label)"     "Семейство систем ЧПУ"
::msgcat::mcset pb_msg_russian "MC(block,func_combo,Label)"                 "Макрос"
::msgcat::mcset pb_msg_russian "MC(block,prefix_popup,add,Label)"           "Добавить префикс текста"
::msgcat::mcset pb_msg_russian "MC(block,prefix_popup,edit,Label)"          "Изменить префикс текста"
::msgcat::mcset pb_msg_russian "MC(block,prefix,Label)"                     "Префикс"
::msgcat::mcset pb_msg_russian "MC(block,suppress_popup,Label)"             "Подавить порядковый номер"
::msgcat::mcset pb_msg_russian "MC(block,custom_func,Label)"                "Макрос пользователя"
::msgcat::mcset pb_msg_russian "MC(seq,combo,macro,Label)"                  "Макрос пользователя"
::msgcat::mcset pb_msg_russian "MC(func,tab,Label)"                         "Макрос"
::msgcat::mcset pb_msg_russian "MC(func,exp,msg)"                           "Выражение для параметра макроса не должно быть пустым."
::msgcat::mcset pb_msg_russian "MC(func,edit,name,Label)"                   "Имя макроса"
::msgcat::mcset pb_msg_russian "MC(func,disp_name,Label)"                   "Выходное имя"
::msgcat::mcset pb_msg_russian "MC(func,param_list,Label)"                  "Список параметров"
::msgcat::mcset pb_msg_russian "MC(func,separator,Label)"                   "Разделитель"
::msgcat::mcset pb_msg_russian "MC(func,start,Label)"                       "Начальный символ"
::msgcat::mcset pb_msg_russian "MC(func,end,Label)"                         "Конечный символ"
::msgcat::mcset pb_msg_russian "MC(func,output,name,Label)"                 "Выходной атрибут"
::msgcat::mcset pb_msg_russian "MC(func,output,check,Label)"                "Имя выходного параметра"
::msgcat::mcset pb_msg_russian "MC(func,output,link,Label)"                 "Символ ссылки"
::msgcat::mcset pb_msg_russian "MC(func,col_param,Label)"                   "Параметр"
::msgcat::mcset pb_msg_russian "MC(func,col_exp,Label)"                     "Выражение"
::msgcat::mcset pb_msg_russian "MC(func,popup,insert,Label)"                "Новый"
::msgcat::mcset pb_msg_russian "MC(func,name,err_msg)"                      "Имя макроса не должно иметь пробелы!"
::msgcat::mcset pb_msg_russian "MC(func,name,blank_err)"                    "Имя макроса не должно быть пустым!"
::msgcat::mcset pb_msg_russian "MC(func,name,contain_err)"                  "Имя макроса должно содержать буквы, числа и знак подчеркивания!"
::msgcat::mcset pb_msg_russian "MC(func,tree_node,start_err)"               "Имя узла должно начинаться с заглавной буквы!"
::msgcat::mcset pb_msg_russian "MC(func,tree_node,contain_err)"             "Имя узла может содержать буквы, числа и знак подчеркивания!"
::msgcat::mcset pb_msg_russian "MC(func,help,Label)"                        "Информация"
::msgcat::mcset pb_msg_russian "MC(func,help,Context)"                      "Показать информацию об объекте."
::msgcat::mcset pb_msg_russian "MC(func,help,MSG_NO_INFO)"                  "Нет информации для этого макроса."


##------
## Title
##
::msgcat::mcset pb_msg_russian "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_russian "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_russian "MC(main,title,Post_Builder)"            "Генератор постпроцессоров"

::msgcat::mcset pb_msg_russian "MC(main,title,Version)"                 "Версия"
::msgcat::mcset pb_msg_russian "MC(main,default,Status)"                "Выберите опцию \"Новый\" или \"Открыть\" в меню \"Файл\"."
::msgcat::mcset pb_msg_russian "MC(main,save,Status)"                   "Сохранить постпроцессор."

##------
## File
##
::msgcat::mcset pb_msg_russian "MC(main,file,Label)"                    "Файл"

::msgcat::mcset pb_msg_russian "MC(main,file,Balloon)"                  "\ Новый, Открыть, Сохранить,\n Сохранить\ как, Закрыть и выйти"

::msgcat::mcset pb_msg_russian "MC(main,file,Context)"                  "\ Новый, Открыть, Сохранить,\n Сохранить\ как, Закрыть и выйти"
::msgcat::mcset pb_msg_russian "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_russian "MC(main,file,new,Label)"                "Новый ..."
::msgcat::mcset pb_msg_russian "MC(main,file,new,Balloon)"              "Создать новый постпроцессор."
::msgcat::mcset pb_msg_russian "MC(main,file,new,Context)"              "Создать новый постпроцессор."
::msgcat::mcset pb_msg_russian "MC(main,file,new,Busy)"                 "Создание нового постпроцессора ..."

::msgcat::mcset pb_msg_russian "MC(main,file,open,Label)"               "Открыть ..."
::msgcat::mcset pb_msg_russian "MC(main,file,open,Balloon)"             "Изменить существующий постпроцессор."
::msgcat::mcset pb_msg_russian "MC(main,file,open,Context)"             "Изменить существующий постпроцессор."
::msgcat::mcset pb_msg_russian "MC(main,file,open,Busy)"                "Открытие постпроцессора ..."

::msgcat::mcset pb_msg_russian "MC(main,file,mdfa,Label)"               "Импорт MDFA ..."
::msgcat::mcset pb_msg_russian "MC(main,file,mdfa,Balloon)"             "Создание нового постпроцессора из MDFA."
::msgcat::mcset pb_msg_russian "MC(main,file,mdfa,Context)"             "Создание нового постпроцессора из MDFA."

::msgcat::mcset pb_msg_russian "MC(main,file,save,Label)"               "Сохранить"
::msgcat::mcset pb_msg_russian "MC(main,file,save,Balloon)"             "Выполняется сохранение постпроцессора."
::msgcat::mcset pb_msg_russian "MC(main,file,save,Context)"             "Выполняется сохранение постпроцессора."
::msgcat::mcset pb_msg_russian "MC(main,file,save,Busy)"                "Сохранение постпроцессора ..."

::msgcat::mcset pb_msg_russian "MC(main,file,save_as,Label)"            "Сохранить как ..."
::msgcat::mcset pb_msg_russian "MC(main,file,save_as,Balloon)"          "Сохранить постпроцессор с новым именем."
::msgcat::mcset pb_msg_russian "MC(main,file,save_as,Context)"          "Сохранить постпроцессор с новым именем."

::msgcat::mcset pb_msg_russian "MC(main,file,close,Label)"              "Закрыть"
::msgcat::mcset pb_msg_russian "MC(main,file,close,Balloon)"            "Выполняется закрытие постпроцессора."
::msgcat::mcset pb_msg_russian "MC(main,file,close,Context)"            "Выполняется закрытие постпроцессора."

::msgcat::mcset pb_msg_russian "MC(main,file,exit,Label)"               "Выход"
::msgcat::mcset pb_msg_russian "MC(main,file,exit,Balloon)"             "Закончить работу генератора постпроцессоров."
::msgcat::mcset pb_msg_russian "MC(main,file,exit,Context)"             "Закончить работу генератора постпроцессоров."

::msgcat::mcset pb_msg_russian "MC(main,file,history,Label)"            "Ранее открытые постпроцессоры"
::msgcat::mcset pb_msg_russian "MC(main,file,history,Balloon)"          "Изменить ранее открытый постпроцессор."
::msgcat::mcset pb_msg_russian "MC(main,file,history,Context)"          "Изменить постпроцессор, открытый в предыдущей сессии."

##---------
## Options
##
::msgcat::mcset pb_msg_russian "MC(main,options,Label)"                 "Опции"

::msgcat::mcset pb_msg_russian "MC(main,options,Balloon)"               " Проверка\ Команды\ пользователя, Резервные копии\ постпроцессора"
::msgcat::mcset pb_msg_russian "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_russian "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_russian "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_russian "MC(main,windows,Balloon)"               "Список изменяемых постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_russian "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_russian "MC(main,options,properties,Label)"      "Свойства"
::msgcat::mcset pb_msg_russian "MC(main,options,properties,Balloon)"    "Свойства"
::msgcat::mcset pb_msg_russian "MC(main,options,properties,Context)"    "Свойства"

::msgcat::mcset pb_msg_russian "MC(main,options,advisor,Label)"         "Экспертная система постпроцессора"
::msgcat::mcset pb_msg_russian "MC(main,options,advisor,Balloon)"       "Экспертная система постпроцессора"
::msgcat::mcset pb_msg_russian "MC(main,options,advisor,Context)"       "Разрешить/запретить экспертную систему постпроцессора"

::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,Label)"       "Проверка команд пользователя"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,Balloon)"     "Проверка команд пользователя"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,Context)"     "Переключатели для проверки команд пользователя"

::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,syntax,Label)"   "Синтаксические ошибки"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,command,Label)"  "Неизвестные команды"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,block,Label)"    "Неизвестные кадры"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,address,Label)"  "Неизвестные адреса"
::msgcat::mcset pb_msg_russian "MC(main,options,cmd_check,format,Label)"   "Неизвестные форматы"

::msgcat::mcset pb_msg_russian "MC(main,options,backup,Label)"          "Резервные копии постпроцессора"
::msgcat::mcset pb_msg_russian "MC(main,options,backup,Balloon)"        "Метод резервного копирования"
::msgcat::mcset pb_msg_russian "MC(main,options,backup,Context)"        "Создание резервных копий, в процессе сохранения постпроцессора."

::msgcat::mcset pb_msg_russian "MC(main,options,backup,one,Label)"      "Резервная копия оригинала"
::msgcat::mcset pb_msg_russian "MC(main,options,backup,all,Label)"      "Резервное копирование при сохранении"
::msgcat::mcset pb_msg_russian "MC(main,options,backup,none,Label)"     "Не создавать резервные копии"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_russian "MC(main,utils,Label)"                   "Утилиты"
::msgcat::mcset pb_msg_russian "MC(main,utils,Balloon)"                 "\ Выбрать\ MOM\ переменную, Инсталляция\ постпроцессора"
::msgcat::mcset pb_msg_russian "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_russian "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_russian "MC(main,utils,etpdf,Label)"             "Изменить файл данных шаблонов постпроцессоров"

::msgcat::mcset pb_msg_russian "MC(main,utils,bmv,Label)"               "Просмотр MOM переменных"
::msgcat::mcset pb_msg_russian "MC(main,utils,blic,Label)"              "Просмотр лицензии"


##------
## Help
##
::msgcat::mcset pb_msg_russian "MC(main,help,Label)"                    "Справка"
::msgcat::mcset pb_msg_russian "MC(main,help,Balloon)"                  "Опции справки"
::msgcat::mcset pb_msg_russian "MC(main,help,Context)"                  "Опции справки"
::msgcat::mcset pb_msg_russian "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_russian "MC(main,help,bal,Label)"                "Экранные подсказки"
::msgcat::mcset pb_msg_russian "MC(main,help,bal,Balloon)"              "Экранные подсказки на значках"
::msgcat::mcset pb_msg_russian "MC(main,help,bal,Context)"              "Разрешить/ запретить отображение экранных подсказок на значках."

::msgcat::mcset pb_msg_russian "MC(main,help,chelp,Label)"              "Контекстная справка "
::msgcat::mcset pb_msg_russian "MC(main,help,chelp,Balloon)"            "Контекстная справка на элементах меню"
::msgcat::mcset pb_msg_russian "MC(main,help,chelp,Context)"            "Контекстная справка на элементах меню"

::msgcat::mcset pb_msg_russian "MC(main,help,what,Label)"               "Что сделать?"
::msgcat::mcset pb_msg_russian "MC(main,help,what,Balloon)"             "Что вы можете здесь сделать?"
::msgcat::mcset pb_msg_russian "MC(main,help,what,Context)"             "Что вы можете здесь сделать?"

::msgcat::mcset pb_msg_russian "MC(main,help,dialog,Label)"             "Справка по меню"
::msgcat::mcset pb_msg_russian "MC(main,help,dialog,Balloon)"           "Справка по этому меню"
::msgcat::mcset pb_msg_russian "MC(main,help,dialog,Context)"           "Справка по этому меню"

::msgcat::mcset pb_msg_russian "MC(main,help,manual,Label)"             "Руководство пользователя"
::msgcat::mcset pb_msg_russian "MC(main,help,manual,Balloon)"           "Справочник пользователя"
::msgcat::mcset pb_msg_russian "MC(main,help,manual,Context)"           "Справочник пользователя"

::msgcat::mcset pb_msg_russian "MC(main,help,about,Label)"              "О генераторе постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(main,help,about,Balloon)"            "О генераторе постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(main,help,about,Context)"            "О генераторе постпроцессоров"

::msgcat::mcset pb_msg_russian "MC(main,help,rel_note,Label)"           "Замечания по версии"
::msgcat::mcset pb_msg_russian "MC(main,help,rel_note,Balloon)"         "Замечания по версии"
::msgcat::mcset pb_msg_russian "MC(main,help,rel_note,Context)"         "Замечания по версии"

::msgcat::mcset pb_msg_russian "MC(main,help,tcl_man,Label)"            "Справочные руководства по Tcl/Tk"
::msgcat::mcset pb_msg_russian "MC(main,help,tcl_man,Balloon)"          "Справочные руководства по Tcl/Tk"
::msgcat::mcset pb_msg_russian "MC(main,help,tcl_man,Context)"          "Справочные руководства по Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_russian "MC(tool,new,Label)"                     "Новый"
::msgcat::mcset pb_msg_russian "MC(tool,new,Context)"                   "Создать новый постпроцессор."

::msgcat::mcset pb_msg_russian "MC(tool,open,Label)"                    "Открыть"
::msgcat::mcset pb_msg_russian "MC(tool,open,Context)"                  "Изменить существующий постпроцессор."

::msgcat::mcset pb_msg_russian "MC(tool,save,Label)"                    "Сохранить"
::msgcat::mcset pb_msg_russian "MC(tool,save,Context)"                  "Выполняется сохранение постпроцессора."

::msgcat::mcset pb_msg_russian "MC(tool,bal,Label)"                     "Экранные подсказки"
::msgcat::mcset pb_msg_russian "MC(tool,bal,Context)"                   "Разрешить/ запретить отображение экранных подсказок на значках."

::msgcat::mcset pb_msg_russian "MC(tool,chelp,Label)"                   "Контекстная справка"
::msgcat::mcset pb_msg_russian "MC(tool,chelp,Context)"                 "Контекстная справка на элементах меню"

::msgcat::mcset pb_msg_russian "MC(tool,what,Label)"                    "Что сделать?"
::msgcat::mcset pb_msg_russian "MC(tool,what,Context)"                  "Что вы можете здесь сделать?"

::msgcat::mcset pb_msg_russian "MC(tool,dialog,Label)"                  "Справка по меню"
::msgcat::mcset pb_msg_russian "MC(tool,dialog,Context)"                "Справка по этому меню"

::msgcat::mcset pb_msg_russian "MC(tool,manual,Label)"                  "Руководство пользователя"
::msgcat::mcset pb_msg_russian "MC(tool,manual,Context)"                "Справочник пользователя"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_russian "MC(msg,error,title)"                    "Ошибка генератора постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(msg,dialog,title)"                   "Сообщение генератора постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(msg,warning)"                        "Предупреждение"
::msgcat::mcset pb_msg_russian "MC(msg,error)"                          "Ошибка"
::msgcat::mcset pb_msg_russian "MC(msg,invalid_data)"                   "Недопустимые данные были введены для параметра"
::msgcat::mcset pb_msg_russian "MC(msg,invalid_browser_cmd)"            "Недопустимая команда браузера :"
::msgcat::mcset pb_msg_russian "MC(msg,wrong_filename)"                 "Имя файла было изменено!"
::msgcat::mcset pb_msg_russian "MC(msg,user_ctrl_limit)"                "Лицензионный постпроцессор не может использоваться как управляющий\n для создания нового постпроцессора, если вы не автор!"
::msgcat::mcset pb_msg_russian "MC(msg,import_limit)"                   "Вы не автор этого лицензионного постпроцессора!\n Команды пользователя не могут быть импортированы!"
::msgcat::mcset pb_msg_russian "MC(msg,limit_msg)"                      "Вы не автор этого лицензионного постпроцессора!"
::msgcat::mcset pb_msg_russian "MC(msg,no_file)"                        "Зашифрованный файл отсутствует для этого лицензионного постпроцессора!"
::msgcat::mcset pb_msg_russian "MC(msg,no_license)"                     "У вас нет необходимой лицензии, чтобы выполнить эту функцию!"
::msgcat::mcset pb_msg_russian "MC(msg,no_license_title)"               "Использование NX/Генератора постпроцессора без лицензии"
::msgcat::mcset pb_msg_russian "MC(msg,no_license_dialog)"              "Вам разрешено использовать NX/Генератор постпроцессора\n без лицензии.  Однако, после этого вы\n не сможете сохранить вашу работу."
::msgcat::mcset pb_msg_russian "MC(msg,pending)"                        "Сервис этой опции будет реализован в следующих версиях."
::msgcat::mcset pb_msg_russian "MC(msg,save)"                           "Вы хотите сохранить ваши изменения\n перед закрытием постпроцессора?"
::msgcat::mcset pb_msg_russian "MC(msg,version_check)"                  "Постпроцессор, созданный в более новой версии генератора постпроцессоров, не может быть открыт в этой версии."

::msgcat::mcset pb_msg_russian "MC(msg,file_corruption)"                "Неправильное содержание файла сеанса генератора постпроцессоров."
::msgcat::mcset pb_msg_russian "MC(msg,bad_tcl_file)"                   "Неправильное содержание TCL-файла вашего постпроцессора."
::msgcat::mcset pb_msg_russian "MC(msg,bad_def_file)"                   "Неправильное содержание файла описания вашего постпроцессора."
::msgcat::mcset pb_msg_russian "MC(msg,invalid_post)"                   "Вы должны задать, по крайней мере, один набор, состоящий из файлов TCL и описания для вашего постпроцессора."
::msgcat::mcset pb_msg_russian "MC(msg,invalid_dir)"                    "Папка не существует."
::msgcat::mcset pb_msg_russian "MC(msg,invalid_file)"                   "Файл не существует или не правильный."
::msgcat::mcset pb_msg_russian "MC(msg,invalid_def_file)"               "Невозможно открыть файл описания"
::msgcat::mcset pb_msg_russian "MC(msg,invalid_tcl_file)"               "Невозможно открыть файл обработчика событий"
::msgcat::mcset pb_msg_russian "MC(msg,dir_perm)"                       "У вас нет прав записи в папку:"
::msgcat::mcset pb_msg_russian "MC(msg,file_perm)"                      "У вас нет прав записи в"

::msgcat::mcset pb_msg_russian "MC(msg,file_exist)"                     "уже существует! \nВы точно хотите заменить их?"
::msgcat::mcset pb_msg_russian "MC(msg,file_missing)"                   "Некоторые или все файлы потеряны для этого постпроцессора.\n Вы не можете открыть этот постпроцессор."
::msgcat::mcset pb_msg_russian "MC(msg,sub_dialog_open)"                "Вы должны завершить изменение всех параметров подменю прежде, чем сохранить постпроцессор!"
::msgcat::mcset pb_msg_russian "MC(msg,generic)"                        "Генератор постпроцессоров, в настоящее время поддерживает только Общие фрезерные станки."
::msgcat::mcset pb_msg_russian "MC(msg,min_word)"                       "Кадр должен содержать по крайней мере одно слово."
::msgcat::mcset pb_msg_russian "MC(msg,name_exists)"                    "уже существует!\n Задайте другое имя."
::msgcat::mcset pb_msg_russian "MC(msg,in_use)"                         "Этот компонент используется. \n Он не может быть удален."
::msgcat::mcset pb_msg_russian "MC(msg,do_you_want_to_proceed)"         "Вы можете принять их как существующие элементы данных и продолжить."
::msgcat::mcset pb_msg_russian "MC(msg,not_installed_properly)"         "не был установлен правильно."
::msgcat::mcset pb_msg_russian "MC(msg,no_app_to_open)"                 "Нет открытых приложений"
::msgcat::mcset pb_msg_russian "MC(msg,save_change)"                    "Вы хотите сохранить изменения?"

::msgcat::mcset pb_msg_russian "MC(msg,external_editor)"                "Внешний редактор"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_russian "MC(msg,set_ext_editor)"                 "Вы можете использовать системную переменную EDITOR, чтобы задать ваш текстовый редактор."
::msgcat::mcset pb_msg_russian "MC(msg,filename_with_space)"            "Пробелы в имени файла не поддерживаются!"
::msgcat::mcset pb_msg_russian "MC(msg,filename_protection)"            "Выбранный файл, используемый одним из изменяемых постпроцессоров, не может быть перезаписан!"


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_russian "MC(msg,parent_win)"                     "Временное окно требует своего заданного родительского окна."
::msgcat::mcset pb_msg_russian "MC(msg,close_subwin)"                   "Вы должны закрыть все подокна, чтобы получить доступ к этой закладке."
::msgcat::mcset pb_msg_russian "MC(msg,block_exist)"                    "Элемент выбранного слова существует в шаблоне кадра."
::msgcat::mcset pb_msg_russian "MC(msg,num_gcode_1)"                    "Количество G-кодов - коды ограничены"
::msgcat::mcset pb_msg_russian "MC(msg,num_gcode_2)"                    "в кадре"
::msgcat::mcset pb_msg_russian "MC(msg,num_mcode_1)"                    "Количество M-кодов - коды ограничены"
::msgcat::mcset pb_msg_russian "MC(msg,num_mcode_2)"                    "в кадре"
::msgcat::mcset pb_msg_russian "MC(msg,empty_entry)"                    "Поле ввода не должно быть пустым."

::msgcat::mcset pb_msg_russian "MC(msg,edit_feed_fmt)"                  "Форматы адреса \"F\" могут быть изменены на странице Подачи"

::msgcat::mcset pb_msg_russian "MC(msg,seq_num_max)"                    "Максимальное значение номера кадра не может превышать максимально допустимое значение адреса "

::msgcat::mcset pb_msg_russian "MC(msg,no_cdl_name)"                    "Имя постпроцессора должно быть задано!"
::msgcat::mcset pb_msg_russian "MC(msg,no_def_name)"                    "Необходимо задать папку! \n И шаблон должен выглядеть как \"\$ UGII_ *\"!"
::msgcat::mcset pb_msg_russian "MC(msg,no_own_name)"                    "Необходимо задать папку! \n И шаблон должен выглядеть как \"\$ UGII_ *\"!"
::msgcat::mcset pb_msg_russian "MC(msg,no_oth_ude_name)"                "Должно быть задано другое имя файла CDL! \n И шаблон должен выглядеть как \"\$UGII_ *\"!"
::msgcat::mcset pb_msg_russian "MC(msg,not_oth_cdl_file)"               "Разрешен только файл CDL!"
::msgcat::mcset pb_msg_russian "MC(msg,not_pui_file)"                   "Разрешен только файл PUI!"
::msgcat::mcset pb_msg_russian "MC(msg,not_cdl_file)"                   "Разрешен только файл CDL!"
::msgcat::mcset pb_msg_russian "MC(msg,not_def_file)"                   "Разрешен только файл DEF!"
::msgcat::mcset pb_msg_russian "MC(msg,not_own_cdl_file)"               "Разрешен только собственный файл CDL!"
::msgcat::mcset pb_msg_russian "MC(msg,no_cdl_file)"                    "Выбранный постпроцессор не имеет связанного файла CDL."
::msgcat::mcset pb_msg_russian "MC(msg,cdl_info)"                       "Файлы CDL и описания выбранного постпроцессора будут ссылочными (INCLUDE) в файле описания этого постпроцессора. \n И файл TCL выбранного постпроцессора также будет исходным файлом обработчика событий этого постпроцессора во время выполнения."

::msgcat::mcset pb_msg_russian "MC(msg,add_max1)"                       "Максимальное значение для адреса"
::msgcat::mcset pb_msg_russian "MC(msg,add_max2)"                       "не должен превышать значение заданное его форматом"


::msgcat::mcset pb_msg_russian "MC(com,text_entry_trans,title,Label)"   "Запись"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_russian "MC(nav_button,no_license,Message)"      "У вас нет необходимой лицензии, чтобы выполнить эту функцию!"

::msgcat::mcset pb_msg_russian "MC(nav_button,ok,Label)"                "ОК"
::msgcat::mcset pb_msg_russian "MC(nav_button,ok,Context)"              "Эта кнопка доступна только в подменю. Она позволяет сохранить изменения и закрыть меню."
::msgcat::mcset pb_msg_russian "MC(nav_button,cancel,Label)"            "Отмена"
::msgcat::mcset pb_msg_russian "MC(nav_button,cancel,Context)"          "Эта кнопка доступна в подменю. Она позволяет закрыть меню."
::msgcat::mcset pb_msg_russian "MC(nav_button,default,Label)"           "По умолчанию"
::msgcat::mcset pb_msg_russian "MC(nav_button,default,Context)"         "Эта кнопка позволяет восстановить параметры меню существующего компонента до значений, когда постпроцессор был создан или открыт в данной сессии. \n \nОднако, имя компонента в запросе будет восстановлено только в его исходное состояние до того, как вы вошли в меню изменения этого компонента."
::msgcat::mcset pb_msg_russian "MC(nav_button,restore,Label)"           "Восстановить"
::msgcat::mcset pb_msg_russian "MC(nav_button,restore,Context)"         "Эта кнопка позволяет восстановить параметры в существующем меню в начальные установки вашего сеанса изменения этого компонента."
::msgcat::mcset pb_msg_russian "MC(nav_button,apply,Label)"             "Применить"
::msgcat::mcset pb_msg_russian "MC(nav_button,apply,Context)"           "Эта кнопка позволяет сохранить изменения, не выходя из меню. Она также восстановит начальные значения текущего меню. \n \n(Смотрите \"Восстановить при необходимости начальные значения\")"
::msgcat::mcset pb_msg_russian "MC(nav_button,filter,Label)"            "Фильтр"
::msgcat::mcset pb_msg_russian "MC(nav_button,filter,Context)"          "Эта кнопка применяет фильтр папки и выводит список файлов, которые удовлетворяют заданному фильтру."
::msgcat::mcset pb_msg_russian "MC(nav_button,yes,Label)"               "Да"
::msgcat::mcset pb_msg_russian "MC(nav_button,yes,Context)"             "Да"
::msgcat::mcset pb_msg_russian "MC(nav_button,no,Label)"                "Нет"
::msgcat::mcset pb_msg_russian "MC(nav_button,no,Context)"              "Нет"
::msgcat::mcset pb_msg_russian "MC(nav_button,help,Label)"              "Справка"
::msgcat::mcset pb_msg_russian "MC(nav_button,help,Context)"            "Справка"

::msgcat::mcset pb_msg_russian "MC(nav_button,open,Label)"              "Открыть"
::msgcat::mcset pb_msg_russian "MC(nav_button,open,Context)"            "Эта кнопка позволяет открыть выбранный постпроцессор для изменения."

::msgcat::mcset pb_msg_russian "MC(nav_button,save,Label)"              "Сохранить"
::msgcat::mcset pb_msg_russian "MC(nav_button,save,Context)"            "Эта кнопка доступна в меню \"Сохранить как\", которое позволяет сохранить постпроцессор под другим именем."

::msgcat::mcset pb_msg_russian "MC(nav_button,manage,Label)"            "Управление ..."
::msgcat::mcset pb_msg_russian "MC(nav_button,manage,Context)"          "Эта кнопка позволяет управлять историей последних открытых постпроцессоров."

::msgcat::mcset pb_msg_russian "MC(nav_button,refresh,Label)"           "Обновить"
::msgcat::mcset pb_msg_russian "MC(nav_button,refresh,Context)"         "Эта кнопка обновляет список соответственно существующим объектам."

::msgcat::mcset pb_msg_russian "MC(nav_button,cut,Label)"               "Вырезать"
::msgcat::mcset pb_msg_russian "MC(nav_button,cut,Context)"             "Эта кнопка вырезает объект, выбранный в списке."

::msgcat::mcset pb_msg_russian "MC(nav_button,copy,Label)"              "Копировать"
::msgcat::mcset pb_msg_russian "MC(nav_button,copy,Context)"            "Эта кнопка копирует выбранный объект."

::msgcat::mcset pb_msg_russian "MC(nav_button,paste,Label)"             "Вставить"
::msgcat::mcset pb_msg_russian "MC(nav_button,paste,Context)"           "Эта кнопка вставляет объект из буфера назад в список."

::msgcat::mcset pb_msg_russian "MC(nav_button,edit,Label)"              "Изменить"
::msgcat::mcset pb_msg_russian "MC(nav_button,edit,Context)"            "Эта кнопка изменяет объект в буфере!"

::msgcat::mcset pb_msg_russian "MC(nav_button,ex_editor,Label)"         "Использовать внешний редактор"

##------------
## New dialog
##
::msgcat::mcset pb_msg_russian "MC(new,title,Label)"                    "Создать новый постпроцессор"
::msgcat::mcset pb_msg_russian "MC(new,Status)"                         "Введите имя & выберите параметры для нового постпроцессора."

::msgcat::mcset pb_msg_russian "MC(new,name,Label)"                     "Имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(new,name,Context)"                   "Имя постпроцессора, который будет создан"

::msgcat::mcset pb_msg_russian "MC(new,desc,Label)"                     "Описание"
::msgcat::mcset pb_msg_russian "MC(new,desc,Context)"                   "Описание постпроцессора, который будет создан"

#Description for each selection
::msgcat::mcset pb_msg_russian "MC(new,mill,desc,Label)"                "Это фрезерный станок."
::msgcat::mcset pb_msg_russian "MC(new,lathe,desc,Label)"               "Это токарный станок."
::msgcat::mcset pb_msg_russian "MC(new,wedm,desc,Label)"                "Это проволочный ЭЭ станок."

::msgcat::mcset pb_msg_russian "MC(new,wedm_2,desc,Label)"              "Это 2-осевой проволочный ЭЭ станок."
::msgcat::mcset pb_msg_russian "MC(new,wedm_4,desc,Label)"              "Это 4-осевой проволочный ЭЭ станок."
::msgcat::mcset pb_msg_russian "MC(new,lathe_2,desc,Label)"             "Это горизонтальный 2-осевой токарный станок."
::msgcat::mcset pb_msg_russian "MC(new,lathe_4,desc,Label)"             "Это 4-осевой зависимый токарный станок."
::msgcat::mcset pb_msg_russian "MC(new,mill_3,desc,Label)"              "Это 3-осевой фрезерный станок."
::msgcat::mcset pb_msg_russian "MC(new,mill_3MT,desc,Label)"            "3-осевой токарно-фрезерный (XZC)"
::msgcat::mcset pb_msg_russian "MC(new,mill_4H,desc,Label)"             "Это 4-осевой фрезерный станок с\n поворотной головкой."
::msgcat::mcset pb_msg_russian "MC(new,mill_4T,desc,Label)"             "Это 4-осевой фрезерный станок с\n поворотным столом."
::msgcat::mcset pb_msg_russian "MC(new,mill_5TT,desc,Label)"            "Это 5-осевой фрезерный станок с\n двумя поворотными осями на столе."
::msgcat::mcset pb_msg_russian "MC(new,mill_5HH,desc,Label)"            "Это 5-осевой фрезерный станок с\n двумя поворотными осями на головке."
::msgcat::mcset pb_msg_russian "MC(new,mill_5HT,desc,Label)"            "Это 5-осевой фрезерный станок с\n поворотной головкой и столом."
::msgcat::mcset pb_msg_russian "MC(new,punch,desc,Label)"               "Это пробивной штамп."

::msgcat::mcset pb_msg_russian "MC(new,post_unit,Label)"                "Единицы вывода постпроцессора"

::msgcat::mcset pb_msg_russian "MC(new,inch,Label)"                     "Дюймы"
::msgcat::mcset pb_msg_russian "MC(new,inch,Context)"                   "Единицы вывода постпроцессора - дюймы"
::msgcat::mcset pb_msg_russian "MC(new,millimeter,Label)"               "Миллиметры"
::msgcat::mcset pb_msg_russian "MC(new,millimeter,Context)"             "Единицы вывода постпроцессора - миллиметры"

::msgcat::mcset pb_msg_russian "MC(new,machine,Label)"                  "Станок"
::msgcat::mcset pb_msg_russian "MC(new,machine,Context)"                "Тип станка, для которого создается данный постпроцессор."

::msgcat::mcset pb_msg_russian "MC(new,mill,Label)"                     "Фрез."
::msgcat::mcset pb_msg_russian "MC(new,mill,Context)"                   "Фрезерный станок"
::msgcat::mcset pb_msg_russian "MC(new,lathe,Label)"                    "Токарный"
::msgcat::mcset pb_msg_russian "MC(new,lathe,Context)"                  "Токарный станок"
::msgcat::mcset pb_msg_russian "MC(new,wire,Label)"                     "Проволочная ЭЭО"
::msgcat::mcset pb_msg_russian "MC(new,wire,Context)"                   "Проволочный ЭЭ станок"
::msgcat::mcset pb_msg_russian "MC(new,punch,Label)"                    "Штамповка"

::msgcat::mcset pb_msg_russian "MC(new,axis,Label)"                     "Выбор осей станка"
::msgcat::mcset pb_msg_russian "MC(new,axis,Context)"                   "Количество и тип осей станка"

#Axis Number
::msgcat::mcset pb_msg_russian "MC(new,axis_2,Label)"                   "2-осевой"
::msgcat::mcset pb_msg_russian "MC(new,axis_3,Label)"                   "3-осевой"
::msgcat::mcset pb_msg_russian "MC(new,axis_4,Label)"                   "4-осевой"
::msgcat::mcset pb_msg_russian "MC(new,axis_5,Label)"                   "5-осевой"
::msgcat::mcset pb_msg_russian "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_russian "MC(new,mach_axis,Label)"                "Оси станка"
::msgcat::mcset pb_msg_russian "MC(new,mach_axis,Context)"              "Выберите оси станка"
::msgcat::mcset pb_msg_russian "MC(new,lathe_2,Label)"                  "2-осевой"
::msgcat::mcset pb_msg_russian "MC(new,mill_3,Label)"                   "3-осевой"
::msgcat::mcset pb_msg_russian "MC(new,mill_3MT,Label)"                 "3-осевой токарно-фрезерный (XZC)"
::msgcat::mcset pb_msg_russian "MC(new,mill_4T,Label)"                  "4-осевой с поворотным столом"
::msgcat::mcset pb_msg_russian "MC(new,mill_4H,Label)"                  "4-осевой с поворотной головкой"
::msgcat::mcset pb_msg_russian "MC(new,lathe_4,Label)"                  "4-осевой"
::msgcat::mcset pb_msg_russian "MC(new,mill_5HH,Label)"                 "5-осевой с двумя поворотными осями на головке"
::msgcat::mcset pb_msg_russian "MC(new,mill_5TT,Label)"                 "5-осевой с двумя поворотными осями на столе"
::msgcat::mcset pb_msg_russian "MC(new,mill_5HT,Label)"                 "5-осевой с поворотной головкой и столом"
::msgcat::mcset pb_msg_russian "MC(new,wedm_2,Label)"                   "2-осевой"
::msgcat::mcset pb_msg_russian "MC(new,wedm_4,Label)"                   "4-осевой"
::msgcat::mcset pb_msg_russian "MC(new,punch,Label)"                    "Штамповка"

::msgcat::mcset pb_msg_russian "MC(new,control,Label)"                  "Система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(new,control,Context)"                "Выберите систему ЧПУ для постпроцессора"

#Controller Type
::msgcat::mcset pb_msg_russian "MC(new,generic,Label)"                  "Базовый"
::msgcat::mcset pb_msg_russian "MC(new,library,Label)"                  "Библиотека"
::msgcat::mcset pb_msg_russian "MC(new,user,Label)"                     "Пользовательский"
::msgcat::mcset pb_msg_russian "MC(new,user,browse,Label)"              "Обзор"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_russian "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_russian "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_russian "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_russian "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_russian "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_russian "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_russian "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_russian "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_russian "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_russian "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_russian "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_russian "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_russian "MC(open,title,Label)"                   "Изменить постпроцессор"
::msgcat::mcset pb_msg_russian "MC(open,Status)"                        "Выберите файл PUI для открытия"
::msgcat::mcset pb_msg_russian "MC(open,file_type_pui)"                 "Файлы сессии генератора постпроцессоров"
::msgcat::mcset pb_msg_russian "MC(open,file_type_tcl)"                 "Файлы Tcl-скриптов"
::msgcat::mcset pb_msg_russian "MC(open,file_type_def)"                 "Файлы описания"
::msgcat::mcset pb_msg_russian "MC(open,file_type_cdl)"                 "Файлы CDL"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_russian "MC(open_save,dlg,title,Label)"          "Выбрать файл"
::msgcat::mcset pb_msg_russian "MC(exp_cc,dlg,title,Label)"             "Экспорт команд пользователя"
::msgcat::mcset pb_msg_russian "MC(show_mt,title,Label)"                "Станок"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_russian "MC(mvb,title,Label)"                    "Просмотр MOM переменных"
::msgcat::mcset pb_msg_russian "MC(mvb,cat,Label)"                      "Категория"
::msgcat::mcset pb_msg_russian "MC(mvb,search,Label)"                   "Поиск"
::msgcat::mcset pb_msg_russian "MC(mvb,defv,Label)"                     "Значение по умолчанию"
::msgcat::mcset pb_msg_russian "MC(mvb,posv,Label)"                     "Допустимые значения"
::msgcat::mcset pb_msg_russian "MC(mvb,data,Label)"                     "Тип данных"
::msgcat::mcset pb_msg_russian "MC(mvb,desc,Label)"                     "Описание"

::msgcat::mcset pb_msg_russian "MC(inposts,title,Label)"                "Изменить template_post.dat"
::msgcat::mcset pb_msg_russian "MC(tpdf,text,Label)"                    "Файл данных шаблона постпроцессора"
::msgcat::mcset pb_msg_russian "MC(inposts,edit,title,Label)"           "Изменить строку"
::msgcat::mcset pb_msg_russian "MC(inposts,edit,post,Label)"            "Постпроцессор"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_russian "MC(save_as,title,Label)"                "Сохранить как"
::msgcat::mcset pb_msg_russian "MC(save_as,name,Label)"                 "Имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(save_as,name,Context)"               "Имя, под которым будет сохранен постпроцессор."
::msgcat::mcset pb_msg_russian "MC(save_as,Status)"                     "Введите имя файла нового постпроцессора."
::msgcat::mcset pb_msg_russian "MC(save_as,file_type_pui)"              "Файлы сессии генератора постпроцессоров"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_russian "MC(common,entry,Label)"                 "Запись"
::msgcat::mcset pb_msg_russian "MC(common,entry,Context)"               "Вы можете задать новое значение в поле ввода."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_russian "MC(nbook,tab,Label)"                    "Закладка журнала"
::msgcat::mcset pb_msg_russian "MC(nbook,tab,Context)"                  "Вы можете выбрать закладку, чтобы перейди на необходимую страницу параметров. \n \nПараметры на закладке могут быть разделены на группы. К каждой группе параметров можно получить доступ через другую закладку."

##------
## Tree
##
::msgcat::mcset pb_msg_russian "MC(tree,select,Label)"                  "Дерево компонент"
::msgcat::mcset pb_msg_russian "MC(tree,select,Context)"                "Вы можете выбрать компонент для просмотра или изменения его содержания или параметров."
::msgcat::mcset pb_msg_russian "MC(tree,create,Label)"                  "Создать"
::msgcat::mcset pb_msg_russian "MC(tree,create,Context)"                "Создать новый компонент, копированием выбранной записи."
::msgcat::mcset pb_msg_russian "MC(tree,cut,Label)"                     "Вырезать"
::msgcat::mcset pb_msg_russian "MC(tree,cut,Context)"                   "Вырезать компонент"
::msgcat::mcset pb_msg_russian "MC(tree,paste,Label)"                   "Вставить"
::msgcat::mcset pb_msg_russian "MC(tree,paste,Context)"                 "Вставить компонент."
::msgcat::mcset pb_msg_russian "MC(tree,rename,Label)"                  "Переименовать"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_russian "MC(encrypt,browser,Label)"              "Список лицензий"
::msgcat::mcset pb_msg_russian "MC(encrypt,title,Label)"                "Выбрать лицензию"
::msgcat::mcset pb_msg_russian "MC(encrypt,output,Label)"               "Зашифровать вывод"
::msgcat::mcset pb_msg_russian "MC(encrypt,license,Label)"              "Лицензия:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_russian "MC(machine,tab,Label)"                  "Станок"
::msgcat::mcset pb_msg_russian "MC(machine,Status)"                     "Задайте параметры кинематики станка."

::msgcat::mcset pb_msg_russian "MC(msg,no_display)"                     "Отображение для этой конфигурации станка не доступно."
::msgcat::mcset pb_msg_russian "MC(msg,no_4th_ctable)"                  "Стол с 4-й осью C не позволяется."
::msgcat::mcset pb_msg_russian "MC(msg,no_4th_max_min)"                 "Максимальный предел 4-й оси не может быть равен минимальному пределу!"
::msgcat::mcset pb_msg_russian "MC(msg,no_4th_both_neg)"                "Оба предела 4-й оси не могут быть отрицательными!"
::msgcat::mcset pb_msg_russian "MC(msg,no_4th_5th_plane)"               "Плоскость вращения 4-ой оси не может совпадать с плоскостью вращения 5-ой оси."
::msgcat::mcset pb_msg_russian "MC(msg,no_4thT_5thH)"                   "Конфигурация с 4-й осью на столе и 5-й - на головке не допустима."
::msgcat::mcset pb_msg_russian "MC(msg,no_5th_max_min)"                 "Максимальный предел 5-й оси не может быть равен минимальному пределу!"
::msgcat::mcset pb_msg_russian "MC(msg,no_5th_both_neg)"                "Оба предела 5-й оси не могут быть отрицательными!"

##---------
# Post Info
##
::msgcat::mcset pb_msg_russian "MC(machine,info,title,Label)"           "Информация о постпроцессоре"
::msgcat::mcset pb_msg_russian "MC(machine,info,desc,Label)"            "Описание"
::msgcat::mcset pb_msg_russian "MC(machine,info,type,Label)"            "Тип станка"
::msgcat::mcset pb_msg_russian "MC(machine,info,kinematics,Label)"      "Кинематика"
::msgcat::mcset pb_msg_russian "MC(machine,info,unit,Label)"            "Ед.вывода"
::msgcat::mcset pb_msg_russian "MC(machine,info,controller,Label)"      "Система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(machine,info,history,Label)"         "История"

##---------
## Display
##
::msgcat::mcset pb_msg_russian "MC(machine,display,Label)"              "Показать станок"
::msgcat::mcset pb_msg_russian "MC(machine,display,Context)"            "Эта опция выводит на экран станок в отдельном окне"
::msgcat::mcset pb_msg_russian "MC(machine,display_trans,title,Label)"  "Станок"


##---------------
## General parms
##
::msgcat::mcset pb_msg_russian "MC(machine,gen,Label)"                      "Общие параметры"
    
::msgcat::mcset pb_msg_russian "MC(machine,gen,out_unit,Label)"             "Единицы вывода постпроцессора:"
::msgcat::mcset pb_msg_russian "MC(machine,gen,out_unit,Context)"           "Единицы вывода постпроцессора"
::msgcat::mcset pb_msg_russian "MC(machine,gen,out_unit,inch,Label)"        "Дюйм." 
::msgcat::mcset pb_msg_russian "MC(machine,gen,out_unit,metric,Label)"      "Метрический"

::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,Label)"         "Пределы перемещения линейных осей"
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,Context)"       "Пределы перемещения линейных осей"
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,x,Context)"     "Задайте пределы перемещения станка вдоль оси X."
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,y,Context)"     "Задайте пределы перемещения станка вдоль оси Y."
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_russian "MC(machine,gen,travel_limit,z,Context)"     "Задайте пределы перемещения станка вдоль оси Z."

::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,Label)"             "Исходное положение"
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,Context)"           "Исходное положение"
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,x,Context)"         "Исходное положение оси X станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,y,Context)"         "Исходное положение оси Y станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_russian "MC(machine,gen,home_pos,z,Context)"         "Исходное положение оси Z станка, относительно позиции физического нулевого положения оси. Станок возвращается в это положение для автоматической смены инструмента."

::msgcat::mcset pb_msg_russian "MC(machine,gen,step_size,Label)"            "Дискретность линейного перемещения"
::msgcat::mcset pb_msg_russian "MC(machine,gen,step_size,min,Label)"        "Минимум"
::msgcat::mcset pb_msg_russian "MC(machine,gen,step_size,min,Context)"      "Минимальная дискретность"

::msgcat::mcset pb_msg_russian "MC(machine,gen,traverse_feed,Label)"        "Подача перехода"
::msgcat::mcset pb_msg_russian "MC(machine,gen,traverse_feed,max,Label)"    "Максимум"
::msgcat::mcset pb_msg_russian "MC(machine,gen,traverse_feed,max,Context)"  "Максимальная подача"

::msgcat::mcset pb_msg_russian "MC(machine,gen,circle_record,Label)"        "Вывод круговой интерполяции"
::msgcat::mcset pb_msg_russian "MC(machine,gen,circle_record,yes,Label)"    "Да"
::msgcat::mcset pb_msg_russian "MC(machine,gen,circle_record,yes,Context)"  "Вывод круговой интерполяции."
::msgcat::mcset pb_msg_russian "MC(machine,gen,circle_record,no,Label)"     "Нет"
::msgcat::mcset pb_msg_russian "MC(machine,gen,circle_record,no,Context)"   "Вывод линейной интерполяции."

::msgcat::mcset pb_msg_russian "MC(machine,gen,config_4and5_axis,oth,Label)"    "Другой"

# Wire EDM parameters
::msgcat::mcset pb_msg_russian "MC(machine,gen,wedm,wire_tilt)"             "Управление наклоном проволоки"
::msgcat::mcset pb_msg_russian "MC(machine,gen,wedm,angle)"                 "Углы"
::msgcat::mcset pb_msg_russian "MC(machine,gen,wedm,coord)"                 "Координаты"

# Lathe parameters
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,Label)"               "Револьверная головка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,Context)"             "Револьверная головка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,conf,Label)"          "Конфигурировать"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,conf,Context)"        "Когда выбрано две револьверных головки, эта опция позволяет сконфигурировать параметры."
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,one,Label)"           "Одна револьверная головка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,one,Context)"         "Токарный станок с одной револьверной головкой"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,two,Label)"           "Две револьверных головки"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,two,Context)"         "Токарный станок с 2 револьверными головками"

::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,conf_trans,Label)"    "Конфигурация револьверной головки"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,prim,Label)"          "Первичная револьверная головка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,prim,Context)"        "Выберите назначение первичной револьверной головки."
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,sec,Label)"           "Вторичная револьверная головка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,sec,Context)"         "Выберите назначение вторичной револьверной головки."
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,designation,Label)"   "Обозначение"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,xoff,Label)"          "Смещение X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,xoff,Context)"        "Задайте смещение по X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,zoff,Label)"          "Смещение Z"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,zoff,Context)"        "Задайте смещение по Z"

::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,front,Label)"         "FRONT"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,rear,Label)"          "REAR"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,right,Label)"         "RIGHT"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,left,Label)"          "LEFT"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,side,Label)"          "SIDE"
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret,saddle,Label)"        "SADDLE"

::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,Label)"           "Множители оси"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,dia,Label)"       "Программирование диаметра"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,dia,Context)"     "Эти опции позволяют программировать диаметр, удваивая значения выбранного адреса в программе ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2x,Context)"      "Этот переключатель позволяет разрешить программирование диаметра, удваивая координаты оси X в кодах программы ЧПУ."

::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2y,Context)"      "Этот переключатель позволяет разрешить программирование диаметра, удваивая координаты оси Y в кодах программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2i,Context)"      "Этот переключатель позволяет удвоить значения слова I при выводе дуг окружностей, когда используется программирование диаметра."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,2j,Context)"      "Этот переключатель позволяет удвоить значения слова J при выводе дуг окружностей, когда используется программирование диаметра."

::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,mir,Label)"       "Зеркальный вывод"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,mir,Context)"     "Эти опции позволяют зеркально отразить выбранный адрес, делая их значения отрицательными в программе ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,x,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты X при выводе в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,y,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты Y при выводе в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,z,Context)"       "Этот переключатель позволяет сделать отрицательным значения координаты Z при выводе в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,i,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова I при выводе записей круговой интерполяции в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,j,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова J при выводе записей круговой интерполяции в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_russian "MC(machine,gen,axis_multi,k,Context)"       "Этот переключатель позволяет сделать отрицательным значения слова K при выводе записей круговой интерполяции в программу ЧПУ."

::msgcat::mcset pb_msg_russian "MC(machine,gen,output,Label)"               "Метод вывода"
::msgcat::mcset pb_msg_russian "MC(machine,gen,output,Context)"             "Метод вывода"
::msgcat::mcset pb_msg_russian "MC(machine,gen,output,tool_tip,Label)"      "Вершина инструмента"
::msgcat::mcset pb_msg_russian "MC(machine,gen,output,tool_tip,Context)"    "Вывод относительно вершины инструмента"
::msgcat::mcset pb_msg_russian "MC(machine,gen,output,turret_ref,Label)"    "Ссылочная точка револьверной головки"
::msgcat::mcset pb_msg_russian "MC(machine,gen,output,turret_ref,Context)"  "Вывод относительно ссылочной точки револьвера"

::msgcat::mcset pb_msg_russian "MC(machine,gen,lathe_turret,msg)"           "Первичная револьверная головка не может совпадать с вторичной револьверной головкой."
::msgcat::mcset pb_msg_russian "MC(machine,gen,turret_chg,msg)"             "Изменение этой опции может потребовать прибавления или удаления кадра G92 в событии \"Смена инструмента\"."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_russian "MC(machine,gen,spindle_axis,Label)"             "Начальная ориентация оси шпинделя"
::msgcat::mcset pb_msg_russian "MC(machine,gen,spindle_axis,Context)"           "Начальная ориентация оси шпинделя для фрезерного станка, может быть задана или как параллельна оси Z или как перпендикулярна к оси Z. Ось инструмента в операции должна быть совместимой с заданной ориентацией оси шпинделя. Произойдет ошибка, если постпроцессор не может позиционировать инструмент по оси шпинделя.\nЭтот вектор может быть перезадан осью шпинделя, заданной в объекте \"Головка\"."

::msgcat::mcset pb_msg_russian "MC(machine,gen,position_in_yaxis,Label)"        "Положение по оси Y"
::msgcat::mcset pb_msg_russian "MC(machine,gen,position_in_yaxis,Context)"      "У станка есть программируемая ось Y, которая может позиционироваться в процессе обработки. Эта опция применима только когда ось шпинделя не параллельна оси Z."

::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,Label)"                "Режим станка"
::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,Context)"              "Режим станка может быть или XZC-фрезерный или простой токарно-фрезерный."

::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Фрезерный XZC"
::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,xzc_mill,Context)"     "У станка в режиме XZC стол, или плоскость патрона работают как поворотная ось C. Все координатные перемещения будут преобразованы в координаты X и C, где X является значением радиуса и C - угол."

::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,mill_turn,Label)"      "Простой токарно-фрезерный"
::msgcat::mcset pb_msg_russian "MC(machine,gen,mach_mode,mill_turn,Context)"    "Этот XZC фрезерный постпроцессор будет связан с токарным постпроцессором, чтобы генерировать программу, которая содержит и фрезерные и токарные операции. Тип операции определяет, какой постпроцессор использовать для вывода программы ЧПУ."

::msgcat::mcset pb_msg_russian "MC(machine,gen,mill_turn,lathe_post,Label)"     "Токарный постпроцессор"
::msgcat::mcset pb_msg_russian "MC(machine,gen,mill_turn,lathe_post,Context)"   "Постпроцессор для токарного станка требуется для простого токарно-фрезерного постпроцессора для вывода токарных операций в программу."

::msgcat::mcset pb_msg_russian "MC(machine,gen,lathe_post,select_name,Label)"   "Выбрать имя"
::msgcat::mcset pb_msg_russian "MC(machine,gen,lathe_post,select_name,Context)" "Выберите имя токарного постпроцессора для использования в простом токарно-фрезерном постпроцессоре.  Возможно, что этот постпроцессор будет найден в папке \\\$UGII_CAM_POST_DIR, где выполняется NX/Постпроцессор, иначе будет использоваться постпроцессор с тем же именем в папке, где находится фрезерный постпроцессор."

::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,Label)"               "Режим вывода координат по умолчанию"
::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,Context)"             "Эти опции задают начальную настройку для режима вывода координат, которые могут быть полярными (XZC) или декартовыми (XYZ). Этот режим может быть изменен командой задаваемой пользователем \\\"SET/POLAR,ON\\\", которая задается в операциях."

::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,polar,Label)"         "Полярный"
::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,polar,Context)"       "Вывод координат в XZC."

::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,cart,Label)"          "Декартовы"
::msgcat::mcset pb_msg_russian "MC(machine,gen,coord_mode,cart,Context)"        "Вывод координат в XYZ."

::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,Label)"             "Режим круговой интерполяции"
::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,Context)"           "Эти опции задают вывод записей круговых перемещений, в полярном (XCR) или декартовом (XYIJ) режимах."

::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Полярный"
::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Круговая интерполяция в кодах XCR."

::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Декартовы"
::msgcat::mcset pb_msg_russian "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Круговая интерполяция в кодах XYIJ."

::msgcat::mcset pb_msg_russian "MC(machine,gen,def_spindle_axis,Label)"         "Начальная ориентация оси шпинделя"
::msgcat::mcset pb_msg_russian "MC(machine,gen,def_spindle_axis,Context)"       "Начальная ориентация оси шпинделя может быть перезадана осью шпинделя, заданной в объекте \"Головка\".\nВектор не должен быть унифицирован."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_russian "MC(machine,axis,fourth,Label)"              "4-я ось"

::msgcat::mcset pb_msg_russian "MC(machine,axis,radius_output,Label)"       "Вывод радиуса"
::msgcat::mcset pb_msg_russian "MC(machine,axis,radius_output,Context)"     "Когда ось инструмента направлена вдоль оси Z (0,0,1), у постпроцессора есть выбор выведения радиуса (X) в полярных координатах, чтобы быть \\\"Всегда положительным\\\", \\\"Всегда отрицательным\\\" или \\\"Кратчайшее расстояние\\\"."

::msgcat::mcset pb_msg_russian "MC(machine,axis,type_head,Label)"           "Головка"
::msgcat::mcset pb_msg_russian "MC(machine,axis,type_table,Label)"          "Стол"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_russian "MC(machine,axis,fifth,Label)"               "Пятая ось"

::msgcat::mcset pb_msg_russian "MC(machine,axis,rotary,Label)"              "Оси вращения"

::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,Label)"              "Расстояние от нуля станка до центра поворота оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,4,Label)"            "Расстояние от нуля станка до центра 4-й оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,5,Label)"            "Расстояние от центра 4-й оси до центра 5-й оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,x,Label)"            "Смещение X"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,x,Context)"          "Задайте смещение поворотной оси по оси X"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,y,Label)"            "Смещение У"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,y,Context)"          "Задайте смещение поворотной оси по оси Y"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,z,Label)"            "Смещение Z"
::msgcat::mcset pb_msg_russian "MC(machine,axis,offset,z,Context)"          "Задайте смещение поворотной оси по оси Z"

::msgcat::mcset pb_msg_russian "MC(machine,axis,rotation,Label)"            "Вращение оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotation,norm,Label)"       "Нормаль"
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotation,norm,Context)"     "Установить направление вращения оси по нормали."
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotation,rev,Label)"        "Обратный"
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotation,rev,Context)"      "Установить обратное направление вращения оси."

::msgcat::mcset pb_msg_russian "MC(machine,axis,direction,Label)"           "Направление оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,direction,Context)"         "Выберите направление оси."

::msgcat::mcset pb_msg_russian "MC(machine,axis,con_motion,Label)"              "Последовательные перемещения вращения"
::msgcat::mcset pb_msg_russian "MC(machine,axis,con_motion,combine,Label)"      "Комбинированный"
::msgcat::mcset pb_msg_russian "MC(machine,axis,con_motion,combine,Context)"    "Этот переключатель позволяет включить/выключить линеаризацию. Так же он включает/выключает опцию использования допуска."
::msgcat::mcset pb_msg_russian "MC(machine,axis,con_motion,tol,Label)"      "Допуск"
::msgcat::mcset pb_msg_russian "MC(machine,axis,con_motion,tol,Context)"    "Эта опция активна только, когда активен переключатель \"Комбинированный\". Задайте допуск."

::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,Label)"           "Обработка превышения предела оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,warn,Label)"      "Предупреждение"
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,warn,Context)"    "Вывод предупреждений при превышении предела перемещения осей"
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,ret,Label)"       "Отвод / Повторное врезание"
::msgcat::mcset pb_msg_russian "MC(machine,axis,violation,ret,Context)"     "Отвод/Повторное врезание при превышении предела оси. \n \nВ команде пользователя PB_CMD_init_rotaty, следующие параметры должны быть настроены для активации этих перемещений: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_russian "MC(machine,axis,limits,Label)"              "Предел оси (градусы)"
::msgcat::mcset pb_msg_russian "MC(machine,axis,limits,min,Label)"          "Минимум"
::msgcat::mcset pb_msg_russian "MC(machine,axis,limits,min,Context)"        "Задайте минимальный предел поворотной оси (градусы)."
::msgcat::mcset pb_msg_russian "MC(machine,axis,limits,max,Label)"          "Максимум"
::msgcat::mcset pb_msg_russian "MC(machine,axis,limits,max,Context)"        "Задайте максимальный предел поворотной оси (градусы)."

::msgcat::mcset pb_msg_russian "MC(machine,axis,incr_text)"                 "Эта поворотная ось может программироваться в приращениях"

::msgcat::mcset pb_msg_russian "MC(machine,axis,rotary_res,Label)"          "Дискретность поворотных перемещений (градусы)"
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotary_res,Context)"        "Задайте дискретность поворотных перемещений (градусы)"

::msgcat::mcset pb_msg_russian "MC(machine,axis,ang_offset,Label)"          "Угловое смещение (градусы)"
::msgcat::mcset pb_msg_russian "MC(machine,axis,ang_offset,Context)"        "Задайте угловое смещение оси (градусы)"

::msgcat::mcset pb_msg_russian "MC(machine,axis,pivot,Label)"               "Расстояние до точки вращения"
::msgcat::mcset pb_msg_russian "MC(machine,axis,pivot,Context)"             "Задайте расстояние до точки поворота."

::msgcat::mcset pb_msg_russian "MC(machine,axis,max_feed,Label)"            "Мак. подача (градус/мин)"
::msgcat::mcset pb_msg_russian "MC(machine,axis,max_feed,Context)"          "Задайте максимальную скорость подачи (градус/мин)."

::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,Label)"               "Плоскость вращения"
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,Context)"             "Выберите XY, YZ, ZX или \"Другая как плоскость поворота\". Опция \\\"\"Другая\"\\\" позволяет задать вектор направления оси."

::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,normal,Label)"        "Вектор нормали плоскости"
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,normal,Context)"      "Задайте вектор нормали к плоскости как ось поворота. \nВектор не должен быть унифицирован."
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,4th,Label)"           "Нормаль плоскости 4-ой оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,4th,Context)"         "Задайте вектор нормали к плоскости вращения 4-й оси."
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,5th,Label)"           "Нормаль плоскости 5-ой оси"
::msgcat::mcset pb_msg_russian "MC(machine,axis,plane,5th,Context)"         "Задайте вектор нормали к плоскости вращения 5-й оси."

::msgcat::mcset pb_msg_russian "MC(machine,axis,leader,Label)"              "Адрес слова"
::msgcat::mcset pb_msg_russian "MC(machine,axis,leader,Context)"            "Задайте адрес слова"

::msgcat::mcset pb_msg_russian "MC(machine,axis,config,Label)"              "Конфигурировать"
::msgcat::mcset pb_msg_russian "MC(machine,axis,config,Context)"            "Эта опция позволяет задать параметры 4-ой и 5-ой осей."

::msgcat::mcset pb_msg_russian "MC(machine,axis,r_axis_conf_trans,Label)"   "Конфигурация поворотных осей"
::msgcat::mcset pb_msg_russian "MC(machine,axis,4th_axis,Label)"            "4-я ось"
::msgcat::mcset pb_msg_russian "MC(machine,axis,5th_axis,Label)"            "5-я ось"
::msgcat::mcset pb_msg_russian "MC(machine,axis,head,Label)"                " Головка "
::msgcat::mcset pb_msg_russian "MC(machine,axis,table,Label)"               " Стол "

::msgcat::mcset pb_msg_russian "MC(machine,axis,rotary_lintol,Label)"       "Допуск на линеаризацию по умолчанию"
::msgcat::mcset pb_msg_russian "MC(machine,axis,rotary_lintol,Context)"     "Это значение будет использоваться как значения допуска по умолчанию, для линеаризации поворотных перемещений, когда постпроцессорная команда LINTOL/ON будет задана в текущей или в предыдущей операции. Команда LINTOL/ может также задать различный допуск на линеаризацию."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_russian "MC(progtpth,tab,Label)"                 "Программа и траектория инструмента"

##---------
## Program
##
::msgcat::mcset pb_msg_russian "MC(prog,tab,Label)"                     "Программа"
::msgcat::mcset pb_msg_russian "MC(prog,Status)"                        "Задать вывод событий"

::msgcat::mcset pb_msg_russian "MC(prog,tree,Label)"                    "Программа -- дерево последовательности"
::msgcat::mcset pb_msg_russian "MC(prog,tree,Context)"                  "Программа ЧПУ разделена на пять сегментов: четыре (4) последовательности и тело траектории инструмента: \n \n * Последовательность в начале программы \n * Последовательность в начале операции\n * Траектория инструмента \n * Последовательность в конце операции \n * Последовательность в конце программы \n \nКаждая последовательность состоит из нескольких маркеров. Маркер указывает на событие, которое может программироваться и может произойти на определенной стадии программы ЧПУ. Вы можете присоединить каждый маркер в нужную позицию кодов программы ЧПУ, которые будут выведены, когда программа обрабатывается постпроцессором. \n \nТраектория инструмента создается из множества событий. Они разделены на три (3) группы: \n \n * Управление станком \n * Перемещения \n * Циклы \n"

::msgcat::mcset pb_msg_russian "MC(prog,tree,prog_strt,Label)"          "Последовательность в начале программы"
::msgcat::mcset pb_msg_russian "MC(prog,tree,prog_end,Label)"           "Последовательность в конце программы"
::msgcat::mcset pb_msg_russian "MC(prog,tree,oper_strt,Label)"          "Последовательность в начале операции"
::msgcat::mcset pb_msg_russian "MC(prog,tree,oper_end,Label)"           "Последовательность в конце операции"
::msgcat::mcset pb_msg_russian "MC(prog,tree,tool_path,Label)"          "Траектория"
::msgcat::mcset pb_msg_russian "MC(prog,tree,tool_path,mach_cnt,Label)" "Управление станком"
::msgcat::mcset pb_msg_russian "MC(prog,tree,tool_path,motion,Label)"   "Перемещение"
::msgcat::mcset pb_msg_russian "MC(prog,tree,tool_path,cycle,Label)"    "Встроенные циклы"
::msgcat::mcset pb_msg_russian "MC(prog,tree,linked_posts,Label)"       "Последовательность связанных постпроцессоров"

::msgcat::mcset pb_msg_russian "MC(prog,add,Label)"                     "Последовательность -- добавить кадр"
::msgcat::mcset pb_msg_russian "MC(prog,add,Context)"                   "Вы можете добавить новый кадр в последовательность, нажимая эту кнопку и перемещая кадр под необходимый маркер. Кадры могут быть присоединены рядом, выше или ниже существующего кадра."

::msgcat::mcset pb_msg_russian "MC(prog,trash,Label)"                   "Последовательность -- мусорная корзина"
::msgcat::mcset pb_msg_russian "MC(prog,trash,Context)"                 "Вы можете удалить любые ненужные кадры из последовательности, перемещая их в мусорную корзину."

::msgcat::mcset pb_msg_russian "MC(prog,block,Label)"                   "Последовательность -- кадр"
::msgcat::mcset pb_msg_russian "MC(prog,block,Context)"                 "Вы можете удалить любой ненужный кадр в последовательности, переместив его в мусорную корзину. \n \nВы можете также открыть всплывающее меню, нажав правую кнопку мыши. Следующие опции доступны в этом меню: \n \n * Изменить \n * Постоянный вывод \n * Вырезать \n * Копировать как \n * Вставить \n * Удалить \n"

::msgcat::mcset pb_msg_russian "MC(prog,select,Label)"                  "Последовательность -- выбрать кадр"
::msgcat::mcset pb_msg_russian "MC(prog,select,Context)"                "Вы можете выбрать тип компонента кадра, который вы хотите добавить к последовательности из этого списка. \n\Aразличные типы компонент включают: \n \n * Новый кадр \n * Существующий кадр ЧПУ \n * Сообщение оператору \n * Команда пользователя \n"

::msgcat::mcset pb_msg_russian "MC(prog,oper_temp,Label)"               "Выбрать шаблон последовательности"
::msgcat::mcset pb_msg_russian "MC(prog,add_block,Label)"               "Добавить кадр"
::msgcat::mcset pb_msg_russian "MC(prog,seq_comb_nc,Label)"             "Отображать кадр в виде кодов системы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(prog,seq_comb_nc,Context)"           "Эта кнопка позволяет вывести на экран содержание последовательности в терминах кодов ЧПУ или кадров. \n \nКоды ЧПУ отображаются словами в порядке вывода."

::msgcat::mcset pb_msg_russian "MC(prog,plus,Label)"                    "Программа -- переключатель \"Свернуть/Развернуть\""
::msgcat::mcset pb_msg_russian "MC(prog,plus,Context)"                  "Эта кнопка позволяет свернуть или развернуть ветви выбранного в дереве компонента."

::msgcat::mcset pb_msg_russian "MC(prog,marker,Label)"                  "Последовательность -- маркер"
::msgcat::mcset pb_msg_russian "MC(prog,marker,Context)"                "Маркеры последовательности указывают возможные события, которые могут быть запрограммированы и могут произойти в последовательности на заданном шаге программы ЧПУ. \n \nВы можете присоединять/упорядочивать кадры, которые выводятся в каждом маркере."

::msgcat::mcset pb_msg_russian "MC(prog,event,Label)"                   "Программа -- события"
::msgcat::mcset pb_msg_russian "MC(prog,event,Context)"                 "Вы можете изменить каждое событие одиночным нажатием левой кнопки мыши."

::msgcat::mcset pb_msg_russian "MC(prog,nc_code,Label)"                 "Программа -- коды ЧПУ"
::msgcat::mcset pb_msg_russian "MC(prog,nc_code,Context)"               "Текст в этом блоке представляет код программы ЧПУ, который будет выводится с этим маркером или в этом событии."
::msgcat::mcset pb_msg_russian "MC(prog,undo_popup,Label)"              "Отмена действия"

## Sequence
##
::msgcat::mcset pb_msg_russian "MC(seq,combo,new,Label)"                "Новый кадр"
::msgcat::mcset pb_msg_russian "MC(seq,combo,comment,Label)"            "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(seq,combo,custom,Label)"             "Команда пользователя"

::msgcat::mcset pb_msg_russian "MC(seq,new_trans,title,Label)"          "Кадр"
::msgcat::mcset pb_msg_russian "MC(seq,cus_trans,title,Label)"          "Команда пользователя"
::msgcat::mcset pb_msg_russian "MC(seq,oper_trans,title,Label)"         "Сообщение оператору"

::msgcat::mcset pb_msg_russian "MC(seq,edit_popup,Label)"               "Изменить"
::msgcat::mcset pb_msg_russian "MC(seq,force_popup,Label)"              "Обязательный вывод"
::msgcat::mcset pb_msg_russian "MC(seq,rename_popup,Label)"             "Переименовать"
::msgcat::mcset pb_msg_russian "MC(seq,rename_popup,Context)"           "Вы можете задать имя для этого компонента."
::msgcat::mcset pb_msg_russian "MC(seq,cut_popup,Label)"                "Вырезать"
::msgcat::mcset pb_msg_russian "MC(seq,copy_popup,Label)"               "Копировать как"
::msgcat::mcset pb_msg_russian "MC(seq,copy_popup,ref,Label)"           "Ссылочные кадры"
::msgcat::mcset pb_msg_russian "MC(seq,copy_popup,new,Label)"           "Новый кадр"
::msgcat::mcset pb_msg_russian "MC(seq,paste_popup,Label)"              "Вставить"
::msgcat::mcset pb_msg_russian "MC(seq,paste_popup,before,Label)"       "До"
::msgcat::mcset pb_msg_russian "MC(seq,paste_popup,inline,Label)"       "Встроенный"
::msgcat::mcset pb_msg_russian "MC(seq,paste_popup,after,Label)"        "После"
::msgcat::mcset pb_msg_russian "MC(seq,del_popup,Label)"                "Удалить"

::msgcat::mcset pb_msg_russian "MC(seq,force_trans,title,Label)"        "Обязательный однократный вывод"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_russian "MC(tool,event_trans,title,Label)"       "Событие"

::msgcat::mcset pb_msg_russian "MC(tool,event_seq,button,Label)"        "Выбрать шаблон события"
::msgcat::mcset pb_msg_russian "MC(tool,add_word,button,Label)"         "Добавить слово"

::msgcat::mcset pb_msg_russian "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset pb_msg_russian "MC(tool,circ_trans,title,Label)"        "Круговая интерполяция -- коды плоскостей"
::msgcat::mcset pb_msg_russian "MC(tool,circ_trans,frame,Label)"        " G-коды плоскости "
::msgcat::mcset pb_msg_russian "MC(tool,circ_trans,xy,Label)"           "Плоскость XY"
::msgcat::mcset pb_msg_russian "MC(tool,circ_trans,yz,Label)"           "Плоскость YZ"
::msgcat::mcset pb_msg_russian "MC(tool,circ_trans,zx,Label)"           "Плоскость ZX"

::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,arc_start,Label)"          "От начала дуги к центру"
::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,arc_center,Label)"         "От центра дуги к началу"
::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,u_arc_start,Label)"        "Без знака от начала дуги к центру"
::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,absolute,Label)"           "Абсолютный центр дуги"
::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,long_thread_lead,Label)"   "Продольный шаг резьбы"
::msgcat::mcset pb_msg_russian "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Поперечный шаг резьбы"

::msgcat::mcset pb_msg_russian "MC(tool,spindle,range,type,Label)"              "Тип диапазона частот вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(tool,spindle,range,range_M,Label)"           "Отдельный М-код диапазона (M41)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle,range,with_spindle_M,Label)"    "Номер диапазона с M-кодом включения шпинделя (M13)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Верхний/нижний пределы диапазона с S-кодом (S+100)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle,range,nonzero_range,msg)"       "Количество диапазонов шпинделя должно быть больше нуля."

::msgcat::mcset pb_msg_russian "MC(tool,spindle_trans,title,Label)"         "Таблица кодов диапазонов частот вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_trans,range,Label)"         "Диапазон"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_trans,code,Label)"          "Код"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_trans,min,Label)"           "Минимум (об/мин)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_trans,max,Label)"           "Максимум (об/мин)"

::msgcat::mcset pb_msg_russian "MC(tool,spindle_desc,sep,Label)"            " Отдельный М-код диапазона (M41, M42 ...) "
::msgcat::mcset pb_msg_russian "MC(tool,spindle_desc,range,Label)"          " Номер диапазона с M-кодом включения шпинделя (M13, M23 ...)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_desc,high,Label)"           " Верхний/нижний пределы диапазона с S-кодом (S+100/S-100)"
::msgcat::mcset pb_msg_russian "MC(tool,spindle_desc,odd,Label)"            " Нечетный/четный диапазон с S-кодом"


::msgcat::mcset pb_msg_russian "MC(tool,config,mill_opt1,Label)"            "Номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,config,mill_opt2,Label)"            "Номер инструмента и номер корректора длины"
::msgcat::mcset pb_msg_russian "MC(tool,config,mill_opt3,Label)"            "Номер корректора длины и номер инструмента"

::msgcat::mcset pb_msg_russian "MC(tool,config,title,Label)"                "Конфигурация кода инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,config,output,Label)"               "Вывод"

::msgcat::mcset pb_msg_russian "MC(tool,config,lathe_opt1,Label)"           "Номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,config,lathe_opt2,Label)"           "Номер инструмента и номер корректора длины"
::msgcat::mcset pb_msg_russian "MC(tool,config,lathe_opt3,Label)"           "Индекс револьверной головки и номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,config,lathe_opt4,Label)"           "Индекс револьверной головки, номер инструмента и номер корректора длины"

::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,num,Label)"               "Номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,next_num,Label)"          "Номер следующего инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,index_num,Label)"         "Индекс револьверной головки и номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,index_next_num,Label)"    "Индекс револьверной головки и номер следующего инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,num_len,Label)"           "Номер инструмента и номер корректора длины"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,next_num_len,Label)"      "Номер следующего инструмента и номер корректора длины"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,len_num,Label)"           "Номер корректора длины и номер инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,len_next_num,Label)"      "Номер корректора длины и номер следующего инструмента"
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,index_num_len,Label)"     "Индекс револьверной головки, номер инструмента и номер корректора длины "
::msgcat::mcset pb_msg_russian "MC(tool,conf_desc,index_next_num_len,Label)"    "Индекс револьверной головки, номер следующего инструмента и номер корректора длины"

::msgcat::mcset pb_msg_russian "MC(tool,oper_trans,title,Label)"            "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(tool,cus_trans,title,Label)"             "Команда пользователя"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_russian "MC(event,feed,IPM_mode)"                "Режим IPM (дюйм/мин)"

##---------
## G Codes
##
::msgcat::mcset pb_msg_russian "MC(gcode,tab,Label)"                    "G-коды"
::msgcat::mcset pb_msg_russian "MC(gcode,Status)"                       "Задайте G-коды"

##---------
## M Codes
##
::msgcat::mcset pb_msg_russian "MC(mcode,tab,Label)"                    "М-коды"
::msgcat::mcset pb_msg_russian "MC(mcode,Status)"                       "Задайте М-коды"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_russian "MC(addrsum,tab,Label)"                  "Сводная таблица слов"
::msgcat::mcset pb_msg_russian "MC(addrsum,Status)"                     "Задайте параметры"

::msgcat::mcset pb_msg_russian "MC(addrsum,col_addr,Label)"             "Слово"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_addr,Context)"           "Вы можете изменить слово нажатием левой кнопки мыши на его имя."
::msgcat::mcset pb_msg_russian "MC(addrsum,col_lead,Label)"             "Лидер/Код"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_data,Label)"             "Тип данных"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_plus,Label)"             "Плюс (+)"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_lzero,Label)"            "Ведущие нули"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_int,Label)"              "Целое"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_dec,Label)"              "Десятичный (.)"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_frac,Label)"             "Дробная часть"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_tzero,Label)"            "Конечные нули"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_modal,Label)"            "Модальный ?"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_min,Label)"              "Минимум"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_max,Label)"              "Максимум"
::msgcat::mcset pb_msg_russian "MC(addrsum,col_trail,Label)"            "Окончание"

::msgcat::mcset pb_msg_russian "MC(addrsum,radio_text,Label)"           "Текст"
::msgcat::mcset pb_msg_russian "MC(addrsum,radio_num,Label)"            "Числовое"

::msgcat::mcset pb_msg_russian "MC(addrsum,addr_trans,title,Label)"     "WORD"
::msgcat::mcset pb_msg_russian "MC(addrsum,other_trans,title,Label)"    "Другие элементы данных"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_russian "MC(wseq,tab,Label)"                     "Последовательность слов"
::msgcat::mcset pb_msg_russian "MC(wseq,Status)"                        "Последовательность слов"

::msgcat::mcset pb_msg_russian "MC(wseq,word,Label)"                    "Мастер-последовательность слов"
::msgcat::mcset pb_msg_russian "MC(wseq,word,Context)"                  "Вы можете упорядочить порядок вывода слов, в котором они выводятся в кадр программы, перемещением любого слова в нужную позицию. \n \nКогда слово, которое вы перемещаете, будет в фокусе (цвет прямоугольника изменится) другого слова, эти два слова поменяются местами. Если слово будет находится в пределах фокуса разделителя между 2 словами, то слово будет вставлено между этими 2 словами. \n \nВы можете подавить вывод любого слова в кадр программы ЧПУ, выключая вывод этого слова простым нажатием левой кнопки мыши. \n \nВы можете так же манипулировать словами, используя опции всплывающего меню на правой кнопке мыши: \n \n * Новый \n * Изменить \n * Удалить \n * Активировать все \n"

::msgcat::mcset pb_msg_russian "MC(wseq,active_out,Label)"              " Вывод - активен     "
::msgcat::mcset pb_msg_russian "MC(wseq,suppressed_out,Label)"          " Вывод - подавлен "

::msgcat::mcset pb_msg_russian "MC(wseq,popup_new,Label)"               "Новый"
::msgcat::mcset pb_msg_russian "MC(wseq,popup_undo,Label)"              "Отмена действия"
::msgcat::mcset pb_msg_russian "MC(wseq,popup_edit,Label)"              "Изменить"
::msgcat::mcset pb_msg_russian "MC(wseq,popup_delete,Label)"            "Удалить"
::msgcat::mcset pb_msg_russian "MC(wseq,popup_all,Label)"               "Активировать все"
::msgcat::mcset pb_msg_russian "MC(wseq,transient_win,Label)"           "WORD"
::msgcat::mcset pb_msg_russian "MC(wseq,cannot_suppress_msg)"           "не может быть подавлен. Это может использоваться как одиночный элемент в"
::msgcat::mcset pb_msg_russian "MC(wseq,empty_block_msg)"               "Подавление вывода этого адреса приведет к недопустимому пустому кадру."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_russian "MC(cust_cmd,tab,Label)"                 "Команда пользователя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,Status)"                    "Задать команду пользователя"

::msgcat::mcset pb_msg_russian "MC(cust_cmd,name,Label)"                "Имя команды"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,name,Context)"              "Имя, которое вы вводите здесь, будет иметь префикс PB_CMD_, чтобы стать фактическим именем команды."
::msgcat::mcset pb_msg_russian "MC(cust_cmd,proc,Label)"                "Процедура"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,proc,Context)"              "Вы должны создать TCL-скрипт, чтобы задать функциональные возможности этой команды. \n \n * Заметьте, что содержание скрипта не будет анализироваться генератором постпроцессора, но будет сохранено в TCL-файле. Поэтому вы отвечаете за правильность синтаксиса скрипта."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,name_msg)"                  "Недопустимое имя команды пользователя. \n Задайте другое имя."
::msgcat::mcset pb_msg_russian "MC(cust_cmd,name_msg_1)"                "зарезервировано для специальных команд пользователя. \n Задайте другое имя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,name_msg_2)"                "Допустимы только команды пользователя для виртуальной \n системы ЧПУ с именами типа PB_CMD_vnc____*.\n Задайте другое имя"

::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,Label)"              "Импорт"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,Context)"            "Импорт команд пользователя из выбранного TCL-файла в постпроцессор."
::msgcat::mcset pb_msg_russian "MC(cust_cmd,export,Label)"              "Экспорт"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,export,Context)"            "Экспорт команд пользователя из постпроцессора в TCL-файл."
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,tree,Label)"         "Импорт команд пользователя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,tree,Context)"       "Этот список содержит специализированные и другие TCL-процедуры, существующие в файле, который вы задали для импорта. Вы можете предварительно просмотреть содержание каждой процедуры, выбирая запись в списке одиночным нажатием левой кнопки мыши. Любая процедура, которая уже существует в постпроцессоре, помечена индикатором <существует>. Двойной щелчок левой кнопкой мыши на записи выводит на экран выключатель рядом с записью. Это позволяет вам выбрать или отменить выбор процедуры для импорта. По умолчанию, все процедуры выбраны для импорта. Вы можете отменить выбор любой записи, чтобы избежать перезаписи существующей процедуры."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,export,tree,Label)"         "Экспорт команд пользователя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,export,tree,Context)"       "Этот список содержит специализированные и другие TCL-процедуры, которые существуют в постпроцессоре. Вы можете предварительно просмотреть содержание каждой процедуры, выбирая запись в списке одиночным нажатием левой кнопки мыши. Двойной щелчок левой кнопкой мыши на записи выводит на экран выключатель рядом с записью. Это позволяет вам выбрать или отменить выбор процедуры для импорта."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,error,title)"               "Ошибка в команде пользователя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,error,msg)"                 "Опция \"Проверка команд пользователя\" может быть включена или выключена с помощью установки выключателя возле записи в соответствующее положение в главном меню \"\"Опции\" -> \"Проверка команд пользователя\"\"."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,select_all,Label)"          "Выбрать все"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,select_all,Context)"        "Нажмите эту кнопку, чтобы выбрать все отображаемые команды для импорта или экспорта. "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,deselect_all,Label)"        "Отменить все"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,deselect_all,Context)"      "Нажмите эту кнопку, чтобы отменить выбор всех команд."

::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,warning,title)"      "Предупреждение импорта / экспорта команды пользователя"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,import,warning,msg)"        "Никакие записи не выбраны для импорта или экспорта."



::msgcat::mcset pb_msg_russian "MC(cust_cmd,cmd,msg)"                   "Команды : "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,blk,msg)"                   "Кадры : "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,add,msg)"                   "Адреса : "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,fmt,msg)"                   "Форматы : "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,referenced,msg)"            "упоминается в команде пользователя "
::msgcat::mcset pb_msg_russian "MC(cust_cmd,not_defined,msg)"           "не были заданы в текущей области действия постпроцессора в процессе."
::msgcat::mcset pb_msg_russian "MC(cust_cmd,cannot_delete,msg)"         "не может быть удален"
::msgcat::mcset pb_msg_russian "MC(cust_cmd,save_post,msg)"             "Вы хотите сохранить этот постпроцессор?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_russian "MC(opr_msg,text,Label)"                 "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(opr_msg,text,Context)"               "Текст, который будет отображен как сообщение оператору. Заданные специальные символы для начала сообщения и конца сообщения будут автоматически присоединены постпроцессором для вас. Эти символы задаются в параметрах страницы \"\"Другие элементы данных\"\" на закладке \"\"Определение данных ЧПУ\"\"."

::msgcat::mcset pb_msg_russian "MC(opr_msg,name,Label)"                 "Имя сообщения"
::msgcat::mcset pb_msg_russian "MC(opr_msg,empty_operator)"             "Сообщение оператору не должно быть пустым."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_russian "MC(link_post,tab,Label)"                "Связанные постпроцессоры"
::msgcat::mcset pb_msg_russian "MC(link_post,Status)"                   "Задать связанные постпроцессоры"

::msgcat::mcset pb_msg_russian "MC(link_post,toggle,Label)"             "Связать другой постпроцессор с этим постпроцессором"
::msgcat::mcset pb_msg_russian "MC(link_post,toggle,Context)"           "Другие постпроцессоры могут быть связаны с этим постпроцессором, чтобы работать со сложными станками, которые выполняют больше чем одну операцию простого фрезерования и токарной обработки."

::msgcat::mcset pb_msg_russian "MC(link_post,head,Label)"               "Головка"
::msgcat::mcset pb_msg_russian "MC(link_post,head,Context)"             "Сложный станок, который может выполнять определенные операции обработки, используя множество различных кинематических наборов в различных режимах.  Каждый кинематический набор обрабатывается как независимая головка в NX/Постпроцессор.  Операции обработки, которые должны быть выполнены со специфической головкой, будут помещены вместе как группа на виде станка или виде методов обработки.  Затем \\\"Событие пользователя UDEГоловка\\\" будет назначен группе для обозначения имени головки."

::msgcat::mcset pb_msg_russian "MC(link_post,post,Label)"               "Постпроцессор"
::msgcat::mcset pb_msg_russian "MC(link_post,post,Context)"             "Постпроцессор назначен на головку для создания кодов ЧПУ."

::msgcat::mcset pb_msg_russian "MC(link_post,link,Label)"               "Связанный постпроцессор"
::msgcat::mcset pb_msg_russian "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_russian "MC(link_post,new,Label)"                "Новый"
::msgcat::mcset pb_msg_russian "MC(link_post,new,Context)"              "Создать новую связь."

::msgcat::mcset pb_msg_russian "MC(link_post,edit,Label)"               "Изменить"
::msgcat::mcset pb_msg_russian "MC(link_post,edit,Context)"             "Изменить связь"

::msgcat::mcset pb_msg_russian "MC(link_post,delete,Label)"             "Удалить"
::msgcat::mcset pb_msg_russian "MC(link_post,delete,Context)"           "Удалить связь."

::msgcat::mcset pb_msg_russian "MC(link_post,select_name,Label)"        "Выбрать имя"
::msgcat::mcset pb_msg_russian "MC(link_post,select_name,Context)"      "Выберите имя постпроцессора для назначения головке.  Возможно, что этот постпроцессор будет найден в папке, где выполняется главный постпроцессор NX/Постпроцессор, иначе будет использоваться постпроцессор с тем же именем в папке \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_russian "MC(link_post,start_of_head,Label)"      "Начало процедуры работы головки"
::msgcat::mcset pb_msg_russian "MC(link_post,start_of_head,Context)"    "Задайте коды ЧПУ или действия, которые должны быть выполнены в начале процедуры работы головки. "

::msgcat::mcset pb_msg_russian "MC(link_post,end_of_head,Label)"        "Конец процедуры работы головки"
::msgcat::mcset pb_msg_russian "MC(link_post,end_of_head,Context)"      "Задайте коды ЧПУ или действия, которые должны быть выполнены в конце процедуры работы головки. "
::msgcat::mcset pb_msg_russian "MC(link_post,dlg,head,Label)"           "Головка"
::msgcat::mcset pb_msg_russian "MC(link_post,dlg,post,Label)"           "Постпроцессор"
::msgcat::mcset pb_msg_russian "MC(link_post,dlg,title,Label)"          "Связанный постпроцессор"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_russian "MC(nc_data,tab,Label)"                  "Задание данных ЧПУ"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_russian "MC(block,tab,Label)"                    "BLOCK"
::msgcat::mcset pb_msg_russian "MC(block,Status)"                       "Задать шаблоны кадра"

::msgcat::mcset pb_msg_russian "MC(block,name,Label)"                   "Имя кадра"
::msgcat::mcset pb_msg_russian "MC(block,name,Context)"                 "Введите имя кадра"

::msgcat::mcset pb_msg_russian "MC(block,add,Label)"                    "Добавить слово"
::msgcat::mcset pb_msg_russian "MC(block,add,Context)"                  "Вы можете добавить новое слово в кадр, нажимая эту кнопку и перемещая слово в кадр, который отображается в окне ниже. Тип слова, который будет создан, выбирается из блока списка справа от этой кнопки."

::msgcat::mcset pb_msg_russian "MC(block,select,Label)"                 "BLOCK -- Выбор слова"
::msgcat::mcset pb_msg_russian "MC(block,select,Context)"               "Вы можете выбрать тип слова, который хотите добавить в кадр из этого списка."

::msgcat::mcset pb_msg_russian "MC(block,trash,Label)"                  "BLOCK -- Корзина"
::msgcat::mcset pb_msg_russian "MC(block,trash,Context)"                "Вы можете удалить любые ненужные слова из кадра, перемещая их в корзину"

::msgcat::mcset pb_msg_russian "MC(block,word,Label)"                   "BLOCK -- Слово"
::msgcat::mcset pb_msg_russian "MC(block,word,Context)"                 "Вы можете удалить любое ненужное слово в этом кадре, переместив его в корзину. \n \nВы можете также открыть всплывающее меню, нажав правую кнопку мыши. Следующие опции доступны в этом меню: \n \n * Изменить \n * Изменить элемент -> \n * Опционально \n * Без разделителя слов \n * Постоянный вывод \n * Удалить \n"

::msgcat::mcset pb_msg_russian "MC(block,verify,Label)"                 "BLOCK -- Проверка слова"
::msgcat::mcset pb_msg_russian "MC(block,verify,Context)"               "Это окно отображает представляемый код программы ЧПУ, который будет выведен для слова, выбранного (подавленного) в кадре, который отображается в окне выше."

::msgcat::mcset pb_msg_russian "MC(block,new_combo,Label)"              "Новый адрес"
::msgcat::mcset pb_msg_russian "MC(block,text_combo,Label)"             "Текст"
::msgcat::mcset pb_msg_russian "MC(block,oper_combo,Label)"             "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(block,comm_combo,Label)"             "Команда"

::msgcat::mcset pb_msg_russian "MC(block,edit_popup,Label)"             "Изменить"
::msgcat::mcset pb_msg_russian "MC(block,view_popup,Label)"             "Вид"
::msgcat::mcset pb_msg_russian "MC(block,change_popup,Label)"           "Сменить элемент"
::msgcat::mcset pb_msg_russian "MC(block,user_popup,Label)"             "Выражение, заданное пользователем"
::msgcat::mcset pb_msg_russian "MC(block,opt_popup,Label)"              "Опциональный"
::msgcat::mcset pb_msg_russian "MC(block,no_sep_popup,Label)"           "Без разделителя слов"
::msgcat::mcset pb_msg_russian "MC(block,force_popup,Label)"            "Обязательный вывод"
::msgcat::mcset pb_msg_russian "MC(block,delete_popup,Label)"           "Удалить"
::msgcat::mcset pb_msg_russian "MC(block,undo_popup,Label)"             "Отмена действия"
::msgcat::mcset pb_msg_russian "MC(block,delete_all,Label)"             "Удалить все активные элементы"

::msgcat::mcset pb_msg_russian "MC(block,cmd_title,Label)"              "Команда пользователя"
::msgcat::mcset pb_msg_russian "MC(block,oper_title,Label)"             "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(block,addr_title,Label)"             "WORD"

::msgcat::mcset pb_msg_russian "MC(block,new_trans,title,Label)"        "WORD"

::msgcat::mcset pb_msg_russian "MC(block,new,word_desc,Label)"          "Новый адрес"
::msgcat::mcset pb_msg_russian "MC(block,oper,word_desc,Label)"         "Сообщение оператору"
::msgcat::mcset pb_msg_russian "MC(block,cmd,word_desc,Label)"          "Команда пользователя"
::msgcat::mcset pb_msg_russian "MC(block,user,word_desc,Label)"         "Выражение, заданное пользователем"
::msgcat::mcset pb_msg_russian "MC(block,text,word_desc,Label)"         "Текстовая строка"

::msgcat::mcset pb_msg_russian "MC(block,user,expr,Label)"              "Выражение"

::msgcat::mcset pb_msg_russian "MC(block,msg,min_word)"                 "Кадр должен содержать по крайней мере одно слово."

::msgcat::mcset pb_msg_russian "MC(block,name_msg)"                     "Недопустимое имя кадра.\n Задайте другое имя."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_russian "MC(address,tab,Label)"                  "WORD"
::msgcat::mcset pb_msg_russian "MC(address,Status)"                     "Задать слова"

::msgcat::mcset pb_msg_russian "MC(address,name,Label)"                 "Имя слова"
::msgcat::mcset pb_msg_russian "MC(address,name,Context)"               "Вы можете изменить имя слова."

::msgcat::mcset pb_msg_russian "MC(address,verify,Label)"               "WORD -- Проверка"
::msgcat::mcset pb_msg_russian "MC(address,verify,Context)"             "Это окно отображает представляемый код программы ЧПУ, который будет выведен для слова."

::msgcat::mcset pb_msg_russian "MC(address,leader,Label)"               "Символ адреса"
::msgcat::mcset pb_msg_russian "MC(address,leader,Context)"             "Вы можете ввести любое число символов как лидер для слова или выбрать символ из всплывающего меню, используя правую кнопку мыши."

::msgcat::mcset pb_msg_russian "MC(address,format,Label)"               "Формат"
::msgcat::mcset pb_msg_russian "MC(address,format,edit,Label)"          "Изменить"
::msgcat::mcset pb_msg_russian "MC(address,format,edit,Context)"        "Эта кнопка позволяет изменить формат, используемый в слове."
::msgcat::mcset pb_msg_russian "MC(address,format,new,Label)"           "Новый"
::msgcat::mcset pb_msg_russian "MC(address,format,new,Context)"         "Эта кнопка позволяет создать новый формат."

::msgcat::mcset pb_msg_russian "MC(address,format,select,Label)"        "WORD -- Выбрать формат"
::msgcat::mcset pb_msg_russian "MC(address,format,select,Context)"      "Эта кнопка позволяет выбрать другой формат для слова."

::msgcat::mcset pb_msg_russian "MC(address,trailer,Label)"              "Окончание"
::msgcat::mcset pb_msg_russian "MC(address,trailer,Context)"            "Вы можете ввести любое число символов как окончание для слова или выбрать символ из всплывающего меню, используя правую кнопку мыши."

::msgcat::mcset pb_msg_russian "MC(address,modality,Label)"             "Модальный ?"
::msgcat::mcset pb_msg_russian "MC(address,modality,Context)"           "Эта опция позволяет указать модальность вывода для выбранного слова."

::msgcat::mcset pb_msg_russian "MC(address,modal_drop,off,Label)"       "Выкл."
::msgcat::mcset pb_msg_russian "MC(address,modal_drop,once,Label)"      "Однажды"
::msgcat::mcset pb_msg_russian "MC(address,modal_drop,always,Label)"    "Всегда"

::msgcat::mcset pb_msg_russian "MC(address,max,value,Label)"            "Максимум"
::msgcat::mcset pb_msg_russian "MC(address,max,value,Context)"          "Вы можете задать максимальное значение слова."

::msgcat::mcset pb_msg_russian "MC(address,value,text,Label)"           "Значение"

::msgcat::mcset pb_msg_russian "MC(address,trunc_drop,Label)"           "Обрезанное значение"
::msgcat::mcset pb_msg_russian "MC(address,warn_drop,Label)"            "Предупреждение пользователя"
::msgcat::mcset pb_msg_russian "MC(address,abort_drop,Label)"           "Прервать процесс"

::msgcat::mcset pb_msg_russian "MC(address,max,error_handle,Label)"     "Обработка ошибок"
::msgcat::mcset pb_msg_russian "MC(address,max,error_handle,Context)"   "Эта кнопка позволяет задать метод, как обработать ситуацию превышения максимального значения: \n \n * Обрезать значение \n * Предупредить пользователя \n * Прервать процесс \n"

::msgcat::mcset pb_msg_russian "MC(address,min,value,Label)"            "Минимум"
::msgcat::mcset pb_msg_russian "MC(address,min,value,Context)"          "Вы можете задать минимальное значение слова."

::msgcat::mcset pb_msg_russian "MC(address,min,error_handle,Label)"     "Обработка ошибок"
::msgcat::mcset pb_msg_russian "MC(address,min,error_handle,Context)"   "Эта кнопка позволяет задать метод, как обработать ситуацию превышения минимального значения: \n \n * Обрезать значение \n * Предупредить пользователя \n * Прервать процесс \n"

::msgcat::mcset pb_msg_russian "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset pb_msg_russian "MC(address,none_popup,Label)"           "Нет"

::msgcat::mcset pb_msg_russian "MC(address,exp,Label)"                  "Выражение"
::msgcat::mcset pb_msg_russian "MC(address,exp,Context)"                "Вы можете задать выражение или константу для кадра."
::msgcat::mcset pb_msg_russian "MC(address,exp,msg)"                    "Выражение для элемента кадра не должно быть пустым."
::msgcat::mcset pb_msg_russian "MC(address,exp,space_only)"             "Выражение для элемента кадра, которое  использует числовой формат не может содержать только пробелы."

## No translation is needed for this string.
::msgcat::mcset pb_msg_russian "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_russian "MC(address,exp,spec_char_msg)"          "Специальный символ \n [::msgcat::mc MC(address,exp,spec_char)] \n не может использоваться в выражении для численных данных."



::msgcat::mcset pb_msg_russian "MC(address,name_msg)"                   "Недопустимое имя слова.\n Задайте другое имя."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_russian "MC(address,rapid_add_name_msg)"         "Адреса rapid1, rapid2 и rapid3 зарезервированы для внутреннего использования генератором постпроцессоров.\n Задайте другое имя."

::msgcat::mcset pb_msg_russian "MC(address,rapid1,desc)"                "Ускоренное перемещение вдоль продольной оси"
::msgcat::mcset pb_msg_russian "MC(address,rapid2,desc)"                "Ускоренное перемещение вдоль поперечной оси"
::msgcat::mcset pb_msg_russian "MC(address,rapid3,desc)"                "Ускоренное перемещение вдоль оси шпинделя"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_russian "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset pb_msg_russian "MC(format,Status)"                      "Задать форматы"

::msgcat::mcset pb_msg_russian "MC(format,verify,Label)"                "FORMAT -- проверка"
::msgcat::mcset pb_msg_russian "MC(format,verify,Context)"              "Это окно отображает представляемый код программы ЧПУ, который будет выведен, используя заданный формат."

::msgcat::mcset pb_msg_russian "MC(format,name,Label)"                  "Имя формата"
::msgcat::mcset pb_msg_russian "MC(format,name,Context)"                "Вы можете изменить имя формата."

::msgcat::mcset pb_msg_russian "MC(format,data,type,Label)"             "Тип данных"
::msgcat::mcset pb_msg_russian "MC(format,data,type,Context)"           "Вы можете задать тип данных для формата."
::msgcat::mcset pb_msg_russian "MC(format,data,num,Label)"              "Числовое"
::msgcat::mcset pb_msg_russian "MC(format,data,num,Context)"            "Эта опция задает тип данных формата как числовой."
::msgcat::mcset pb_msg_russian "MC(format,data,num,integer,Label)"      "FORMAT -- число цифр целой части"
::msgcat::mcset pb_msg_russian "MC(format,data,num,integer,Context)"    "Эта опция задает количество разрядов для целого числа или целочисленной части вещественного числа."
::msgcat::mcset pb_msg_russian "MC(format,data,num,fraction,Label)"     "FORMAT -- число цифр дробной части"
::msgcat::mcset pb_msg_russian "MC(format,data,num,fraction,Context)"   "Эта опция задает количество разрядов для дробной части вещественного числа."
::msgcat::mcset pb_msg_russian "MC(format,data,num,decimal,Label)"      "Вывод десятичной точки (.)"
::msgcat::mcset pb_msg_russian "MC(format,data,num,decimal,Context)"    "Эта опция позволяет управлять выводом десятичных точек в коде программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(format,data,num,lead,Label)"         "Вывод ведущих нулей"
::msgcat::mcset pb_msg_russian "MC(format,data,num,lead,Context)"       "Эта опция позволяет вывод ведущих нулей в кодах программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(format,data,num,trail,Label)"        "Вывод конечных нулей"
::msgcat::mcset pb_msg_russian "MC(format,data,num,trail,Context)"      "Эта опция позволяет вывод конечных нулей для вещественных значений в кодах программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(format,data,text,Label)"             "Текст"
::msgcat::mcset pb_msg_russian "MC(format,data,text,Context)"           "Эта опция задает тип данных формата как текстовая строка."
::msgcat::mcset pb_msg_russian "MC(format,data,plus,Label)"             "Вывод ведущего символа плюс (+)"
::msgcat::mcset pb_msg_russian "MC(format,data,plus,Context)"           "Эта опция позволяет управлять выводом знака плюс в коде программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(format,zero_msg)"                    "Невозможно создать копию формата Zero"
::msgcat::mcset pb_msg_russian "MC(format,zero_cut_msg)"                "Невозможно удалить формат Zero"

::msgcat::mcset pb_msg_russian "MC(format,data,dec_zero,msg)"           "По крайней мере одна из опций: Десятичная точка, ведущие нули или конечные нули должна быть включена."

::msgcat::mcset pb_msg_russian "MC(format,data,no_digit,msg)"           "Количество разрядов для целой и дробной части числа не должно быть нулевым."

::msgcat::mcset pb_msg_russian "MC(format,name_msg)"                    "Недопустимое имя формата.\n Задайте другое имя."
::msgcat::mcset pb_msg_russian "MC(format,error,title)"                 "Ошибка формата"
::msgcat::mcset pb_msg_russian "MC(format,error,msg)"                   "Этот формат используется в адресах"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_russian "MC(other,tab,Label)"                    "Другие элементы данных"
::msgcat::mcset pb_msg_russian "MC(other,Status)"                       "Задайте параметры"

::msgcat::mcset pb_msg_russian "MC(other,seq_num,Label)"                "Нумерация кадров"
::msgcat::mcset pb_msg_russian "MC(other,seq_num,Context)"              "Этот переключатель позволяет включить/выключить вывод номер кадра в файл листинга."
::msgcat::mcset pb_msg_russian "MC(other,seq_num,start,Label)"          "Номер первого кадра"
::msgcat::mcset pb_msg_russian "MC(other,seq_num,start,Context)"        "Задайте номер первого кадра программы."
::msgcat::mcset pb_msg_russian "MC(other,seq_num,inc,Label)"            "Приращение номера кадра"
::msgcat::mcset pb_msg_russian "MC(other,seq_num,inc,Context)"          "Задайте приращение номера кадра. "
::msgcat::mcset pb_msg_russian "MC(other,seq_num,freq,Label)"           "Частота вывода номера кадра"
::msgcat::mcset pb_msg_russian "MC(other,seq_num,freq,Context)"         "Задайте частоту вывода номеров кадра в программу ЧПУ."
::msgcat::mcset pb_msg_russian "MC(other,seq_num,max,Label)"            "Максимальное значение номера кадра"
::msgcat::mcset pb_msg_russian "MC(other,seq_num,max,Context)"          "Задайте максимальное значение номера кадра"

::msgcat::mcset pb_msg_russian "MC(other,chars,Label)"                  "Специальные символы"
::msgcat::mcset pb_msg_russian "MC(other,chars,word_sep,Label)"         "Разделитель слов"
::msgcat::mcset pb_msg_russian "MC(other,chars,word_sep,Context)"       "Задайте символ, который будет использоваться как разделитель слов."
::msgcat::mcset pb_msg_russian "MC(other,chars,decimal_pt,Label)"       "Десятичная точка"
::msgcat::mcset pb_msg_russian "MC(other,chars,decimal_pt,Context)"     "Задайте символ, который будет использоваться как десятичная точка."
::msgcat::mcset pb_msg_russian "MC(other,chars,end_of_block,Label)"     "Конец кадра"
::msgcat::mcset pb_msg_russian "MC(other,chars,end_of_block,Context)"   "Задайте символ, который будет использоваться как конец кадра."
::msgcat::mcset pb_msg_russian "MC(other,chars,comment_start,Label)"    "Начало сообщения"
::msgcat::mcset pb_msg_russian "MC(other,chars,comment_start,Context)"  "Задайте символы, которые будут использоваться как начало строки сообщения оператору."
::msgcat::mcset pb_msg_russian "MC(other,chars,comment_end,Label)"      "Конец сообщения"
::msgcat::mcset pb_msg_russian "MC(other,chars,comment_end,Context)"    "Задайте символы, которые будут использоваться как конец строки сообщения оператору."

::msgcat::mcset pb_msg_russian "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_russian "MC(other,opskip,leader,Label)"          "Заголовок строки"
::msgcat::mcset pb_msg_russian "MC(other,opskip,leader,Context)"        "Заголовок строки OPSKIP"

::msgcat::mcset pb_msg_russian "MC(other,gm_codes,Label)"               "Вывод кодов G и M в одном кадре"
::msgcat::mcset pb_msg_russian "MC(other,g_codes,Label)"                "Количество G-кодов в кадре"
::msgcat::mcset pb_msg_russian "MC(other,g_codes,Context)"              "Этот переключатель позволяет включить/выключить разрешенное количество G-кодов в одном кадре программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(other,g_codes,num,Label)"            "Количество G-кодов"
::msgcat::mcset pb_msg_russian "MC(other,g_codes,num,Context)"          "Задайте количество G-кодов в одном кадре программы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(other,m_codes,Label)"                "Количество M-кодов"
::msgcat::mcset pb_msg_russian "MC(other,m_codes,Context)"              "Этот переключатель позволяет включить/выключить разрешенное количество M-кодов в одном кадре программы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(other,m_codes,num,Label)"            "Количество M-кодов в кадре"
::msgcat::mcset pb_msg_russian "MC(other,m_codes,num,Context)"          "Задайте количество M-кодов в одном кадре программы ЧПУ"

::msgcat::mcset pb_msg_russian "MC(other,opt_none,Label)"               "Нет"
::msgcat::mcset pb_msg_russian "MC(other,opt_space,Label)"              "Пробел"
::msgcat::mcset pb_msg_russian "MC(other,opt_dec,Label)"                "Десятичный (.)"
::msgcat::mcset pb_msg_russian "MC(other,opt_comma,Label)"              "Запятая (,)"
::msgcat::mcset pb_msg_russian "MC(other,opt_semi,Label)"               "Точка с запятой (;)"
::msgcat::mcset pb_msg_russian "MC(other,opt_colon,Label)"              "Двоеточие (:)"
::msgcat::mcset pb_msg_russian "MC(other,opt_text,Label)"               "Текстовая строка"
::msgcat::mcset pb_msg_russian "MC(other,opt_left,Label)"               "Левая круглая скобка ("
::msgcat::mcset pb_msg_russian "MC(other,opt_right,Label)"              "Правая круглая скобка )"
::msgcat::mcset pb_msg_russian "MC(other,opt_pound,Label)"              "Знак фунта (\#)"
::msgcat::mcset pb_msg_russian "MC(other,opt_aster,Label)"              "Звездочка (*)"
::msgcat::mcset pb_msg_russian "MC(other,opt_slash,Label)"              "Слеш (/)"
::msgcat::mcset pb_msg_russian "MC(other,opt_new_line,Label)"           "Новая строка (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_russian "MC(other,ude,Label)"                    "События, задаваемые пользователем"
::msgcat::mcset pb_msg_russian "MC(other,ude_include,Label)"            "Включить другой файл CDL"
::msgcat::mcset pb_msg_russian "MC(other,ude_include,Context)"          "Эта опция позволяет постпроцессору включать ссылку на файл CDL в файле описания."

::msgcat::mcset pb_msg_russian "MC(other,ude_file,Label)"               "Имя файл CDL"
::msgcat::mcset pb_msg_russian "MC(other,ude_file,Context)"             "Путь и имя файла CDL, на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH, используемая в сессии UG/NX."
::msgcat::mcset pb_msg_russian "MC(other,ude_select,Label)"             "Выбрать имя"
::msgcat::mcset pb_msg_russian "MC(other,ude_select,Context)"           "Выберите файл CDL, на который будет ссылаться (INCLUDE) файл описания этого постпроцессора. По умолчанию, выбранное имя файла будет начинаться с \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Вы можете изменить составное имя как необходимо после выбора."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_russian "MC(output,tab,Label)"                   "Настройки вывода"
::msgcat::mcset pb_msg_russian "MC(output,Status)"                      "Конфигурировать параметры вывода"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_russian "MC(output,vnc,Label)"                   "Виртуальная система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,std,Label)"          "Автономный"
::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,sub,Label)"          "Подчиненный"
::msgcat::mcset pb_msg_russian "MC(output,vnc,status,Label)"            "Выбрать файл  VNC"
::msgcat::mcset pb_msg_russian "MC(output,vnc,mis_match,Label)"         "Выбранный файл не соответствует значению по умолчанию для имени файла виртуальной системы ЧПУ. \n Вы хотите повторно задать файл?"
::msgcat::mcset pb_msg_russian "MC(output,vnc,output,Label)"            "Генерировать виртуальную систему ЧПУ (VNC)"
::msgcat::mcset pb_msg_russian "MC(output,vnc,output,Context)"          "Эта опция позволяет генерировать виртуальную систему ЧПУ. Постпроцессор, созданный с виртуальной системой ЧПУ, может использоваться для встроенной симуляции программы."
::msgcat::mcset pb_msg_russian "MC(output,vnc,main,Label)"              "Исходная виртуальная система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(output,vnc,main,Context)"            "Имя исходной виртуальной системы ЧПУ, которое будет исходным для зависимой виртуальной системы ЧПУ. Во время выполнения симуляции, предполагается, что этот постпроцессор будет найден в папке, в котором располагается зависимая виртуальная система ЧПУ, в противном случае, будет использоваться постпроцессор с тем же именем в папке \\\$UGII_CAM_POST_DIR."


::msgcat::mcset pb_msg_russian "MC(output,vnc,main,err_msg)"                 "Исходная виртуальная система ЧПУ должна быть задана для зависимой виртуальной системы ЧПУ "
::msgcat::mcset pb_msg_russian "MC(output,vnc,main,select_name,Label)"       "Выбрать имя"
::msgcat::mcset pb_msg_russian "MC(output,vnc,main,select_name,Context)"     "Выберите имя виртуальной системы ЧПУ, которая будет исходной для зависимой виртуальной системы ЧПУ. В процессе работы симуляции, предполагается, что этот постпроцессор будет находится в папке, в котором располагается зависимая виртуальная система ЧПУ, в противном случае будет использоваться постпроцессор с таким же именем из папки \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,Label)"                   "Режим виртуальной системы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,Context)"                 "Виртуальная система ЧПУ может быть или автономной или зависимой от родительской виртуальной системы ЧПУ."
::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,std,Context)"             "Автономная Виртуальная система ЧПУ является встроенной."
::msgcat::mcset pb_msg_russian "MC(output,vnc,mode,sub,Context)"             "Зависимая  Виртуальная система ЧПУ - в значительной степени зависит от родительской  виртуальной системы ЧПУ. Это будет родительская виртуальная система ЧПУ которая работает во время выполнения симуляции."
::msgcat::mcset pb_msg_russian "MC(output,vnc,pb_ver,msg)"                   "Виртуальная система ЧПУ, созданная в Генераторе постпроцессора "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_russian "MC(listing,tab,Label)"                  "Файл листинга"
::msgcat::mcset pb_msg_russian "MC(listing,Status)"                     "Задайте параметры файла листинга"

::msgcat::mcset pb_msg_russian "MC(listing,gen,Label)"                  "Генерировать файл листинга"
::msgcat::mcset pb_msg_russian "MC(listing,gen,Context)"                "Этот переключатель позволяет включить/выключить вывод в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,Label)"                      "Элементы файла листинга"
::msgcat::mcset pb_msg_russian "MC(listing,parms,Label)"                "Компоненты"

::msgcat::mcset pb_msg_russian "MC(listing,parms,x,Label)"              "X-координата"
::msgcat::mcset pb_msg_russian "MC(listing,parms,x,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты X в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,y,Label)"              "Y-координата"
::msgcat::mcset pb_msg_russian "MC(listing,parms,y,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты Y в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,z,Label)"              "Z-координата"
::msgcat::mcset pb_msg_russian "MC(listing,parms,z,Context)"            "Этот переключатель позволяет включить/выключить вывод координаты Z в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,4,Label)"              "Угол 4-й оси"
::msgcat::mcset pb_msg_russian "MC(listing,parms,4,Context)"            "Этот переключатель позволяет включить/выключить вывод угла 4-ой оси в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,5,Label)"              "Угол 5-й оси"
::msgcat::mcset pb_msg_russian "MC(listing,parms,5,Context)"            "Этот переключатель позволяет включить/выключить вывод угла 5-ой оси в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,feed,Label)"           "Подача"
::msgcat::mcset pb_msg_russian "MC(listing,parms,feed,Context)"         "Этот переключатель позволяет включить/выключить вывод подач в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,parms,speed,Label)"          "Скорость"
::msgcat::mcset pb_msg_russian "MC(listing,parms,speed,Context)"        "Этот переключатель позволяет включить/выключить вывод частоты вращения шпинделя в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,extension,Label)"            "Расширение файла листинга"
::msgcat::mcset pb_msg_russian "MC(listing,extension,Context)"          "Задайте расширение файла листинга"

::msgcat::mcset pb_msg_russian "MC(listing,nc_file,Label)"              "Расширения выходного файла программы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(listing,nc_file,Context)"            "Задайте расширение файла программы ЧПУ"

::msgcat::mcset pb_msg_russian "MC(listing,header,Label)"               "Заголовок программы"
::msgcat::mcset pb_msg_russian "MC(listing,header,oper_list,Label)"     "Список операций"
::msgcat::mcset pb_msg_russian "MC(listing,header,tool_list,Label)"     "Список инструмента"

::msgcat::mcset pb_msg_russian "MC(listing,footer,Label)"               "Примечание программы"
::msgcat::mcset pb_msg_russian "MC(listing,footer,cut_time,Label)"      "Общее время обработки"

::msgcat::mcset pb_msg_russian "MC(listing,format,Label)"                   "Формат страницы"
::msgcat::mcset pb_msg_russian "MC(listing,format,print_header,Label)"      "Заголовок для печати страницы"
::msgcat::mcset pb_msg_russian "MC(listing,format,print_header,Context)"    "Этот переключатель позволяет включить/выключить вывод заголовка в файл листинга."

::msgcat::mcset pb_msg_russian "MC(listing,format,length,Label)"        "Длина страницы (Строки)"
::msgcat::mcset pb_msg_russian "MC(listing,format,length,Context)"      "Задайте количество строк на странице для файла листинга."
::msgcat::mcset pb_msg_russian "MC(listing,format,width,Label)"         "Ширина страницы (Столбцы)"
::msgcat::mcset pb_msg_russian "MC(listing,format,width,Context)"       "Задайте количество колонок на странице для файла листинга."

::msgcat::mcset pb_msg_russian "MC(listing,other,tab,Label)"            "Другие опции"
::msgcat::mcset pb_msg_russian "MC(listing,output,Label)"               "Вывод элементов управления"

::msgcat::mcset pb_msg_russian "MC(listing,output,warning,Label)"       "Вывод предупреждений"
::msgcat::mcset pb_msg_russian "MC(listing,output,warning,Context)"     "Этот переключатель позволяет включить/выключить вывод предупреждений с процессе работы постпроцессора."

::msgcat::mcset pb_msg_russian "MC(listing,output,review,Label)"        "Активировать инструмент отладки"
::msgcat::mcset pb_msg_russian "MC(listing,output,review,Context)"      "Этот переключатель позволяет активировать инструмент отладки в процессе вывода на постпроцессор."

::msgcat::mcset pb_msg_russian "MC(listing,output,group,Label)"         "Генерировать вывод группы"
::msgcat::mcset pb_msg_russian "MC(listing,output,group,Context)"       "Этот переключатель позволяет включить/выключить управление выводом группы в процессе вывода на постпроцессор."

::msgcat::mcset pb_msg_russian "MC(listing,output,verbose,Label)"       "Отображать подробное сообщение об ошибках"
::msgcat::mcset pb_msg_russian "MC(listing,output,verbose,Context)"     "Этот переключатель позволяет отобразить расширенные описания для аварийных ситуаций. При этом постпроцессор будет работать несколько медленнее."

::msgcat::mcset pb_msg_russian "MC(listing,oper_info,Label)"            "Информация об операции"
::msgcat::mcset pb_msg_russian "MC(listing,oper_info,parms,Label)"      "Параметры операции"
::msgcat::mcset pb_msg_russian "MC(listing,oper_info,tool,Label)"       "Параметры инструмента"
::msgcat::mcset pb_msg_russian "MC(listing,oper_info,cut_time,,Label)"  "Время обработки"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_russian "MC(listing,user_tcl,frame,Label)"       "Исходный TCL пользователя"
::msgcat::mcset pb_msg_russian "MC(listing,user_tcl,check,Label)"       "Исходный Tcl-файл пользователя"
::msgcat::mcset pb_msg_russian "MC(listing,user_tcl,check,Context)"     "Этот переключатель позволяет указать исходный собственный TCL-файл"
::msgcat::mcset pb_msg_russian "MC(listing,user_tcl,name,Label)"        "Имя файла"
::msgcat::mcset pb_msg_russian "MC(listing,user_tcl,name,Context)"      "Задайте имя Tcl-файла, который хотите использовать как исходный для этого постпроцессора"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_russian "MC(preview,tab,Label)"                  "Просмотр файлов постпроцессора"
::msgcat::mcset pb_msg_russian "MC(preview,new_code,Label)"             "Новый код"
::msgcat::mcset pb_msg_russian "MC(preview,old_code,Label)"             "Старый код"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_russian "MC(event_handler,tab,Label)"            "Обработчики событий"
::msgcat::mcset pb_msg_russian "MC(event_handler,Status)"               "Выберите событие для просмотра кодов процедуры"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_russian "MC(definition,tab,Label)"               "Определения"
::msgcat::mcset pb_msg_russian "MC(definition,Status)"                  "Выберите элемент для просмотра содержания"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_russian "MC(advisor,tab,Label)"                  "Экспертная система постпроцессора"
::msgcat::mcset pb_msg_russian "MC(advisor,Status)"                     "Экспертная система постпроцессора"

::msgcat::mcset pb_msg_russian "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_russian "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_russian "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_russian "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_russian "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset pb_msg_russian "MC(definition,addr_txt,Label)"          "WORD"
::msgcat::mcset pb_msg_russian "MC(definition,block_txt,Label)"         "BLOCK"
::msgcat::mcset pb_msg_russian "MC(definition,comp_txt,Label)"          "Составной BLOCK"
::msgcat::mcset pb_msg_russian "MC(definition,post_txt,Label)"          "Post BLOCK"
::msgcat::mcset pb_msg_russian "MC(definition,oper_txt,Label)"          "Сообщение оператору"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_russian "MC(msg,odd)"                            "Нечетное количество аргументов"
::msgcat::mcset pb_msg_russian "MC(msg,wrong_list_1)"                   "Неизвестные опции"
::msgcat::mcset pb_msg_russian "MC(msg,wrong_list_2)"                   "Должна быть одна из:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_russian "MC(event,start_prog,name)"              "Начало программы"

### Operation Start
::msgcat::mcset pb_msg_russian "MC(event,opr_start,start_path,name)"    "Начало траектории"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,from_move,name)"     "Перемещение из т. From"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,fst_tool,name)"      "Первый инструмент"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,auto_tc,name)"       "Автоматическая смена инструмента"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,manual_tc,name)"     "Смена инструмента вручную"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,init_move,name)"     "Начальное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,fst_move,name)"      "Первое перемещение"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,appro_move,name)"    "Перемещение подхода"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,engage_move,name)"   "Перемещение врезания"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,fst_cut,name)"       "Первый рез"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,fst_lin_move,name)"  "Первое линейное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,start_pass,name)"    "Начало прохода"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,cutcom_move,name)"   "Перемещение включения коррекции"
::msgcat::mcset pb_msg_russian "MC(event,opr_start,lead_move,name)"     "Перемещение подхода"

### Operation End
::msgcat::mcset pb_msg_russian "MC(event,opr_end,ret_move,name)"        "Перемещение отвода"
::msgcat::mcset pb_msg_russian "MC(event,opr_end,rtn_move,name)"        "Перемещение возврата"
::msgcat::mcset pb_msg_russian "MC(event,opr_end,goh_move,name)"        "Перемещение Gohome"
::msgcat::mcset pb_msg_russian "MC(event,opr_end,end_path,name)"        "Конец операции"
::msgcat::mcset pb_msg_russian "MC(event,opr_end,lead_move,name)"       "Перемещение отхода"
::msgcat::mcset pb_msg_russian "MC(event,opr_end,end_pass,name)"        "Конец прохода"

### Program End
::msgcat::mcset pb_msg_russian "MC(event,end_prog,name)"                "Завершение программы"


### Tool Change
::msgcat::mcset pb_msg_russian "MC(event,tool_change,name)"             "Смена инструмента"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,m_code)"           "М-коды"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,m_code,tl_chng)"   "Смена инструмента"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,m_code,pt)"        "Первичная револьверная головка"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,m_code,st)"        "Вторичная револьверная головка"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,t_code)"           "Т код"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,t_code,conf)"      "Конфигурировать"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,t_code,pt_idx)"    "Индекс первичной револьверной головки"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,t_code,st_idx)"    "Индекс вторичной револьверной головки"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,tool_num)"         "Номер инструмента"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,tool_num,min)"     "Минимум"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,tool_num,max)"     "Максимум"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,time)"             "Время (сек.)"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,time,tl_chng)"     "Смена инструмента"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,retract)"          "Отвод"
::msgcat::mcset pb_msg_russian "MC(event,tool_change,retract_z)"        "Отвод по Z"

### Length Compensation
::msgcat::mcset pb_msg_russian "MC(event,length_compn,name)"            "Коррекция длины"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,g_code)"          "G-код"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,g_code,len_adj)"  "Регистр коррекции длины инструмента"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,t_code)"          "Т код"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,t_code,conf)"     "Конфигурировать"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,len_off)"         "Регистр коррекции длины"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,len_off,min)"     "Минимум"
::msgcat::mcset pb_msg_russian "MC(event,length_compn,len_off,max)"     "Максимум"

### Set Modes
::msgcat::mcset pb_msg_russian "MC(event,set_modes,name)"               "Режим установок"
::msgcat::mcset pb_msg_russian "MC(event,set_modes,out_mode)"           "Режим вывода"
::msgcat::mcset pb_msg_russian "MC(event,set_modes,g_code)"             "G-код"
::msgcat::mcset pb_msg_russian "MC(event,set_modes,g_code,absolute)"    "Абсолютный"
::msgcat::mcset pb_msg_russian "MC(event,set_modes,g_code,incremental)" "Приращение"
::msgcat::mcset pb_msg_russian "MC(event,set_modes,rotary_axis)"        "Поворотная ось может программироваться в приращениях"

### Spindle RPM
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,name)"                     "Частота вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,dir_m_code)"               "М-коды направления вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,dir_m_code,cw)"            "По часовой стрелке (ПоЧС)"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,dir_m_code,ccw)"           "Против часовой стрелки (ПротивЧС)"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,range_control)"            "Управления диапазоном частот вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,range_control,dwell_time)" "Задержка времени при смене диапазона (сек.)"
::msgcat::mcset pb_msg_russian "MC(event,spindle_rpm,range_control,range_code)" "Задайте код диапазона"

### Spindle CSS
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,name)"             "Шпиндель ПСвП"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,g_code)"           "G-код шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,g_code,const)"     "Код постоянной скорости резания"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,g_code,max)"       "Код максимальных оборотов"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,g_code,sfm)"       "Код для отмены режима SFM"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,max)"              "Максимальные обороты при симуляции постоянной скорости резания"
::msgcat::mcset pb_msg_russian "MC(event,spindle_css,sfm)"              "Всегда включать режим IPR для SFM"

### Spindle Off
::msgcat::mcset pb_msg_russian "MC(event,spindle_off,name)"             "Выключение шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_off,dir_m_code)"       "М-код направления вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(event,spindle_off,dir_m_code,off)"   "Выкл."

### Coolant On
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,name)"              "СОЖ включена"
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code)"            "М-коды"
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code,on)"         "Вкл."
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code,flood)"      "Полив"
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code,mist)"       "Распыление"
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code,thru)"       "Через"
::msgcat::mcset pb_msg_russian "MC(event,coolant_on,m_code,tap)"        "Смешанный"

### Coolant Off
::msgcat::mcset pb_msg_russian "MC(event,coolant_off,name)"             "СОЖ выключена"
::msgcat::mcset pb_msg_russian "MC(event,coolant_off,m_code)"           "М-коды"
::msgcat::mcset pb_msg_russian "MC(event,coolant_off,m_code,off)"       "Выкл."

### Inch Metric Mode
::msgcat::mcset pb_msg_russian "MC(event,inch_metric_mode,name)"            "Режим дюймы/миллиметры"
::msgcat::mcset pb_msg_russian "MC(event,inch_metric_mode,g_code)"          "G-код"
::msgcat::mcset pb_msg_russian "MC(event,inch_metric_mode,g_code,english)"  "Английские (дюйм)"
::msgcat::mcset pb_msg_russian "MC(event,inch_metric_mode,g_code,metric)"   "Метрические (мм)"

### Feedrates
::msgcat::mcset pb_msg_russian "MC(event,feedrates,name)"               "Подачи"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,ipm_mode)"           "Режим IPM"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,ipr_mode)"           "Режим IPR"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,dpm_mode)"           "Режим DPM"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mmpm_mode)"          "Режим MMPM"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mmpr_mode)"          "Режим MMPR"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,frn_mode)"           "Режим FRN"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,g_code)"             "G-код"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,format)"             "Формат"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,max)"                "Максимум"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,min)"                "Минимум"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,label)"         "Режимы подач"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,lin)"           "Только линейные"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,rot)"           "Только поворотные"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,lin_rot)"       "Линейные и поворотные"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,rap_lin)"       "Ускоренное только линейные"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,rap_rot)"       "Ускоренное только поворотные"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,mode,rap_lin_rot)"   "Ускоренное линейное и поворотное"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,cycle_mode)"         "Режим подачи в цикле"
::msgcat::mcset pb_msg_russian "MC(event,feedrates,cycle)"              "Цикл"

### Cutcom On
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,name)"               "Включение коррекции"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,g_code)"             "G-код"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,left)"               "Слева"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,right)"              "Справа"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,app_planes)"         "Применяемые плоскости"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,edit_planes)"        "Изменить коды плоскостей"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,reg)"                "Регистр коррекции"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,min)"                "Минимум"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,max)"                "Максимум"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_on,bef)"                "Выключение коррекции перед изменением"

### Cutcom Off
::msgcat::mcset pb_msg_russian "MC(event,cutcom_off,name)"              "Выключение коррекции"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_off,g_code)"            "G-код"
::msgcat::mcset pb_msg_russian "MC(event,cutcom_off,off)"               "Выкл."

### Delay
::msgcat::mcset pb_msg_russian "MC(event,delay,name)"                   "Задержка"
::msgcat::mcset pb_msg_russian "MC(event,delay,seconds)"                "Секунды"
::msgcat::mcset pb_msg_russian "MC(event,delay,seconds,g_code)"         "G-код"
::msgcat::mcset pb_msg_russian "MC(event,delay,seconds,format)"         "Формат"
::msgcat::mcset pb_msg_russian "MC(event,delay,out_mode)"               "Режим вывода"
::msgcat::mcset pb_msg_russian "MC(event,delay,out_mode,sec)"           "Только секунды"
::msgcat::mcset pb_msg_russian "MC(event,delay,out_mode,rev)"           "Только обороты"
::msgcat::mcset pb_msg_russian "MC(event,delay,out_mode,feed)"          "Зависимые от подачи"
::msgcat::mcset pb_msg_russian "MC(event,delay,out_mode,ivs)"           "Инверсное время"
::msgcat::mcset pb_msg_russian "MC(event,delay,revolution)"             "Обороты"
::msgcat::mcset pb_msg_russian "MC(event,delay,revolution,g_code)"      "G-код"
::msgcat::mcset pb_msg_russian "MC(event,delay,revolution,format)"      "Формат"

### Option Stop
::msgcat::mcset pb_msg_russian "MC(event,opstop,name)"                  "Опциональный останов"

### Auxfun
::msgcat::mcset pb_msg_russian "MC(event,auxfun,name)"                  "Дополнительная функция"

### Prefun
::msgcat::mcset pb_msg_russian "MC(event,prefun,name)"                  "Функция позиционирования"

### Load Tool
::msgcat::mcset pb_msg_russian "MC(event,loadtool,name)"                "Загрузка инструмента"

### Stop
::msgcat::mcset pb_msg_russian "MC(event,stop,name)"                    "Остановка"

### Tool Preselect
::msgcat::mcset pb_msg_russian "MC(event,toolpreselect,name)"           "Предварительный выбор инструмента"

### Thread Wire
::msgcat::mcset pb_msg_russian "MC(event,threadwire,name)"              "Заправка проволоки"

### Cut Wire
::msgcat::mcset pb_msg_russian "MC(event,cutwire,name)"                 "Обрезка проволоки"

### Wire Guides
::msgcat::mcset pb_msg_russian "MC(event,wireguides,name)"              "Направляющие проволоки"

### Linear Move
::msgcat::mcset pb_msg_russian "MC(event,linear,name)"                  "Линейное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,linear,g_code)"                "G-код"
::msgcat::mcset pb_msg_russian "MC(event,linear,motion)"                "Линейное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,linear,assume)"                "Использовать режим ускоренного перемещения при максимальной подаче перехода"

### Circular Move
::msgcat::mcset pb_msg_russian "MC(event,circular,name)"                "Круговое перемещение"
::msgcat::mcset pb_msg_russian "MC(event,circular,g_code)"              "G-коды перемещений"
::msgcat::mcset pb_msg_russian "MC(event,circular,clockwise)"           "По часовой стрелке (ПоЧС)"
::msgcat::mcset pb_msg_russian "MC(event,circular,counter-clock)"       "Против часовой стрелки (ПротивЧС)"
::msgcat::mcset pb_msg_russian "MC(event,circular,record)"              "Запись круговых движений"
::msgcat::mcset pb_msg_russian "MC(event,circular,full_circle)"         "Полная окружность"
::msgcat::mcset pb_msg_russian "MC(event,circular,quadrant)"            "Квадрант"
::msgcat::mcset pb_msg_russian "MC(event,circular,ijk_def)"             "Задание IJK"
::msgcat::mcset pb_msg_russian "MC(event,circular,ij_def)"              "Задание IJ"
::msgcat::mcset pb_msg_russian "MC(event,circular,ik_def)"              "Задание IK"
::msgcat::mcset pb_msg_russian "MC(event,circular,planes)"              "Применяемые плоскости"
::msgcat::mcset pb_msg_russian "MC(event,circular,edit_planes)"         "Изменить коды плоскостей"
::msgcat::mcset pb_msg_russian "MC(event,circular,radius)"              "Радиус"
::msgcat::mcset pb_msg_russian "MC(event,circular,min)"                 "Минимум"
::msgcat::mcset pb_msg_russian "MC(event,circular,max)"                 "Максимум"
::msgcat::mcset pb_msg_russian "MC(event,circular,arc_len)"             "Минимальная длина дуги"

### Rapid Move
::msgcat::mcset pb_msg_russian "MC(event,rapid,name)"                   "Ускоренное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,rapid,g_code)"                 "G-код"
::msgcat::mcset pb_msg_russian "MC(event,rapid,motion)"                 "Ускоренное перемещение"
::msgcat::mcset pb_msg_russian "MC(event,rapid,plane_change)"           "Смена рабочей плоскости "

### Lathe Thread
::msgcat::mcset pb_msg_russian "MC(event,lathe,name)"                   "Резьба на токарной операции"
::msgcat::mcset pb_msg_russian "MC(event,lathe,g_code)"                 "G-код для резьбы"
::msgcat::mcset pb_msg_russian "MC(event,lathe,cons)"                   "Постоянный"
::msgcat::mcset pb_msg_russian "MC(event,lathe,incr)"                   "Приращение"
::msgcat::mcset pb_msg_russian "MC(event,lathe,decr)"                   "Уменьшение"

### Cycle
::msgcat::mcset pb_msg_russian "MC(event,cycle,g_code)"                 "G-код и настройка"
::msgcat::mcset pb_msg_russian "MC(event,cycle,customize,Label)"        "Настройки"
::msgcat::mcset pb_msg_russian "MC(event,cycle,customize,Context)"      "Этот переключатель позволяет настроить цикл. \n\nПо умолчанию, основная конструкция каждого цикла задана установками общих параметров. Эти общие элементы не могут изменятся в каждом цикле. \n\nВключение этой опции позволяет получить полный контроль над конфигурацией цикла. Изменения, сделанные в общих параметрам, больше не будут воздействовать на цикл."
::msgcat::mcset pb_msg_russian "MC(event,cycle,start,Label)"            "Начало цикла"
::msgcat::mcset pb_msg_russian "MC(event,cycle,start,Context)"          "Эта опция может быть включена для станков, которые выполняют циклы, используя кадр начала цикла (G79...) после того, как цикл был задан (G81...)."
::msgcat::mcset pb_msg_russian "MC(event,cycle,start,text)"             "Использовать кадр начала цикла, чтобы выполнить цикл"
::msgcat::mcset pb_msg_russian "MC(event,cycle,rapid_to)"               "Ускоренное - в"
::msgcat::mcset pb_msg_russian "MC(event,cycle,retract_to)"             "Отвод - в"
::msgcat::mcset pb_msg_russian "MC(event,cycle,plane_control)"          "Управление плоскостью в цикле"
::msgcat::mcset pb_msg_russian "MC(event,cycle,com_param,name)"         "Общие параметры"
::msgcat::mcset pb_msg_russian "MC(event,cycle,cycle_off,name)"         "Выключение цикла"
::msgcat::mcset pb_msg_russian "MC(event,cycle,plane_chng,name)"        "Смена плоскости в цикле"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill,name)"             "Сверление"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_dwell,name)"       "Задержка при сверлении"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_text,name)"        "Сверление - ввод текста"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_csink,name)"       "Сверление - зенковка"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_deep,name)"        "Глубокое сверление"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_brk_chip,name)"    "Сверление с ломкой стружки"
::msgcat::mcset pb_msg_russian "MC(event,cycle,tap,name)"               "нарезание резьбы метчиком"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore,name)"              "Растачивание"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_dwell,name)"        "Задержка при расточке"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_drag,name)"         "Расточка"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_no_drag,name)"      "Расточка с ориентацией"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_back,name)"         "Обратная расточка"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_manual,name)"       "Ручная расточка"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_manual_dwell,name)" "Ручная расточка с задержкой"
::msgcat::mcset pb_msg_russian "MC(event,cycle,peck_drill,name)"        "Глубокое сверление"
::msgcat::mcset pb_msg_russian "MC(event,cycle,break_chip,name)"        "Ломка стружки"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_dwell_sf,name)"    "Сверление с задержкой (Центровка)"
::msgcat::mcset pb_msg_russian "MC(event,cycle,drill_deep_peck,name)"   "Глубокое сверление (С выводом)"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_ream,name)"         "Расточка (развертка)"
::msgcat::mcset pb_msg_russian "MC(event,cycle,bore_no-drag,name)"      "Расточка с ориентацией"

##------------
## G Code
##
::msgcat::mcset pb_msg_russian "MC(g_code,rapid,name)"                  "Ускоренное перемещение"
::msgcat::mcset pb_msg_russian "MC(g_code,linear,name)"                 "Линейное перемещение"
::msgcat::mcset pb_msg_russian "MC(g_code,circular_clw,name)"           "Круговая интерполяция по ЧС"
::msgcat::mcset pb_msg_russian "MC(g_code,circular_cclw,name)"          "Круговая интерполяция против ЧС"
::msgcat::mcset pb_msg_russian "MC(g_code,delay_sec,name)"              "Задержка (сек.)"
::msgcat::mcset pb_msg_russian "MC(g_code,delay_rev,name)"              "Задержка (об.)"
::msgcat::mcset pb_msg_russian "MC(g_code,pln_xy,name)"                 "Плоскость XY"
::msgcat::mcset pb_msg_russian "MC(g_code,pln_zx,name)"                 "Плоскость ZX"
::msgcat::mcset pb_msg_russian "MC(g_code,pln_yz,name)"                 "Плоскость YZ"
::msgcat::mcset pb_msg_russian "MC(g_code,cutcom_off,name)"             "Выключение коррекции"
::msgcat::mcset pb_msg_russian "MC(g_code,cutcom_left,name)"            "Коррекция слева"
::msgcat::mcset pb_msg_russian "MC(g_code,cutcom_right,name)"           "Коррекция справа"
::msgcat::mcset pb_msg_russian "MC(g_code,length_plus,name)"            "Положительная коррекция длины инструмента"
::msgcat::mcset pb_msg_russian "MC(g_code,length_minus,name)"           "Отрицательная коррекция длины инструмента"
::msgcat::mcset pb_msg_russian "MC(g_code,length_off,name)"             "Выключение коррекции длины инструмента"
::msgcat::mcset pb_msg_russian "MC(g_code,inch,name)"                   "Режим - дюймы"
::msgcat::mcset pb_msg_russian "MC(g_code,metric,name)"                 "Режим - метрический"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_start,name)"            "Код начала цикла"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_off,name)"              "Выключение цикла"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_drill,name)"            "Цикл сверления"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_drill_dwell,name)"      "Цикл сверления с задержкой"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_drill_deep,name)"       "Цикл глубокого сверления"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_drill_bc,name)"         "Цикл сверления с ломкой стружки"
::msgcat::mcset pb_msg_russian "MC(g_code,tap,name)"                    "Цикл нарезания резьбы"
::msgcat::mcset pb_msg_russian "MC(g_code,bore,name)"                   "Цикл растачивания"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_drag,name)"              "Цикл расточки"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_no_drag,name)"           "Цикл расточки с ориентацией"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_dwell,name)"             "Цикл расточки с задержкой"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_manual,name)"            "Цикл расточки с ручным выводом"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_back,name)"              "Цикл обратной расточки"
::msgcat::mcset pb_msg_russian "MC(g_code,bore_manual_dwell,name)"      "Цикл расточки с ручным выводом и задержкой"
::msgcat::mcset pb_msg_russian "MC(g_code,abs,name)"                    "Абсолютный режим"
::msgcat::mcset pb_msg_russian "MC(g_code,inc,name)"                    "Режим в приращениях"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_retract_auto,name)"     "Отвод в цикле (Авто)"
::msgcat::mcset pb_msg_russian "MC(g_code,cycle_retract_manual,name)"   "Отвод в цикле (Вручную)"
::msgcat::mcset pb_msg_russian "MC(g_code,reset,name)"                  "Сброс"
::msgcat::mcset pb_msg_russian "MC(g_code,fr_ipm,name)"                 "Режим подачи IPM"
::msgcat::mcset pb_msg_russian "MC(g_code,fr_ipr,name)"                 "Режим подачи IPR"
::msgcat::mcset pb_msg_russian "MC(g_code,fr_frn,name)"                 "Режим подачи FRN"
::msgcat::mcset pb_msg_russian "MC(g_code,spindle_css,name)"            "Шпиндель ПСвП"
::msgcat::mcset pb_msg_russian "MC(g_code,spindle_rpm,name)"            "Частота вращения шпинделя"
::msgcat::mcset pb_msg_russian "MC(g_code,ret_home,name)"               "Возврат в точку Home"
::msgcat::mcset pb_msg_russian "MC(g_code,cons_thread,name)"            "Постоянная резьба"
::msgcat::mcset pb_msg_russian "MC(g_code,incr_thread,name)"            "Приращение резьбы"
::msgcat::mcset pb_msg_russian "MC(g_code,decr_thread,name)"            "Уменьшающаяся резьба"
::msgcat::mcset pb_msg_russian "MC(g_code,feedmode_in,pm)"              "Режим подачи IPM"
::msgcat::mcset pb_msg_russian "MC(g_code,feedmode_in,pr)"              "Режим подачи IPR"
::msgcat::mcset pb_msg_russian "MC(g_code,feedmode_mm,pm)"              "Режим подачи MMPM"
::msgcat::mcset pb_msg_russian "MC(g_code,feedmode_mm,pr)"              "Режим подачи MMPR"
::msgcat::mcset pb_msg_russian "MC(g_code,feedmode,dpm)"                "Режим подачи DPM"

##------------
## M Code
##
::msgcat::mcset pb_msg_russian "MC(m_code,stop_manual_tc,name)"         "Остановка/Смена инструмента вручную"
::msgcat::mcset pb_msg_russian "MC(m_code,stop,name)"                   "Остановка"
::msgcat::mcset pb_msg_russian "MC(m_code,opt_stop,name)"               "Опциональный останов"
::msgcat::mcset pb_msg_russian "MC(m_code,prog_end,name)"               "Конец программы"
::msgcat::mcset pb_msg_russian "MC(m_code,spindle_clw,name)"            "Включение шпинделя/По часовой стрелке"
::msgcat::mcset pb_msg_russian "MC(m_code,spindle_cclw,name)"           "Включение шпинделя против часовой стрелки"
::msgcat::mcset pb_msg_russian "MC(m_code,lathe_thread,type1)"          "Постоянная резьба"
::msgcat::mcset pb_msg_russian "MC(m_code,lathe_thread,type2)"          "Приращение резьбы"
::msgcat::mcset pb_msg_russian "MC(m_code,lathe_thread,type3)"          "Уменьшающаяся резьба"
::msgcat::mcset pb_msg_russian "MC(m_code,spindle_off,name)"            "Выключение шпинделя"
::msgcat::mcset pb_msg_russian "MC(m_code,tc_retract,name)"             "Смена инструмента/отвод"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_on,name)"             "СОЖ включена"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_fld,name)"            "Подача СОЖ поливом"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_mist,name)"           "Подача СОЖ туманом"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_thru,name)"           "Подача СОЖ через инструмент"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_tap,name)"            "Подача СОЖ через сопла"
::msgcat::mcset pb_msg_russian "MC(m_code,coolant_off,name)"            "СОЖ выключена"
::msgcat::mcset pb_msg_russian "MC(m_code,rewind,name)"                 "Перемотка"
::msgcat::mcset pb_msg_russian "MC(m_code,thread_wire,name)"            "Заправка проволоки"
::msgcat::mcset pb_msg_russian "MC(m_code,cut_wire,name)"               "Обрезка проволоки"
::msgcat::mcset pb_msg_russian "MC(m_code,fls_on,name)"                 "Прокачка включена"
::msgcat::mcset pb_msg_russian "MC(m_code,fls_off,name)"                "Прокачка выключена"
::msgcat::mcset pb_msg_russian "MC(m_code,power_on,name)"               "Включение энергии"
::msgcat::mcset pb_msg_russian "MC(m_code,power_off,name)"              "Выключение энергии"
::msgcat::mcset pb_msg_russian "MC(m_code,wire_on,name)"                "Заправка проволоки"
::msgcat::mcset pb_msg_russian "MC(m_code,wire_off,name)"               "Обрезка проволоки"
::msgcat::mcset pb_msg_russian "MC(m_code,pri_turret,name)"             "Первичная револьверная головка"
::msgcat::mcset pb_msg_russian "MC(m_code,sec_turret,name)"             "Вторичная револьверная головка"

##------------
## UDE
##
::msgcat::mcset pb_msg_russian "MC(ude,editor,enable,Label)"            "Разрешить изменение события задаваемых пользователем"
::msgcat::mcset pb_msg_russian "MC(ude,editor,enable,as_saved,Label)"   "Как сохранено"
::msgcat::mcset pb_msg_russian "MC(ude,editor,TITLE)"                   "Событие задаваемое пользователем"

::msgcat::mcset pb_msg_russian "MC(ude,editor,no_ude)"                  "Нет соответствующего события задаваемого пользователем!"

::msgcat::mcset pb_msg_russian "MC(ude,editor,int,Label)"               "Целое"
::msgcat::mcset pb_msg_russian "MC(ude,editor,int,Context)"             "Добавить новый целочисленный параметр, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,real,Label)"              "Вещественное"
::msgcat::mcset pb_msg_russian "MC(ude,editor,real,Context)"            "Добавить новый вещественный параметр, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,txt,Label)"               "Текст"
::msgcat::mcset pb_msg_russian "MC(ude,editor,txt,Context)"             "Добавить новый текстовый параметр, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,bln,Label)"               "Булевая"
::msgcat::mcset pb_msg_russian "MC(ude,editor,bln,Context)"             "Добавить новый булевый параметр, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,Label)"               "Опция"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,Context)"             "Добавить новый параметр опции, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,pnt,Label)"               "Точка"
::msgcat::mcset pb_msg_russian "MC(ude,editor,pnt,Context)"             "Добавить новый параметр точки, перетащив его мышью в правый список."

::msgcat::mcset pb_msg_russian "MC(ude,editor,trash,Label)"             "Редактор -- мусорная корзина"
::msgcat::mcset pb_msg_russian "MC(ude,editor,trash,Context)"           "Вы можете удалить любые ненужные параметры из правого списка, перемещая их в мусорную корзину."

::msgcat::mcset pb_msg_russian "MC(ude,editor,event,Label)"             "Событие"
::msgcat::mcset pb_msg_russian "MC(ude,editor,event,Context)"           "Вы можете изменить параметры события в меню с помощью MB1."

::msgcat::mcset pb_msg_russian "MC(ude,editor,param,Label)"             "Событие -- параметры"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,Context)"           "Вы можете изменить любой параметр нажатием на правую кнопку мыши или изменить порядок параметров используя перемещение. \n \nПараметры отображаемые ярко-синим цветом являются системными, и эти параметры не могут быть удалены. \nПараметры, отображаемые цветом старого дерева, являются несистемными, и эти параметры могут быть удалены."

::msgcat::mcset pb_msg_russian "MC(ude,editor,param,edit,Label)"        "Параметры -- опция"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,edit,Context)"      "Нажмите кнопку мыши 1, чтобы выбрать опцию по умолчанию. \n Дважды нажмите на кнопку мыши 1, чтобы изменить опцию."
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,editor,Label)"      "Тип параметра: "

::msgcat::mcset pb_msg_russian "MC(ude,editor,pnt,sel,Label)"           "Выбрать"
::msgcat::mcset pb_msg_russian "MC(ude,editor,pnt,dsp,Label)"           "Отобразить"

::msgcat::mcset pb_msg_russian "MC(ude,editor,dlg,ok,Label)"            "ОК"
::msgcat::mcset pb_msg_russian "MC(ude,editor,dlg,bck,Label)"           "Назад"
::msgcat::mcset pb_msg_russian "MC(ude,editor,dlg,cnl,Label)"           "Отмена"

::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,PL,Label)"       "Метка параметра"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,VN,Label)"       "Имя переменной"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,DF,Label)"       "Значение по умолчанию"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,PL,Context)"     "Задайте метку параметра"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,VN,Context)"     "Задайте имя переменной"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,DF,Context)"     "Задайте значение по умолчанию"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,TG)"             "Переключатель"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,TG,B,Label)"     "Переключатель"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,TG,B,Context)"   "Выберите значение переключателя"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ON,Label)"       "Вкл."
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,OFF,Label)"      "Выкл."
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ON,Context)"     "Выберите значение по умолчанию как Вкл."
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,OFF,Context)"    "Выберите значение по умолчанию как Выкл."
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,OL)"             "Список опций"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ADD,Label)"      "Добавить"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,CUT,Label)"      "Вырезать"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,PASTE,Label)"    "Вставить"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ADD,Context)"    "Добавить запись"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,CUT,Context)"    "Вырезать запись"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,PASTE,Context)"  "Вставить запись"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ENTRY,Label)"    "Опция"
::msgcat::mcset pb_msg_russian "MC(ude,editor,paramdlg,ENTRY,Context)"  "Введите запись"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EN,Label)"       "Имя события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EN,Context)"     "Задайте имя события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,PEN,Label)"      "Имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,PEN,Context)"    "Задайте имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,PEN,C,Label)"    "Имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,PEN,C,Context)"  "Этот переключатель позволяет задать имя постпроцессора"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EL,Label)"       "Метка события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EL,Context)"     "Задайте метку события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EL,C,Label)"     "Метка события"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EL,C,Context)"   "Этот переключатель позволяет задать метку события"

::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC,Label)"           "Категория"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC,Context)"         "Этот переключатель позволяет задать категорию"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Фрезерный"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Сверлильный"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Токарный"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "ПЭЭО"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Задание фрезерной категории"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Задание сверлильной категории"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Задание токарной категории"
::msgcat::mcset pb_msg_russian "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Задание ЭЭО категории"

::msgcat::mcset pb_msg_russian "MC(ude,editor,EDIT)"                    "Изменить событие"
::msgcat::mcset pb_msg_russian "MC(ude,editor,CREATE)"                  "Создать событие управления станком"
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,HELP)"              "Справка"
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,EDIT)"              "Изменить параметры заданные пользователем..."
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,EDIT)"              "Изменить..."
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,VIEW)"              "Вид..."
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,DELETE)"            "Удалить"
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,CREATE)"            "Создать новое событие управления станком..."
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,IMPORT)"            "Импорт событий управления станком..."
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_BLANK)"         "Имя события не может быть пустым!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_SAMENAME)"      "Имя события существует!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,popup,MSG_SameHandler)"   "Обработчик событий существует! \nИзмените имя события или постпроцессора, если оно проверено!"
::msgcat::mcset pb_msg_russian "MC(ude,validate)"                       "В этом событии нет параметров!"
::msgcat::mcset pb_msg_russian "MC(ude,prev,tab,Label)"                 "События, задаваемые пользователем"
::msgcat::mcset pb_msg_russian "MC(ude,prev,ude,Label)"                 "События управления станком"
::msgcat::mcset pb_msg_russian "MC(ude,prev,udc,Label)"                 "Циклы, заданные пользователем"
::msgcat::mcset pb_msg_russian "MC(ude,prev,mc,Label)"                  "Системные события управления станком"
::msgcat::mcset pb_msg_russian "MC(ude,prev,nmc,Label)"                 "Не системные события управления станком"
::msgcat::mcset pb_msg_russian "MC(udc,prev,sys,Label)"                 "Системные циклы"
::msgcat::mcset pb_msg_russian "MC(udc,prev,nsys,Label)"                "Не системные циклы"
::msgcat::mcset pb_msg_russian "MC(ude,prev,Status)"                    "Выберите запись для описания"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,MSG_BLANK)"           "Строка опции не может быть пустой!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,MSG_SAME)"            "Строка опции существует!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,MSG_PST_SAME)"        "Опция, которую вы вставляете, существует!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,MSG_IDENTICAL)"       "Некоторые опции одинаковые!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,opt,NO_OPT)"              "В списке нет опций!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_NO_VNAME)"      "Имя переменной не может быть пустым!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Имя переменной уже существует!"
::msgcat::mcset pb_msg_russian "MC(ude,editor,spindle_css,INFO)"        "Это событие является общим с событием задаваемым пользователем \"Частота вращения шпинделя\""
::msgcat::mcset pb_msg_russian "MC(ude,import,ihr,Label)"               "Наследовать события, задаваемые пользователем из постпроцессора"

::msgcat::mcset pb_msg_russian "MC(ude,import,ihr,Context)"             "Эта опция позволяет постпроцессору наследовать определения событий задаваемых пользователем и их обработчики из другого постпроцессора."

::msgcat::mcset pb_msg_russian "MC(ude,import,sel,Label)"               "Выберите постпроцессор"

::msgcat::mcset pb_msg_russian "MC(ude,import,sel,Context)"             "Выберите необходимый файл PUI постпроцессора. Рекомендуется, чтобы все связанные с постпроцессором файлы (PUI, Def, Tcl & CDL), были расположены в том же каталоге (папке) в процессе выполнения вывода на постпроцессор."

::msgcat::mcset pb_msg_russian "MC(ude,import,name_cdl,Label)"          "Имя файл CDL"

::msgcat::mcset pb_msg_russian "MC(ude,import,name_cdl,Context)"        "Путь и имя файла CDL, который связан с выбранным постпроцессором и на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset pb_msg_russian "MC(ude,import,name_def,Label)"          "Имя файла описания"
::msgcat::mcset pb_msg_russian "MC(ude,import,name_def,Context)"        "Путь и имя файла описания выбранного постпроцессора и на который будет создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset pb_msg_russian "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_russian "MC(ude,import,ihr_pst,Label)"           "Постпроцессор"
::msgcat::mcset pb_msg_russian "MC(ude,import,ihr_folder,Label)"        "Папка"
::msgcat::mcset pb_msg_russian "MC(ude,import,own_folder,Label)"        "Папка"
::msgcat::mcset pb_msg_russian "MC(ude,import,own,Label)"               "Включить собственный файл CDL"

::msgcat::mcset pb_msg_russian "MC(ude,import,own,Context)"             "Эта опция позволяет постпроцессору включать ссылку на собственный файл CDL в файле описания."

::msgcat::mcset pb_msg_russian "MC(ude,import,own_ent,Label)"           "Собственный файл CDL"

::msgcat::mcset pb_msg_russian "MC(ude,import,own_ent,Context)"         "Путь и имя файла CDL, который связан с выбранным постпроцессором и на который создана ссылка (INCLUDE) в файле описания этого постпроцессора. Имя пути должно начаться с системной переменной UG (\\\$UGII) или не иметь пути. Когда путь не задан, будет использоваться переменная UGII_CAM_FILE_SEARCH_PATH текущей сессии UG/NX."

::msgcat::mcset pb_msg_russian "MC(ude,import,sel,pui,status)"          "Выбрать файл PUI"
::msgcat::mcset pb_msg_russian "MC(ude,import,sel,cdl,status)"          "Выбрать файл CDL"

##---------
## UDC
##
::msgcat::mcset pb_msg_russian "MC(udc,editor,TITLE)"                   "Цикл заданный пользователем"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CREATE)"                  "Создать цикл задаваемый пользователем"
::msgcat::mcset pb_msg_russian "MC(udc,editor,TYPE)"                    "Тип цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,type,UDC)"                "Заданный пользователем"
::msgcat::mcset pb_msg_russian "MC(udc,editor,type,SYSUDC)"             "Заданное системой"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCLBL,Label)"            "Метка цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCNAME,Label)"           "Имя цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCLBL,Context)"          "Задайте метку цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCNAME,Context)"         "Задайте имя цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCLBL,C,Label)"          "Метка цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,CYCLBL,C,Context)"        "Этот переключатель позволяет задать метку цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,EDIT)"              "Изменить параметры заданные пользователем..."
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,MSG_BLANK)"         "Имя цикла не может быть пустым!"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,MSG_SAMENAME)"      "Имя цикла уже существует!"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,MSG_SameHandler)"   "Обработчик событий существует!\n Измените имя события цикла!"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Имя цикла принадлежит типу системного цикла!"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Этот вид системного цикла существует!"
::msgcat::mcset pb_msg_russian "MC(udc,editor,EDIT)"                    "Изменить событие цикла"
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,CREATE)"            "Создать новый цикл задаваемый пользователем..."
::msgcat::mcset pb_msg_russian "MC(udc,editor,popup,IMPORT)"            "Импорт циклов задаваемых пользователем..."
::msgcat::mcset pb_msg_russian "MC(udc,drill,csink,INFO)"               "Это событие является общим обработчиком для сверления!"
::msgcat::mcset pb_msg_russian "MC(udc,drill,simulate,INFO)"            "Это событие - один из способов эмуляции циклов!"
::msgcat::mcset pb_msg_russian "MC(udc,drill,dwell,INFO)"               "Это событие является общим с циклом задаваемым пользователем "


#######
# IS&V
#######
::msgcat::mcset pb_msg_russian "MC(isv,tab,label)"                      "Виртуальная система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,Status)"                         "Задайте параметры для встроенной симуляции и проверки."
::msgcat::mcset pb_msg_russian "MC(isv,review,Status)"                  "Просмотр команд виртуальной системы ЧПУ"

::msgcat::mcset pb_msg_russian "MC(isv,setup,Label)"                    "Конфигурация"
::msgcat::mcset pb_msg_russian "MC(isv,vnc_command,Label)"              "Команды виртуальной системы ЧПУ"
####################
# General Definition
####################
::msgcat::mcset pb_msg_russian "MC(isv,select_Main)"                    "Выберите мастер-файл VNC для зависимого VNC."
::msgcat::mcset pb_msg_russian "MC(isv,setup,machine,Label)"            "Станок"
::msgcat::mcset pb_msg_russian "MC(isv,setup,component,Label)"          "Установка инструмента"
::msgcat::mcset pb_msg_russian "MC(isv,setup,mac_zcs_frame,Label)"      "Ссылочная нулевая точка программы"
::msgcat::mcset pb_msg_russian "MC(isv,setup,mac_zcs,Label)"            "Компонент"
::msgcat::mcset pb_msg_russian "MC(isv,setup,mac_zcs,Context)"          "Задайте компонент как ссылочную базу ZCS. Это должен быть неповоротный элемент, к которому прямо или косвенно крепится деталь в дереве кинематики."
::msgcat::mcset pb_msg_russian "MC(isv,setup,spin_com,Label)"           "Компонент"
::msgcat::mcset pb_msg_russian "MC(isv,setup,spin_com,Context)"         "Задайте компонент, к которому будет крепиться инструмент. Это должен быть компонент шпинделя для фрезерного постпроцессора и компонент револьвера для токарного постпроцессора."

::msgcat::mcset pb_msg_russian "MC(isv,setup,spin_jct,Label)"           "Соединение"
::msgcat::mcset pb_msg_russian "MC(isv,setup,spin_jct,Context)"         "Задает соединение для крепления инструмента. Это соединение в центре грани шпинделя для фрезерных постпроцессоров. Это соединение вращения револьвера для токарных постпроцессоров. Это будет точка крепления инструмента, если револьвер не подвижен."

::msgcat::mcset pb_msg_russian "MC(isv,setup,axis_name,Label)"          "Ось, заданная на станке"
::msgcat::mcset pb_msg_russian "MC(isv,setup,axis_name,Context)"        "Задайте имена осей, чтобы согласовать вашу конфигурацию кинематики станка"




::msgcat::mcset pb_msg_russian "MC(isv,setup,axis_frm,Label)"           "Имена осей станка с ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,setup,rev_fourth,Label)"         "Вращение в противоположную сторону"
::msgcat::mcset pb_msg_russian "MC(isv,setup,rev_fourth,Context)"       "Задайте направление вращения поворотной оси, оно может быть обратным или нормальным. Это применяется только для поворотного стола."
::msgcat::mcset pb_msg_russian "MC(isv,setup,rev_fifth,Label)"          "Вращение в противоположную сторону"

::msgcat::mcset pb_msg_russian "MC(isv,setup,fourth_limit,Label)"       "Предел вращения"
::msgcat::mcset pb_msg_russian "MC(isv,setup,fourth_limit,Context)"     "Задайте, есть ли у этой поворотной оси пределы поворота"
::msgcat::mcset pb_msg_russian "MC(isv,setup,fifth_limit,Label)"        "Предел вращения"
::msgcat::mcset pb_msg_russian "MC(isv,setup,limiton,Label)"            "Да"
::msgcat::mcset pb_msg_russian "MC(isv,setup,limitoff,Label)"           "Нет"
::msgcat::mcset pb_msg_russian "MC(isv,setup,fourth_table,Label)"       "4-я ось"
::msgcat::mcset pb_msg_russian "MC(isv,setup,fifth_table,Label)"        "5-я ось"
::msgcat::mcset pb_msg_russian "MC(isv,setup,header,Label)"             " Стол "
::msgcat::mcset pb_msg_russian "MC(isv,setup,intialization,Label)"      "Система ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,setup,general_def,Label)"        "Начальная установка"
::msgcat::mcset pb_msg_russian "MC(isv,setup,advanced_def,Label)"       "Другие опции"
::msgcat::mcset pb_msg_russian "MC(isv,setup,InputOutput,Label)"        "Специальные коды ЧПУ"

::msgcat::mcset pb_msg_russian "MC(isv,setup,program,Label)"            "Описание программы по умолчанию"
::msgcat::mcset pb_msg_russian "MC(isv,setup,output,Label)"             "Экспорт программы описания"
::msgcat::mcset pb_msg_russian "MC(isv,setup,output,Context)"           "Вывод описания программы в файл"
::msgcat::mcset pb_msg_russian "MC(isv,setup,input,Label)"              "Импорт программы описания"
::msgcat::mcset pb_msg_russian "MC(isv,setup,input,Context)"            "Вызов программы определения из файла"
::msgcat::mcset pb_msg_russian "MC(isv,setup,file_err,Msg)"             "Выбранный файл не соответствует типу файла описания программы по умолчанию, Вы хотите продолжить?"
::msgcat::mcset pb_msg_russian "MC(isv,setup,wcs,Label)"                "Смещение нуля"
::msgcat::mcset pb_msg_russian "MC(isv,setup,tool,Label)"               "Данные инструмента"
::msgcat::mcset pb_msg_russian "MC(isv,setup,g_code,Label)"             "Специальный G-код"
::msgcat::mcset pb_msg_russian "MC(isv,setup,special_vnc,Label)"        "Специальный код ЧПУ"

::msgcat::mcset pb_msg_russian "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_russian "MC(isv,setup,initial_motion,Label)"     "Перемещение"
::msgcat::mcset pb_msg_russian "MC(isv,setup,initial_motion,Context)"   "Задайте начальное перемещение станка"

::msgcat::mcset pb_msg_russian "MC(isv,setup,spindle,frame,Label)"      "Шпиндель"
::msgcat::mcset pb_msg_russian "MC(isv,setup,spindle_mode,Label)"       "Режим"
::msgcat::mcset pb_msg_russian "MC(isv,setup,spindle_direction,Label)"  "Направление"
::msgcat::mcset pb_msg_russian "MC(isv,setup,spindle,frame,Context)"    "Задайте начальные единицы задания оборотов шпинделя и направление вращения"

::msgcat::mcset pb_msg_russian "MC(isv,setup,feedrate_mode,Label)"      "Режим подачи"
::msgcat::mcset pb_msg_russian "MC(isv,setup,feedrate_mode,Context)"    "Задайте начальные единицы измерения подачи"

::msgcat::mcset pb_msg_russian "MC(isv,setup,boolean,frame,Label)"      "Задать булевою запись"
::msgcat::mcset pb_msg_russian "MC(isv,setup,power_on_wcs,Label)"       "Включение энергии РСК  "
::msgcat::mcset pb_msg_russian "MC(isv,setup,power_on_wcs,Context)"     "0 указывает, что будет использоваться значение нулевой точки станка по умолчанию\n 1 указывает, что будет использоваться первое заданное пользователем смещение нулевой точки (рабочей системы координат)"

::msgcat::mcset pb_msg_russian "MC(isv,setup,use_s_leader,Label)"       "Используется S"
::msgcat::mcset pb_msg_russian "MC(isv,setup,use_f_leader,Label)"       "Используется F"


::msgcat::mcset pb_msg_russian "MC(isv,setup,dog_leg,Label)"            "Резкое изменение ускоренного перемещения"
::msgcat::mcset pb_msg_russian "MC(isv,setup,dog_leg,Context)"          "Включение этой опции задает логическое позиционирование при ускоренных перемещениях; выключение этой опции задает ускоренное перемещение согласно коду ЧПУ (из точки в точку по прямой)."

::msgcat::mcset pb_msg_russian "MC(isv,setup,dog_leg,yes)"              "Да"
::msgcat::mcset pb_msg_russian "MC(isv,setup,dog_leg,no)"               "Нет"

::msgcat::mcset pb_msg_russian "MC(isv,setup,on_off_frame,Label)"       "Задать Включение/Выключение"
::msgcat::mcset pb_msg_russian "MC(isv,setup,stroke_limit,Label)"       "Предел хода"
::msgcat::mcset pb_msg_russian "MC(isv,setup,cutcom,Label)"             "Коррекция"
::msgcat::mcset pb_msg_russian "MC(isv,setup,tl_adjust,Label)"          "Регистр коррекции длины инструмента"
::msgcat::mcset pb_msg_russian "MC(isv,setup,scale,Label)"              "Масштаб"
::msgcat::mcset pb_msg_russian "MC(isv,setup,macro_modal,Label)"        "Макро задания модальности"
::msgcat::mcset pb_msg_russian "MC(isv,setup,wcs_rotate,Label)"         "Вращение РСК"
::msgcat::mcset pb_msg_russian "MC(isv,setup,cycle,Label)"              "Цикл"

::msgcat::mcset pb_msg_russian "MC(isv,setup,initial_mode,frame,Label)"     "Режим ввода"
::msgcat::mcset pb_msg_russian "MC(isv,setup,initial_mode,frame,Context)"   "Задайте начальный режим работы в абсолютных координатах или в приращениях"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,rewindstop,Label)"   "Код остановки программы с перемоткой"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,rewindstop,Context)" "Задайте остановки программы с перемоткой"

::msgcat::mcset pb_msg_russian "MC(isv,control_var,frame,Label)"        "Переменные управления"

::msgcat::mcset pb_msg_russian "MC(isv,sign_define,convarleader,Label)"     "Символ адреса"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,convarleader,Context)"   "Задайте переменные системы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,conequ,Label)"           "Символ равно"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,conequ,Context)"         "Задайте знак для символа Равно"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,percent,Label)"          "Символ процента %"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,leaderjing,Label)"       "Sharp #"
::msgcat::mcset pb_msg_russian "MC(isv,sign_define,text_string,Label)"      "Текстовая строка"

::msgcat::mcset pb_msg_russian "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_russian "MC(isv,input_mode,Label)"               "Начальный режим"
::msgcat::mcset pb_msg_russian "MC(isv,absolute_mode,Label)"            "Абсолютный"
::msgcat::mcset pb_msg_russian "MC(isv,incremental_style,frame,Label)"  "Режим в приращениях"

::msgcat::mcset pb_msg_russian "MC(isv,incremental_mode,Label)"         "Приращение"
::msgcat::mcset pb_msg_russian "MC(isv,incremental_gcode,Label)"        "G-код"
::msgcat::mcset pb_msg_russian "MC(isv,incremental_gcode,Context)"      "Используйте команды G90 G91, чтобы включить абсолютный режим или режим в приращениях"
::msgcat::mcset pb_msg_russian "MC(isv,incremental_uvw,Label)"          "Специальный адрес"
::msgcat::mcset pb_msg_russian "MC(isv,incremental_uvw,Context)"        "Использовать специальный адрес для абсолютного режима или режима работы в приращениях. Например: Адреса X Y Z указывают на абсолютный режим, адреса U V W, указывает на режим в приращения."
::msgcat::mcset pb_msg_russian "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_russian "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_russian "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_russian "MC(isv,incr_a,Label)"                   "4-я ось "
::msgcat::mcset pb_msg_russian "MC(isv,incr_b,Label)"                   "5-я ось "

::msgcat::mcset pb_msg_russian "MC(isv,incr_x,Context)"                 "Задайте специальный адрес оси X, который используется для вывода координат оси в приращении"
::msgcat::mcset pb_msg_russian "MC(isv,incr_y,Context)"                 "Задайте специальный адрес оси Y, который используется для вывода координат оси в приращении"
::msgcat::mcset pb_msg_russian "MC(isv,incr_z,Context)"                 "Задайте специальный адрес оси Z, который используется для вывода координат оси в приращении"
::msgcat::mcset pb_msg_russian "MC(isv,incr_a,Context)"                 "Задайте специальный адрес четвертой оси, который используется для вывода координат оси в приращении"
::msgcat::mcset pb_msg_russian "MC(isv,incr_b,Context)"                 "Задайте специальный адрес пятой оси, который используется для вывода координат оси в приращении"
::msgcat::mcset pb_msg_russian "MC(isv,vnc_mes,frame,Label)"            "Вывод сообщений виртуальной системы ЧПУ"

::msgcat::mcset pb_msg_russian "MC(isv,vnc_message,Label)"              "Список сообщений виртуальной системы ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,vnc_message,Context)"            "Если эта опция включена, то все сообщения отладки виртуальной системы ЧПУ будут отображаться в процессе симуляции в окне сообщений."

::msgcat::mcset pb_msg_russian "MC(isv,vnc_mes,prefix,Label)"           "Префикс сообщения"
::msgcat::mcset pb_msg_russian "MC(isv,spec_desc,Label)"                "Описание"
::msgcat::mcset pb_msg_russian "MC(isv,spec_codelist,Label)"            "Список кодов"
::msgcat::mcset pb_msg_russian "MC(isv,spec_nccode,Label)"              "Коды ЧПУ / строка"

################
# WCS Definition
################
::msgcat::mcset pb_msg_russian "MC(isv,machine_zero,offset,Label)"      "Смещение нулевой точки станка от\nточки нулевого соединения станка"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,frame,Label)"         "Смещение нуля"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_leader,Label)"               " Код "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,origin_x,Label)"      " X-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,origin_y,Label)"      " Y-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,origin_z,Label)"      " Z-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,a_offset,Label)"      " А-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,b_offset,Label)"      " B-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,c_offset,Label)"      " C-смещение  "
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,wcs_num,Label)"       "Система координат"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,wcs_num,Context)"     "Задайте номер нулевой точки, которая должна быть добавлена"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,wcs_add,Label)"       "Добавить"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,wcs_add,Context)"     "Добавьте новую систему координат смещения нуля, задайте ее позицию"
::msgcat::mcset pb_msg_russian "MC(isv,wcs_offset,wcs_err,Msg)"         "Этот номер системы координат уже существует!"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,frame,Label)"          "Информация об инструменте"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,tool_entry,Label)"     "Введите новое имя инструмента"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,tool_name,Label)"      "       Имя       "

::msgcat::mcset pb_msg_russian "MC(isv,tool_info,tool_num,Label)"       " Инструмент "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,add_tool,Label)"       "Добавить"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,tool_diameter,Label)"  " Диаметр "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,offset_usder,Label)"   "   Смещения вершины   "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,carrier_id,Label)"     " Идентификатор магазина "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,pocket_id,Label)"      " Идентификатор кармана "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,cutcom_reg,Label)"     "     Коррекция     "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,cutreg,Label)"         "Регистр "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,cutval,Label)"         "Смещение "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,adjust_reg,Label)"     " Настройка длины "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,tool_type,Label)"      "   Тип   "
::msgcat::mcset pb_msg_russian "MC(isv,prog,setup,Label)"               "Описание программы по умолчанию"
::msgcat::mcset pb_msg_russian "MC(isv,prog,setup_right,Label)"         "Описание программы"
::msgcat::mcset pb_msg_russian "MC(isv,output,setup_data,Label)"        "Задайте файл описания программы"
::msgcat::mcset pb_msg_russian "MC(isv,input,setup_data,Label)"         "Выберите файл описания программы"

::msgcat::mcset pb_msg_russian "MC(isv,tool_info,toolnum,Label)"        "Номер инструмента  "
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,toolnum,Context)"      "Задайте номер инструмента, который должен быть добавлен"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,add_tool,Context)"     "Добавьте новый инструмент, задайте его параметры"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,add_err,Msg)"          "Этот номер инструмента уже существует!"
::msgcat::mcset pb_msg_russian "MC(isv,tool_info,name_err,Msg)"         "Имя инструмента не может быть пустым!"

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_russian "MC(isv,g_code,frame,Label)"             "Специальный G-код"
::msgcat::mcset pb_msg_russian "MC(isv,g_code,frame,Context)"           "Задайте специальные G-коды, которые используются в симуляции"
::msgcat::mcset pb_msg_russian "MC(isv,g_code,from_home,Label)"         "Начало из точки Home"
::msgcat::mcset pb_msg_russian "MC(isv,g_code,return_home,Label)"       "Возврат в точку Home"
::msgcat::mcset pb_msg_russian "MC(isv,g_code,mach_wcs,Label)"          "Перемещение СК станка"
::msgcat::mcset pb_msg_russian "MC(isv,g_code,set_local,Label)"         "Задание локальных координат"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,frame,Label)"       "Специальные команды ЧПУ"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,frame,Context)"     "Команды ЧПУ для управления специальными устройствами"


::msgcat::mcset pb_msg_russian "MC(isv,spec_pre,frame,Label)"           "Команды препроцессора"
::msgcat::mcset pb_msg_russian "MC(isv,spec_pre,frame,Context)"         "Список команд включает все символы или обозначения, который должны быть обработаны прежде, чем кадр будет рассчитан для вывода координат"

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,add,Label)"         "Добавить"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,edit,Label)"        "Изменить"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,delete,Label)"      "Удалить"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,title,Label)"       "Специальная команда для других устройств"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,add_sim,Label)"     "Добавить команду SIM @Cursor"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,init_sim,Label)"    "Выберите одну команду"

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,preleader,Label)"   "Символ адреса"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,preleader,Context)" "Задайте адрес для препроцессорной команды, задаваемой пользователем."

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,precode,Label)"     "Код"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,precode,Context)"   "Задайте адрес для препроцессорной команды, задаваемой пользователем."

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,leader,Label)"      "Символ адреса"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,leader,Context)"    "Задайте адрес для команды, задаваемой пользователем."

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,code,Label)"        "Код"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,code,Context)"      "Задайте адрес для команды, задаваемой пользователем."

::msgcat::mcset pb_msg_russian "MC(isv,spec_command,add,Context)"       "Добавить новую команду задаваемую пользователем"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,add_err,Msg)"       "Этот символ уже обработан!"
::msgcat::mcset pb_msg_russian "MC(isv,spec_command,sel_err,Msg)"       "Выберите команду"
::msgcat::mcset pb_msg_russian "MC(isv,export,error,title)"             "Предупреждение"

::msgcat::mcset pb_msg_russian "MC(isv,tool_table,title,Label)"         "Таблица инструмента"
::msgcat::mcset pb_msg_russian "MC(isv,ex_editor,warning,Msg)"          "Это команда VNC, генерируемая системой. Изменения не будут сохранены."


# - Languages
#
::msgcat::mcset pb_msg_russian "MC(language,Label)"                     "Язык"
::msgcat::mcset pb_msg_russian "MC(pb_msg_english)"                     "Английский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_french)"                      "Французский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_german)"                      "Немецкий"
::msgcat::mcset pb_msg_russian "MC(pb_msg_italian)"                     "Итальянский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_japanese)"                    "Японский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_korean)"                      "Корейский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_russian)"                     "Русский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_simple_chinese)"              "Упрощенный китайский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_spanish)"                     "Испанский"
::msgcat::mcset pb_msg_russian "MC(pb_msg_traditional_chinese)"         "Традиционный китайский"

### Exit Options Dialog
::msgcat::mcset pb_msg_russian "MC(exit,options,Label)"                 "Опции выхода"
::msgcat::mcset pb_msg_russian "MC(exit,options,SaveAll,Label)"         "Выход с сохранением всех"
::msgcat::mcset pb_msg_russian "MC(exit,options,SaveNone,Label)"        "Выход без сохранения"
::msgcat::mcset pb_msg_russian "MC(exit,options,SaveSelect,Label)"      "Выход с сохранением выбранных"

### OptionMenu Items
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Other)"       "Другой"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,None)"        "Нет"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,RT_R)"        "Ускоренное перемещение & R"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Rapid)"       "Ускоренное"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,RS)"          "Ускоренное перемещение шпинделя"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,C_off_RS)"    "Выключение цикла при ускоренном перемещении шпинделя"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Auto)"        "Авто"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Abs_Inc)"     "Абсолютные/приращения"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Abs_Only)"    "Только абсолютные"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Inc_Only)"    "Только приращения"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,SD)"          "Кратчайшее расстояние"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,AP)"          "Всегда положительный"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,AN)"          "Всегда отрицательный"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Z_Axis)"      "Z ось"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,+X_Axis)"     "+X ось"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,-X_Axis)"     "-X ось"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,Y_Axis)"      "Y ось"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,MDD)"         "Направление задается значением"
::msgcat::mcset pb_msg_russian "MC(optionMenu,item,SDD)"         "Направление задается знаком"

