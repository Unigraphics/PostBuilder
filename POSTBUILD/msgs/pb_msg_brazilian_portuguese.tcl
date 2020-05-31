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
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "Nomes de arquivos que contêm caracteres especiais não são suportados!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "O próprio componente da publicação pode não ser selecionado nesta inclusão!"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Arquivo de alerta"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "Saída NC"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Suprimir verificação da publicação atual"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Integrar mensagens de depuração da publicação"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Desativar mudança de licença para a publicação atual"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Controle de licença"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Incluir outro arquivo CDL ou DEF"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Profundidade de Punção"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Quebra-Cavaco de Punção"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Flutuação de Punção"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Profundidade de Punção"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Quebra-Cavaco de Punção"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Detectar mudança no eixo da ferramenta entre os orifícios"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Corte"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Início do Caminho Subop"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Final do Caminho Subop"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Início do Contorno"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Final do Contorno"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Diversos"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Desbaste com Torno"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Propriedades da Coluna"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "O UDE para uma coluna de fresa ou de torno não pode ser especificado com apenas uma categoria \"Wedm\"!"

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Detectar Alteração do Plano de Trabalho para Inferior"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "O formato não pode acomodar o valor das expressões"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Altere o Formato do Endereço relacionado antes de sair desta página ou salvar esta coluna!"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Modifique o Formato antes de sair desta página ou salvar esta coluna!"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Altere o Formado do Endereço relacionado antes de entrar nesta página!"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Os nomes dos seguintes Blocos excederam o limite de comprimento:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Os nomes das seguintes Palavras excederam o limite de comprimento:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Verificando o nome do Bloco e da Palavra"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Alguns nomes de Blocos ou Palavras excederam o limite de comprimento."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "O comprimento da sequência excedeu o limite."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Incluir Outro Arquivo CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Selecione a opção \\\"Novo\\\" do menu suspenso (clique com o botão direito do mouse) para incluir outros arquivos CDL com esta coluna."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "Herdar UDE Da Coluna A"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Selecione a opção \\\"Novo\\\" do menu suspenso (clique com o botão direito do mouse) para herdar definições de UDE e manipuladores associados de uma coluna."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Acima"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Abaixo"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "O arquivo CDL especificado já foi incluído!"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Vincular Variáveis Tcl às Variáveis C"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Um conjunto de variáveis Tcl alteradas frequentemente (por exemplo, \\\"mom_pos\\\") pode ser vinculado diretamente às variáveis C internas para melhorar o desempenho do pós-processamento. Entretanto, determinadas restrições devem ser observadas para evitar possíveis erros e diferenças na saída NC."

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Verificar a Resolução do Movimento Linear/Giratório"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "A configuração do formato pode não acomodar a saída para a \"Resolução do Movimento Linear\"."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "A configuração do formato pode não acomodar a saída para a \"Resolução do Movimento Giratório\"."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Digitar descrição para os comandos personalizados exportados"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Descrição"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Excluir Todos Os Elementos Ativos Nesta Fila"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Condição de Saída"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Novo..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Editar..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Remover..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Especificar um nome diferente. \nO comando da condição de saída deve ser prefixado com"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Interpolação de Linearização"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Ângulo de Rotação"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Os pontos de interpolação serão calculados com base na distribuição dos ângulos inicial e final dos eixos de rotação."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Eixo da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Os pontos de interpolação serão calculados com base na distribuição dos vetores inicial e final do eixo da ferramenta."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Continuar"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Cancelar"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Tolerância Padrão"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Tolerância de Linearização Padrão"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "POL"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Criar Processador da Coluna Subordinada Nova "
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Coluna Subordinada"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Somente Unidades Subpost"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "A nova coluna subordinada para unidades de saída alternativa deve ser nomeada\nadicionando o sufixo \"__MM\" ou \"__POL\" ao nome da coluna principal."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Unidade de Saída Alternativa"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Coluna Principal"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "Somente uma coluna principal completa pode ser usada para criar uma coluna subordinada nova!"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "A coluna principal deve ser criada ou salva\nno Post Builder versão 8.0 ou mais recente."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "A coluna principal deve ser especificada para a criação de uma coluna subordinada!"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Unidades de Saída de Subpost :"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Parâmetros das Unidades "
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Taxa de Alimentação"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Subpost de Unidades Alternativas Opcionais"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "Padrão"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "O nome padrão da subpost de unidades alternativas será <nome da coluna>_MM ou <nome da coluna>_POL"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Especificar"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Especificar o nome de uma subpost de unidades alternativas"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Selecionar Nome"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Somente uma subpost de unidades alternativas pode ser selecionada!"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "A subpost selecionada não suporta as unidades de saída alternativas para esta coluna!"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Subpost de Unidades Alternativas"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "O NX Post usará a subpost de unidades, se fornecida, para processar as unidades de saída alternativas para esta coluna."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Ação Definida pelo Usuário para Violação do Limite do  Eixo"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Mover Hélice"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "Expressões usadas nos Endereços"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "não serão afetadas pela alteração desta opção!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Esta ação vai restaurar a lista de códigos NC especiais e\nseus manipuladores para especificar quando esta coluna foi aberta ou criada.\n\n Você deseja continuar?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Esta ação vai restaurar a lista de códigos NC especiais e\nseus manipuladores para especificar quando esta página foi visitada pela última vez.\n\n Você deseja continuar?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "O Nome do Objeto Já Existe... Operação de Colar Inválida!"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Escolher Uma Família de Controlador "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Este arquivo não contém nenhum comando VNC novo ou diferente!"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "Este arquivo não contém nenhum comando personalizado novo ou diferente!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Os nomes das ferramentas não podem ser os mesmos!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "Você não é o autor desta coluna. \nVocê não vai ter permissão para renomeá-la ou alterar a sua licença."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "O nome do arquivo tcl do usuário deve ser especificado."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "Existem entradas vazias nesta página de parâmetros."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "A sequência que você está tentando colar pode ter\nexcedido o limite de comprimento ou\ncontém múltiplas linhas ou caracteres inválidos."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "A primeira letra do nome do bloco não pode ser maiúscula!\n Especifique um nome diferente."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Definido pelo usuário"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Manipulador"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Esse arquivo de usuário não existe!"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Incluir Controlador NC Virtual"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Sinal de Igual (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "Movimento NURBS"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Flutuação de Punção"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Rosca"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "O agrupamento aninhado não é suportado!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Mapa de bits"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Adicione um novo parâmetro de mapa de bits, arrastando-o para a lista à direita."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Grupo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Adicione um novo parâmetro de agrupamento, arrastando-o para a lista à direita."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Descrição"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Especificar informação do evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "Especificar a URL para a descrição do evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "O arquivo de imagem deve estar no formato BMP!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "O nome do arquivo de mapa de bits não deve conter um caminho de diretório!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "O nome da variável deve começar com uma letra."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "O nome da variável não deve usar uma palavra chave: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Status"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Vetor "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Adicione um novo parâmetro de vetor, arrastando-o para a lista à direita."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "A URL deve ter o formato \"http://*\" ou \"file://*\", e não deve conter nenhuma barra invertida."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "A descrição e a URL devem ser especificadas!"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "A configuração do eixo deve ser selecionada para uma ferramenta de máquina."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Família do Controlador "
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Macro"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Adicionar Texto de Prefixo"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Editar Texto de Prefixo"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Prefixo"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Suprimir Número de Sequência"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Personalizar a Macro"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Personalizar a Macro"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Macro"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "A expressão para um parâmetro de Macro não deve ficar em branco."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Nome da Macro"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Nome de Saída"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Lista de Parâmetros"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Separador"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Caractere Inicial"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Caractere Final"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Atributo de Saída"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Nome dos Parâmetros de Saída"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Vincular Caractere"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Parâmetro"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Expressão"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Novo"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "O nome da macro não deve conter espaços!"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "O nome da macro não deve ficar em branco!"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "O nome da macro deve conter somente caracteres alfabéticos, dígitos e sublinhados!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "O nome do nó deve começar com uma letra maiúscula!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "O nome do nó aceita somente caracteres alfabéticos, dígitos e sublinhados!"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Informações"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Mostrar informações do objeto."
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "Não há informações fornecidas para esta Macro."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigráficos"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Versão"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "Selecionar a opção Novo ou Abrir no menu de Arquivo."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "Salvar a Coluna."

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Arquivo"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Novo, Abrir, Salvar,\n Salvar\ Como, Fechar e Sair"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Novo, Abrir, Salvar,\n Salvar\ Como, Fechar e Sair"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Novo ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Criar uma nova Coluna."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Criar uma nova Coluna."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Criando uma Coluna Nova..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Abrir ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Editar uma Coluna existente."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Editar uma Coluna existente."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Abrindo a Coluna..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "Importar MDFA... "
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Criar uma Coluna nova a partir do MDFA."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Criar uma Coluna nova a partir do MDFA."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Salvar"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "Salvar a Coluna em progresso."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "Salvar a Coluna em progresso."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "Salvando a Coluna..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Salvar Como ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "Salvar a Coluna com um nome novo."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "Salvar a Coluna com um nome novo."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Fechar"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "Fechar a Coluna em progresso."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "Fechar a Coluna em progresso."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Sair"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Finalizar o Post Builder."
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Finalizar o Post Builder."

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Colunas Abertas Recentemente"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Editar um Coluna visitada anteriormente."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Editar um Coluna visitada nas sessões anteriores do Post Builder."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Opções"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Validar Comandos\ Personalizados\ , Coluna\ de Backup"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "A lista de edição de colunas"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Propriedades"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Propriedades"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Propriedades"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "Consultor de Coluna"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "Consultor de coluna"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "Habilitar/desabilitar o Consultor de Coluna."

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Validar os Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Validar os Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Trocar para a Validação dos Comandos Personalizados "

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Erros de Sintaxe"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Comandos Desconhecidos"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Blocos Desconhecidos"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Endereços Desconhecidos"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Formatos Desconhecidos"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "Coluna de Backup"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "Método de Coluna de Backup"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Criar cópias de segurança ao salvar a Coluna em progresso."

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Fazer Backup do Original"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Fazer Backup de Tudo que for Salvo"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Nenhum Backup"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Utilitários"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ Escolher\ Variável\ MOM, Instalar\ Coluna"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "Editar o Arquivo de Dados de Colunas de Modelo"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "Procurar Variáveis MOM"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Procurar Licenças"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Ajuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Opções da Ajuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Opções da Ajuda"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Dicas de Balão"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Dicas de Balão nos Ícones"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Habilitar/desabilitar a exibição das dicas de balão da ferramenta para os ícones."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Ajuda Sensível ao Contexto"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Ajuda Sensível ao Contexto nos Itens da Caixa de Diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Ajuda Sensível ao Contexto nos Itens da Caixa de Diálogo"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "O Que Fazer?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "O Que Você Pode Fazer Aqui?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "O Que Você Pode Fazer Aqui?"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Ajuda Na Caixa de Diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Ajuda Nesta Caixa de Diálogo"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Ajuda Nesta Caixa de Diálogo"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Manual do Usuário"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Manual de Ajuda do Usuário"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Manual de Ajuda do Usuário"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "Sobre o Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "Sobre o Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "Sobre o Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Notas de Lançamento"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Notas de Lançamento"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Notas de Lançamento"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Manuais de Referência Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Manuais de Referência Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Manuais de Referência Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Novo"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Criar uma nova Coluna."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Abrir"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Editar uma Coluna existente."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Salvar"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "Salvar a Coluna em progresso."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Dicas de Balão"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Habilitar/desabilitar a exibição das dicas da ferramenta de balão para ícones."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Ajuda Sensível ao Contexto"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Ajuda Sensível ao Contexto nos Itens da Caixa de Diálogo"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "O Que Fazer?"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "O Que Você Pode Fazer Aqui?"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Ajuda Na Caixa de Diálogo"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Ajuda Nesta Caixa de Diálogo"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Manual do Usuário"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Manual de Ajuda do Usuário"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Erro no Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Mensagem do Post Builder "
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Aviso"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Erro"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Foram digitados dados inválidos para o parâmetro"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Comando do navegador inválido:"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "O nome do arquivo foi alterado!"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "Uma coluna licenciada não pode ser usada como controlador\n para a criação de uma coluna nova se você não é o autor!"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "Você não é o autor desta coluna licenciada.\n Os comandos personalizados podem não ser importados!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "Você não é o autor desta coluna licenciada!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Está faltando um arquivo criptografado para esta coluna licenciada!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "Você não tem a devida licença para realizar esta função!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "Usar o NX/Post Builder Sem Licença"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Você está autorizado a usar o NX/Post Builder\n sem a devida licença. Entretanto, você não\n poderá salvar seu trabalho ao finalizar."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "O serviço desta opção será implementado em uma versão futura."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "Você deseja salvar suas alterações\n antes de fechar a Coluna em progresso?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "Uma coluna criada com uma versão mais recente do Post Builder não pode ser aberta nesta versão."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Conteúdo incorreto no arquivo da Sessão do Post Builder."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Conteúdo incorreto no arquivo Tcl da sua Coluna."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Conteúdo incorreto no arquivo de Definição da sua Coluna."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Você deve especificar, no mínimo, um conjunto de arquivos Tcl e de Definição para a sua Coluna."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "O diretório não existe."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Arquivo Não Encontrado ou Inválido."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "Não é possível abrir o Arquivo de Definição"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "Não é possível abrir o Arquivo do Manipulador de Evento"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "Você não tem a permissão de gravação no diretório."
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "Você não tem a permissão de gravar em"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "já existe! \nVocê deseja substitui-los assim mesmo?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Alguns ou todos os arquivos desta Coluna estão faltando.\n Você não pode abrir esta Coluna."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Você tem que finalizar a edição de todos os sub-diálogos dos parâmetros antes de salvar a Coluna!"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "O Post Builder atual só foi implementado para Máquinas de Fresagem Genéricas."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Um Bloco deve conter, no mínimo, uma Palavra."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "já existe!\n Especifique um nome diferente."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Este componente está sendo usado.\n Ele não pode ser excluído."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Você pode considerá-los como elementos de dados existentes e prosseguir."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "não foi instalado adequadamente."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "Nenhum aplicativo para abrir"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "Deseja salvar as alterações?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Editor Externo"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Você pode usar o EDITOR de variável de ambiente para ativar o seu editor de texto favorito."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "Um nome de arquivo contendo espaço não é suportado!"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "O arquivo selecionado usado por uma das colunas de edição não pode ser sobrescrito!"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Uma janela transiente requer sua janela pai definida."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Você deve fechar todas as sub-janelas para habilitar esta aba."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "Existe um elemento da Palavra selecionada no Modelo de Bloco."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "O número de Códigos - G estão restritos a"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "por bloco"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "O número de Códigos - M estão restritos a"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "por bloco"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "A Entrada não deve ficar vazia."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Os formatos de Endereço \"F\" podem ser editados na página de parâmetros da Taxa de Avanço."

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "O valor máximo do Número da Sequência não deve exceder a capacidade do Endereço N de"

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "O nome da coluna deve ser especificado!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "A pasta deve ser especificada!\n E o padrão deve ser como \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "A pasta deve ser especificada!\n E o padrão deve ser como \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "O nome do outro arquivo cdl deve ser especificado!\n E o padrão deve ser como \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "É permitido apenas arquivo CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "É permitido apenas arquivo PUI!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "É permitido apenas arquivo CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "É permitido apenas arquivo DEF!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "É permitido apenas arquivo CDL próprio!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "A coluna selecionada não tem um arquivo CDL associado."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "Os arquivos CDL e de definição da coluna selecionada serão referenciados (INCLUIR) no arquivo de definição desta coluna.\n E o arquivo Tcl da coluna selecionada também será disponibilizado pelo arquivo do manipulador de evento desta coluna no tempo de execução."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "O valor máximo do Endereço"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "não deve exceder a capacidade do seu Formato de"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Entrada"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "Você não tem a devida licença para realizar esta função!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Este botão está disponível somente em um sub-diálogo. Ele permite que você salve as alterações e ignore a caixa de diálogo."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Cancelar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Este botão está disponível em um sub-diálogo. Ele permite que você ignore a caixa de diálogo."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "Padrão"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Este botão permite que você restaure os parâmetros na caixa de diálogo atual de um componente, para as mesmas condições de quando a Coluna na sessão foi criada ou aberta. \n \nEntretanto, o nome do componente em questão, se está presente, será restaurado somente para seu estado inicial da visita atual a este componente."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Restaurar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Este botão permite que você restaure os parâmetros na caixa de diálogo atual para as suas configurações iniciais da sua visita atual a este componente."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Aplicar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Este botão permite que você salve as alterações sem eliminar a caixa de diálogo atual. Isto também vai restabelecer a condição inicial da caixa de diálogo atual. \n \n(Consulte Restaurar sobre a necessidade da condição inicial)"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Filtro"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Este botão vai aplicar o filtro do diretório e listar os arquivos que satisfazem a condição."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Sim"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Sim"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "Não"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "Não"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Ajuda"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Ajuda"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Abrir"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Este botão permite que você abra a Coluna selecionada para edição."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Salvar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Este botão está disponível na caixa de diálogo Salvar Como, que permite que você salve a Coluna em progresso."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Gerenciar ..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Este botão permite que você gerencie o histórico das Colunas visitadas recentemente."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Atualizar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Este botão permite que você atualize a lista de acordo com a existência de objetos."

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Cortar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Este botão cortará os objeto selecionado da lista."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Copiar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Este botão copiará o objeto selecionado."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Colar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Este botão colará o objeto no buffer novamente na lista."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Editar"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Este botão editará o objeto no buffer!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Usar Editor Externo"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Criar Processador da Coluna Nova"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Digite o Nome e Escolha o Parâmetro para a Coluna Nova."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "Nome da Coluna"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Nome do Processador da Coluna a ser criada "

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Descrição"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Descrição do Processador da Coluna a ser criada"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "Esta é uma Máquina de Fresagem."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "Esta é uma Máquina de Torno."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "Esta é uma Máquina EDM de Fio."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "Esta é uma Máquina EDM de Fio de 2 Eixos."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "Esta é uma Máquina EDM de Fio de 4 Eixos."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "Esta é uma Máquina de Torno Horizontal de 2 Eixos."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "Esta é uma Máquina de Torno Dependente de 4 Eixos."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "Esta é uma Máquina de Fresagem de 3 Eixos."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "Fresa-Torno de 3 Eixos (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "Esta é uma Máquina de Fresagem de 4 Eixos Com\n Cabeçote Giratório."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "Esta é uma Máquina de Fresagem de 4 Eixos Com\n Mesa Giratória."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "Esta é uma Máquina de Fresagem de 5 Eixos Com\n Mesa Giratória Dupla."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "Esta é uma Máquina de Fresagem de 5 Eixos Com\n Cabeçotes Giratórios Duplos."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "Esta é uma Máquina de Fresagem de 5 Eixos Com\n Mesa e Cabeçote Giratórios."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "Esta é uma Máquina de Perfurar."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "Unidade de Saída da Coluna"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Polegadas"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Unidade de Saída do Processador da Coluna em Polegadas"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Milímetros"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Unidade de Saída do Processador da Coluna em Milímetros"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Tipo de ferramenta de máquina para a qual o Processador de Coluna foi criado."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Fresar"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Máquina de Fresagem"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Torno"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Máquina de Torno"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Usinagem por eletroerosão a fio (EDM)"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Máquina EDM a Fio"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Punção"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Seleção de Eixos de Máquina"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Número e tipo de eixos de máquina"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Eixo da Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Selecionar o Eixo da Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "Fresa-Torno de 3 Eixos (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 Eixos com Mesa Giratória"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 Eixos com Cabeçote Giratório"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 Eixos com Cabeçotes Giratórios Duplos  "
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 Eixos com Mesa Giratória Dupla  "
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 Eixos com Cabeçote e Mesa Giratórios"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4 Eixos"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Punção"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Controlador"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "Selecionar o Controlador de Coluna."

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Genérico"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Biblioteca"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Do usuário"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Procurar"

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
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "Editar Coluna"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Escolha um arquivo PUI para abrir."
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Arquivos de Sessão do Post Builder"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Arquivos de Script Tcl"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Arquivos de Definição "
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "Arquivos CDL"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Selecione um arquivo"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Exportar Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Ferramenta de Máquina"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "Navegador das Variáveis MOM"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Categoria"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Pesquisar"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Valor Padrão"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Valores Possíveis"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Tipo de Dados"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Descrição"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Editar template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "Arquivo de Dados de Colunas Modelo"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Editar Uma  Linha"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Coluna"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Salvar Como"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "Nome da Coluna"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "O nome que o Processador de Coluna deve ser salvo."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Digite o novo nome de arquivo da Coluna."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Arquivos de sessão do Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Entrada"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Você vai especificar um novo valor no campo de entrada."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Aba do Notebook"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Você pode selecionar uma aba para ir para a página de parâmetro desejada. \n \nOs parâmetros em uma aba podem ser divididos em grupos. Cada grupo de parâmetros pode ser acessado através de outra aba."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Árvore de Componentes"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Você pode selecionar um componente para visualizar ou editar seu conteúdo ou parâmetros."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Criar"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Criar um novo componente copiando o item selecionado."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Cortar"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Recortar um componente."
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Colar"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Colar um componente."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Renomear"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Lista de Licenças"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Selecionar Uma Licença"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Criptografar a Saída"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Licença :  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Especificar os Parâmetros Cinemáticos da Máquina."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "Não está disponível uma imagem para a configuração dessa máquina ferramenta."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "O 4º eixo da mesa C não está permitido."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "O limite de eixo máximo do 4º eixo não pode ser igual ao limite de eixo mínimo!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Os limites do 4º eixo não podem ser ambos negativos!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "O plano do 4º eixo não pode ser o mesmo do 5º eixo."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "A mesa do 4º eixo e o cabeçote do 5º eixo não estão permitidos."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "O limite de eixo máximo do 5º eixo não pode ser igual ao limite de eixo mínimo!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Os limites do 5º eixo não podem ser ambos negativos!"

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "Informações da Coluna"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Descrição"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Tipo de Máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Cinemática"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Unidade de Saída"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Controlador"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "Histórico"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Exibir Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Esta opção Exibe a Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Ferramenta de Máquina"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Parâmetros Gerais"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "Unidade de Saída da Coluna :"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Unidade de Saída de Processamento da Coluna"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Polegada" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Métrica"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Limites do Curso do Eixo Linear"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Limites do Curso do Eixo Linear"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Especificar o limite do Curso da Máquina ao longo do eixo  X. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Especificar o limite do Curso da Máquina ao longo do eixo  Y. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Especificar o limite do Curso da Máquina ao longo do eixo  Z. "

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Posição Inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Posição Inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "Posição inicial da máquina do eixo X em relação à posição física zero do eixo. A máquina volta para esta posição para a troca de ferramenta automática. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "Posição inicial da máquina do eixo Y em relação à posição física zero do eixo. A máquina volta para esta posição para a troca de ferramenta automática. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "Posição inicial da máquina do eixo Z em relação à posição física zero do eixo. A máquina volta para esta posição para a troca de ferramenta automática. "

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Resolução do Movimento Linear"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Resolução Mínima"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Taxa de Avanço Transversal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Máximo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Taxa de Avanço Máxima"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Registro Circular da Saída"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Sim"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Registro Circular da Saída."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "Não"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Registro Linear da Saída."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Outras"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Controle da Inclinação do Fio"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Ângulos"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Coordenadas"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Configurar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "Quando a opção Duas Torres está selecionada, ela permite que você configure os parâmetros."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Uma Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Máquina de Torno de Uma Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Duas Torres"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Máquina de Torno de Duas Torres"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Configuração da Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Torre Principal"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Selecionar a Designação da Torre Principal."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Torre Secundária"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Selecionar a Designação da Torre Secundária."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Designação"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "Deslocamento X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "Especificar o Deslocamento X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Deslocamento Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Especificar o Deslocamento Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "FRONTAL"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "TRASEIRA"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "DIREITA"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "ESQUERDA"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "LADO"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "CARRO"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Multiplicadores do Eixo "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Programação do Diâmetro "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Estas opções permitem que você habilite a Programação do Diâmetro, dobrando os valores dos endereços selecionados na saída N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Esta chave permite que você habilite a Programação do Diâmetro, dobrando as coordenadas do eixo X na saída N/C. "

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Esta chave permite que você habilite a Programação do Diâmetro, dobrando as coordenadas do eixo Y na saída N/C. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Esta chave permite que você dobre os valores de I dos registros circulares quando Programação do Diâmetro for utilizada."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Esta chave permite que você dobre os valores de J dos registros circulares quando Programação do Diâmetro for utilizada."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Espelhar Saída"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Estas opções permitem que você espelhe os endereços selecionados, negando seus valores na saída N/C "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Esta chave permite que você negue as coordenadas do eixo X na saída N/C. "
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Esta chave permite que você negue as coordenadas do eixo Y na saída N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Esta chave permite que você negue as coordenadas do eixo Z na saída N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Esta chave permite que você negue os valores de I dos registros circulares na saída N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Esta chave permite que você negue os valores de J dos registros circulares na saída N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Esta chave permite que você negue os valores de K dos registros circulares na saída N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Método de Saída"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Método de Saída"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "Ponta de Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Saída em relação à Ponta da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Referência da Torre"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Saída em relação a Referência da Torre"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "A designação da Torre Principal não pode ser a mesma da Torre Secundária."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "A alteração desta opção pode requerer a adição ou exclusão de um bloco G92 nos eventos de Troca de Ferramenta."
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Eixo do Fuso Inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "O eixo do fuso inicial designado para a ferramenta de fresagem ativa pode ser especificado como paralelo ou perpendicular ao eixo Z. O eixo de ferramenta da operação deve ser compatível com o eixo do fuso especificado. \nEste vetor pode ser sobrescrito pelo eixo do fuso especificado com um objeto de Cabeçote."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Posição no Eixo Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "A máquina tem um eixo Y programável que pode ser posicionado durante o contorno. Esta opção somente é aplicável quando o Eixo do Fuso não está ao longo do eixo Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Modo de Máquina"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "O Modo de Máquina pode ser Fresa-XZC ou Fresa-Torno Simples."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fresa XZC"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Uma fresa XZC terá uma mesa ou uma face de mandril travada em uma máquina de fresa-torno como o eixo C giratório. Todos os movimentos de XY serão convertidos em X e C, sendo X um valor de raio e C o ângulo."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Fresa-Torno Simples"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Esta coluna de fresagem XZC será vinculada a uma coluna de torno para processar um programa que contém as operações de fresagem e torneamento. O tipo de operação determinará que coluna deve ser usada para produzir saídas N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Coluna de Torno"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Uma coluna de torno é necessária para uma coluna de Fresa-Torno Simples para o pós-processamento das operações de torneamento em um programa."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Selecionar Nome"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Selecione o nome de uma coluna de torno para ser usado em uma coluna de Fresa-Torno Simples. Provavelmente, esta coluna será encontrada no diretório \\\$UGII_CAM_ POST_DIR, no tempo de execução da Coluna/NX; caso contrário, será usada uma coluna com o mesmo nome no diretório onde reside a coluna de fresa."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Modo de Coordenada Padrão"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Esta opção define a configuração inicial para que o modo de saída de coordenada seja Polar (XZC) ou Cartesiano  (XYZ). Este modo pode ser alterado através de \\\"DEFINIR,POLAR,ATIVAR\\\" programados no UDE com as operações."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Saída coordenada em XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Cartesiano"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Saída coordenada em  XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Modo Registro Circular"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Esta opção define a saída dos registros circulares no modo Polar (XCR) ou Cartesiano (XYIJ)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Saída Circular em XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartesiano"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Saída Circular em XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Eixo do Fuso Inicial"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "O eixo do fuso inicial pode ser sobregravado pelo eixo do fuso especificado com um objeto de Cabeçote. \nO vetor não precisa ser unificado."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "Quarto Eixo"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Saída do Raio "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Quando o eixo da ferramenta está ao longo do eixo Z (0,0,1), a coluna tem a opção de gerar o raio (X) das coordenadas polares como \\\"Sempre Positivo\\\", \\\"Sempre Negativo\\\" ou \\\"Distância Mais Curta\\\"."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Início"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Tabela"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Quinto Eixo"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Eixo Giratório"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Zero da Máquina Para Centro do Eixo Giratório"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Zero da Máquina Para Centro do 4º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Centro do 4º Eixo Para o Centro do 5º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "Deslocamento X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "Especificar o Deslocamento X do Eixo Giratório."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Deslocamento Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Especificar o Deslocamento Y do Eixo Giratório."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Deslocamento Z"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Especificar o Deslocamento Z do Eixo Giratório."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Rotação do Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Definir a Direção de Rotação do Eixo como Normal."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Invertido"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Definir a Direção de Rotação do Eixo como Invertida."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Direção do Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Selecionar a Direção do Eixo."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Movimentos Giratórios Consecutivos"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Combinado"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Esta chave permite que você habilite/desabilite a linearização. Ela vai habilitar/desabilitar a opção Tolerância"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Tolerância"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Esta opção está ativa somente quando a chave Combinado está ativa. Especificar a Tolerância."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Processamento da Violação do Limite do Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Aviso"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Avisos de Saída sobre a Violação do limite do Eixo."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Retrair / Engatar Novamente"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Retrair / Engatar Novamente na Violação do limite do Eixo. \n \nNo comando personalizado PB_CMD_init_rotaty, os seguintes parâmetros podem ser ajustados para conseguir o movimento desejado: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Limites do Eixo (Grau)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Especificar o limite Mínimo do Eixo Giratório (Grau)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Máximo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Especificar o limite Máximo do Eixo Giratório (Grau)"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Este Eixo Giratório Pode Ser Em Incrementos "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Resolução do Movimento Giratório (Grau)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Especificar a Resolução do Movimento Giratório (Grau)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Deslocamento Angular (Grau)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Especificar o Deslocamento Angular do Eixo (Grau)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Distância do Pivô"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Especificar a Distância do Pivô."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Taxa de Avanço Máx. (Grau/Min)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Especificar a Taxa de Avanço Máxima (Grau/Min)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Plano de Rotação"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "Selecione XY, YZ, ZX ou Outro como Plano de Rotação. A opção \\\"Outro\\\" permite que você especifique um vetor arbitrário."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Vetor Normal do Plano"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Especifica o Vetor Normal do Plano como eixo de rotação. \nO vetor não precisa ser unificado."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "Normal do Plano do 4º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Especificar um vetor normal plano para rotação do 4º eixo."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "Normal do Plano do 5º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Especificar um vetor normal plano para rotação do 5º eixo."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Seta da Palavra"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Especificar a Seta da Palavra."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Configurar"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Esta opção permite que você defina os parâmetros dos eixos 4º e 5º."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Configuração do Eixo Giratório"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "4º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "5º Eixo"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Início "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Tabela "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Tolerância de Linearização Padrão"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Este valor será usado como tolerância padrão para linearizar o movimento de rotação, quando o comando da coluna LINTOL/ON for especificado com a(s) operação(ões) atual(is) ou anterior(es). O comando LINTOL/ também pode especificar uma tolerância de linearização diferente."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Caminho do Programa e da Ferramenta"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Programa"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Definir a saída de Eventos"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Programa -- Árvore de Sequência"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Um programa N/C está dividido em cinco segmentos: quatro (4) Sequências e o corpo do caminho da ferramenta: \n \n * Sequência Inicial do Programa \n * Sequência Inicial da Operação \n * Caminho da Ferramenta \n * Sequência Final da Operação \n * Sequência Final do Programa \n \nCada Sequência consiste de uma série de Marcadores. Um Marcador indica um evento que pode ser programado e pode ocorrer em uma etapa específica de um programa N/C. Você pode anexar cada Marcador com um arranjo de códigos N/C para ser produzido quando o programa for pós-processado. \n \nO caminho da ferramenta está formado por numerosos Eventos. Eles estão divididos em três (3) grupos: \n \n * Controle da Máquina \n * Movimentos \n * Ciclos \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Sequência Inicial do Programa"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Sequência Final do Programa"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Sequência Inicial da Operação"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Sequência Final da Operação"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Caminho da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Controle de Máquina"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Movimento"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Ciclos Encapsulados "
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Sequência de Colunas Vinculadas"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Sequência -- Adicionar Bloco"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Você pode adicionar um Bloco novo a uma Sequência, pressionando este botão e arrastando-o para o Marcador desejado. Os Blocos também podem ser anexados ao lado, acima ou abaixo de um Bloco existente."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Sequência -- Lata de Lixo"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Você pode eliminar os Blocos não desejados da Sequência, arrastando-os para esta lata de lixo."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Sequência -- Bloco"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Você pode excluir qualquer Bloco não desejado na Sequência, arrastando-o para a lata de lixo. \n \nVocê também pode ativar um menu suspenso, pressionando o botão direito do mouse. Vários serviços estão disponíveis neste menu : \n \n * Editar \n * Saída de Força \n * Recortar \n * Copiar Como \n * Colar \n * Excluir \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Sequência -- Seleção de Bloco"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "Você pode selecionar o tipo de componente do Bloco que deseja adicionar à Sequência desta lista. \n\AOs tipos de componentes disponíveis são : \n \n * Bloco Novo \n * Bloco N/C Existente \n * Mensagem do Operador \n * Comando Personalizado \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Selecionar Um Modelo de Sequência"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Adicionar Bloco"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Exibir Blocos de Código N/C Combinados"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Este botão permite que você exiba o conteúdo de uma Sequência em termos de Blocos ou códigos N/C. \n \nOs códigos N/C exibirão as Palavras na ordem apropriada."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Programa -- Chave Ocultar / Expandir"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Este botão permite que você oculte ou expanda os ramos deste componente."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Sequência -- Marcador"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Os Marcadores de uma Sequência indicam os possíveis eventos que podem ser programados e que podem ocorrer em sequência em um etapa específica de um programa N/C. \n \nVocê pode anexar/arranjar os Blocos para serem produzidos a cada Marcador."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Programa -- Evento"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Você pode editar cada Evento com um único clique com o botão esquerdo do mouse."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Programa -- Código N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "O texto nesta caixa exibe o código N/C representativo para ser produzido neste Marcador ou deste Evento."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Desfazer"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Bloco Novo"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Comando Personalizado"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Bloco"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Comando Personalizado"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Mensagem do Operador"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Editar"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Saída de Força "
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Renomear"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Você pode especificar o nome para este componente."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Cortar"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Copiar como"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Bloco(s) Referenciado(s)"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Bloco(s) Novo(s)"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Colar"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Antes"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "Em linha"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "Após"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Excluir"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Saída de Força Uma Vez"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Evento"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Selecionar Um Modelo de Evento"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Adicionar Palavra"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMATO"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Movimento Circular --  Códigos do Plano "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " Códigos G do Plano "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Plano XY"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Plano YZ"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Plano ZX"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "Arco do Início Para o Centro"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "Arco do Centro Para o Início"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Arco Não Sinalizado do Início Para o Centro"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Centro do Arco Absoluto "
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Guia da Rosca Longitudinal"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Guia da Rosca Transversal"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Tipo de Gama do Fuso"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Separar Código M da Gama (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Número da Gama com Código M do Fuso (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Gama Superior/Inferior com Código S (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "O número de Gamas do Fuso deve ser maior que zero."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Tabela de Código da Gama do Fuso"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Intervalo"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Código"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Mínimo (RPM)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Máximo (RPM)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Separar Código M da Gama (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Número da Gama com Código M do Fuso (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Gama Superior/Inferior com Código S (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Gama Par/Ímpar com Código S"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Número da Ferramenta E Número do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Número do Deslocamento do Comprimento E Número da Ferramenta"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Configuração do Código da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Saída"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Número da Ferramenta E Número do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Índice da Torre e Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Número da Ferramenta do Índice da Torre E Número do Deslocamento do Comprimento"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Próximo Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Índice da Torre E Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Índice da Torre E Próximo Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Número da Ferramenta E Número do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Próximo Número da Ferramenta E Número do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Número do Deslocamento do Comprimento E Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Número do Deslocamento do Comprimento E Próximo Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Índice da Torre, Número da Ferramenta E Número do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Índice da Torre, Próximo Número da Ferramenta E Número do Deslocamento do Comprimento"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Comando Personalizado"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "Modo IPM (Pol/Min)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "Códigos G"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "Especificar Códigos G"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "Códigos M"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "Especificar Códigos M"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Resumo de Palavra"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Especificar Parâmetros"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Palavra"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Você pode editar um endereço de Palavra clicando com o botão esquerdo do mouse no seu nome."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Seta/Código"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Tipo de Dados"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Mais (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Zero à Esquerda"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Integer"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Decimal (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Fração"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Zero à Direita"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "Modal ?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Máximo"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Seta"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Texto"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Numérico"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "PALAVRA"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Outros Elementos de Dados "

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Sequenciamento de Palavra "
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Sequenciar as Palavras"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Sequência de Palavras Mestre"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Você pode criar uma sequência da ordem das Palavras para aparecer na saída N/C, arrastando qualquer Palavra para a posição desejada. \n \nQuando a Palavra que está sendo arrastada está em foco (a cor do retângulo se altera) com a outra Palavra, estas 2 Palavras trocarão de posição. Se uma Palavra é arrastada dentro do foco de um separador entre 2 Palavras, a Palavra será inserida entre estas 2 Palavras. \n \nVocê pode suprimir a geração de qualquer Palavra no arquivo N/C, desativando-a com um único clique com o botão esquerdo do mouse. \n \nVocê também pode manipular estas Palavras usando as opções de um menu suspenso : \n \n * Novo \n * Editar \n * Excluir \n * Ativar Tudo \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Saída - Ativa     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Saída - Suprimida "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Novo"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Desfazer"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Editar"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Excluir"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Ativar Tudo"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "PALAVRA"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "não pode ser suprimido. Ele foi usado como um elementos único no"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Suprimir a saída deste Endereço resultará em Bloco(s) vazio(s) inválido(s)."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Comando Personalizado"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Definir Comandos Personalizados"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Nome do Comando"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "O nome que você digitou aqui vai receber o prefixo PB_CMD_ para ser o nome real do comando."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Procedimento"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Você vai inserir um script Tcl para definir a funcionalidade deste comando. \n \n * Observe que o conteúdo do script não será analisado pelo Post Builder, mas será salvo no arquivo Tcl. Portanto, você é o responsável pela sintaxe correta do script."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Nome do Comando Personalizado inválido.\n Especificar um nome diferente"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "está reservado para Comandos Personalizados especiais.\n Especificar um nome diferente"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Somente nomes de comando personalizados VNC como \n PB_CMD_vnc____* são permitidos.\n Especificar um nome diferente"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Importar"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Importar Comandos Personalizados de um arquivo Tcl selecionado para a Coluna em progresso."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Exportar"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Exportar Comandos Personalizados da Coluna em progresso para um arquivo Tcl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Importar Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Esta lista contém os procedimentos de comandos personalizados e outros procedimentos Tcl encontrados no arquivo que você especificou para importar. Você pode visualizar o conteúdo de cada procedimento, selecionando o item na lista com um único clique com o botão esquerdo do mouse. Qualquer procedimento que já existe  na Coluna em progresso está identificado com um indicador <existe>. Um duplo clique com o botão esquerdo do mouse em um item vai alternar a caixa de seleção ao lado deste item. Isto permite que você selecione ou desmarque a seleção de um procedimento a importar. Por padrão, todos os procedimentos estão selecionados para a importação. Você pode desmarcar a seleção de qualquer item para evitar sobrescrever um procedimento existente."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Exportar Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Esta lista contém os procedimentos de comandos personalizados e outros procedimentos Tcl que existem na Coluna em progresso. Você pode visualizar o conteúdo de cada procedimento selecionando o item na lista com um único clique com o botão esquerdo do mouse. Um duplo clique com o botão esquerdo do mouse em um item vai alternar a caixa de seleção ao lado do item. Isto permite que você selecione somente os procedimentos desejados para exportar."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Erro no Comando Personalizado"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "A Validação dos Comandos Personalizados pode ser habilitada ou desabilitada com a configuração das chaves no menu suspenso do item do menu principal \"Opções -> Validar Comandos Personalizados\"."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Selecionar Tudo"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Clique neste botão para selecionar todos os comandos exibidos para importar ou exportar."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Cancelar Todas as Seleções"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Clique neste botão para desmarcar a seleção de todos os comandos."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Aviso de Importar / Exportar Comandos Personalizados"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "Não foi selecionado nenhum item para importar ou exportar."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Comandos : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Blocos : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Endereços : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Formatos : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "referenciado no Comando Personalizado "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "não foi definido no escopo atual da Coluna em progresso."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "não pode ser excluída."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "Você deseja salvar esta Coluna assim mesmo?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Texto a ser exibido como uma mensagem do operador. Os caracteres especiais requeridos para começar e finalizar a mensagem serão anexados automaticamente pelo Post Builder para você. Estes caracteres estão especificados na página de parâmetros \"Outros Elementos de Dados\" na aba \"Definições de Dados N/C\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Nome da Mensagem"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Uma Mensagem do Operador não deve estar vazia."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Colunas Vinculadas"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Definir Colunas Vinculadas"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Vincular Outras Colunas a Esta Coluna"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Outras colunas podem ser vinculadas a esta para processar ferramentas de máquinas complexas que realizam mais de uma combinação de modos de fresagem e torneamento simples."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Início"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Uma ferramenta de máquina complexa pode realizar suas operações de usinagem usando conjuntos diferentes de cinemáticos em vários modos de usinagem. Cada conjunto de cinemáticos é tratado como um Cabeçote independente na Coluna/NX. As operações de usinagem que necessitam ser realizadas com um Cabeçote específico serão colocadas juntas como um grupo na Ferramenta de Máquina ou na Vista do Método de Usinagem. Um \\\"Cabeçote\\\" UDE será atribuído ao grupo para designar o nome deste cabeçote."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Coluna"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Um coluna é atribuída a um Cabeçote para produzir os Códigos N/C."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Uma Coluna Vinculada"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Novo"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Criar um novo vínculo."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Editar"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Editar um vínculo."

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Excluir"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Excluir um vínculo."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Selecionar Nome"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Selecione o nome de uma coluna a ser atribuída a um Cabeçote. Provavelmente, esta coluna será encontrada no diretório onde está a coluna principal no tempo de execução da Coluna/NX; caso contrário, será usada uma coluna com o mesmo nome no diretório \\\$UGII_CAM_POST-DIR. "

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Início do Cabeçote"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Especificar os códigos N/C ou ações a serem executadas no início desde Cabeçote."

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Final do Cabeçote"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Especificar os códigos N/C ou ações a serem executadas no final desde Cabeçote."
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Início"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Coluna"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Coluna Vinculada"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "Definições de Dados N/C"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "BLOCO"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Definir os Modelos de Bloco"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Nome do Bloco"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Digitar o Nome do Bloco"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Adicionar Palavra"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Você pode adicionar uma Palavra nova em um Bloco, pressionando este botão ou arrastando-a para o Bloco exibido na janela abaixo. O tipo de Palavra que será criado é selecionado na caixa de lista à direita deste botão."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOCO -- Seleção de Palavra"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Você pode selecionar nesta lista o tipo de Palavra que deseja adicionar no Bloco."

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOCO -- Lata de Lixo"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Você pode eliminar todas as Palavras não desejadas de um Bloco arrastando-as para esta lata de lixo."

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOCO -- Palavra"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Você pode excluir toda Palavra não desejada neste Bloco arrastando-a para a lata de lixo. \n \nVocê também pode ativar um menu suspenso, pressionando o botão direito do mouse. Vários serviços estão disponíveis neste menu : \n \n * Editar \n * Alterar Elemento -> \n * Opcional \n * Sem Separador de Palavra \n * Saída de Força \n * Excluir \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOCO -- Verificação de Palavra "
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "Esta janela exibe o código N/C representativo para ser gerado para uma Palavra selecionada (pressionada) no Bloco mostrado na janela acima"

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Endereço Novo"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Texto"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Comando"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Editar"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Visualizar"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Alterar Elemento"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Expressão Definida pelo Usuário "
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Opcional"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Sem Separador de Palavra "
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Saída de Força "
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Excluir"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Desfazer"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Excluir Todos os Elementos Ativos"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Comando Personalizado "
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "PALAVRA"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "PALAVRA"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Endereço Novo"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Mensagem do Operador"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Comando Personalizado"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Expressão Definida pelo Usuário "
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Sequência de Texto"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Expressão"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Um Bloco deve conter, no mínimo, uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Nome do Bloco inválido.\n Especificar um nome diferente."

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "PALAVRA"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Definir as Palavras"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Nome da Palavra"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Você pode editar o nome de uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "PALAVRA -- Verificação"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "Esta janela exibe o código N/C representativo a ser gerado para uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Seta"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Você pode digitar qualquer número de caracteres como a Seta para uma Palavra ou selecionar um caractere de um menu pop-up, usando o botão direito do mouse."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Formato"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Editar"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Este botão permite que você edite o Formato usado por uma Palavra."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Novo"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Este botão permite que você crie um novo Formato."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "PALAVRA --  Selecionar Formato"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Este botão permite que você selecione um Formato diferente para uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Reboque"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Você pode digitar qualquer número de caracteres como o Reboque para uma Palavra ou selecionar um caractere de um menu pop-up, usando o botão direito do mouse."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "Modal ?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Esta opção permite que você defina a modalidade para uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Desativado"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Uma vez"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Sempre"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Máximo"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Você especificará um valor máximo para uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Valor"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Valor Truncado"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Avisar Usuário"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Anular Processo"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Processar Violação"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Este botão permite que você especifique o método de processamento da violação do valor máximo: \n \n * Valor Truncado \n *  \n * Avisar Usuário \n *  \n * Anular Processo \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Você especificará um valor mínimo para uma Palavra."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Processar Violação"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Este botão permite que você especifique o método de processamento da violação do valor mínimo: \n \n * Valor Truncado \n  * Avisar Usuário \n  * Anular Processo \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMATO "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Nenhum"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Expressão"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "Você especificará uma expressão ou uma constante para um Bloco."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "A expressão para um elemento de Bloco não deve ficar em branco."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "A expressão para um elemento de Bloco usando Formato numérico não pode conter somente espaços."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "O(s) caractere(s) especial(is) \n [::msgcat::mc MC(address,exp,spec_char)] \n não pode ser usado em uma expressão para dados numéricos."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Nome do Bloco Inválido.\n Especifique um nome diferente."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 e rapid3 estão reservados para o uso interno do Post Builder.\n Especifique um nome diferente."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Posicionamento Rápido ao longo do Eixo Longitudinal"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Posicionamento Rápido ao longo do Eixo Transversal"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Posicionamento Rápido ao longo do Eixo do Fuso"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMATO"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Definir os Formatos"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMATO -- Verificação"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "Esta janela exibe o Código N/C representativo a ser gerado usando o Formato especificado."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Nome de Formato"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Você pode editar o nome de um Formato."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Tipo de Dados"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Você especificará o Tipo de Dados para um Formato."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Numérico"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Esta opção define o tipo de dados de um Formato como um Numérico."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMATO -- Dígitos Inteiros"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Esta opção especifica o número de dígitos inteiros ou a parte inteira de um número real."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMATO -- Dígitos da Fração"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Esta opção especifica o número de dígitos da parte fracionada de um número real."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Usar Ponto Decimal (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Esta opção permite que você use pontos decimais no código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Usar Zeros à Esquerda"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Esta opção habilita o uso de zeros à esquerda nos números no código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Usar Zeros à Direita"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Esta opção habilita o uso de zeros à direita nos números reais no código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Texto"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Esta opção define o tipo de dados de um Formato como uma sequência de texto."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Usar Sinal de Mais (+) à Esquerda"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Esta opção permite que você use sinais de mais no código N/C."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "Não é possível fazer uma cópia do formato Zero"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "Não é possível excluir um formato Zero"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "No mínimo, uma das opções de Ponto Decimal, Zeros à Esquerda ou Zeros à Direita deve ser verificada."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "O número de dígitos do número inteiro e da fração não deve ser zero."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Nome do Formato Inválido.\n Especificar um nome diferente."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Erro no Formato"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Este Formato já foi usado em Endereços"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Outros Elementos de Dados "
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Especificar os Parâmetros"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Número de Sequência"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Esta chave permite que você habilite/desabilite a geração de números de sequência no código N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Início do Número de Sequência"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Especificar o início dos números de sequência."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Aumento do Número de Sequência "
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Especificar o aumento dos números de sequência."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Frequência do Número de Sequência "
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Especificar a frequência que os números de sequência aparecem no código N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Número de Sequência Máximo"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Especificar o valor máximo dos números de sequência."

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Caracteres Especiais"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Separador de Palavra"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Especificar um caractere a ser usado como separador de palavra."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Ponto Decimal"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Especificar um caractere a ser usado como o ponto decimal."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Final do Bloco"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Especificar um caractere a ser usado como o final do bloco."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Início da Mensagem"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Especificar os caracteres a serem usados como o início de uma linha de mensagem do operador."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Final da Mensagem"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Especificar os caracteres a serem usados como o final de uma linha de mensagem do operador."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Seta da Linha"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "Seta da Linha OPSKIP"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "Saída de Códigos G e M Por Bloco"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Número de Códigos G por Bloco"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Esta chave permite que você habilite/desabilite o controle do número dos códigos G por bloco de saída N/C."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Número de Códigos G"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Especifica o número de códigos G por bloco de saída N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Número de Códigos M"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Esta chave permite que você habilite/desabilite o controle do número dos códigos M por bloco de saída N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Número de Códigos M por Bloco"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Especificar o número de códigos M por bloco de saída N/C."

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Nenhum"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Espaço"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Decimal (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Vírgula (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Ponto e Vírgula (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Dois Pontos (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Sequência de Texto"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Parêntese Esquerdo ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Parênteses Direito )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Sinal de Libra (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Asterisco (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Barra (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Linha Nova (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "Eventos Definidos Pelo Usuário"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Incluir Outro Arquivo CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Esta opção habilita esta coluna para incluir uma referência em um arquivo CDL no seu arquivo de definição."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "Nome do Arquivo CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "O nome do caminho e do arquivo de um arquivo CDL a ser referenciado (INCLUIR) no arquivo de definição desta coluna. O nome do caminho deve começar com uma variável de ambiente UG (\\\$UGII) ou sem nenhuma. Se nenhum caminho for especificado, será usado UGII_CAM_FILE_SEARCH_PATH para localizar o arquivo pelo UG/NX no tempo de execução."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Selecionar Nome"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Selecionar um arquivo CDL a ser referenciado (INCLUIR) no arquivo de definição desta coluna. Por padrão, o nome do arquivo selecionado receberá o prefixo \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Você pode editar o nome do caminho como desejar após a seleção."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Configurações de Saída"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Configurar Parâmetros de Saída"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Controlador N/C Virtual"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Independente"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Subordinado"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Selecionar Um Arquivo VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "O arquivo selecionado não coincide com o nome do arquivo VNC padrão.\n Você deseja selecionar novamente o arquivo?"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Gerar Controlador N/C Virtual (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Esta opção permite que você gere um Controlador N/C Virtual (VNC). Uma coluna criada com o VNC habilitado pode ser usada pelo ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "VNC Mestre"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "O nome do VNC Mestre que será disponibilizado por um VNC Subordinado. No tempo de execução do ISV, provavelmente, esta coluna será encontrada no diretório onde está o VNC Subordinado; caso contrário, será usada uma coluna com o mesmo nome no diretório \\\$UGII_CAM_POST_DIR."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Um VNC Mestre deve ser especificado para um VNC Subordinado."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Selecionar Nome"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Selecionar o nome de um VNC para ser disponibilizado para um VNC Subordinado. No tempo de execução do ISV, provavelmente, esta coluna será encontrada no diretório onde está o VNC Subordinado; caso contrário, será usada uma coluna com o mesmo nome no diretório \\\$UGII_CAM_POST_DIR. "

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Modo do Controlador N/C Virtual"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Um Controlador N/C Virtual pode ser Autônomo ou Subordinado ao VNC Mestre."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Um VNC Autônomo é auto-suficiente."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Um VNC Subordinado é, fundamentalmente, dependente do seu VNC Mestre. Ele disponibilizará o VNC Mestre no tempo de execução do ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Controlador N/C Virtual criado com o Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Arquivo de Listas"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Especificar os Parâmetros do Arquivo de Listas"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Gerar Arquivo de Listas"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Esta chave permite que você habilite/desabilite a geração do Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Elementos do Arquivo de Listas "
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Componentes"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "Coordenada X"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Esta chave permite que você habilite/desabilite a geração da coordenada x no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Coordenada Y"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Esta chave permite que você habilite/desabilite a geração da coordenada y no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Coordenada Z"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Esta chave permite que você habilite/desabilite a geração da coordenada z no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "Ângulo do 4º Eixo"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Esta chave permite que você habilite/desabilite a geração do ângulo do 4º eixo no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "Ângulo do 5º Eixo"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Esta chave permite que você habilite/desabilite a geração do ângulo do 5º eixo no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Alimentação "
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Esta chave permite que você habilite/desabilite a geração da taxa de avanço no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Velocidade"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Esta chave permite que você habilite/desabilite a geração da velocidade do fuso no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Extensão do Arquivo de Listas"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Especificar a extensão do Arquivo de Listas "

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "Extensão do Arquivo de Saída N/C"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "Especificar a extensão do arquivo de saída N/C"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Cabeçalho do Programa"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Lista de Operação"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Lista de Ferramentas"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Programar Rodapé"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Tempo de Usinagem Total"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Formato de Página"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Imprimir Cabeçalho da Página"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Esta chave permite que você habilite/desabilite a geração de cabeçalho de página no Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Comprimento da Página (Linhas)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Especificar o número de filas por página para o Arquivo de Listas."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Largura da Página (Colunas)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Especificar o número de colunas por página para o Arquivo de Listas."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Outras Opções"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Gerar Elementos de Controle"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Gerar Mensagens de Aviso"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Esta chave permite que você habilite/desabilite a geração de mensagens de aviso durante o processamento da coluna."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "Ativar a Ferramenta de Revisão"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Esta chave permite que você ative a Ferramenta de Revisão durante o processamento da coluna."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Gerar Saída de Grupo"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Esta chave permite que você habilite/desabilite o controle da Saída de Grupo durante o processamento da coluna."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Exibir Mensagens de Erro Verbosas"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Esta chave permite que você exiba as descrições estendidas para as condições de erro. A exibição vai diminuir a velocidade do Processamento da Coluna."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Informações da Operação"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Parâmetros da Operação"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Parâmetros de Ferramentas"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Tempo de Usinagem"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Fonte de Tcl do Usuário"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Disponibilizar Arquivo Tcl do Usuário"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Esta chave permite que você disponibilize seu próprio arquivo Tcl."
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Nome do Arquivo"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Especificar o nome de um arquivo Tcl que deseja disponibilizar para esta Coluna."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Visualizar Arquivos da Coluna"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Código Novo"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Código Antigo"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Manipuladores de Evento"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Escolher o Evento para visualizar o procedimento"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Definições"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Escolher o item para visualizar o conteúdo"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "Consultor de Coluna"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "Consultor de Coluna"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "SEPARADOR_PALAVRA"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "FINAL_DO_BLOCO"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "NÚM_SEQUÊNCIA"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUIR"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMATO"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "PALAVRA"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "BLOCO"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "BLOCO de Composição"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "BLOCO de Coluna"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "Mensagem do Operador"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Contagem variável dos argumentos opc."
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Opção(ões) desconhecida(s)"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   ". Deve ser um de:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Início do Programa"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Início do Caminho"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Do Movimento"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "Primeira Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Troca de Ferramenta Automática"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Alteração Manual da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Movimento Inicial"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "Primeiro Movimento"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Movimento de Aproximação"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Movimento de Engate"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "Primeiro Corte"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "Primeiro Movimento Linear"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Início do Passe"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Movimento Cutcom"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Movimento de Inclinação Interna"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Movimento de Retração"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Movimento de Retorno"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Movimento Gohome"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Final do Caminho"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Movimento de Inclinação Externa"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Final do Passe"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "Final do Programa"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Alteração de Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Alteração de Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Torre Principal"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Torre Secundária"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "Código T"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Configurar"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Índice da Torre Principal "
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Índice da Torre Secundária "
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Número da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Hora (Seg)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Alteração de Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Retrair"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Retrair Para Z de"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Compensação do Comprimento "
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Ajuste do Comprimento da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "Código T"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Configurar"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Registro do Deslocamento do Comprimento"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Máximo"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Definir Modos"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Modo de Saída"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Absoluto"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Incremental"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "O Eixo Giratório Pode Ser Incremental"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "RPM do fuso"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "Códigos M da Direção do Fuso"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "Sentido Horário (SH)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "Sentido Anti-Horário (SAH)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Controle da Gama do Fuso"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Tempo de Intervalo da Troca de Gama (Seg)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Especificar o Código da Gama"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "Fuso CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "Código G do Fuso"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Código da Superfície Constante"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Código de RPM Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Código Para Cancelar SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "RPM Máximo Durante CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Sempre Ter o modo IPR para SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Fuso Desativado"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "Código M da Direção do Fuso"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Desativado"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "Refrigerante Ligado"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "Ligado"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Inundar"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Névoa"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Através"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "Puncionar"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "Refrigerante Desligado"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "Código M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Desativado"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Modo Métrico Polegada"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Inglês (Polegada)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Métrico (Milímetro)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Taxas de Avanço"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "Modo IPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "Modo IPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "Modo DPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "Modo MMPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "Modo MMPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "Modo FRN"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Formato"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Modos da Taxa de Avanço"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Apenas Linear"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Somente Giratório"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Linear e Giratório"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Somente Linear Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Somente Giratório Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Linear e Giratório Rápidos"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Modo da Taxa de Avanço do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Ciclo"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Cutcom Ativado"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Esquerda"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Direita"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Planos Aplicáveis"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Editar Códigos do Plano "
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Registro Cutcom"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Desativar Cutcom Antes da Troca"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Cutcom Desativado"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Desativado"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Retardo"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Segundos"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Formato"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Modo de Saída"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Somente Segundos"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Somente Revoluções"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Depende da Taxa de Avanço"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Inverter Tempo"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Revoluções"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Formato"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Carregar Ferramenta"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Parar"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Pré-selecionar Ferramenta"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Enfiar Fio"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Cortar Fio"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Guias do Fio"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Movimento Linear"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Movimento Linear"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Modo Rápido Adotado no Avanço Transversal Máximo "

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Movimento Circular"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "Código G do Movimento"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "Sentido Horário (SH)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "Sentido Anti-Horário (SAH)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Registro Circular "
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Círculo Completo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Quadrante"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "Definição de IJK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "Definição de IJ"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "Definição de IK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Planos Aplicáveis"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Editar Códigos do Plano "
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Raio"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Mínimo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Máximo"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Comprimento Mínimo de Arco"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Movimento Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "Código G"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Movimento Rápido"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Alteração do Plano de Trabalho"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Rosca no Torno"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "Código G da Rosca"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Constante"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Incremental"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "Reduzido"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "Código G e Personalização"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Personalizar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Esta chave permite que você personalize um ciclo. \n\nPor padrão, a construção básica de cada ciclo é definida pelas configurações dos Parâmetros Comuns. Estes elementos comuns em cada ciclo estão restringidos para modificações. \n\nAlternar esta chave permite que você obtenha o controle total da configuração de um ciclo. As alterações feitas nos Parâmetros Comuns não afetarão nenhum ciclo personalizado."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Início do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Esta opção pode ser ativada para as máquinas ferramentas que executam ciclos usando um bloco de início de ciclo (G79...) depois que o ciclo foi definido (G81...)."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Usar Bloco de Início de Ciclo Para Executar Ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Rápido - Para"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Retrair - Para"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Controle do Plano do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Parâmetros Comuns"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Ciclo Desativado"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Alteração do Plano do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Perfurar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Intervalo de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Texto de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Csink de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Profundidade de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Perfuração de Quebra-Cavaco"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "Puncionar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Calibre"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Intervalo do Orifício"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Orifício Arrastar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Orifício Não Arrastar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Orifício Voltar"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Orifício Manual"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Intervalo Manual do Orifício"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Bico Broca"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Quebrar Chip"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Intervalo de Perfuração (FaceDaMancha)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Profundidade de Perfuração (Incremento)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Orifício (Escarear)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Orifício Não Arrastar"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Movimento Rápido"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Movimento Linear"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Interpolação Circular SH"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Interpolação Circular SAH"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Atraso (Seg)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Atraso (Rev)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "Plano XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "Plano ZX "
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "Plano YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Cutcom Desativado"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Cutcom Esquerdo"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Cutcom Direito"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Ajuste do Comprimento da Ferramenta Para Mais"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Ajuste do Comprimento da Ferramenta Para Menos"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Ajuste do Comprimento da Ferramenta Desativado"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Modo Polegada"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Modo Métrico"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Código de Início do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Ciclo Desativado"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Ciclo de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Intervalo do Ciclo de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Profundidade do Ciclo de Perfuração "
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Quebra de Cavaco do Ciclo de Perfuração"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Ciclo de Rosqueamento"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Ciclo do Orifício"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Ciclo do Orifício Arrastar"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Ciclo do Orifício Não Arrastar"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Intervalo do Ciclo do Orifício "
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Ciclo do Orifício Manual"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Ciclo do Orifício Voltar"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Intervalo do Ciclo do Orifício Manual"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Modo Absoluto"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Modo Incrementos"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Ciclo Retrair (AUTOMÁTICO)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Ciclo Retrair (MANUAL)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Redefinir"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "Modo da Taxa de Avanço IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "Modo da Taxa de Avanço IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "Modo da Taxa de Avanço FRN"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "Fuso CSS"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "RPM do fuso"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Retornar ao Início"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Rosqueamento Constante"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Rosqueamento em Incrementos"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Reduzir Rosqueamento"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "Modo Taxa de Avanço IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "Modo Taxa de Avanço IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "Modo da Taxa de Avanço MMPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "Modo da Taxa de Avanço MMPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "Modo da Taxa de Avanço DPM"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Parar/Troca de Ferramenta Manual "
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Parar"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Fim do Programa "
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Fuso Ativado/SH"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Fuso SAH"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Rosca Constante"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Rosca Incremental"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Rosca Decremental"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Fuso Desativado"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Troca de Ferramenta/Retrair"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "Refrigerante Ligado"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Líquido de Refrigeração Contínuo"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Líquido de Refrigeração em Névoa"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Líquido de Refrigeração Através"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Líquido de Refrigeração no Rosqueamento"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "Refrigerante Desligado"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Retroceder"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Enfiar Fio"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Cortar Fio"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Nivelamento Ativado"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Nivelamento Desativado"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Energia Ativada"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Energia Desativada"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Fio Ativado"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Fio Desativado"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Torre Principal"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Torre Secundária"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "Habilitar Editor UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Conforme Salvo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Evento Definido pelo Usuário"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "Nenhum UDE importante!"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Integer"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Adicionar um novo parâmetro inteiro, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Real"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Adicionar um novo parâmetro real, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Texto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Adicionar um novo parâmetro de sequência, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Booleano"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Adicionar um novo parâmetro booleano, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Opção"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Adicionar um novo parâmetro de opção, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Ponto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Adicionar um novo parâmetro de ponto, arrastando-o para a lista à direita."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Editor -- Lata de Lixo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Você pode eliminar os parâmetros não desejados da lista à direita, arrastando-os para esta lata de lixo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "Você pode editar parâmetros de evento aqui, pelo MB1."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Evento -- Parâmetros"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Você pode editar cada parâmetro clicando com o botão direito do mouse ou alterar a ordem dos parâmetros com a função arrastar e soltar.\n \nO parâmetro na cor azul-claro é definido pelo sistema e não pode ser excluído. \nO parâmetro na cor areia escura não é definido pelo sistema e pode ser modificado ou excluído."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Parâmetros -- Opção"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Clique com o mouse do botão 1 para selecionar a opção padrão.\n Dê um duplo clique com o botão do mouse 1 para editar a opção."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Tipo de Parâmetro: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Selecionar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Exibir"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Fundo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Cancelar"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Etiqueta do Parâmetro"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Nome da Variável"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Valor Padrão"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Especificar a etiqueta do parâmetro"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Especificar o nome da variável"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Especificar o valor padrão"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Alternar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Alternar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Selecionar o valor de alternância"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Ativado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Desativado"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Selecionar o valor padrão como ATIVADO"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Selecionar o valor padrão como DESATIVADO"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Lista de Opções "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Adicionar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Cortar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Colar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Adicionar um item"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Recortar um item"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Colar um item"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Opção"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Digitar um item"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Nome do Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Especificar o nome do evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "Nome da Coluna"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "Especificar o nome da coluna"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nome da Coluna"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Esta chave permite que você defina o nome da coluna"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Etiqueta do Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Especificar a etiqueta do evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Etiqueta do Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Esta chave permite que você defina a etiqueta do evento"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Categoria"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Esta chave permite que você defina a categoria"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fresar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Perfurar"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Torno"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Wedm"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Definir a categoria da fresa"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Definir a categoria da broca"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Definir a categoria do torno"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Definir a categoria de wedm"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Editar Evento"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Criar Evento de Controle da Máquina"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Ajuda"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Editar Parâmetros Definidos pelo Usuário..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Editar..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Visualizar..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Excluir"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Criar Novo Evento de Controle da Máquina..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Importar Eventos de Controle da Máquina..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "O nome do evento não pode estar em branco!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "O nome do evento já existe!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "O manipulador de evento já existe! \nModificar o nome do evento ou o nome da coluna, se estiver marcado!"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "Não há parâmetros neste evento!"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "Eventos Definidos Pelo Usuário"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "Eventos de Controle de Máquina"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Ciclos Definidos pelo Usuário "
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Eventos de Controle da Máquina do Sistema"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Eventos de Controle da Máquina do Não Sistema"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Ciclos do Sistema"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Ciclos do Não Sistema"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Escolher o item para definição"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "A sequência de opção não pode estar em branco!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "A sequência de opção já existe!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "A opção que você colou já existe!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Algumas opções são idênticas!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "Não há nenhuma opção na lista!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "O nome da variável não pode estar em branco!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "O nome da variável já existe!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "Este evento compartilha o UDE com o \"RPM do Fuso\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "Herdar UDE De Uma Coluna"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Esta opção permite que esta coluna herde a definição de UDE e seus manipuladores de uma coluna."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Selecionar Coluna"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Selecionar o arquivo PUI da coluna desejada. É recomendável que todos os arquivos (PUI, Def, Tcl e CDL) associados com a coluna que está sendo herdada sejam colocados no mesmo diretório (pasta) para utilização do tempo de execução."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "Nome do Arquivo CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "O nome do caminho e do arquivo CDL associado com a coluna selecionada que será referenciada (INCLUIR) no arquivo de definição desta coluna. O nome do caminho deve começar com uma variável de ambiente UG (\\\$UGII) ou sem nenhuma. Se nenhum caminho for especificado, será usado o UGII_CAM_FILE_SEARCH_PATH para localizar o arquivo pelo UG/NX no tempo de execução. "

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Nome do Arquivo Def"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "O nome do caminho e do arquivo de definição da coluna selecionada que será referenciada (INCLUIR) no arquivo de definição desta coluna. O nome do caminho deve começar com uma variável de ambiente UG (\\\$UGII) ou sem nenhuma. Se nenhum caminho for especificado, será usado UGII_CAM_FILE_SEARCH_PATH para localizar o arquivo pelo UG/NX no tempo de execução. "

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Coluna"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Pasta"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Pasta"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Incluir o Arquivo CDL Próprio"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Esta opção permite que esta coluna inclua a referência do seu próprio arquivo CDL no seu arquivo de definição."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Arquivo CDL Próprio"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "O nome do caminho e do arquivo CDL associado com esta coluna a ser referenciada (INCLUIR) no arquivo de definição desta coluna. O nome do arquivo real será determinado quando esta coluna for salva. O nome do caminho deve começar com uma variável de ambiente UG (\\\$UGII) ou sem nenhuma. Se nenhum caminho for especificado, será usado UGII_CAM_FILE_SEARCH_PATH para localizar o arquivo pelo UG/NX no tempo de execução."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "Selecionar um arquivo PUI"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "Selecionar um arquivo CDL"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Ciclo Definido pelo Usuário "
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Criar Ciclo Definido pelo Usuário "
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Tipo de Ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Definido pelo usuário"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Sistema Definido"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Etiqueta do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Nome do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Especificar a etiqueta do ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Especificar o nome do ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Etiqueta do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Esta chave permite que você defina uma etiqueta do ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Editar os Parâmetros Definidos pelo Usuário..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "O nome do ciclo não pode estar em branco!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "O nome do ciclo já existe!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "O manipulador de evento já existe!\n Modifique o nome do evento do ciclo!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "O nome do ciclo pertence ao tipo Ciclo do Sistema!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Este tipo de Ciclo do Sistema já existe!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Editar Evento do Ciclo"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Criar um Novo Ciclo Definido pelo Usuário..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Importar Ciclos Definidos pelo Usuário..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "Este evento compartilha o manipulador com a Broca!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "Este evento é um tipo de ciclos simulados!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "Este evento compartilha o Ciclo Definido pelo Usuário com  "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Controlador N/C Virtual"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Especificar parâmetros para ISV"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "Revisar os Comandos VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Configuração"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "Comandos VNC"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "Selecionar o arquivo VNC mestre para um VNC subordinado."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Ferramenta de Máquina"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Montagem da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Programar a Referência Zero"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Componente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Especificar um componente como a base de referência ZCS. Ele deve ser um componente não giratório ao qual a peça está conectada direta ou indiretamente na árvore Cinemática."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Componente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Especificar um componente ao qual serão montadas as ferramentas. Ele deve ser o componente do fuso para uma coluna de fresa e o componente da torre para uma coluna do torno."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Junção"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Definir uma Junção para as ferramentas de montagem. É a Junção no centro da face do fuso de uma coluna de fresa. É a Junção giratória da torre de uma coluna de torno. Será a Junção de montagem da ferramenta, se a torre estiver fixada."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "Eixo Especificado na Máquina Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Especificar os nomes do eixo para que se correspondam com a configuração cinemática da sua máquina ferramenta."




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "Nomes do Eixos NC"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Inverter Rotação"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Especificar a direção de rotação do eixo. Pode ser inversa ou normal. Aplica-se somente a uma mesa giratória."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Inverter a Rotação"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Limite de Rotação"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Especificar se o eixo giratório tem limites"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Limite de Rotação"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Sim"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "Não"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "4º Eixo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "5º Eixo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Tabela "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Controlador"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Configuração Inicial"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Outras Opções"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Códigos NC Especiais"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Definição do Programa Padrão"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Exportar Definição do Programa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Salvar a Definição do Programa em um arquivo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Importar a Definição do Programa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Recuperar a Definição do Programa de um arquivo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "O arquivo selecionado não coincide com o tipo de Arquivo de Definição de Programa padrão; você deseja continuar?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Deslocamentos do Acessório"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Dados da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Código G Especial"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Código NC Especial"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Movimento"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Especificar o movimento inicial da Ferramenta de Máquina"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Fuso"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Modo"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Direção"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Especificar a unidade da velocidade inicial do fuso e a direção de rotação"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Modo de Taxa de Avanço"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Especificar a unidade da taxa de avanço inicial"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Definição do Item Booleano"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "Energia Ativada  WCS  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 indica que será usada a coordenada zero padrão da máquina\n 1 indica que será usado o primeiro deslocamento do acessório definido pelo usuário (coordenada de trabalho)"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "Usado S "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "Usado F "


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Ângulo Agudo Rápido "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "ATIVADO vai percorrer os movimento rápidos como se fosse um ângulo agudo; DESATIVADO vai percorrer os movimentos rápidos segundo o código NC (ponto a ponto)."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Sim"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "Não"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "Definição de ATIVADO/DESATIVADO"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Limite do Curso"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Cutcom"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Ajuste do Comprimento da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              " Escala"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Modal Macro"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "Rotação WCS"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Ciclo"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Modo de Entrada"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Especificar o modo de entrada inicial como absoluto ou em incrementos"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Código Parar Voltar Atrás"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Especificar o Código Parar Volta Atrás"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Variáveis de Controle"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Seta"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Especificar a variável do controlador"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Sinal de Igual"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Especificar o Sinal de Igual de controle"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Sinal de porcentagem %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Afiado #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Sequência de texto"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Modo Inicial"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Absoluto"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Modo de Incrementos"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Incremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "Código G"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Usando G90 ou G91 para diferenciar entre o modo absoluto e o modo em incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Seta Especial"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Usando a seta especial para diferenciar entre o modo absoluto e o modo em incrementos. fig: Seta X Y Z indica que está no modo absoluto; Seta U V W indica que está no modo em incrementos."
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "Quarto Eixo "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "Quinto Eixo "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Especificar a seta especial do Eixo X usada no estilo de incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Especificar a seta especial do Eixo Y usada no estilo de incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Especificar a seta especial do Eixo Z usada no estilo de incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Especificar a seta especial do Quarto Eixo usada no estilo de incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Especificar a seta especial do Quinto Eixo usada no estilo de incrementos"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "Mensagem VNC da Saída"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "Mensagem VNC da Lista"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Se esta opção está marcada, todas as mensagens de depuração VNC serão exibidas na janela de mensagem de operação durante a simulação."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Prefixo da Mensagem"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Descrição"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Lista de Códigos"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "Código NC / Sequência"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Deslocamentos Zero da Máquina da\nJunção Zero da Máquina Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Deslocamentos do Acessório"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Código "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " Deslocamento X  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Deslocamento Y  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Deslocamento Z  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " Deslocamento A  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " Deslocamento B  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " Deslocamento C  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Sistema de Coordenadas"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Especificar o número do deslocamento do acessório que necessita ser adicionado"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Adicionar"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Adicionar novo sistema de coordenadas de deslocamento do acessório,especificar sua posição."
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Este número do sistema de coordenadas já existiu!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Informação da Ferramenta"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Inserir um nome de ferramenta novo"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Nome       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Ferramenta "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Adicionar"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Diâmetro "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Deslocamentos da Ponta   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " ID do Transportador "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " ID da Cavidade "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     CUTCOM     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Registrar "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Deslocamento "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Ajuste do Comprimento  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Tipo   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Definição do Programa Padrão"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Definição do Programa"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Especificar o Arquivo de Definição do Programa"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Selecionar o Arquivo de Definição do Programa"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Número da Ferramenta  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Especificar o número da ferramenta que necessita ser adicionado"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Adicionar uma ferramenta nova,especificar seus parâmetros"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Este número de ferramenta já existiu!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "O nome da ferramenta não pode estar vazio!"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Código G Especial"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "Especificar os códigos G especiais usados na simulação"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Do Início"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Retornar ao Início"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Movimento de Referência da Máquina"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Definir a Coordenada Local "

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "Comandos NC Especiais"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Comandos NC especificados para dispositivos especiais"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Comandos Pré-processados"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "A lista de comandos inclui todos os sinais ou símbolos que necessitam ser processados antes que um bloco seja sujeito à análise para coordenadas"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Adicionar"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Editar"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Excluir"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Comando Especial para outros Dispositivos"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "Adicionar Comando SIM @Cursor"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Selecionar um Comando"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Seta"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Especificar a Seta para o comando pré-processado definido pelo usuário."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Código"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Especificar a Seta para o comando pré-processado definido pelo cliente."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Seta"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Especificar a Seta para o comando definido pelo usuário."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Código"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Especificar a Seta para o comando definido pelo cliente."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Adicionar um novo comando definido pelo usuário"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Este símbolo já foi processado!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Escolher um comando"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Aviso"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Tabela de Ferramentas"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "Este é um comando VNC gerado pelo sistema. As alterações não serão salvas."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Idioma"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Inglês"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Francês"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Alemão"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Italiano"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "Japonês"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "Coreano"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "Russo"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "Chinês Simplificado"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "Espanhol"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "Chinês Tradicional "

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Sair das Opções"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Sair e Salvar Tudo"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Sair sem Salvar"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Sair e Salvar Selecionado"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Outras"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Nenhum"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Transversal Rápido e R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Fuso Rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Ciclo Desativado e, em seguida, Fuso Rápido"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Automático"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Absoluto/Em Incrementos"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Somente Absoluto "
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Somente Em Incrementos"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "Distância mais curta"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Sempre Positivo"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Sempre Negativo"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Eixo Z"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+Eixo X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-Eixo X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Eixo Y"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "A Magnitude Determina a Direção"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "O Sinal Determina a Direção"


