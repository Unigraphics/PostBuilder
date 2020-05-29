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
::msgcat::mcset pb_msg_japanese "MC(event,misc,subop_start,name)"      "サブオペレーションパスの開始"
::msgcat::mcset pb_msg_japanese "MC(event,misc,subop_end,name)"        "サブオペレーションパスの終了"
::msgcat::mcset pb_msg_japanese "MC(event,misc,contour_start,name)"    "コンタ開始"
::msgcat::mcset pb_msg_japanese "MC(event,misc,contour_end,name)"      "コンタ終了"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,misc,Label)"             "その他"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,lathe_rough,name)"     "旋盤荒削り"
::msgcat::mcset pb_msg_japanese "MC(main,file,properties,Label)"       "ポストプロパティ"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_CATEGORY)"    "ミルまたは旋盤ポストのUDEは、\"Wedm\" カテゴリでのみ指定することはできません!"

::msgcat::mcset pb_msg_japanese "MC(event,cycle,plane_change,label)"   "作業平面を下側に検出"
::msgcat::mcset pb_msg_japanese "MC(format,check_1,error,msg)"         "フォーマットは式の値を満たすことができません"

::msgcat::mcset pb_msg_japanese "MC(format,check_4,error,msg)"         "このページを終了する前またはこのポストを保存する前に関係するアドレスのフォーマットを変更してください!"
::msgcat::mcset pb_msg_japanese "MC(format,check_5,error,msg)"         "このページを終了するかまたはこのポストを保存する前にフォーマットを修正してください!"
::msgcat::mcset pb_msg_japanese "MC(format,check_6,error,msg)"         "このページを開始する前に関係するアドレスのフォーマットを変更してください!"

::msgcat::mcset pb_msg_japanese "MC(msg,old_block,maximum_length)"     "次のブロックの名前は、長さ制限を超えています:"
::msgcat::mcset pb_msg_japanese "MC(msg,old_address,maximum_length)"   "次のワードの名前は、長さ制限を超えています:"
::msgcat::mcset pb_msg_japanese "MC(msg,block_address,check,title)"    "ブロックおよびワード名をチェックしています"
::msgcat::mcset pb_msg_japanese "MC(msg,block_address,maximum_length)" "幾つかのブロックまたはワードの名前が長さ制限を超えています。"

::msgcat::mcset pb_msg_japanese "MC(address,maximum_name_msg)"         "文字列長さが制限を超えています。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,oth_list,Label)"        "他のCDLファイルを含む"
::msgcat::mcset pb_msg_japanese "MC(ude,import,oth_list,Context)"      "ポップアップメニュー(右クリック)から\\\"新規作成\\\" オプションを選択して、このポストのCDLファイルを含みます。"
::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr_list,Label)"        "ポストからUDEを継承"
::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr_list,Context)"      "ポップアップメニュー(右クリック)から\\\"新規作成\\\" オプションを選択して、ポストからUDE定義および関連するハンドラを継承します。"
::msgcat::mcset pb_msg_japanese "MC(ude,import,up,Label)"              "上"
::msgcat::mcset pb_msg_japanese "MC(ude,import,down,Label)"            "下"
::msgcat::mcset pb_msg_japanese "MC(msg,exist_cdl_file)"               "指定したCDLファイルは既に含まれています!"

::msgcat::mcset pb_msg_japanese "MC(listing,link_var,check,Label)"     "Tcl変数をC変数にリンク"
::msgcat::mcset pb_msg_japanese "MC(listing,link_var,check,Context)"   "(\\\"mom_pos\\\" などの)頻繁に変更されるTcl変数は、内部C変数に直接リンクしてポスト処理のパフォーマンスを向上させることが可能です。しかしながら、NC出力において発生し得るエラーや差異を避けるために、特定の制限を観察する必要があります。"

::msgcat::mcset pb_msg_japanese "MC(msg,check_resolution,title)"       "線形/回転モーションレゾリューションをチェック"
::msgcat::mcset pb_msg_japanese "MC(msg,check_resolution,linear)"      "フォーマット設定は、\"線形モーションレゾリューション\" の出力に適用できません。"
::msgcat::mcset pb_msg_japanese "MC(msg,check_resolution,rotary)"      "フォーマット設定は、\"回転モーションレゾリューション\" の出力に適用できません。"

::msgcat::mcset pb_msg_japanese "MC(cmd,export,desc,label)"            "エクスポートされたカスタムコマンドの説明を入力"
::msgcat::mcset pb_msg_japanese "MC(cmd,desc_dlg,title)"               "説明"
::msgcat::mcset pb_msg_japanese "MC(block,delete_row,Label)"           "この行におけるすべてのアクティブな要素を削除"
::msgcat::mcset pb_msg_japanese "MC(block,exec_cond,set,Label)"        "出力条件"
::msgcat::mcset pb_msg_japanese "MC(block,exec_cond,new,Label)"        "新規作成..."
::msgcat::mcset pb_msg_japanese "MC(block,exec_cond,edit,Label)"       "編集..."
::msgcat::mcset pb_msg_japanese "MC(block,exec_cond,remove,Label)"     "除去..."

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name_msg_for_cond)"       "異なる名前を指定してください。 \n出力条件コマンドは次のプレフィックスが必要です"

::msgcat::mcset pb_msg_japanese "MC(machine,linearization,Label)"         "線形補間"
::msgcat::mcset pb_msg_japanese "MC(machine,linearization,angle,Label)"   "回転角度"
::msgcat::mcset pb_msg_japanese "MC(machine,linearization,angle,Context)" "補間された点は、回転軸の最初と最後の分布を基準として計算されます。"
::msgcat::mcset pb_msg_japanese "MC(machine,linearization,axis,Label)"    "ツール軸"
::msgcat::mcset pb_msg_japanese "MC(machine,linearization,axis,Context)"  "補間された点は、ツール軸の最初と最後のベクトルの分布を基準として計算されます。"
::msgcat::mcset pb_msg_japanese "MC(machine,resolution,continue,Label)"   "継続"
::msgcat::mcset pb_msg_japanese "MC(machine,resolution,abort,Label)"      "中止"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,def_lintol,Label)"       "デフォルト公差"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,def_lintol,Context)"     "デフォルト線形化公差"
::msgcat::mcset pb_msg_japanese "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset pb_msg_japanese "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_japanese "MC(new_sub,title,Label)"                 "新規下位ポストプロセッサを作成"
::msgcat::mcset pb_msg_japanese "MC(new,sub_post,toggle,label)"           "下位ポスト"
::msgcat::mcset pb_msg_japanese "MC(new,sub_post,toggle,tmp_label)"       "サブポスト - 単位のみ"
::msgcat::mcset pb_msg_japanese "MC(new,unit_post,filename,msg)"          "別の出力単位の新規下位ポストは、ポストフィックス\n\"__MM\" または\"__IN\" をメインポストの名前に追加することにより命名する必要があります。"
::msgcat::mcset pb_msg_japanese "MC(new,alter_unit,toggle,label)"         "別の出力単位"
::msgcat::mcset pb_msg_japanese "MC(new,main_post,label)"                 "メインポスト"
::msgcat::mcset pb_msg_japanese "MC(new,main_post,warning_1,msg)"         "完全なメインポストのみが新規下位ポストの作成に使用できます!"
::msgcat::mcset pb_msg_japanese "MC(new,main_post,warning_2,msg)"         "メインポストは、ポストビルダバージョン8.0またはそれ以降において\n作成または保存されなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(new,main_post,specify_err,msg)"       "下位ポストの作成のためにメインポストを指定しなければなりません!"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,alter_unit,Label)"        "サブポスト出力単位 :"
::msgcat::mcset pb_msg_japanese "MC(unit_related_param,tab,Label)"        "単位パラメータ"
::msgcat::mcset pb_msg_japanese "MC(unit_related_param,feed_rate,Label)"  "送り速度"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,frame,Label)"        "別の単位のサブポスト(オプション)"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,default,Label)"      "デフォルト"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,default,Context)"    "別の単位サブポストのデフォルト名は、<post name>__MM または <post name>__IN です"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,specify,Label)"      "指定"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,specify,Context)"    "別の単位サブポストの名前を指定"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,select_name,Label)"  "名前を選択"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,warning_1,msg)"      "1つの別の単位サブポストのみが選択可能です!"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,warning_2,msg)"      "選択したサブポストは、このポストに対する別の出力をサポートできません!"

::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,post_name,Label)"    "別の単位サブポスト"
::msgcat::mcset pb_msg_japanese "MC(listing,alt_unit,post_name,Context)"  "NX Postは、単位サブポストが提供されている場合はそれを使用して、このポストに対する別の出力単位を扱います。"


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,user,evt_title)"  "軸限界違反に対するユーザ定義アクション"
::msgcat::mcset pb_msg_japanese "MC(event,helix,name)"                       "螺旋移動"
::msgcat::mcset pb_msg_japanese "MC(event,circular,ijk_param,prefix,msg)"    "アドレスで使用される式は"
::msgcat::mcset pb_msg_japanese "MC(event,circular,ijk_param,postfix,msg)"   "このオプションの変更には影響されません!"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_codelist,default,msg)"          "このアクションは特殊なNCコードのリストおよびそれらの\nハンドラを、このポストが開かれたときまたは作成されたときの状態に戻します。\n\n続行しますか?"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_codelist,restore,msg)"          "このアクションは特殊なNCコードのリストおよびそれらの\nハンドラを、このページを最後に開いたときの状態に戻します。\n\n続行しますか?"
::msgcat::mcset pb_msg_japanese "MC(msg,block_format_command,paste_err)"     "オブジェクト名が存在します...貼付けは無効です!"
::msgcat::mcset pb_msg_japanese "MC(main,file,open,choose_cntl_type)"        "コントローラファミリを選択"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,no_vnc_cmd,msg)"         "このファイルは、新しいVNCコマンドまたは異なるVNCコマンドを含んでいません!"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,no_cmd,msg)"             "このファイルは、新しいカスタムコマンドまたは異なるカスタムコマンドを含んでいません!"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,name_same_err,Msg)"        "ツール名は同一にできません!"
::msgcat::mcset pb_msg_japanese "MC(msg,limit_to_change_license)"            "このポストの作者ではありません。\nこのポストの名前を変更したりライセンスを変更する権限はありません。"
::msgcat::mcset pb_msg_japanese "MC(output,other_opts,validation,msg)"       "ユーザのtclファイルの名前を指定する必要があります。"
::msgcat::mcset pb_msg_japanese "MC(machine,empty_entry_err,msg)"            "このパラメータページには空のエントリがあります。"
::msgcat::mcset pb_msg_japanese "MC(msg,control_v_limit)"                    "貼付けようとしているストリングは長さ制限を\n越えているか、あるいは複数行や無効な\n文字を含んでいる可能性があります。"
::msgcat::mcset pb_msg_japanese "MC(block,capital_name_msg)"                 "ブロック名の先頭の文字は大文字にできません!\n 別の名前を指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,user,Label)"      "ユーザ定義"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,user,Handler)"    "ハンドラ"
::msgcat::mcset pb_msg_japanese "MC(new,user,file,NOT_EXIST)"                "このユーザファイルは存在しません!"
::msgcat::mcset pb_msg_japanese "MC(new,include_vnc,Label)"                  "仮想NCコントローラを含む"
::msgcat::mcset pb_msg_japanese "MC(other,opt_equal,Label)"                  "等号 (=)"
::msgcat::mcset pb_msg_japanese "MC(event,nurbs,name)"                       "NURBS移動"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,tap_float,name)"             "タップフロート"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,thread,name)"                "ねじ切り"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,group,MSG_NESTED_GROUP)"      "ネストされたグループ化はサポートされていません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,bmp,Label)"                   "ビットマップ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,bmp,Context)"                 "新しいビットマップパラメータを右のリストにドラッグすることで追加します。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,group,Label)"                 "グループ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,group,Context)"               "新しいグループパラメータを右のリストにドラッグすることで追加します。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,DESC,Label)"         "説明"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,DESC,Context)"       "イベント情報を指定"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,URL,Context)"        "イベント説明に対するURLを指定"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "イメージファイルはBMPフォーマットでなければなりません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "ビットマップファイル名にはディレクトリパスを含めません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "変数名は、文字で始めなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "変数名では、次のキーワードは使用すべきではありません: "
::msgcat::mcset pb_msg_japanese "MC(ude,editor,status_label)"                "ステータス"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,vector,Label)"                "ベクトル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,vector,Context)"              "新しいベクトルパラメータを右のリストにドラッグすることで追加します。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URLのフォーマットは、\"http://*\"または\"file://*\"で、バックスラッシュは使用しません。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "説明およびURLを指定しなければなりません! "
::msgcat::mcset pb_msg_japanese "MC(new,MSG_NO_AXIS)"                        "工作機械に対して軸構成を選択しなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(machine,info,controller_type,Label)"     "コントローラファミリ"
::msgcat::mcset pb_msg_japanese "MC(block,func_combo,Label)"                 "マクロ"
::msgcat::mcset pb_msg_japanese "MC(block,prefix_popup,add,Label)"           "プレフィックステキストを追加"
::msgcat::mcset pb_msg_japanese "MC(block,prefix_popup,edit,Label)"          "プレフィックステキストを編集"
::msgcat::mcset pb_msg_japanese "MC(block,prefix,Label)"                     "プレフィックス"
::msgcat::mcset pb_msg_japanese "MC(block,suppress_popup,Label)"             "シーケンス番号を抑制"
::msgcat::mcset pb_msg_japanese "MC(block,custom_func,Label)"                "カスタムマクロ"
::msgcat::mcset pb_msg_japanese "MC(seq,combo,macro,Label)"                  "カスタムマクロ"
::msgcat::mcset pb_msg_japanese "MC(func,tab,Label)"                         "マクロ"
::msgcat::mcset pb_msg_japanese "MC(func,exp,msg)"                           "マクロのパラメータに対する式はブランクではいけません。"
::msgcat::mcset pb_msg_japanese "MC(func,edit,name,Label)"                   "マクロ名"
::msgcat::mcset pb_msg_japanese "MC(func,disp_name,Label)"                   "出力名"
::msgcat::mcset pb_msg_japanese "MC(func,param_list,Label)"                  "パラメータリスト"
::msgcat::mcset pb_msg_japanese "MC(func,separator,Label)"                   "セパレータ"
::msgcat::mcset pb_msg_japanese "MC(func,start,Label)"                       "開始文字"
::msgcat::mcset pb_msg_japanese "MC(func,end,Label)"                         "終了文字"
::msgcat::mcset pb_msg_japanese "MC(func,output,name,Label)"                 "出力属性"
::msgcat::mcset pb_msg_japanese "MC(func,output,check,Label)"                "出力パラメータ名"
::msgcat::mcset pb_msg_japanese "MC(func,output,link,Label)"                 "リンク文字"
::msgcat::mcset pb_msg_japanese "MC(func,col_param,Label)"                   "パラメータ"
::msgcat::mcset pb_msg_japanese "MC(func,col_exp,Label)"                     "式"
::msgcat::mcset pb_msg_japanese "MC(func,popup,insert,Label)"                "新規作成"
::msgcat::mcset pb_msg_japanese "MC(func,name,err_msg)"                      "マクロ名にスペースを含めてはいけません!"
::msgcat::mcset pb_msg_japanese "MC(func,name,blank_err)"                    "マクロ名はブランクでない必要があります! "
::msgcat::mcset pb_msg_japanese "MC(func,name,contain_err)"                  "マクロ名にはアルファベット、数字および下線文字のみを使用します! "
::msgcat::mcset pb_msg_japanese "MC(func,tree_node,start_err)"               "ノード名は大文字で開始しなければなりません!"
::msgcat::mcset pb_msg_japanese "MC(func,tree_node,contain_err)"             "ノード名の文字は、アルファベット、数字または下線のみが受入れられます!"
::msgcat::mcset pb_msg_japanese "MC(func,help,Label)"                        "情報"
::msgcat::mcset pb_msg_japanese "MC(func,help,Context)"                      "オブジェクトの情報を表示します。"
::msgcat::mcset pb_msg_japanese "MC(func,help,MSG_NO_INFO)"                  "このマクロに対して情報は提供されていません。"


##------
## Title
##
::msgcat::mcset pb_msg_japanese "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_japanese "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_japanese "MC(main,title,Post_Builder)"            "ポストビルダ"

::msgcat::mcset pb_msg_japanese "MC(main,title,Version)"                 "バージョン"
::msgcat::mcset pb_msg_japanese "MC(main,default,Status)"                "ファイルメニューの新規作成または開くオプションを選択します。"
::msgcat::mcset pb_msg_japanese "MC(main,save,Status)"                   "ポストを保存します。"

##------
## File
##
::msgcat::mcset pb_msg_japanese "MC(main,file,Label)"                    "ファイル"

::msgcat::mcset pb_msg_japanese "MC(main,file,Balloon)"                  "\ 新規作成、開く、保存、\n 名前を変えて\ 保存、閉じるおよび終了、を行います"

::msgcat::mcset pb_msg_japanese "MC(main,file,Context)"                  "\ 新規作成、開く、保存、\n 名前を変えて\ 保存、閉じるおよび終了、を行います"
::msgcat::mcset pb_msg_japanese "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_japanese "MC(main,file,new,Label)"                "新規作成..."
::msgcat::mcset pb_msg_japanese "MC(main,file,new,Balloon)"              "新規ポストを作成します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,new,Context)"              "新規ポストを作成します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,new,Busy)"                 "新規ポストを作成しています..."

::msgcat::mcset pb_msg_japanese "MC(main,file,open,Label)"               "開く..."
::msgcat::mcset pb_msg_japanese "MC(main,file,open,Balloon)"             "既存のポストを編集します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,open,Context)"             "既存のポストを編集します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,open,Busy)"                "ポストを開いています..."

::msgcat::mcset pb_msg_japanese "MC(main,file,mdfa,Label)"               "MDFAをインポート..."
::msgcat::mcset pb_msg_japanese "MC(main,file,mdfa,Balloon)"             "MDFAから新規ポストを作成します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,mdfa,Context)"             "MDFAから新規ポストを作成します。"

::msgcat::mcset pb_msg_japanese "MC(main,file,save,Label)"               "保存"
::msgcat::mcset pb_msg_japanese "MC(main,file,save,Balloon)"             "実行中のポストを保存します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,save,Context)"             "実行中のポストを保存します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,save,Busy)"                "ポストを保存しています..."

::msgcat::mcset pb_msg_japanese "MC(main,file,save_as,Label)"            "名前を変えて保存..."
::msgcat::mcset pb_msg_japanese "MC(main,file,save_as,Balloon)"          "ポストを新しい名前で保存します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,save_as,Context)"          "ポストを新しい名前で保存します。"

::msgcat::mcset pb_msg_japanese "MC(main,file,close,Label)"              "閉じる"
::msgcat::mcset pb_msg_japanese "MC(main,file,close,Balloon)"            "実行中のポストを閉じます。"
::msgcat::mcset pb_msg_japanese "MC(main,file,close,Context)"            "実行中のポストを閉じます。"

::msgcat::mcset pb_msg_japanese "MC(main,file,exit,Label)"               "終了"
::msgcat::mcset pb_msg_japanese "MC(main,file,exit,Balloon)"             "ポストビルダを終了します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,exit,Context)"             "ポストビルダを終了します。"

::msgcat::mcset pb_msg_japanese "MC(main,file,history,Label)"            "最近開いたポスト"
::msgcat::mcset pb_msg_japanese "MC(main,file,history,Balloon)"          "以前に使用したポストを編集します。"
::msgcat::mcset pb_msg_japanese "MC(main,file,history,Context)"          "以前のポストビルダセッションで使用したポストを編集します。"

##---------
## Options
##
::msgcat::mcset pb_msg_japanese "MC(main,options,Label)"                 "オプション"

::msgcat::mcset pb_msg_japanese "MC(main,options,Balloon)"               " カスタム\ コマンドを\ 検証、ポストを\ バックアップ"
::msgcat::mcset pb_msg_japanese "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_japanese "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_japanese "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_japanese "MC(main,windows,Balloon)"               "編集ポストリスト"
::msgcat::mcset pb_msg_japanese "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_japanese "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_japanese "MC(main,options,properties,Label)"      "プロパティ"
::msgcat::mcset pb_msg_japanese "MC(main,options,properties,Balloon)"    "プロパティ"
::msgcat::mcset pb_msg_japanese "MC(main,options,properties,Context)"    "プロパティ"

::msgcat::mcset pb_msg_japanese "MC(main,options,advisor,Label)"         "ポストアドバイザ"
::msgcat::mcset pb_msg_japanese "MC(main,options,advisor,Balloon)"       "ポストアドバイザ"
::msgcat::mcset pb_msg_japanese "MC(main,options,advisor,Context)"       "ポストアドバイザを使用可能/不可にします。"

::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,Label)"       "カスタムコマンドの検証"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,Balloon)"     "カスタムコマンドの検証"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,Context)"     "カスタムコマンド検証のスイッチです。"

::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,syntax,Label)"   "構文エラー"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,command,Label)"  "不明なコマンド"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,block,Label)"    "不明なブロック"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,address,Label)"  "不明なアドレス"
::msgcat::mcset pb_msg_japanese "MC(main,options,cmd_check,format,Label)"   "不明なフォーマット"

::msgcat::mcset pb_msg_japanese "MC(main,options,backup,Label)"          "ポストのバックアップ"
::msgcat::mcset pb_msg_japanese "MC(main,options,backup,Balloon)"        "ポストのバックアップ方法"
::msgcat::mcset pb_msg_japanese "MC(main,options,backup,Context)"        "実行中のポストの保存時に、バックアップコピーを作成します。"

::msgcat::mcset pb_msg_japanese "MC(main,options,backup,one,Label)"      "オリジナルをバックアップ"
::msgcat::mcset pb_msg_japanese "MC(main,options,backup,all,Label)"      "保存時にバックアップ"
::msgcat::mcset pb_msg_japanese "MC(main,options,backup,none,Label)"     "バックアップなし"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_japanese "MC(main,utils,Label)"                   "ユーティリティ"
::msgcat::mcset pb_msg_japanese "MC(main,utils,Balloon)"                 "\ MOM\ 変数を\ 選択、ポストを\ インストール"
::msgcat::mcset pb_msg_japanese "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_japanese "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_japanese "MC(main,utils,etpdf,Label)"             "テンプレートポストデータファイルの編集"

::msgcat::mcset pb_msg_japanese "MC(main,utils,bmv,Label)"               "MOM変数ブラウザ"
::msgcat::mcset pb_msg_japanese "MC(main,utils,blic,Label)"              "ライセンスをブラウズ"


##------
## Help
##
::msgcat::mcset pb_msg_japanese "MC(main,help,Label)"                    "ヘルプ"
::msgcat::mcset pb_msg_japanese "MC(main,help,Balloon)"                  "ヘルプのオプションを表示します"
::msgcat::mcset pb_msg_japanese "MC(main,help,Context)"                  "ヘルプオプション"
::msgcat::mcset pb_msg_japanese "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_japanese "MC(main,help,bal,Label)"                "バルーンチップ"
::msgcat::mcset pb_msg_japanese "MC(main,help,bal,Balloon)"              "アイコンのバルーンチップ"
::msgcat::mcset pb_msg_japanese "MC(main,help,bal,Context)"              "アイコンに対するバルーンツールチップの表示を使用可能/不可にします。"

::msgcat::mcset pb_msg_japanese "MC(main,help,chelp,Label)"              "コンテキストヘルプ"
::msgcat::mcset pb_msg_japanese "MC(main,help,chelp,Balloon)"            "ダイアログアイテムのコンテキストヘルプです"
::msgcat::mcset pb_msg_japanese "MC(main,help,chelp,Context)"            "ダイアログアイテムのコンテキストヘルプ"

::msgcat::mcset pb_msg_japanese "MC(main,help,what,Label)"               "作業内容"
::msgcat::mcset pb_msg_japanese "MC(main,help,what,Balloon)"             "ここで実行可能な内容を記します"
::msgcat::mcset pb_msg_japanese "MC(main,help,what,Context)"             "ここで実行可能な内容"

::msgcat::mcset pb_msg_japanese "MC(main,help,dialog,Label)"             "ダイアログのヘルプ"
::msgcat::mcset pb_msg_japanese "MC(main,help,dialog,Balloon)"           "このダイアログのヘルプです"
::msgcat::mcset pb_msg_japanese "MC(main,help,dialog,Context)"           "このダイアログのヘルプ"

::msgcat::mcset pb_msg_japanese "MC(main,help,manual,Label)"             "オンラインヘルプ"
::msgcat::mcset pb_msg_japanese "MC(main,help,manual,Balloon)"           "ユーザーのためのオンラインヘルプです"
::msgcat::mcset pb_msg_japanese "MC(main,help,manual,Context)"           "ユーザーズヘルプマニュアル"

::msgcat::mcset pb_msg_japanese "MC(main,help,about,Label)"              "バージョン情報"
::msgcat::mcset pb_msg_japanese "MC(main,help,about,Balloon)"            "バージョン情報"
::msgcat::mcset pb_msg_japanese "MC(main,help,about,Context)"            "バージョン情報"

::msgcat::mcset pb_msg_japanese "MC(main,help,rel_note,Label)"           "リリースノート"
::msgcat::mcset pb_msg_japanese "MC(main,help,rel_note,Balloon)"         "リリースノート"
::msgcat::mcset pb_msg_japanese "MC(main,help,rel_note,Context)"         "リリースノート"

::msgcat::mcset pb_msg_japanese "MC(main,help,tcl_man,Label)"            "Tcl/Tk リファレンスマニュアル"
::msgcat::mcset pb_msg_japanese "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk リファレンスマニュアル"
::msgcat::mcset pb_msg_japanese "MC(main,help,tcl_man,Context)"          "Tcl/Tk リファレンスマニュアル"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_japanese "MC(tool,new,Label)"                     "新規作成"
::msgcat::mcset pb_msg_japanese "MC(tool,new,Context)"                   "新規ポストを作成します。"

::msgcat::mcset pb_msg_japanese "MC(tool,open,Label)"                    "開く"
::msgcat::mcset pb_msg_japanese "MC(tool,open,Context)"                  "既存のポストを編集します。"

::msgcat::mcset pb_msg_japanese "MC(tool,save,Label)"                    "保存"
::msgcat::mcset pb_msg_japanese "MC(tool,save,Context)"                  "実行中のポストを保存します。"

::msgcat::mcset pb_msg_japanese "MC(tool,bal,Label)"                     "バルーンチップ"
::msgcat::mcset pb_msg_japanese "MC(tool,bal,Context)"                   "アイコンに対するバルーンツールチップの表示を使用可能/不可にします。"

::msgcat::mcset pb_msg_japanese "MC(tool,chelp,Label)"                   "コンテキストヘルプ"
::msgcat::mcset pb_msg_japanese "MC(tool,chelp,Context)"                 "ダイアログアイテムのコンテキストヘルプ"

::msgcat::mcset pb_msg_japanese "MC(tool,what,Label)"                    "作業内容"
::msgcat::mcset pb_msg_japanese "MC(tool,what,Context)"                  "ここで実行可能な内容"

::msgcat::mcset pb_msg_japanese "MC(tool,dialog,Label)"                  "ダイアログのヘルプ"
::msgcat::mcset pb_msg_japanese "MC(tool,dialog,Context)"                "このダイアログのヘルプ"

::msgcat::mcset pb_msg_japanese "MC(tool,manual,Label)"                  "ユーザーズマニュアル"
::msgcat::mcset pb_msg_japanese "MC(tool,manual,Context)"                "ユーザーズヘルプマニュアル"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_japanese "MC(msg,error,title)"                    "ポストビルダエラー"
::msgcat::mcset pb_msg_japanese "MC(msg,dialog,title)"                   "ポストビルダメッセージ"
::msgcat::mcset pb_msg_japanese "MC(msg,warning)"                        "警告"
::msgcat::mcset pb_msg_japanese "MC(msg,error)"                          "エラー"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_data)"                   "パラメータに対して無効なデータがキー入力されました"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_browser_cmd)"            "無効なブラウザコマンド:"
::msgcat::mcset pb_msg_japanese "MC(msg,wrong_filename)"                 "ファイル名が変更されています!"
::msgcat::mcset pb_msg_japanese "MC(msg,user_ctrl_limit)"                "作者でなければ、新規ポストの作成に対して\nライセンスされたポストをコントローラとして使用できません!"
::msgcat::mcset pb_msg_japanese "MC(msg,import_limit)"                   "このライセンスされたポストの作者ではありません。\n カスタムコマンドはインポートされない可能性があります!"
::msgcat::mcset pb_msg_japanese "MC(msg,limit_msg)"                      "このライセンスされたポストの作者ではありません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_file)"                        "ライセンスされたこのポストに対する暗号化されたファイルが見つかりません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_license)"                     "この機能を実行する適切なライセンスがありません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_license_title)"               "ライセンスがない状態でのNX/Post Builderの使用"
::msgcat::mcset pb_msg_japanese "MC(msg,no_license_dialog)"              "適切なライセンスがない状態でNX/Post Builderの使用\nを許可されています。しかしながら、後になって作業を\n保存することはできません。"
::msgcat::mcset pb_msg_japanese "MC(msg,pending)"                        "このオプションのサービスは、将来のリリースで実装されます。"
::msgcat::mcset pb_msg_japanese "MC(msg,save)"                           "実行中のポストを閉じる前に\n 変更内容を保存しますか?"
::msgcat::mcset pb_msg_japanese "MC(msg,version_check)"                  "新しいバージョンのポストビルダで作成されたポストは、このバージョンでは開けません。"

::msgcat::mcset pb_msg_japanese "MC(msg,file_corruption)"                "ポストビルダセッションファイルに不正な内容があります。"
::msgcat::mcset pb_msg_japanese "MC(msg,bad_tcl_file)"                   "ポストのTclファイルに不正な内容があります。"
::msgcat::mcset pb_msg_japanese "MC(msg,bad_def_file)"                   "ポストの定義ファイルに不正な内容があります。"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_post)"                   "ポストに対して少なくとも1セットのTclおよび定義ファイルを指定しなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_dir)"                    "ディレクトリが存在しません。"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_file)"                   "ファイルが見つからないか無効です。"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_def_file)"               "定義ファイルを開けません"
::msgcat::mcset pb_msg_japanese "MC(msg,invalid_tcl_file)"               "イベントハンドラファイルを開けません"
::msgcat::mcset pb_msg_japanese "MC(msg,dir_perm)"                       "ディレクトリに対する書込みアクセス権がありません:"
::msgcat::mcset pb_msg_japanese "MC(msg,file_perm)"                      "次に対する書込みアクセス権がありません:"

::msgcat::mcset pb_msg_japanese "MC(msg,file_exist)"                     "既に存在します! \nそれらを置換しますか?"
::msgcat::mcset pb_msg_japanese "MC(msg,file_missing)"                   "このポストに対する一部または全部のファイルが見つかりません。\n このポストを開けません。"
::msgcat::mcset pb_msg_japanese "MC(msg,sub_dialog_open)"                "ポストを保存する前にすべてのパラメータサブダイアログの編集を完了しなければなりません!"
::msgcat::mcset pb_msg_japanese "MC(msg,generic)"                        "現在、ポストビルダは、一般ミル加工機械に対してのみ実装されています。"
::msgcat::mcset pb_msg_japanese "MC(msg,min_word)"                       "ブロックには少なくとも1つのワードを含む必要があります。"
::msgcat::mcset pb_msg_japanese "MC(msg,name_exists)"                    "既に存在します!\n 異なる名前を指定します。"
::msgcat::mcset pb_msg_japanese "MC(msg,in_use)"                         "このコンポーネントは使用中です。.\n 削除できません。"
::msgcat::mcset pb_msg_japanese "MC(msg,do_you_want_to_proceed)"         "それらを既存のデータ要素として仮定して進めることができます。"
::msgcat::mcset pb_msg_japanese "MC(msg,not_installed_properly)"         "適切にインストールされていません。"
::msgcat::mcset pb_msg_japanese "MC(msg,no_app_to_open)"                 "開くアプリケーションがありません"
::msgcat::mcset pb_msg_japanese "MC(msg,save_change)"                    "変更を保存しますか?"

::msgcat::mcset pb_msg_japanese "MC(msg,external_editor)"                "外部エディタ"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_japanese "MC(msg,set_ext_editor)"                 "環境変数EDITORを使用して、希望するテキストエディタをアクティブにできます。"
::msgcat::mcset pb_msg_japanese "MC(msg,filename_with_space)"            "空白を含むファイル名はサポートされていません!"
::msgcat::mcset pb_msg_japanese "MC(msg,filename_protection)"            "編集ポストの1つにより使用される選択ファイルは上書きできません!"


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_japanese "MC(msg,parent_win)"                     "一時的なウィンドウには、親ウィンドウを定義する必要があります。"
::msgcat::mcset pb_msg_japanese "MC(msg,close_subwin)"                   "このタブを有効にするにはすべてのサブウィンドウを閉じなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(msg,block_exist)"                    "ブロックテンプレート内に、選択されたワードの要素が存在します。"
::msgcat::mcset pb_msg_japanese "MC(msg,num_gcode_1)"                    "Gコード数は次に制限されます:"
::msgcat::mcset pb_msg_japanese "MC(msg,num_gcode_2)"                    "ブロック"
::msgcat::mcset pb_msg_japanese "MC(msg,num_mcode_1)"                    "Mコード数は次に制限されます:"
::msgcat::mcset pb_msg_japanese "MC(msg,num_mcode_2)"                    "ブロック"
::msgcat::mcset pb_msg_japanese "MC(msg,empty_entry)"                    "エンティティは空ではいけません。"

::msgcat::mcset pb_msg_japanese "MC(msg,edit_feed_fmt)"                  "アドレス\"F\"のフォーマットは、送り速度パラメータページで編集可能です"

::msgcat::mcset pb_msg_japanese "MC(msg,seq_num_max)"                    "シーケンス番号の最大値はアドレス数の容量を超えてはいけません"

::msgcat::mcset pb_msg_japanese "MC(msg,no_cdl_name)"                    "ポスト名を固有にする必要があります!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_def_name)"                    "フォルダを固有にする必要があります!\n そしてパターンを\"\$UGII_*\"のようにします!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_own_name)"                    "フォルダを固有にする必要があります!\n そしてパターンを\"\$UGII_*\"のようにします!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_oth_ude_name)"                "他のcdlファイル名を固有にする必要があります!\n そしてパターンを\"\$UGII_*\"のようにします!"
::msgcat::mcset pb_msg_japanese "MC(msg,not_oth_cdl_file)"               "CDLファイルのみ許可されます!"
::msgcat::mcset pb_msg_japanese "MC(msg,not_pui_file)"                   "PUIファイルのみ許可されます!"
::msgcat::mcset pb_msg_japanese "MC(msg,not_cdl_file)"                   "CDLファイルのみ許可されます!"
::msgcat::mcset pb_msg_japanese "MC(msg,not_def_file)"                   "DEFファイルのみ許可されます!"
::msgcat::mcset pb_msg_japanese "MC(msg,not_own_cdl_file)"               "固有のCDLファイルのみ許可されます!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_cdl_file)"                    "選択したポストには関連するCDLファイルがありません。"
::msgcat::mcset pb_msg_japanese "MC(msg,cdl_info)"                       "選択したポストのCDLおよび定義ファイルはこのポストの定義ファイルで参照(INCLUDE)されます。\n そして選択したポストのTclファイルもランタイム時にこのポストのイベントハンドラファイルによって提供されます。"

::msgcat::mcset pb_msg_japanese "MC(msg,add_max1)"                       "アドレスの最大値"
::msgcat::mcset pb_msg_japanese "MC(msg,add_max2)"                       "は、そのフォーマットの次の容量を超えてはいけません:"


::msgcat::mcset pb_msg_japanese "MC(com,text_entry_trans,title,Label)"   "エントリ"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_japanese "MC(nav_button,no_license,Message)"      "この機能を実行する適切なライセンスがありません!"

::msgcat::mcset pb_msg_japanese "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset pb_msg_japanese "MC(nav_button,ok,Context)"              "このボタンはサブダイアログでのみ使用可能です。これにより変更を保存してダイアログを閉じることができます。"
::msgcat::mcset pb_msg_japanese "MC(nav_button,cancel,Label)"            "キャンセル"
::msgcat::mcset pb_msg_japanese "MC(nav_button,cancel,Context)"          "このボタンはサブダイアログで使用可能です。これによりダイアログを閉じることができます。"
::msgcat::mcset pb_msg_japanese "MC(nav_button,default,Label)"           "デフォルト"
::msgcat::mcset pb_msg_japanese "MC(nav_button,default,Context)"         "このボタンにより、コンポーネントの現在のダイアログ上のパラメータを、セッション内のポストが最初に作成または開かれたときの状態に復元することができます。\n \nしかしながら、問題となっているコンポーネント名が存在する場合、それは、このコンポーネントへの現在の参照の初期状態にしか復元されません。"
::msgcat::mcset pb_msg_japanese "MC(nav_button,restore,Label)"           "復元"
::msgcat::mcset pb_msg_japanese "MC(nav_button,restore,Context)"         "このボタンにより、表示されているダイアログのパラメータを、このコンポーネントへの現在参照している初期状態へと復元することができます。"
::msgcat::mcset pb_msg_japanese "MC(nav_button,apply,Label)"             "適用"
::msgcat::mcset pb_msg_japanese "MC(nav_button,apply,Context)"           "このボタンにより、表示されているダイアログを閉じることなく変更を保存することができます。これはまた、表示されているダイアログの初期状態を再確立します。\n \n(初期状態への必要性は復元を参照してください)"
::msgcat::mcset pb_msg_japanese "MC(nav_button,filter,Label)"            "フィルタ"
::msgcat::mcset pb_msg_japanese "MC(nav_button,filter,Context)"          "このボタンは、ディレクトリフィルタを適用して、条件を満たすファイルをリストします。"
::msgcat::mcset pb_msg_japanese "MC(nav_button,yes,Label)"               "あり"
::msgcat::mcset pb_msg_japanese "MC(nav_button,yes,Context)"             "あり"
::msgcat::mcset pb_msg_japanese "MC(nav_button,no,Label)"                "なし"
::msgcat::mcset pb_msg_japanese "MC(nav_button,no,Context)"              "なし"
::msgcat::mcset pb_msg_japanese "MC(nav_button,help,Label)"              "ヘルプ"
::msgcat::mcset pb_msg_japanese "MC(nav_button,help,Context)"            "ヘルプ"

::msgcat::mcset pb_msg_japanese "MC(nav_button,open,Label)"              "開く"
::msgcat::mcset pb_msg_japanese "MC(nav_button,open,Context)"            "このボタンにより、選択したポストを編集のために開くことができます。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,save,Label)"              "保存"
::msgcat::mcset pb_msg_japanese "MC(nav_button,save,Context)"            "このボタンは、実行中のポストの保存を許可する、名前を変えて保存ダイアログで使用可能です。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,manage,Label)"            "管理..."
::msgcat::mcset pb_msg_japanese "MC(nav_button,manage,Context)"          "このボタンにより、最近使用したポストの履歴を管理できます。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,refresh,Label)"           "リフレッシュ"
::msgcat::mcset pb_msg_japanese "MC(nav_button,refresh,Context)"         "このボタンは、オブジェクトの存在に従ってリストをリフレッシュします。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,cut,Label)"               "切取り"
::msgcat::mcset pb_msg_japanese "MC(nav_button,cut,Context)"             "このボタンは、選択したオブジェクトをリストから切取ります。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,copy,Label)"              "コピー"
::msgcat::mcset pb_msg_japanese "MC(nav_button,copy,Context)"            "このボタンは選択したオブジェクトをコピーします。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,paste,Label)"             "貼付け"
::msgcat::mcset pb_msg_japanese "MC(nav_button,paste,Context)"           "このボタンはバッファ内のオブジェクトをリストに貼付けて戻します。"

::msgcat::mcset pb_msg_japanese "MC(nav_button,edit,Label)"              "編集"
::msgcat::mcset pb_msg_japanese "MC(nav_button,edit,Context)"            "このボタンは、バッファ内のオブジェクトを編集します!"

::msgcat::mcset pb_msg_japanese "MC(nav_button,ex_editor,Label)"         "外部エディタを使用"

##------------
## New dialog
##
::msgcat::mcset pb_msg_japanese "MC(new,title,Label)"                    "新規ポストプロセッサの作成"
::msgcat::mcset pb_msg_japanese "MC(new,Status)"                         "新規ポストに対する名前を入力してパラメータを選択します。"

::msgcat::mcset pb_msg_japanese "MC(new,name,Label)"                     "ポスト名"
::msgcat::mcset pb_msg_japanese "MC(new,name,Context)"                   "作成するポストプロセッサの名前"

::msgcat::mcset pb_msg_japanese "MC(new,desc,Label)"                     "説明"
::msgcat::mcset pb_msg_japanese "MC(new,desc,Context)"                   "作成するポストプロセッサの説明"

#Description for each selection
::msgcat::mcset pb_msg_japanese "MC(new,mill,desc,Label)"                "ミル加工機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,lathe,desc,Label)"               "旋盤機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,wedm,desc,Label)"                "ワイヤEDM機械です。"

::msgcat::mcset pb_msg_japanese "MC(new,wedm_2,desc,Label)"              "2軸ワイヤEDM機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,wedm_4,desc,Label)"              "4軸ワイヤEDM機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,lathe_2,desc,Label)"             "2軸横旋盤機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,lathe_4,desc,Label)"             "4軸従属旋盤機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_3,desc,Label)"              "3軸ミル加工機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_3MT,desc,Label)"            "3軸ミルターン(XZC)"
::msgcat::mcset pb_msg_japanese "MC(new,mill_4H,desc,Label)"             "回転ヘッドのある4軸ミル加工\n機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_4T,desc,Label)"             "回転テーブルのある4軸ミル加工\n機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5TT,desc,Label)"            "デュアル回転テーブルのある\n5軸ミル加工機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5HH,desc,Label)"            "デュアル回転ヘッドのある\n5軸ミル加工機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5HT,desc,Label)"            "回転ヘッドおよびテーブルのある\n5軸ミル加工機械です。"
::msgcat::mcset pb_msg_japanese "MC(new,punch,desc,Label)"               "パンチ機械です。"

::msgcat::mcset pb_msg_japanese "MC(new,post_unit,Label)"                "ポスト出力単位"

::msgcat::mcset pb_msg_japanese "MC(new,inch,Label)"                     "インチ"
::msgcat::mcset pb_msg_japanese "MC(new,inch,Context)"                   "ポストプロセッサ出力単位インチ"
::msgcat::mcset pb_msg_japanese "MC(new,millimeter,Label)"               "ミリメートル"
::msgcat::mcset pb_msg_japanese "MC(new,millimeter,Context)"             "ポストプロセッサ出力単位ミリメートル"

::msgcat::mcset pb_msg_japanese "MC(new,machine,Label)"                  "工作機械"
::msgcat::mcset pb_msg_japanese "MC(new,machine,Context)"                "ポストプロセッサを作成する対象となる工作機械タイプです。"

::msgcat::mcset pb_msg_japanese "MC(new,mill,Label)"                     "ミル"
::msgcat::mcset pb_msg_japanese "MC(new,mill,Context)"                   "ミル加工機械"
::msgcat::mcset pb_msg_japanese "MC(new,lathe,Label)"                    "旋盤"
::msgcat::mcset pb_msg_japanese "MC(new,lathe,Context)"                  "旋盤機械"
::msgcat::mcset pb_msg_japanese "MC(new,wire,Label)"                     "ワイヤEDM"
::msgcat::mcset pb_msg_japanese "MC(new,wire,Context)"                   "ワイヤEDM機械"
::msgcat::mcset pb_msg_japanese "MC(new,punch,Label)"                    "パンチ"

::msgcat::mcset pb_msg_japanese "MC(new,axis,Label)"                     "機械軸選択"
::msgcat::mcset pb_msg_japanese "MC(new,axis,Context)"                   "機械軸の数およびタイプ"

#Axis Number
::msgcat::mcset pb_msg_japanese "MC(new,axis_2,Label)"                   "2軸"
::msgcat::mcset pb_msg_japanese "MC(new,axis_3,Label)"                   "3軸"
::msgcat::mcset pb_msg_japanese "MC(new,axis_4,Label)"                   "4軸"
::msgcat::mcset pb_msg_japanese "MC(new,axis_5,Label)"                   "5軸"
::msgcat::mcset pb_msg_japanese "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_japanese "MC(new,mach_axis,Label)"                "工作機械軸"
::msgcat::mcset pb_msg_japanese "MC(new,mach_axis,Context)"              "工作機械軸を選択"
::msgcat::mcset pb_msg_japanese "MC(new,lathe_2,Label)"                  "2軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_3,Label)"                   "3軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_3MT,Label)"                 "3軸ミルターン(XZC)"
::msgcat::mcset pb_msg_japanese "MC(new,mill_4T,Label)"                  "回転テーブル付きの4軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_4H,Label)"                  "回転ヘッド付きの4軸"
::msgcat::mcset pb_msg_japanese "MC(new,lathe_4,Label)"                  "4軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5HH,Label)"                 "デュアル回転ヘッド付きの5軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5TT,Label)"                 "デュアル回転テーブル付きの5軸"
::msgcat::mcset pb_msg_japanese "MC(new,mill_5HT,Label)"                 "回転ヘッドおよびテーブル付きの5軸"
::msgcat::mcset pb_msg_japanese "MC(new,wedm_2,Label)"                   "2軸"
::msgcat::mcset pb_msg_japanese "MC(new,wedm_4,Label)"                   "4軸"
::msgcat::mcset pb_msg_japanese "MC(new,punch,Label)"                    "パンチ"

::msgcat::mcset pb_msg_japanese "MC(new,control,Label)"                  "コントローラ"
::msgcat::mcset pb_msg_japanese "MC(new,control,Context)"                "ポストコントローラを選択します。"

#Controller Type
::msgcat::mcset pb_msg_japanese "MC(new,generic,Label)"                  "一般"
::msgcat::mcset pb_msg_japanese "MC(new,library,Label)"                  "ライブラリ"
::msgcat::mcset pb_msg_japanese "MC(new,user,Label)"                     "ユーザ設定"
::msgcat::mcset pb_msg_japanese "MC(new,user,browse,Label)"              "ブラウズ"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_japanese "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_japanese "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_japanese "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_japanese "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_japanese "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_japanese "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_japanese "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_japanese "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_japanese "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_japanese "MC(new,heiden,Label)"                   "Heidenhaim"
::msgcat::mcset pb_msg_japanese "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_japanese "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_japanese "MC(open,title,Label)"                   "ポストを編集"
::msgcat::mcset pb_msg_japanese "MC(open,Status)"                        "PUIファイルを選択して開きます。"
::msgcat::mcset pb_msg_japanese "MC(open,file_type_pui)"                 "ポストビルダセッションファイル"
::msgcat::mcset pb_msg_japanese "MC(open,file_type_tcl)"                 "Tclスクリプトファイル"
::msgcat::mcset pb_msg_japanese "MC(open,file_type_def)"                 "定義ファイル"
::msgcat::mcset pb_msg_japanese "MC(open,file_type_cdl)"                 "CDLファイル"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_japanese "MC(open_save,dlg,title,Label)"          "ファイルを選択"
::msgcat::mcset pb_msg_japanese "MC(exp_cc,dlg,title,Label)"             "カスタムコマンドをエクスポート"
::msgcat::mcset pb_msg_japanese "MC(show_mt,title,Label)"                "工作機械"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_japanese "MC(mvb,title,Label)"                    "MOM変数ブラウザ"
::msgcat::mcset pb_msg_japanese "MC(mvb,cat,Label)"                      "カテゴリ"
::msgcat::mcset pb_msg_japanese "MC(mvb,search,Label)"                   "検索"
::msgcat::mcset pb_msg_japanese "MC(mvb,defv,Label)"                     "デフォルト値"
::msgcat::mcset pb_msg_japanese "MC(mvb,posv,Label)"                     "取り得る値"
::msgcat::mcset pb_msg_japanese "MC(mvb,data,Label)"                     "データタイプ"
::msgcat::mcset pb_msg_japanese "MC(mvb,desc,Label)"                     "説明"

::msgcat::mcset pb_msg_japanese "MC(inposts,title,Label)"                "template_post.datの編集"
::msgcat::mcset pb_msg_japanese "MC(tpdf,text,Label)"                    "テンプレートポストデータファイル"
::msgcat::mcset pb_msg_japanese "MC(inposts,edit,title,Label)"           "行の編集"
::msgcat::mcset pb_msg_japanese "MC(inposts,edit,post,Label)"            "ポスト"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_japanese "MC(save_as,title,Label)"                "名前を変えて保存"
::msgcat::mcset pb_msg_japanese "MC(save_as,name,Label)"                 "ポスト名"
::msgcat::mcset pb_msg_japanese "MC(save_as,name,Context)"               "名前を変えて保存するポストプロセッサの名前です。"
::msgcat::mcset pb_msg_japanese "MC(save_as,Status)"                     "新しいポストファイル名を入力します。"
::msgcat::mcset pb_msg_japanese "MC(save_as,file_type_pui)"              "ポストビルダセッションファイル"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_japanese "MC(common,entry,Label)"                 "エントリ"
::msgcat::mcset pb_msg_japanese "MC(common,entry,Context)"               "エントリフィールドに新しい値を指定します。"

##-----------
## Note Book
##
::msgcat::mcset pb_msg_japanese "MC(nbook,tab,Label)"                    "ノートブックタブ"
::msgcat::mcset pb_msg_japanese "MC(nbook,tab,Context)"                  "タブを選択して、希望するパラメータページへ移動できます。\n \nタブ下のパラメータを分割してグループにできます。パラメータの各グループには、別のタブからアクセスできます。"

##------
## Tree
##
::msgcat::mcset pb_msg_japanese "MC(tree,select,Label)"                  "コンポーネントツリー"
::msgcat::mcset pb_msg_japanese "MC(tree,select,Context)"                "表示するコンポーネントまたはその内容/パラメータを編集するコンポーネントを選択できます。"
::msgcat::mcset pb_msg_japanese "MC(tree,create,Label)"                  "作成"
::msgcat::mcset pb_msg_japanese "MC(tree,create,Context)"                "選択したアイテムをコピーすることで、新規コンポーネントを作成します。"
::msgcat::mcset pb_msg_japanese "MC(tree,cut,Label)"                     "切取り"
::msgcat::mcset pb_msg_japanese "MC(tree,cut,Context)"                   "コンポーネントを切取ります。"
::msgcat::mcset pb_msg_japanese "MC(tree,paste,Label)"                   "貼付け"
::msgcat::mcset pb_msg_japanese "MC(tree,paste,Context)"                 "コンポーネントを貼付けます。"
::msgcat::mcset pb_msg_japanese "MC(tree,rename,Label)"                  "名前を変更"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_japanese "MC(encrypt,browser,Label)"              "ライセンスリスト"
::msgcat::mcset pb_msg_japanese "MC(encrypt,title,Label)"                "ライセンスを選択"
::msgcat::mcset pb_msg_japanese "MC(encrypt,output,Label)"               "出力を暗号化"
::msgcat::mcset pb_msg_japanese "MC(encrypt,license,Label)"              "ライセンス:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(machine,tab,Label)"                  "工作機械"
::msgcat::mcset pb_msg_japanese "MC(machine,Status)"                     "マシンキネマティックパラメータを指定します。"

::msgcat::mcset pb_msg_japanese "MC(msg,no_display)"                     "この工作機械構成に対するイメージはありません。"
::msgcat::mcset pb_msg_japanese "MC(msg,no_4th_ctable)"                  "第4軸Cテーブルは許可されません。"
::msgcat::mcset pb_msg_japanese "MC(msg,no_4th_max_min)"                 "第4軸の最大軸限界は最小軸限界と等しくできません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_4th_both_neg)"                "第4軸限界を両方とも負にはできません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_4th_5th_plane)"               "第4軸の平面を第5軸の平面と同じにできません。"
::msgcat::mcset pb_msg_japanese "MC(msg,no_4thT_5thH)"                   "第4軸テーブルおよび第5軸ヘッドは許可されません。"
::msgcat::mcset pb_msg_japanese "MC(msg,no_5th_max_min)"                 "第5軸の最大軸限界は最小軸限界と等しくできません!"
::msgcat::mcset pb_msg_japanese "MC(msg,no_5th_both_neg)"                "第5軸限界を両方とも負にはできません。"

##---------
# Post Info
##
::msgcat::mcset pb_msg_japanese "MC(machine,info,title,Label)"           "ポスト情報"
::msgcat::mcset pb_msg_japanese "MC(machine,info,desc,Label)"            "説明"
::msgcat::mcset pb_msg_japanese "MC(machine,info,type,Label)"            "機械タイプ"
::msgcat::mcset pb_msg_japanese "MC(machine,info,kinematics,Label)"      "キネマティクス"
::msgcat::mcset pb_msg_japanese "MC(machine,info,unit,Label)"            "出力単位"
::msgcat::mcset pb_msg_japanese "MC(machine,info,controller,Label)"      "コントローラ"
::msgcat::mcset pb_msg_japanese "MC(machine,info,history,Label)"         "履歴"

##---------
## Display
##
::msgcat::mcset pb_msg_japanese "MC(machine,display,Label)"              "工作機械を表示"
::msgcat::mcset pb_msg_japanese "MC(machine,display,Context)"            "このオプションは工作機械を表示します"
::msgcat::mcset pb_msg_japanese "MC(machine,display_trans,title,Label)"  "工作機械"


##---------------
## General parms
##
::msgcat::mcset pb_msg_japanese "MC(machine,gen,Label)"                      "一般パラメータ"
    
::msgcat::mcset pb_msg_japanese "MC(machine,gen,out_unit,Label)"             "ポスト出力単位:"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,out_unit,Context)"           "ポスト処理出力単位"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,out_unit,inch,Label)"        "インチ" 
::msgcat::mcset pb_msg_japanese "MC(machine,gen,out_unit,metric,Label)"      "メートル"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,Label)"         "線形軸移動制限"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,Context)"       "線形軸移動制限"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,x,Context)"     "X軸に沿った機械移動制限を指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,y,Context)"     "Y軸に沿った機械移動制限を指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,travel_limit,z,Context)"     "Z軸に沿った機械移動制限を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,Label)"             "ホームポジション"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,Context)"           "ホームポジション"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,x,Context)"         "軸の物理ゼロ位置に相対するX軸の機械ホームポジションです。機械は自動ツール交換でこの位置に戻ります。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,y,Context)"         "軸の物理ゼロ位置に相対するX軸の機械ホームポジションです。機械は自動ツール交換でこの位置に戻ります。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,home_pos,z,Context)"         "軸の物理ゼロ位置に相対するX軸の機械ホームポジションです。機械は自動ツール交換でこの位置に戻ります。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,step_size,Label)"            "線形モーションのレゾリューション"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,step_size,min,Label)"        "最小"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,step_size,min,Context)"      "最小レゾリューション"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,traverse_feed,Label)"        "トラバーサル送り速度"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,traverse_feed,max,Label)"    "最大"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,traverse_feed,max,Context)"  "最大送り速度"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,circle_record,Label)"        "円形レコード出力"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,circle_record,yes,Label)"    "あり"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,circle_record,yes,Context)"  "円形レコードを出力します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,circle_record,no,Label)"     "なし"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,circle_record,no,Context)"   "線形レコードを出力します。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,config_4and5_axis,oth,Label)"    "その他"

# Wire EDM parameters
::msgcat::mcset pb_msg_japanese "MC(machine,gen,wedm,wire_tilt)"             "ワイヤ傾斜制御"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,wedm,angle)"                 "角度"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,wedm,coord)"                 "座標"

# Lathe parameters
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,Label)"               "タレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,Context)"             "タレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,conf,Label)"          "構成"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,conf,Context)"        "2つのタレット選択時に、このオプションによってパラメータを構成できます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,one,Label)"           "1つのタレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,one,Context)"         "1つのタレット旋盤機械"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,two,Label)"           "2つのタレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,two,Context)"         "2つのタレット旋盤機械"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,conf_trans,Label)"    "タレット構成"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,prim,Label)"          "プライマリタレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,prim,Context)"        "プライマリタレットの指定を選択します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,sec,Label)"           "セカンダリタレット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,sec,Context)"         "セカンダリタレットの指定を選択します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,designation,Label)"   "指定"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,xoff,Label)"          "Xオフセット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,xoff,Context)"        "Xオフセットを指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,zoff,Label)"          "Zオフセット"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,zoff,Context)"        "Zオフセットを指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,front,Label)"         "FRONT"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,rear,Label)"          "REAR"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,right,Label)"         "RIGHT"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,left,Label)"          "LEFT"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,side,Label)"          "SIDE"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret,saddle,Label)"        "SADDLE"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,Label)"           "軸の乗数"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,dia,Label)"       "直径プログラミング"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,dia,Context)"     "これらのオプションにより、N/C出力の選択済みアドレスの値を2倍にすることで、直径プログラミングを有効にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2x,Context)"      "このスイッチにより、N/C出力のX軸座標を2倍にすることで、直径プログラミングを有効にできます。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2y,Context)"      "このスイッチにより、N/C出力のY軸座標を2倍にすることで、直径プログラミングを有効にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2i,Context)"      "このスイッチにより、直径プログラミング使用時に、円形レコードのIの値を2倍にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,2j,Context)"      "このスイッチにより、直径プログラミング使用時に、円形レコードのJの値を2倍にできます。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,mir,Label)"       "ミラー出力"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,mir,Context)"     "これらのオプションにより、N/C出力の値を負にすることで選択したアドレスをミラーできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,x,Label)"         " - X"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,x,Context)"       "このスイッチにより、N/C出力のX軸座標を負にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,y,Label)"         " - Y"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,y,Context)"       "このスイッチにより、N/C出力のY軸座標を負にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,z,Label)"         " - Z"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,z,Context)"       "このスイッチにより、N/C出力のZ軸座標を負にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,i,Label)"         " - I"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,i,Context)"       "このスイッチにより、N/C出力の円形レコードのIの値を負にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,j,Label)"         " - J"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,j,Context)"       "このスイッチにより、N/C出力の円形レコードのJの値を負にできます。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,k,Label)"         " - K"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,axis_multi,k,Context)"       "このスイッチにより、N/C出力の円形レコードのKの値を負にできます。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,Label)"               "出力方法"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,Context)"             "出力方法"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,tool_tip,Label)"      "ツール先端"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,tool_tip,Context)"    "ツール先端に相対する出力"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,turret_ref,Label)"    "タレット参照"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,output,turret_ref,Context)"  "タレット参照に相対する出力"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,lathe_turret,msg)"           "プライマリタレットの移動先は、セカンダリタレットの移動先と同じにできません。"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,turret_chg,msg)"             "このオプションの変更には、ツール交換イベントでG92ブロックの追加または削除が必要になる可能性があります。"
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_japanese "MC(machine,gen,spindle_axis,Label)"             "初期スピンドル軸"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,spindle_axis,Context)"           "活動中のミル加工ツールに指定された初期スピンドル軸は、Z軸へ平行またはZ軸へ直角のいずれかとして指定できます。オペレーションのツール軸は指定されたスピンドル軸と一致しなければなりません。指定されたスピンドル軸にポストを配置できない場合はエラーが発生します。\nこのベクトルは、ヘッドオブジェクトで指定されたスピンドル軸によりオーバライドされる可能性があります。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,position_in_yaxis,Label)"        "Y軸の位置"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,position_in_yaxis,Context)"      "機械には、コンタ加工中に位置決めできるプログラム可能Y軸があります。このオプションは、スピンドル軸がZ軸に沿わないときのみ適用可能です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,Label)"                "機械モード"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,Context)"              "機械モードはXZC Millまたは単純ミルターンのいずれかです。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZCミル"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,xzc_mill,Context)"     "XZCミルには、回転C軸としてみるターン機械上にロックされたテーブルまたはチャックフェースができます。すべてのXY移動はXおよびCに変換され、Xは半径値に、Cは角度になります。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,mill_turn,Label)"      "単純ミルターン"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,mach_mode,mill_turn,Context)"    "このXZCミルポストは、ミル加工および旋削オペレーションの両方を含むプログラムを処理する旋盤ポストにリンクされます。オペレーションタイプが、N/C出力の生成に使用するポストを決定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,mill_turn,lathe_post,Label)"     "旋盤ポスト"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,mill_turn,lathe_post,Context)"   "旋盤ポストは、プログラムで旋削オペレーションをポスト処理するために単純ミルターンポストで必要です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,lathe_post,select_name,Label)"   "名前を選択"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,lathe_post,select_name,Context)" "単純ミルターンポストで使用される旋盤ポストの名前を選択します。おそらく、このポストはNX/Postランタイムの\\\$UGII_CAM_POST_DIRディレクトリにあります。そうでない場合は、ミルポストがあるディレクトリにある同じ名前のポストが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,Label)"               "デフォルト座標モード"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,Context)"             "このオプションは、座標出力モードに対する初期設定を極座標(XZC)または直交座標(XYZ)に定義します。このモードは\\\"SET/POLAR,ON\\\" UDEのプログラムによってオペレーションで変更できます。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,polar,Label)"         "極座標"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,polar,Context)"       "XZCでの座標出力です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,cart,Label)"          "直交座標"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,coord_mode,cart,Context)"        "XYZでの座標出力です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,Label)"             "円形レコードモード"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,Context)"           "このオプションは、円形レコード出力を極座標(XCR)または直交座標(XYIJ)モードに定義します。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,polar,Label)"       "極座標"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,polar,Context)"     "XCRでの円形出力です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,cart,Label)"        "直交座標"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,xzc_arc_mode,cart,Context)"      "XYIJでの円形出力です。"

::msgcat::mcset pb_msg_japanese "MC(machine,gen,def_spindle_axis,Label)"         "初期スピンドル軸"
::msgcat::mcset pb_msg_japanese "MC(machine,gen,def_spindle_axis,Context)"       "初期スピンドル軸は、ヘッドオブジェクトで指定されるスピンドル軸によりオーバライドされる可能性があります。\nベクトルを単位化する必要はありません。"


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_japanese "MC(machine,axis,fourth,Label)"              "第4軸"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,radius_output,Label)"       "半径出力"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,radius_output,Context)"     "ツール軸がZ軸(0,0,1)に沿っている、ポストには極座標の半径(X)を\\\"常に正\\\"、\\\"常に負\\\"または\\\"最短距離\\\"にして出力する選択肢があります。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,type_head,Label)"           "ヘッド"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,type_table,Label)"          "テーブル"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_japanese "MC(machine,axis,fifth,Label)"               "第5軸"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotary,Label)"              "回転軸"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,Label)"              "機械ゼロ - 回転軸中心"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,4,Label)"            "機械ゼロ - 第4軸中心"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,5,Label)"            "機械ゼロ - 第5軸中心"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,x,Label)"            "Xオフセット"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,x,Context)"          "回転軸Xオフセットを指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,y,Label)"            "Yオフセット"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,y,Context)"          "回転軸Yオフセットを指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,z,Label)"            "Zオフセット"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,offset,z,Context)"          "回転軸Zオフセットを指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotation,Label)"            "軸回転"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotation,norm,Label)"       "法線"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotation,norm,Context)"     "軸回転方向を法線にセットします。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotation,rev,Label)"        "反転"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotation,rev,Context)"      "軸回転方向を反対にセットします。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,direction,Label)"           "軸方向"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,direction,Context)"         "軸の方向を選択します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,con_motion,Label)"              "連続回転モーション"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,con_motion,combine,Label)"      "組合せ"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,con_motion,combine,Context)"    "このスイッチにより、線形化を使用可能/不可にできます。これは公差オプションを使用可能/不可にします。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,con_motion,tol,Label)"      "公差"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,con_motion,tol,Context)"    "このオプションは、組合せスイッチがアクティブなときのみアクティブになります。公差を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,Label)"           "軸制限違反処理"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,warn,Label)"      "警告"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,warn,Context)"    "軸制限の違反で警告を出力します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,ret,Label)"       "リトラクト/再エンゲージ"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,violation,ret,Context)"     "軸制限違反でリトラクト/再エンゲージします。\n\nカスタムコマンドPB_CMD_init_rotatyでは、次のパラメータを調整 - して好みの移動を実行できます:\n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,limits,Label)"              "軸制限(度)"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,limits,min,Label)"          "最小"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,limits,min,Context)"        "最小回転軸制限(度)を指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,limits,max,Label)"          "最大"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,limits,max,Context)"        "最大回転軸制限(度)を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,incr_text)"                 "この回転軸をインクリメンタル可能にする"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotary_res,Label)"          "回転モーションレゾリューション(度)"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotary_res,Context)"        "回転モーションレゾリューション(度)を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,ang_offset,Label)"          "角度オフセット(度)"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,ang_offset,Context)"        "軸角度オフセット(度)を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,pivot,Label)"               "ピボット距離"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,pivot,Context)"             "ピボット距離を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,max_feed,Label)"            "最大送り速度(度/分)"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,max_feed,Context)"          "最大送り速度(度/分)を指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,Label)"               "回転の平面"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,Context)"             "回転の平面としてXY、YZ、ZXまたはその他を選択します。\\\"その他\\\"オプションにより、任意のベクトルを指定しできます。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,normal,Label)"        "平面法線ベクトル"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,normal,Context)"      "回転の軸として平面法線ベクトルを指定します。\nベクトルを単位化する必要はありません。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,4th,Label)"           "第4軸平面法線"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,4th,Context)"         "第4軸回転に対する平面法線ベクトルを指定します。"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,5th,Label)"           "第5軸平面法線"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,plane,5th,Context)"         "第5軸回転に対する平面法線ベクトルを指定します。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,leader,Label)"              "ワードリーダ"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,leader,Context)"            "ワードリーダを指定"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,config,Label)"              "構成"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,config,Context)"            "このオプションにより、第4および第5軸パラメータを定義できます。"

::msgcat::mcset pb_msg_japanese "MC(machine,axis,r_axis_conf_trans,Label)"   "回転軸の構成"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,4th_axis,Label)"            "第4軸"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,5th_axis,Label)"            "第5軸"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,head,Label)"                " ヘッド "
::msgcat::mcset pb_msg_japanese "MC(machine,axis,table,Label)"               " テーブル "

::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotary_lintol,Label)"       "デフォルト線形化公差"
::msgcat::mcset pb_msg_japanese "MC(machine,axis,rotary_lintol,Context)"     "この値は、LINTOL/ONポストコマンドが現在または先行するオペレーションで指定されるときに、回転移動を線形化するためのデフォルト公差として使用されます。LINTOL/コマンドはまた、異なる線形化公差を指定できます。"

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(progtpth,tab,Label)"                 "プログラムおよびツールパス"

##---------
## Program
##
::msgcat::mcset pb_msg_japanese "MC(prog,tab,Label)"                     "プログラム"
::msgcat::mcset pb_msg_japanese "MC(prog,Status)"                        "イベントの出力を定義します。"

::msgcat::mcset pb_msg_japanese "MC(prog,tree,Label)"                    "プログラム -- シーケンスツリー"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,Context)"                  "N/Cプログラムは、4つのシーケンスとツールパスのボディとなる、5つのセグメントに分割されます。\n \n * プログラム開始シーケンス \n * オペレーション開始シーケンス \n * ツールパス \n * オペレーション終了シーケンス \n * プログラム終了シーケンス \n \n各シーケンスは一連のマーカによって構成されます。1つのマーカは、プログラム可能で、N/Cプログラムの特定の段階において発生する可能性があるイベントを示します。各マーカにN/Cコードの特定のアレンジメントをアタッチして、プログラムがポスト処理される際に出力することができます。\n \nツールパスは多数のイベントからなります。これらは3つのグループに分割されます。\n \n * 機械制御 \n * モーション \n * サイクル \n"

::msgcat::mcset pb_msg_japanese "MC(prog,tree,prog_strt,Label)"          "プログラム開始シーケンス"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,prog_end,Label)"           "プログラム終了シーケンス"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,oper_strt,Label)"          "オペレーション開始シーケンス"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,oper_end,Label)"           "オペレーション終了シーケンス"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,tool_path,Label)"          "ツールパス"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,tool_path,mach_cnt,Label)" "機械制御"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,tool_path,motion,Label)"   "モーション"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,tool_path,cycle,Label)"    "標準サイクル"
::msgcat::mcset pb_msg_japanese "MC(prog,tree,linked_posts,Label)"       "リンクしたポストシーケンス"

::msgcat::mcset pb_msg_japanese "MC(prog,add,Label)"                     "シーケンス -- ブロックを追加"
::msgcat::mcset pb_msg_japanese "MC(prog,add,Context)"                   "このボタンを押して希望するマーカへドラッグすることで、新規ブロックをシーケンスに追加できます。ブロックは、既存のブロックの横、上または下にもアタッチできます。"

::msgcat::mcset pb_msg_japanese "MC(prog,trash,Label)"                   "シーケンス -- ごみ箱"
::msgcat::mcset pb_msg_japanese "MC(prog,trash,Context)"                 "不要なブロックをこのごみ箱へドラッグすることで、シーケンスから廃棄できます。"

::msgcat::mcset pb_msg_japanese "MC(prog,block,Label)"                   "シーケンス -- ブロック"
::msgcat::mcset pb_msg_japanese "MC(prog,block,Context)"                 "不要なブロックをごみ箱へドラッグすることで、シーケンスから削除できます。\n \nマウスの右ボタンを押すと、ポップアップメニューをアクティブにもできます。幾つかのサービスがメニュー上で使用可能です。\n \n * 編集 \n * 出力を強制\n * 切取り\n * 別名でコピー\n * 貼付け\n * 削除\n"

::msgcat::mcset pb_msg_japanese "MC(prog,select,Label)"                  "シーケンス -- ブロック選択"
::msgcat::mcset pb_msg_japanese "MC(prog,select,Context)"                "このリストからシーケンスに追加したいブロックコンポーネントのタイプを選択できます。\n\A使用可能なコンポーネントタイプ: \n \n * 新規ブロック\n * 既存のN/Cブロック\n * オペレータメッセージ\n * カスタムコマンド\n"

::msgcat::mcset pb_msg_japanese "MC(prog,oper_temp,Label)"               "シーケンステンプレートを選択"
::msgcat::mcset pb_msg_japanese "MC(prog,add_block,Label)"               "ブロックを追加"
::msgcat::mcset pb_msg_japanese "MC(prog,seq_comb_nc,Label)"             "組合せN/Cコードブロックを表示"
::msgcat::mcset pb_msg_japanese "MC(prog,seq_comb_nc,Context)"           "このボタンにより、ブロックまたはN/Cコードに関して、シーケンスの内容を表示することができます。\n \nN/Cコードは適切な順序でワードを表示します。"

::msgcat::mcset pb_msg_japanese "MC(prog,plus,Label)"                    "プログラム -- 折畳み/展開スイッチ"
::msgcat::mcset pb_msg_japanese "MC(prog,plus,Context)"                  "このボタンにより、このコンポーネントの分岐を折畳みまたは展開表示できます。"

::msgcat::mcset pb_msg_japanese "MC(prog,marker,Label)"                  "シーケンス -- マーカ"
::msgcat::mcset pb_msg_japanese "MC(prog,marker,Context)"                "シーケンスのマーカは、プログラム可能で、N/Cプログラムの特定の段階でシーケンスに発生する可能性があるイベントを示します。\n \n各マーカで出力するブロックをアタッチ/アレンジできます。"

::msgcat::mcset pb_msg_japanese "MC(prog,event,Label)"                   "プログラム -- イベント"
::msgcat::mcset pb_msg_japanese "MC(prog,event,Context)"                 "マウスの左ボタンをシングルクリックして、各イベントを編集できます。"

::msgcat::mcset pb_msg_japanese "MC(prog,nc_code,Label)"                 "プログラム -- N/Cコード"
::msgcat::mcset pb_msg_japanese "MC(prog,nc_code,Context)"               "このボックス内のテキストは、このマーカまたはこのイベントから出力される代表的なN/Cコードを表示します。"
::msgcat::mcset pb_msg_japanese "MC(prog,undo_popup,Label)"              "アンドゥ"

## Sequence
##
::msgcat::mcset pb_msg_japanese "MC(seq,combo,new,Label)"                "新規ブロック"
::msgcat::mcset pb_msg_japanese "MC(seq,combo,comment,Label)"            "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(seq,combo,custom,Label)"             "カスタムコマンド"

::msgcat::mcset pb_msg_japanese "MC(seq,new_trans,title,Label)"          "ブロック"
::msgcat::mcset pb_msg_japanese "MC(seq,cus_trans,title,Label)"          "カスタムコマンド"
::msgcat::mcset pb_msg_japanese "MC(seq,oper_trans,title,Label)"         "オペレータメッセージ"

::msgcat::mcset pb_msg_japanese "MC(seq,edit_popup,Label)"               "編集"
::msgcat::mcset pb_msg_japanese "MC(seq,force_popup,Label)"              "出力を強制"
::msgcat::mcset pb_msg_japanese "MC(seq,rename_popup,Label)"             "名前を変更"
::msgcat::mcset pb_msg_japanese "MC(seq,rename_popup,Context)"           "このコンポーネントに対する名前を指定できます。"
::msgcat::mcset pb_msg_japanese "MC(seq,cut_popup,Label)"                "切取り"
::msgcat::mcset pb_msg_japanese "MC(seq,copy_popup,Label)"               "別名でコピー"
::msgcat::mcset pb_msg_japanese "MC(seq,copy_popup,ref,Label)"           "参照ブロック"
::msgcat::mcset pb_msg_japanese "MC(seq,copy_popup,new,Label)"           "新規ブロック"
::msgcat::mcset pb_msg_japanese "MC(seq,paste_popup,Label)"              "貼付け"
::msgcat::mcset pb_msg_japanese "MC(seq,paste_popup,before,Label)"       "前"
::msgcat::mcset pb_msg_japanese "MC(seq,paste_popup,inline,Label)"       "インライン"
::msgcat::mcset pb_msg_japanese "MC(seq,paste_popup,after,Label)"        "後"
::msgcat::mcset pb_msg_japanese "MC(seq,del_popup,Label)"                "削除"

::msgcat::mcset pb_msg_japanese "MC(seq,force_trans,title,Label)"        "一度出力を強制"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_japanese "MC(tool,event_trans,title,Label)"       "イベント"

::msgcat::mcset pb_msg_japanese "MC(tool,event_seq,button,Label)"        "イベントテンプレートを選択"
::msgcat::mcset pb_msg_japanese "MC(tool,add_word,button,Label)"         "ワードを追加"

::msgcat::mcset pb_msg_japanese "MC(tool,format_trans,title,Label)"      "フォーマット"

::msgcat::mcset pb_msg_japanese "MC(tool,circ_trans,title,Label)"        "円形移動 -- 平面コード"
::msgcat::mcset pb_msg_japanese "MC(tool,circ_trans,frame,Label)"        " 平面Gコード "
::msgcat::mcset pb_msg_japanese "MC(tool,circ_trans,xy,Label)"           "XY平面"
::msgcat::mcset pb_msg_japanese "MC(tool,circ_trans,yz,Label)"           "YZ平面"
::msgcat::mcset pb_msg_japanese "MC(tool,circ_trans,zx,Label)"           "ZX平面"

::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,arc_start,Label)"          "円弧 - 開始から中心"
::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,arc_center,Label)"         "円弧 - 中心から開始"
::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,u_arc_start,Label)"        "符号無し円弧 - 開始から中心"
::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,absolute,Label)"           "絶対円弧 - 中心"
::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,long_thread_lead,Label)"   "縦方向ねじ切りリード"
::msgcat::mcset pb_msg_japanese "MC(tool,ijk_desc,tran_thread_lead,Label)"   "横方向ねじ切りリード"

::msgcat::mcset pb_msg_japanese "MC(tool,spindle,range,type,Label)"              "スピンドル範囲タイプ"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle,range,range_M,Label)"           "分離範囲Mコード(M41)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle,range,with_spindle_M,Label)"    "スピンドルMコードを持つ範囲番号(M13)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Sコードを持つ高/低範囲(S+100)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle,range,nonzero_range,msg)"       "スピンドル範囲の番号は、ゼロより大きくなければなりません。"

::msgcat::mcset pb_msg_japanese "MC(tool,spindle_trans,title,Label)"         "スピンドル範囲コードテーブル"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_trans,range,Label)"         "範囲"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_trans,code,Label)"          "コード"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_trans,min,Label)"           "最小(RPM)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_trans,max,Label)"           "最大(RPM)"

::msgcat::mcset pb_msg_japanese "MC(tool,spindle_desc,sep,Label)"            " 分離範囲Mコード(M41、M42 ...) "
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_desc,range,Label)"          " スピンドルMコードを持つ範囲番号(M13、M23 ...)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_desc,high,Label)"           " Sコードを持つ高/低範囲(S+100/S - 100)"
::msgcat::mcset pb_msg_japanese "MC(tool,spindle_desc,odd,Label)"            " Sコードを持つ奇数/偶数範囲"


::msgcat::mcset pb_msg_japanese "MC(tool,config,mill_opt1,Label)"            "ツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,config,mill_opt2,Label)"            "ツール番号およびツール長さオフセット番号"
::msgcat::mcset pb_msg_japanese "MC(tool,config,mill_opt3,Label)"            "長さオフセット番号およびツール番号"

::msgcat::mcset pb_msg_japanese "MC(tool,config,title,Label)"                "ツールコード構成"
::msgcat::mcset pb_msg_japanese "MC(tool,config,output,Label)"               "出力"

::msgcat::mcset pb_msg_japanese "MC(tool,config,lathe_opt1,Label)"           "ツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,config,lathe_opt2,Label)"           "ツール番号およびツール長さオフセット番号"
::msgcat::mcset pb_msg_japanese "MC(tool,config,lathe_opt3,Label)"           "タレットインデックスおよびツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,config,lathe_opt4,Label)"           "タレットインデックスツール番号およびツール長さオフセット番号"

::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,num,Label)"               "ツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,next_num,Label)"          "次のツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,index_num,Label)"         "タレットインデックスおよびツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,index_next_num,Label)"    "タレットインデックスおよび次のツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,num_len,Label)"           "ツール番号およびツール長さオフセット番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,next_num_len,Label)"      "次のツール番号およびツール長さオフセット番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,len_num,Label)"           "長さオフセット番号およびツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,len_next_num,Label)"      "長さオフセット番号および次のツール番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,index_num_len,Label)"     "タレットインデックス、ツール番号およびツール長さオフセット番号"
::msgcat::mcset pb_msg_japanese "MC(tool,conf_desc,index_next_num_len,Label)"    "タレットインデックス、次のツール番号およびツール長さオフセット番号"

::msgcat::mcset pb_msg_japanese "MC(tool,oper_trans,title,Label)"            "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(tool,cus_trans,title,Label)"             "カスタムコマンド"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_japanese "MC(event,feed,IPM_mode)"                "IPM(インチ/分)モード"

##---------
## G Codes
##
::msgcat::mcset pb_msg_japanese "MC(gcode,tab,Label)"                    "Gコード"
::msgcat::mcset pb_msg_japanese "MC(gcode,Status)"                       "Gコードを指定"

##---------
## M Codes
##
::msgcat::mcset pb_msg_japanese "MC(mcode,tab,Label)"                    "Mコード"
::msgcat::mcset pb_msg_japanese "MC(mcode,Status)"                       "Mコードを指定"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_japanese "MC(addrsum,tab,Label)"                  "ワードサマリ "
::msgcat::mcset pb_msg_japanese "MC(addrsum,Status)"                     "パラメータを指定"

::msgcat::mcset pb_msg_japanese "MC(addrsum,col_addr,Label)"             "ワード"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_addr,Context)"           "マウスの左ボタンで名前をクリックすると、ワードアドレスを編集できます。"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_lead,Label)"             "リーダ/コード"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_data,Label)"             "データタイプ"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_plus,Label)"             "プラス(+)"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_lzero,Label)"            "先行ゼロ"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_int,Label)"              "整数"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_dec,Label)"              "小数点(.)"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_frac,Label)"             "小数部"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_tzero,Label)"            "末尾ゼロ"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_modal,Label)"            "モーダル"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_min,Label)"              "最小"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_max,Label)"              "最大"
::msgcat::mcset pb_msg_japanese "MC(addrsum,col_trail,Label)"            "トレーラ"

::msgcat::mcset pb_msg_japanese "MC(addrsum,radio_text,Label)"           "テキスト"
::msgcat::mcset pb_msg_japanese "MC(addrsum,radio_num,Label)"            "数値"

::msgcat::mcset pb_msg_japanese "MC(addrsum,addr_trans,title,Label)"     "ワード"
::msgcat::mcset pb_msg_japanese "MC(addrsum,other_trans,title,Label)"    "他のデータ要素"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_japanese "MC(wseq,tab,Label)"                     "ワードシーケンス"
::msgcat::mcset pb_msg_japanese "MC(wseq,Status)"                        "ワードに順番を付けます"

::msgcat::mcset pb_msg_japanese "MC(wseq,word,Label)"                    "マスタワードシーケンス"
::msgcat::mcset pb_msg_japanese "MC(wseq,word,Context)"                  "任意のワードを希望する位置へドラッグすることで、N/C出力に表示されるワードを順番に配置できます。\n \nドラッグされているワードが他のワードに焦点を合わせているとき(長方形の色が変化します)、これらの2つのワードの位置がスワップされます。ワードが、2つのワードの間のセパレータの焦点内にドラッグされた場合、ワードは、これらの2つのワードの間に挿入されます。 \n \nマウスの左ボタンでクリックしてトグルをオフに切替えることで、任意のワードをN/Cファイルに出力されるのを抑制することができます。\n \nまた、ポップアップメニューのオプションを使用して、これらのワードを操作することもできます。\n \n * 新規作成 \n * 編集 \n * 削除 \n * すべてアクティブ化 \n"

::msgcat::mcset pb_msg_japanese "MC(wseq,active_out,Label)"              " 出力 - アクティブ     "
::msgcat::mcset pb_msg_japanese "MC(wseq,suppressed_out,Label)"          " 出力 - 抑制 "

::msgcat::mcset pb_msg_japanese "MC(wseq,popup_new,Label)"               "新規作成"
::msgcat::mcset pb_msg_japanese "MC(wseq,popup_undo,Label)"              "アンドゥ"
::msgcat::mcset pb_msg_japanese "MC(wseq,popup_edit,Label)"              "編集"
::msgcat::mcset pb_msg_japanese "MC(wseq,popup_delete,Label)"            "削除"
::msgcat::mcset pb_msg_japanese "MC(wseq,popup_all,Label)"               "すべてアクティブ化"
::msgcat::mcset pb_msg_japanese "MC(wseq,transient_win,Label)"           "ワード"
::msgcat::mcset pb_msg_japanese "MC(wseq,cannot_suppress_msg)"           "は抑制できません。単一要素として使用されています"
::msgcat::mcset pb_msg_japanese "MC(wseq,empty_block_msg)"               "このアドレスの出力を抑制すると、結果として無効な空のブロックが生じます。"

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,tab,Label)"                 "カスタムコマンド"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,Status)"                    "カスタムコマンドを定義"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name,Label)"                "コマンド名"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name,Context)"              "ここで入力する名前にはPB_CMD_のプレフィックスが付けられて、実際のコマンド名になります。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,proc,Label)"                "手順"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,proc,Context)"              "このコマンドの機能を定義するためにTclスクリプトを入力します。\n \n *ポストビルダは、スクリプトの内容の解釈を行いませんが、Tclファイルには保存されます。従って、スクリプトの構文的な正確さは、ユーザが責任を持ちます。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name_msg)"                  "カスタムコマンド名が無効です。\n 異なる名前を指定します。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name_msg_1)"                "特殊なカスタムコマンドに対して予約されています。\n 異なる名前を指定します。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,name_msg_2)"                "PB_CMD_vnc____*のようなVNCカスタム\n  コマンド名のみ許可されています。\n 異なる名前を指定します。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,Label)"              "インポート"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,Context)"            "選択したTclファイルから進行中のポストへ、カスタムコマンドをインポートします。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,export,Label)"              "エクスポート"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,export,Context)"            "カスタムコマンドを、実行中のポストからTclファイルへエクスポートします。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,tree,Label)"         "カスタムコマンドをインポート"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,tree,Context)"       "このリストには、インポートするために指定したファイルにあるカスタムコマンド手順および他のTcl手順が含まれます。マウスの左ボタンクリックでリストのアイテムを選択することによって、各手順の内容をプレビューできます。実行中のポストに既に存在する手順は、<exist>インジケータで識別されます。アイテムをマウスの左ボタンでダブルクリックすると、アイテムの横にあるチェックボックスが切替えられます。これにより、インポートする手順を選択または選択解除できます。デフォルトでは、すべての手順がインポートされるように選択されています。既存の手順を上書きしないように、アイテムを選択解除できます。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,export,tree,Label)"         "カスタムコマンドをエクスポート"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,export,tree,Context)"       "このリストには、実行中のポストにあるカスタムコマンド手順および他のTcl手順が含まれます。マウスの左ボタンでリストのアイテムを選択することによって、各手順の内容をプレビューできます。アイテムをマウスの左ボタンでダブルクリックすると、アイテムの横にあるチェックボックスにトグルがつきます。これにより、エクスポートする必要な手順のみを選択できます。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,error,title)"               "カスタムコマンドエラー"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,error,msg)"                 "カスタムコマンドの検証は、メインメニューアイテム\"オプション→カスタムコマンドを検証\"のプルダウンのスイッチをセットすることで使用可能/使用不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,select_all,Label)"          "すべてを選択"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,select_all,Context)"        "このボタンをクリックして、インポートまたはエクスポートする表示されたすべてのコマンドを選択します。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,deselect_all,Label)"        "すべてを選択解除"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,deselect_all,Context)"      "このボタンをクリックして、すべてのコマンドを選択解除します。"

::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,warning,title)"      "カスタムコマンドをインポート/エクスポートの警告"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,import,warning,msg)"        "インポートまたはエクスポートするアイテムが選択されていません。"



::msgcat::mcset pb_msg_japanese "MC(cust_cmd,cmd,msg)"                   "コマンド: "
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,blk,msg)"                   "ブロック: "
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,add,msg)"                   "アドレス: "
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,fmt,msg)"                   "フォーマット: "
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,referenced,msg)"            "カスタムコマンドで参照されます "
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,not_defined,msg)"           "実行中のポストの現在の範囲では定義されていません。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,cannot_delete,msg)"         "削除できません。"
::msgcat::mcset pb_msg_japanese "MC(cust_cmd,save_post,msg)"             "とにかくこのポストを保存しますか?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_japanese "MC(opr_msg,text,Label)"                 "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(opr_msg,text,Context)"               "オペレータメッセージとして表示されるテキストです。メッセージの開始および終了で必要とされる特殊文字は、ポストビルダによって自動的にアタッチされます。これらの文字は、\"N/Cデータ定義\"タブの下の\"他のデータ要素\"パラメータページで指定されます。"

::msgcat::mcset pb_msg_japanese "MC(opr_msg,name,Label)"                 "メッセージ名"
::msgcat::mcset pb_msg_japanese "MC(opr_msg,empty_operator)"             "オペレータメッセージは、空ではいけません。"


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_japanese "MC(link_post,tab,Label)"                "リンクしたポスト"
::msgcat::mcset pb_msg_japanese "MC(link_post,Status)"                   "リンクしたポストを定義"

::msgcat::mcset pb_msg_japanese "MC(link_post,toggle,Label)"             "他のポストをこのポストにリンク"
::msgcat::mcset pb_msg_japanese "MC(link_post,toggle,Context)"           "他のポストをこのポストにリンクして、単純なミル加工および旋削モードの複数の組合せを実行する複雑な工作機械を扱うことができます。"

::msgcat::mcset pb_msg_japanese "MC(link_post,head,Label)"               "ヘッド"
::msgcat::mcset pb_msg_japanese "MC(link_post,head,Context)"             "複雑な工作機械は、様々な加工モードのキネマティクスの異なるセットを使用して加工オペレーションを実行できます。キネマティクスの各セットは、NX/Postの独立ヘッドとして扱われます。特定のヘッドで実行する必要がある加工オペレーションは、工作機械または加工方法ビューに、1つのグループとして一緒に配置されます。それから、\\\"ヘッド\\\"UDEがグループに割当てられ、このヘッドに対する名前が指定されます。"

::msgcat::mcset pb_msg_japanese "MC(link_post,post,Label)"               "ポスト"
::msgcat::mcset pb_msg_japanese "MC(link_post,post,Context)"             "ポストは、N/Cコードを生成するヘッドに割当てられます。"

::msgcat::mcset pb_msg_japanese "MC(link_post,link,Label)"               "リンクしたポスト"
::msgcat::mcset pb_msg_japanese "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_japanese "MC(link_post,new,Label)"                "新規作成"
::msgcat::mcset pb_msg_japanese "MC(link_post,new,Context)"              "新規リンクを作成します。"

::msgcat::mcset pb_msg_japanese "MC(link_post,edit,Label)"               "編集"
::msgcat::mcset pb_msg_japanese "MC(link_post,edit,Context)"             "リンクを編集します。"

::msgcat::mcset pb_msg_japanese "MC(link_post,delete,Label)"             "削除"
::msgcat::mcset pb_msg_japanese "MC(link_post,delete,Context)"           "リンクを削除します。"

::msgcat::mcset pb_msg_japanese "MC(link_post,select_name,Label)"        "名前を選択"
::msgcat::mcset pb_msg_japanese "MC(link_post,select_name,Context)"      "ヘッドに割当てるポストの名前を選択します。おそらく、このポストはNX/Postランタイムにおいてメインポストのあるディレクトリにあります。そうでない場合は、\\\$UGII_CAM_POST_DIRディレクトリにある同じ名前のポストが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(link_post,start_of_head,Label)"      "ヘッドの開始"
::msgcat::mcset pb_msg_japanese "MC(link_post,start_of_head,Context)"    "このヘッドの最初に実行するN/Cコードまたはアクションを指定します。"

::msgcat::mcset pb_msg_japanese "MC(link_post,end_of_head,Label)"        "ヘッドの終了"
::msgcat::mcset pb_msg_japanese "MC(link_post,end_of_head,Context)"      "このヘッドの最後に実行するN/Cコードまたはアクションを指定します。"
::msgcat::mcset pb_msg_japanese "MC(link_post,dlg,head,Label)"           "ヘッド"
::msgcat::mcset pb_msg_japanese "MC(link_post,dlg,post,Label)"           "ポスト"
::msgcat::mcset pb_msg_japanese "MC(link_post,dlg,title,Label)"          "リンクしたポスト"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(nc_data,tab,Label)"                  "N/Cデータ定義"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_japanese "MC(block,tab,Label)"                    "ブロック"
::msgcat::mcset pb_msg_japanese "MC(block,Status)"                       "ブロックテンプレートを定義します。"

::msgcat::mcset pb_msg_japanese "MC(block,name,Label)"                   "ブロック名"
::msgcat::mcset pb_msg_japanese "MC(block,name,Context)"                 "ブロック名を入力"

::msgcat::mcset pb_msg_japanese "MC(block,add,Label)"                    "ワードを追加"
::msgcat::mcset pb_msg_japanese "MC(block,add,Context)"                  "このボタンを押して、下のウィンドウに表示されるブロックにドラッグすることで、新規ワードをブロックに追加できます。作成されるワードのタイプは、このボタンの右側にあるリストボックスから選択されます。"

::msgcat::mcset pb_msg_japanese "MC(block,select,Label)"                 "ブロック -- ワード選択"
::msgcat::mcset pb_msg_japanese "MC(block,select,Context)"               "ブロックに追加したいワードのタイプを、このリストから選択できます。"

::msgcat::mcset pb_msg_japanese "MC(block,trash,Label)"                  "ブロック -- ごみ箱"
::msgcat::mcset pb_msg_japanese "MC(block,trash,Context)"                "不要なワードをこのごみ箱へドラッグすることで、ブロックから廃棄できます。"

::msgcat::mcset pb_msg_japanese "MC(block,word,Label)"                   "ブロック -- ワード"
::msgcat::mcset pb_msg_japanese "MC(block,word,Context)"                 "不要なワードをごみ箱へドラッグすることで、ブロックから削除できます。\n \nマウスの右ボタンを押すと、ポップアップメニューをアクティブにもできます。幾つかのサービスがメニュー上で使用可能です。\n \n * 編集 \n * 出力を強制 \n * カット \n * 別名でコピー \n * 貼付け \n * 削除 \n"

::msgcat::mcset pb_msg_japanese "MC(block,verify,Label)"                 "ブロック -- ワード検証"
::msgcat::mcset pb_msg_japanese "MC(block,verify,Context)"               "このウィンドウには、上のウィンドウに表示されるブロックで選択(くぼんだ)ワードに対して出力される代表N/Cコードが表示されます。"

::msgcat::mcset pb_msg_japanese "MC(block,new_combo,Label)"              "新規アドレス"
::msgcat::mcset pb_msg_japanese "MC(block,text_combo,Label)"             "テキスト"
::msgcat::mcset pb_msg_japanese "MC(block,oper_combo,Label)"             "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(block,comm_combo,Label)"             "コマンド"

::msgcat::mcset pb_msg_japanese "MC(block,edit_popup,Label)"             "編集"
::msgcat::mcset pb_msg_japanese "MC(block,view_popup,Label)"             "表示"
::msgcat::mcset pb_msg_japanese "MC(block,change_popup,Label)"           "要素を変更"
::msgcat::mcset pb_msg_japanese "MC(block,user_popup,Label)"             "ユーザ定義式"
::msgcat::mcset pb_msg_japanese "MC(block,opt_popup,Label)"              "オプション"
::msgcat::mcset pb_msg_japanese "MC(block,no_sep_popup,Label)"           "ワードセパレータなし"
::msgcat::mcset pb_msg_japanese "MC(block,force_popup,Label)"            "出力を強制"
::msgcat::mcset pb_msg_japanese "MC(block,delete_popup,Label)"           "削除"
::msgcat::mcset pb_msg_japanese "MC(block,undo_popup,Label)"             "アンドゥ"
::msgcat::mcset pb_msg_japanese "MC(block,delete_all,Label)"             "すべてのアクティブ要素を削除"

::msgcat::mcset pb_msg_japanese "MC(block,cmd_title,Label)"              "カスタムコマンド"
::msgcat::mcset pb_msg_japanese "MC(block,oper_title,Label)"             "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(block,addr_title,Label)"             "ワード"

::msgcat::mcset pb_msg_japanese "MC(block,new_trans,title,Label)"        "ワード"

::msgcat::mcset pb_msg_japanese "MC(block,new,word_desc,Label)"          "新規アドレス"
::msgcat::mcset pb_msg_japanese "MC(block,oper,word_desc,Label)"         "オペレータメッセージ"
::msgcat::mcset pb_msg_japanese "MC(block,cmd,word_desc,Label)"          "カスタムコマンド"
::msgcat::mcset pb_msg_japanese "MC(block,user,word_desc,Label)"         "ユーザ定義式"
::msgcat::mcset pb_msg_japanese "MC(block,text,word_desc,Label)"         "文字列"

::msgcat::mcset pb_msg_japanese "MC(block,user,expr,Label)"              "式"

::msgcat::mcset pb_msg_japanese "MC(block,msg,min_word)"                 "ブロックには少なくとも1つのワードを含む必要があります。"

::msgcat::mcset pb_msg_japanese "MC(block,name_msg)"                     "ブロック名が無効です。\n 異なる名前を指定します。"

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_japanese "MC(address,tab,Label)"                  "ワード"
::msgcat::mcset pb_msg_japanese "MC(address,Status)"                     "ワードを定義"

::msgcat::mcset pb_msg_japanese "MC(address,name,Label)"                 "ワード名"
::msgcat::mcset pb_msg_japanese "MC(address,name,Context)"               "ワードの名前を編集できます。"

::msgcat::mcset pb_msg_japanese "MC(address,verify,Label)"               "ワード -- 検証"
::msgcat::mcset pb_msg_japanese "MC(address,verify,Context)"             "このウィンドウには、ワードに対して出力される代表N/Cコードが表示されます。"

::msgcat::mcset pb_msg_japanese "MC(address,leader,Label)"               "リーダ"
::msgcat::mcset pb_msg_japanese "MC(address,leader,Context)"             "ワードのリーダとして任意の数の文字を入力するか、マウスの右ボタンを使用してポップアップメニューから文字を選択できます。"

::msgcat::mcset pb_msg_japanese "MC(address,format,Label)"               "フォーマット"
::msgcat::mcset pb_msg_japanese "MC(address,format,edit,Label)"          "編集"
::msgcat::mcset pb_msg_japanese "MC(address,format,edit,Context)"        "このボタンにより、ワードによって使用されるフォーマットを編集できます。"
::msgcat::mcset pb_msg_japanese "MC(address,format,new,Label)"           "新規作成"
::msgcat::mcset pb_msg_japanese "MC(address,format,new,Context)"         "このボタンにより、新規フォーマットを作成できます。"

::msgcat::mcset pb_msg_japanese "MC(address,format,select,Label)"        "ワード -- フォーマットを選択"
::msgcat::mcset pb_msg_japanese "MC(address,format,select,Context)"      "このボタンにより、ワードに対する別のフォーマットを選択できます。"

::msgcat::mcset pb_msg_japanese "MC(address,trailer,Label)"              "トレーラ"
::msgcat::mcset pb_msg_japanese "MC(address,trailer,Context)"            "ワードに対するトレーラとして任意の数の文字を入力するか、マウスの右ボタンを使用してポップアップメニューから文字を選択できます。"

::msgcat::mcset pb_msg_japanese "MC(address,modality,Label)"             "モーダル"
::msgcat::mcset pb_msg_japanese "MC(address,modality,Context)"           "このオプションにより、ワードに対するモダリティをセットできます。"

::msgcat::mcset pb_msg_japanese "MC(address,modal_drop,off,Label)"       "オフ"
::msgcat::mcset pb_msg_japanese "MC(address,modal_drop,once,Label)"      "一度"
::msgcat::mcset pb_msg_japanese "MC(address,modal_drop,always,Label)"    "常に"

::msgcat::mcset pb_msg_japanese "MC(address,max,value,Label)"            "最大"
::msgcat::mcset pb_msg_japanese "MC(address,max,value,Context)"          "ワードに対する最大値を指定します。"

::msgcat::mcset pb_msg_japanese "MC(address,value,text,Label)"           "値"

::msgcat::mcset pb_msg_japanese "MC(address,trunc_drop,Label)"           "値を切詰め"
::msgcat::mcset pb_msg_japanese "MC(address,warn_drop,Label)"            "ユーザに警告"
::msgcat::mcset pb_msg_japanese "MC(address,abort_drop,Label)"           "プロセスを中止"

::msgcat::mcset pb_msg_japanese "MC(address,max,error_handle,Label)"     "違反処理"
::msgcat::mcset pb_msg_japanese "MC(address,max,error_handle,Context)"   "このボタンにより、最大値への違反を処理する方法を指定できます。 \n \n * 値を切詰め\n * ユーザに警告\n * プロセスを中止\n"

::msgcat::mcset pb_msg_japanese "MC(address,min,value,Label)"            "最小"
::msgcat::mcset pb_msg_japanese "MC(address,min,value,Context)"          "ワードに対する最小値を指定します。"

::msgcat::mcset pb_msg_japanese "MC(address,min,error_handle,Label)"     "違反処理"
::msgcat::mcset pb_msg_japanese "MC(address,min,error_handle,Context)"   "このボタンにより、最小値への違反を処理する方法を指定できます。 \n \n * 値を切詰め\n * ユーザに警告\n * プロセスを中止\n"

::msgcat::mcset pb_msg_japanese "MC(address,format_trans,title,Label)"   "フォーマット "
::msgcat::mcset pb_msg_japanese "MC(address,none_popup,Label)"           "なし"

::msgcat::mcset pb_msg_japanese "MC(address,exp,Label)"                  "式"
::msgcat::mcset pb_msg_japanese "MC(address,exp,Context)"                "ブロックへの式または定数を指定できます。"
::msgcat::mcset pb_msg_japanese "MC(address,exp,msg)"                    "ブロック要素に対する式はブランクではいけません。"
::msgcat::mcset pb_msg_japanese "MC(address,exp,space_only)"             "数値フォーマットを使用するブロック要素の式は、空白のみ含むことができません。"

## No translation is needed for this string.
::msgcat::mcset pb_msg_japanese "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_japanese "MC(address,exp,spec_char_msg)"          "特殊文字 \n [::msgcat::mc MC(address,exp,spec_char)] \n は、数値データに対する式では使用できません。"



::msgcat::mcset pb_msg_japanese "MC(address,name_msg)"                   "ワード名が無効です。\n 異なる名前を指定してください。"
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_japanese "MC(address,rapid_add_name_msg)"         "rapid1、rapid2およびrapid3は、ポストビルダによる内部使用に対して予約されています。\n 異なる名前を指定してください。"

::msgcat::mcset pb_msg_japanese "MC(address,rapid1,desc)"                "縦方向軸に沿った早送り位置"
::msgcat::mcset pb_msg_japanese "MC(address,rapid2,desc)"                "横方向軸に沿った早送り位置"
::msgcat::mcset pb_msg_japanese "MC(address,rapid3,desc)"                "スピンドル軸に沿った早送り位置"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_japanese "MC(format,tab,Label)"                   "フォーマット"
::msgcat::mcset pb_msg_japanese "MC(format,Status)"                      "フォーマットを定義"

::msgcat::mcset pb_msg_japanese "MC(format,verify,Label)"                "フォーマット -- 検証"
::msgcat::mcset pb_msg_japanese "MC(format,verify,Context)"              "このウィンドウは、指定されたフォーマットを使用して出力される代表的なN/Cコードを表示します。"

::msgcat::mcset pb_msg_japanese "MC(format,name,Label)"                  "フォーマット名"
::msgcat::mcset pb_msg_japanese "MC(format,name,Context)"                "フォーマット名を編集できます。"

::msgcat::mcset pb_msg_japanese "MC(format,data,type,Label)"             "データタイプ"
::msgcat::mcset pb_msg_japanese "MC(format,data,type,Context)"           "フォーマットに対するデータタイプを指定します。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,Label)"              "数値"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,Context)"            "このオプションは、フォーマットのデータタイプを数値として定義します。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,integer,Label)"      "フォーマット -- 整数の桁"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,integer,Context)"    "このオプションは、整数の桁数または実数の整数部分の桁数を指定します。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,fraction,Label)"     "小数点未満桁数"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,fraction,Context)"   "このオプションは、実数の小数点未満桁数を指定します。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,decimal,Label)"      "小数点(.)を出力"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,decimal,Context)"    "このオプションにより、N/Cコード内の小数点を出力できます。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,lead,Label)"         "先頭にゼロを出力"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,lead,Context)"       "このオプションは、N/Cコード内の番号に先頭ゼロを追加することを有効にします。"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,trail,Label)"        "末尾にゼロを出力"
::msgcat::mcset pb_msg_japanese "MC(format,data,num,trail,Context)"      "このオプションは、N/Cコード内の実数に末尾ゼロを追加することを有効にします。"
::msgcat::mcset pb_msg_japanese "MC(format,data,text,Label)"             "テキスト"
::msgcat::mcset pb_msg_japanese "MC(format,data,text,Context)"           "このオプションは、フォーマットのデータタイプを文字列として定義します。"
::msgcat::mcset pb_msg_japanese "MC(format,data,plus,Label)"             "先頭にプラス符号(+)を出力"
::msgcat::mcset pb_msg_japanese "MC(format,data,plus,Context)"           "このオプションにより、N/Cコード内のプラス符号を出力できます。"
::msgcat::mcset pb_msg_japanese "MC(format,zero_msg)"                    "ゼロフォーマットのコピーは作成できません"
::msgcat::mcset pb_msg_japanese "MC(format,zero_cut_msg)"                "ゼロフォーマットを削除できません"

::msgcat::mcset pb_msg_japanese "MC(format,data,dec_zero,msg)"           "小数点、先頭ゼロまたは末尾ゼロオプションのうち、少なくとも1つをチェックする必要があります。"

::msgcat::mcset pb_msg_japanese "MC(format,data,no_digit,msg)"           "整数および小数点未満の桁数は、両方ともゼロではいけません。"

::msgcat::mcset pb_msg_japanese "MC(format,name_msg)"                    "フォーマット名が無効です。\n 異なる名前を指定します。"
::msgcat::mcset pb_msg_japanese "MC(format,error,title)"                 "フォーマットエラー"
::msgcat::mcset pb_msg_japanese "MC(format,error,msg)"                   "このフォーマットはアドレスで使用されています"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_japanese "MC(other,tab,Label)"                    "他のデータ要素"
::msgcat::mcset pb_msg_japanese "MC(other,Status)"                       "パラメータを指定"

::msgcat::mcset pb_msg_japanese "MC(other,seq_num,Label)"                "シーケンス番号"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,Context)"              "このスイッチにより、N/Cコード内のシーケンス番号の出力を使用可能/不可にします。"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,start,Label)"          "シーケンス番号 - 開始"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,start,Context)"        "シーケンス番号の開始を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,inc,Label)"            "シーケンス番号 - 増分"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,inc,Context)"          "シーケンス番号の増分を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,freq,Label)"           "シーケンス番号 - 頻度"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,freq,Context)"         "N/Cコードに表示されるシーケンス番号の頻度を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,max,Label)"            "シーケンス番号 - 最大"
::msgcat::mcset pb_msg_japanese "MC(other,seq_num,max,Context)"          "シーケンス番号の最大値を指定します。"

::msgcat::mcset pb_msg_japanese "MC(other,chars,Label)"                  "特殊文字"
::msgcat::mcset pb_msg_japanese "MC(other,chars,word_sep,Label)"         "ワードセパレータ"
::msgcat::mcset pb_msg_japanese "MC(other,chars,word_sep,Context)"       "ワードセパレータとして使用される文字を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,chars,decimal_pt,Label)"       "小数点"
::msgcat::mcset pb_msg_japanese "MC(other,chars,decimal_pt,Context)"     "小数点として使用する文字を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,chars,end_of_block,Label)"     "ブロックの終了"
::msgcat::mcset pb_msg_japanese "MC(other,chars,end_of_block,Context)"   "ブロックの最後として使用される文字を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,chars,comment_start,Label)"    "メッセージ開始"
::msgcat::mcset pb_msg_japanese "MC(other,chars,comment_start,Context)"  "オペレータメッセージ行の最初として使用される文字を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,chars,comment_end,Label)"      "メッセージ終了"
::msgcat::mcset pb_msg_japanese "MC(other,chars,comment_end,Context)"    "オペレータメッセージ行の最後として使用される文字を指定します。"

::msgcat::mcset pb_msg_japanese "MC(other,opskip,Label)"                 "オプショナルスキップ"
::msgcat::mcset pb_msg_japanese "MC(other,opskip,leader,Label)"          "ラインリーダ"
::msgcat::mcset pb_msg_japanese "MC(other,opskip,leader,Context)"        "オプショナルスキップラインリーダ"

::msgcat::mcset pb_msg_japanese "MC(other,gm_codes,Label)"               "ブロックごとのGおよびMコードの出力"
::msgcat::mcset pb_msg_japanese "MC(other,g_codes,Label)"                "ブロックごとのGコードの数"
::msgcat::mcset pb_msg_japanese "MC(other,g_codes,Context)"              "このスイッチにより、N/C出力ブロックごとのGコード数の制御を使用可能/不可にできます。"
::msgcat::mcset pb_msg_japanese "MC(other,g_codes,num,Label)"            "Gコードの数"
::msgcat::mcset pb_msg_japanese "MC(other,g_codes,num,Context)"          "N/C出力ブロックごとのGコードの数を指定します。"
::msgcat::mcset pb_msg_japanese "MC(other,m_codes,Label)"                "Mコードの数"
::msgcat::mcset pb_msg_japanese "MC(other,m_codes,Context)"              "このスイッチにより、N/C出力ブロックごとのMコード数の制御を使用可能/不可にできます。"
::msgcat::mcset pb_msg_japanese "MC(other,m_codes,num,Label)"            "ブロックごとのMコードの数"
::msgcat::mcset pb_msg_japanese "MC(other,m_codes,num,Context)"          "N/C出力ブロックごとのMコードの数を指定します。"

::msgcat::mcset pb_msg_japanese "MC(other,opt_none,Label)"               "なし"
::msgcat::mcset pb_msg_japanese "MC(other,opt_space,Label)"              "空白"
::msgcat::mcset pb_msg_japanese "MC(other,opt_dec,Label)"                "小数点(.)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_comma,Label)"              "カンマ(,)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_semi,Label)"               "セミコロン(;)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_colon,Label)"              "コロン(:)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_text,Label)"               "文字列"
::msgcat::mcset pb_msg_japanese "MC(other,opt_left,Label)"               "左括弧 ("
::msgcat::mcset pb_msg_japanese "MC(other,opt_right,Label)"              "右括弧 )"
::msgcat::mcset pb_msg_japanese "MC(other,opt_pound,Label)"              "ポンド記号(\#)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_aster,Label)"              "アスタリスク(*)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_slash,Label)"              "スラッシュ(/)"
::msgcat::mcset pb_msg_japanese "MC(other,opt_new_line,Label)"           "新しいライン(\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_japanese "MC(other,ude,Label)"                    "ユーザ定義イベント"
::msgcat::mcset pb_msg_japanese "MC(other,ude_include,Label)"            "他のCDLファイルを含む"
::msgcat::mcset pb_msg_japanese "MC(other,ude_include,Context)"          "このオプションでは、このポストがCDLファイルへの参照を定義ファイル内で含むようことを可能にします。"

::msgcat::mcset pb_msg_japanese "MC(other,ude_file,Label)"               "CDLファイル名"
::msgcat::mcset pb_msg_japanese "MC(other,ude_file,Context)"             "このポストの定義ファイルで参照(INCLUDE)されるCDLファイルのパスおよびファイル名です。パス名はUG環境変数(\\\$UGII)で開始するか、何も指定しません。パスが指定されないとき、ランタイムにおけるUG/NXにより、ファイルの検索にUGII_CAM_FILE_SEARCH_PATHが使用されます。"
::msgcat::mcset pb_msg_japanese "MC(other,ude_select,Label)"             "名前を選択"
::msgcat::mcset pb_msg_japanese "MC(other,ude_select,Context)"           "このポストの定義ファイルで参照(INCLUDE)されるCDLファイルを選択します。デフォルトで、選択されるファイル名の先頭には、\\\$UGII_CAM_USER_DEF_EVENT_DIR/が追加されます。選択後に、希望する場合には、パス名を編集できます。"


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(output,tab,Label)"                   "出力設定"
::msgcat::mcset pb_msg_japanese "MC(output,Status)"                      "出力パラメータを構成"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(output,vnc,Label)"                   "仮想N/Cコントローラ"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,std,Label)"          "独立"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,sub,Label)"          "従属"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,status,Label)"            "VNCファイルを選択します。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mis_match,Label)"         "選択されたファイルがデフォルトVNCファイル名と一致しません。\n ファイルを再選択しますか?"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,output,Label)"            "仮想N/Cコントローラ(VNC)を生成"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,output,Context)"          "このオプションは、仮想N/Cコントローラ(VNC)の生成を可能にします。従って、VNCが使用できる状態で作成されたポストをISVに使用できます。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,main,Label)"              "マスタVNC"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,main,Context)"            "従属VNCによって提供されるマスタVNCの名前です。ISVランタイムにおいて、おそらく、このポストは従属VNCがあるディレクトリで見つかります。そうでない場合、\\\$UGII_CAM_POST_DIRディレクトリにある同じ名前のポストが使用されます。"


::msgcat::mcset pb_msg_japanese "MC(output,vnc,main,err_msg)"                 "従属VNCに対するマスタVNCを指定しなければなりません。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,main,select_name,Label)"       "名前を選択"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,main,select_name,Context)"     "従属VNCによって提供されるVNCの名前を選択します。ISVランタイムにおいて、おそらく、このポストは従属VNCがあるディレクトリで見つかります。そうでない場合、\\\$UGII_CAM_POST_DIRディレクトリにある同じ名前のポストが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,Label)"                   "仮想N/Cコントローラモード"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,Context)"                 "仮想N/Cコントローラは独立またはマスタVNCの従属になります。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,std,Context)"             "独立VNCは内蔵されています。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,mode,sub,Context)"             "従属VNCは主にそのマスタVNCに従属します。これはISVランタイムにおいて、マスタVNCを提供します。"
::msgcat::mcset pb_msg_japanese "MC(output,vnc,pb_ver,msg)"                   "ポストビルダで作成した仮想N/Cコントローラ  "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(listing,tab,Label)"                  "リストファイル"
::msgcat::mcset pb_msg_japanese "MC(listing,Status)"                     "リストファイルパラメータを指定します。"

::msgcat::mcset pb_msg_japanese "MC(listing,gen,Label)"                  "リストファイルを生成"
::msgcat::mcset pb_msg_japanese "MC(listing,gen,Context)"                "このスイッチにより、リストファイルの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,Label)"                      "リストファイル要素"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,Label)"                "コンポーネント"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,x,Label)"              "X座標"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,x,Context)"            "このスイッチにより、X座標のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,y,Label)"              "Y座標"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,y,Context)"            "このスイッチにより、Y座標のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,z,Label)"              "Z座標"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,z,Context)"            "このスイッチにより、Z座標のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,4,Label)"              "第4軸角度"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,4,Context)"            "このスイッチにより、第4軸角度のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,5,Label)"              "第5軸角度"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,5,Context)"            "このスイッチにより、第5軸角度のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,feed,Label)"           "送り"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,feed,Context)"         "このスイッチにより、送り速度のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,parms,speed,Label)"          "速度"
::msgcat::mcset pb_msg_japanese "MC(listing,parms,speed,Context)"        "このスイッチにより、スピンドル速度のリストファイルへの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,extension,Label)"            "リストファイル拡張子"
::msgcat::mcset pb_msg_japanese "MC(listing,extension,Context)"          "リストファイルの拡張子を指定します"

::msgcat::mcset pb_msg_japanese "MC(listing,nc_file,Label)"              "N/C出力ファイル拡張子"
::msgcat::mcset pb_msg_japanese "MC(listing,nc_file,Context)"            "N/C出力ファイルの拡張子を指定します"

::msgcat::mcset pb_msg_japanese "MC(listing,header,Label)"               "プログラムヘッダ"
::msgcat::mcset pb_msg_japanese "MC(listing,header,oper_list,Label)"     "オペレーションリスト"
::msgcat::mcset pb_msg_japanese "MC(listing,header,tool_list,Label)"     "ツールリスト"

::msgcat::mcset pb_msg_japanese "MC(listing,footer,Label)"               "プログラムフッタ"
::msgcat::mcset pb_msg_japanese "MC(listing,footer,cut_time,Label)"      "合計加工時間"

::msgcat::mcset pb_msg_japanese "MC(listing,format,Label)"                   "ページフォーマット"
::msgcat::mcset pb_msg_japanese "MC(listing,format,print_header,Label)"      "ページヘッダを出力"
::msgcat::mcset pb_msg_japanese "MC(listing,format,print_header,Context)"    "このスイッチにより、リストファイルへのページヘッダの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,format,length,Label)"        "ページ長さ(行)"
::msgcat::mcset pb_msg_japanese "MC(listing,format,length,Context)"      "リストファイルに対してページごとの行数を指定します。"
::msgcat::mcset pb_msg_japanese "MC(listing,format,width,Label)"         "ページ幅(列)"
::msgcat::mcset pb_msg_japanese "MC(listing,format,width,Context)"       "リストファイルに対してページごとの列数を指定します。"

::msgcat::mcset pb_msg_japanese "MC(listing,other,tab,Label)"            "他のオプション"
::msgcat::mcset pb_msg_japanese "MC(listing,output,Label)"               "出力制御要素"

::msgcat::mcset pb_msg_japanese "MC(listing,output,warning,Label)"       "警告メッセージを出力"
::msgcat::mcset pb_msg_japanese "MC(listing,output,warning,Context)"     "このスイッチにより、ポスト処理中の警告メッセージの出力を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,output,review,Label)"        "レビューツールをアクティブ化"
::msgcat::mcset pb_msg_japanese "MC(listing,output,review,Context)"      "このスイッチにより、ポスト処理中にレビューツールをアクティブ化できます。"

::msgcat::mcset pb_msg_japanese "MC(listing,output,group,Label)"         "グループ出力を生成"
::msgcat::mcset pb_msg_japanese "MC(listing,output,group,Context)"       "このスイッチにより、ポスト処理中のグループ出力の制御を使用可能/不可にできます。"

::msgcat::mcset pb_msg_japanese "MC(listing,output,verbose,Label)"       "冗長エラーメッセージを表示"
::msgcat::mcset pb_msg_japanese "MC(listing,output,verbose,Context)"     "このスイッチにより、エラー条件に対する拡張説明を表示できます。これは多少ポスト処理の速度を遅くします。"

::msgcat::mcset pb_msg_japanese "MC(listing,oper_info,Label)"            "オペレーション情報"
::msgcat::mcset pb_msg_japanese "MC(listing,oper_info,parms,Label)"      "オペレーションパラメータ"
::msgcat::mcset pb_msg_japanese "MC(listing,oper_info,tool,Label)"       "ツールパラメータ"
::msgcat::mcset pb_msg_japanese "MC(listing,oper_info,cut_time,,Label)"  "加工時間"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_japanese "MC(listing,user_tcl,frame,Label)"       "ユーザTclソース"
::msgcat::mcset pb_msg_japanese "MC(listing,user_tcl,check,Label)"       "ユーザのTclファイルを提供"
::msgcat::mcset pb_msg_japanese "MC(listing,user_tcl,check,Context)"     "このスイッチにより、固有のTclファイルを提供できます"
::msgcat::mcset pb_msg_japanese "MC(listing,user_tcl,name,Label)"        "ファイル名"
::msgcat::mcset pb_msg_japanese "MC(listing,user_tcl,name,Context)"      "このポストに提供したいTclファイルの名前を指定します"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(preview,tab,Label)"                  "ポストファイルプレビュー"
::msgcat::mcset pb_msg_japanese "MC(preview,new_code,Label)"             "新しいコード"
::msgcat::mcset pb_msg_japanese "MC(preview,old_code,Label)"             "古いコード"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_japanese "MC(event_handler,tab,Label)"            "イベントハンドラ"
::msgcat::mcset pb_msg_japanese "MC(event_handler,Status)"               "手順を表示するイベントを選択します"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_japanese "MC(definition,tab,Label)"               "定義"
::msgcat::mcset pb_msg_japanese "MC(definition,Status)"                  "内容を表示するアイテムを選択します"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_japanese "MC(advisor,tab,Label)"                  "ポストアドバイザ"
::msgcat::mcset pb_msg_japanese "MC(advisor,Status)"                     "ポストアドバイザ"

::msgcat::mcset pb_msg_japanese "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_japanese "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_japanese "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_japanese "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_japanese "MC(definition,format_txt,Label)"        "フォーマット"
::msgcat::mcset pb_msg_japanese "MC(definition,addr_txt,Label)"          "ワード"
::msgcat::mcset pb_msg_japanese "MC(definition,block_txt,Label)"         "ブロック"
::msgcat::mcset pb_msg_japanese "MC(definition,comp_txt,Label)"          "複合ブロック"
::msgcat::mcset pb_msg_japanese "MC(definition,post_txt,Label)"          "ポストブロック"
::msgcat::mcset pb_msg_japanese "MC(definition,oper_txt,Label)"          "オペレータメッセージ"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_japanese "MC(msg,odd)"                            "オプションの引数の奇数"
::msgcat::mcset pb_msg_japanese "MC(msg,wrong_list_1)"                   "不明なオプション"
::msgcat::mcset pb_msg_japanese "MC(msg,wrong_list_2)"                   "次のうちの1つ:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_japanese "MC(event,start_prog,name)"              "プログラムの開始"

### Operation Start
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,start_path,name)"    "パスの開始"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,from_move,name)"     "移動元"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,fst_tool,name)"      "最初のツール"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,auto_tc,name)"       "自動ツール交換"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,manual_tc,name)"     "手動ツール交換"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,init_move,name)"     "初期移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,fst_move,name)"      "最初の移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,appro_move,name)"    "アプローチ移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,engage_move,name)"   "エンゲージ移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,fst_cut,name)"       "最初の切削"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,fst_lin_move,name)"  "最初の線形移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,start_pass,name)"    "パスの開始"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,cutcom_move,name)"   "ツール径補正移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_start,lead_move,name)"     "リードイン移動"

### Operation End
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,ret_move,name)"        "リトラクト移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,rtn_move,name)"        "復帰移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,goh_move,name)"        "GOHOME移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,end_path,name)"        "ツールパスの終了"
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,lead_move,name)"       "リードアウト移動"
::msgcat::mcset pb_msg_japanese "MC(event,opr_end,end_pass,name)"        "パスの終了"

### Program End
::msgcat::mcset pb_msg_japanese "MC(event,end_prog,name)"                "プログラムの終了"


### Tool Change
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,name)"             "ツール交換"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,m_code)"           "Mコード"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,m_code,tl_chng)"   "ツール交換"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,m_code,pt)"        "プライマリタレット"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,m_code,st)"        "セカンダリタレット"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,t_code)"           "Tコード"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,t_code,conf)"      "構成"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,t_code,pt_idx)"    "プライマリタレットインデックス"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,t_code,st_idx)"    "セカンダリタレットインデックス"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,tool_num)"         "ツール番号"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,tool_num,min)"     "最小"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,tool_num,max)"     "最大"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,time)"             "時間(秒)"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,time,tl_chng)"     "ツール交換"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,retract)"          "リトラクト"
::msgcat::mcset pb_msg_japanese "MC(event,tool_change,retract_z)"        "次のZにリトラクト"

### Length Compensation
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,name)"            "長さ補正"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,g_code)"          "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,g_code,len_adj)"  "ツール長補正"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,t_code)"          "Tコード"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,t_code,conf)"     "構成"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,len_off)"         "長さオフセットレジスタ"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,len_off,min)"     "最小"
::msgcat::mcset pb_msg_japanese "MC(event,length_compn,len_off,max)"     "最大"

### Set Modes
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,name)"               "モードをセット"
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,out_mode)"           "出力モード"
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,g_code)"             "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,g_code,absolute)"    "絶対"
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,g_code,incremental)" "増分"
::msgcat::mcset pb_msg_japanese "MC(event,set_modes,rotary_axis)"        "回転軸を増分にできます"

### Spindle RPM
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,name)"                     "スピンドルRPM"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,dir_m_code)"               "スピンドル方向Mコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,dir_m_code,cw)"            "時計回り(CW)"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,dir_m_code,ccw)"           "反時計回り(CCW)"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,range_control)"            "スピンドル範囲制御"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,range_control,dwell_time)" "範囲変更ドウェル時間(秒)"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_rpm,range_control,range_code)" "範囲コードを指定"

### Spindle CSS
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,name)"             "スピンドルCSS"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,g_code)"           "スピンドルGコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,g_code,const)"     "一定サーフェスコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,g_code,max)"       "最大RPMコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,g_code,sfm)"       "SFMを取消すコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,max)"              "CSS中の最大RPM"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_css,sfm)"              "SFM用のIPRモードを常に所有"

### Spindle Off
::msgcat::mcset pb_msg_japanese "MC(event,spindle_off,name)"             "スピンドルオフ"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_off,dir_m_code)"       "スピンドル方向Mコード"
::msgcat::mcset pb_msg_japanese "MC(event,spindle_off,dir_m_code,off)"   "オフ"

### Coolant On
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,name)"              "クーラント - オン"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code)"            "Mコード"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code,on)"         "ON"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code,flood)"      "フラッド"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code,mist)"       "ミスト"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code,thru)"       "スルー"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_on,m_code,tap)"        "タップ"

### Coolant Off
::msgcat::mcset pb_msg_japanese "MC(event,coolant_off,name)"             "クーラント - オフ"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_off,m_code)"           "Mコード"
::msgcat::mcset pb_msg_japanese "MC(event,coolant_off,m_code,off)"       "オフ"

### Inch Metric Mode
::msgcat::mcset pb_msg_japanese "MC(event,inch_metric_mode,name)"            "インチ メトリック モード"
::msgcat::mcset pb_msg_japanese "MC(event,inch_metric_mode,g_code)"          "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,inch_metric_mode,g_code,english)"  "インチ単位(インチ)"
::msgcat::mcset pb_msg_japanese "MC(event,inch_metric_mode,g_code,metric)"   "メートル法(ミリメートル)"

### Feedrates
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,name)"               "送り速度"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,ipm_mode)"           "IPMモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,ipr_mode)"           "IPRモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,dpm_mode)"           "DPMモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mmpm_mode)"          "MMPMモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mmpr_mode)"          "MMPRモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,frn_mode)"           "FRNモード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,g_code)"             "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,format)"             "フォーマット"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,max)"                "最大"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,min)"                "最小"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,label)"         "送り速度モード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,lin)"           "線形補間のみ"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,rot)"           "回転のみ"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,lin_rot)"       "線形および回転"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,rap_lin)"       "早送り線形補間のみ"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,rap_rot)"       "早送り回転のみ"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,mode,rap_lin_rot)"   "早送り線形および回転"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,cycle_mode)"         "サイクル - 送り速度モード"
::msgcat::mcset pb_msg_japanese "MC(event,feedrates,cycle)"              "サイクル"

### Cutcom On
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,name)"               "ツール径補正 - オン"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,g_code)"             "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,left)"               "左"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,right)"              "右"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,app_planes)"         "適用可能平面"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,edit_planes)"        "平面コードを編集"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,reg)"                "ツール径補正レジスタ"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,min)"                "最小"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,max)"                "最大"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_on,bef)"                "交換前にツール径補正オフ"

### Cutcom Off
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_off,name)"              "ツール径補正 - オフ"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_off,g_code)"            "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,cutcom_off,off)"               "オフ"

### Delay
::msgcat::mcset pb_msg_japanese "MC(event,delay,name)"                   "遅延"
::msgcat::mcset pb_msg_japanese "MC(event,delay,seconds)"                "秒"
::msgcat::mcset pb_msg_japanese "MC(event,delay,seconds,g_code)"         "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,delay,seconds,format)"         "フォーマット"
::msgcat::mcset pb_msg_japanese "MC(event,delay,out_mode)"               "出力モード"
::msgcat::mcset pb_msg_japanese "MC(event,delay,out_mode,sec)"           "秒のみ"
::msgcat::mcset pb_msg_japanese "MC(event,delay,out_mode,rev)"           "回転数のみ"
::msgcat::mcset pb_msg_japanese "MC(event,delay,out_mode,feed)"          "送り速度依存"
::msgcat::mcset pb_msg_japanese "MC(event,delay,out_mode,ivs)"           "インバースタイム"
::msgcat::mcset pb_msg_japanese "MC(event,delay,revolution)"             "回転数"
::msgcat::mcset pb_msg_japanese "MC(event,delay,revolution,g_code)"      "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,delay,revolution,format)"      "フォーマット"

### Option Stop
::msgcat::mcset pb_msg_japanese "MC(event,opstop,name)"                  "オプショナルストップ"

### Auxfun
::msgcat::mcset pb_msg_japanese "MC(event,auxfun,name)"                  "補助機能"

### Prefun
::msgcat::mcset pb_msg_japanese "MC(event,prefun,name)"                  "準備機能"

### Load Tool
::msgcat::mcset pb_msg_japanese "MC(event,loadtool,name)"                "ツールをロード"

### Stop
::msgcat::mcset pb_msg_japanese "MC(event,stop,name)"                    "停止"

### Tool Preselect
::msgcat::mcset pb_msg_japanese "MC(event,toolpreselect,name)"           "ツール事前選択"

### Thread Wire
::msgcat::mcset pb_msg_japanese "MC(event,threadwire,name)"              "ねじ切りワイヤ"

### Cut Wire
::msgcat::mcset pb_msg_japanese "MC(event,cutwire,name)"                 "カットワイヤ"

### Wire Guides
::msgcat::mcset pb_msg_japanese "MC(event,wireguides,name)"              "ワイヤガイド"

### Linear Move
::msgcat::mcset pb_msg_japanese "MC(event,linear,name)"                  "線形移動"
::msgcat::mcset pb_msg_japanese "MC(event,linear,g_code)"                "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,linear,motion)"                "線形モーション"
::msgcat::mcset pb_msg_japanese "MC(event,linear,assume)"                "最大トラバーサル送りにおける仮定早送りモード"

### Circular Move
::msgcat::mcset pb_msg_japanese "MC(event,circular,name)"                "円形移動"
::msgcat::mcset pb_msg_japanese "MC(event,circular,g_code)"              "モーションGコード"
::msgcat::mcset pb_msg_japanese "MC(event,circular,clockwise)"           "時計回り(CLW)"
::msgcat::mcset pb_msg_japanese "MC(event,circular,counter-clock)"       "反時計回り(CCLW)"
::msgcat::mcset pb_msg_japanese "MC(event,circular,record)"              "円形レコード"
::msgcat::mcset pb_msg_japanese "MC(event,circular,full_circle)"         "全円"
::msgcat::mcset pb_msg_japanese "MC(event,circular,quadrant)"            "象限"
::msgcat::mcset pb_msg_japanese "MC(event,circular,ijk_def)"             "IJK 定義"
::msgcat::mcset pb_msg_japanese "MC(event,circular,ij_def)"              "IJ 定義"
::msgcat::mcset pb_msg_japanese "MC(event,circular,ik_def)"              "IK 定義"
::msgcat::mcset pb_msg_japanese "MC(event,circular,planes)"              "適用可能平面"
::msgcat::mcset pb_msg_japanese "MC(event,circular,edit_planes)"         "平面コードを編集"
::msgcat::mcset pb_msg_japanese "MC(event,circular,radius)"              "半径"
::msgcat::mcset pb_msg_japanese "MC(event,circular,min)"                 "最小"
::msgcat::mcset pb_msg_japanese "MC(event,circular,max)"                 "最大"
::msgcat::mcset pb_msg_japanese "MC(event,circular,arc_len)"             "最小円弧長"

### Rapid Move
::msgcat::mcset pb_msg_japanese "MC(event,rapid,name)"                   "早送り移動"
::msgcat::mcset pb_msg_japanese "MC(event,rapid,g_code)"                 "Gコード"
::msgcat::mcset pb_msg_japanese "MC(event,rapid,motion)"                 "早送りモーション"
::msgcat::mcset pb_msg_japanese "MC(event,rapid,plane_change)"           "作業平面変更"

### Lathe Thread
::msgcat::mcset pb_msg_japanese "MC(event,lathe,name)"                   "旋盤ねじ切り加工"
::msgcat::mcset pb_msg_japanese "MC(event,lathe,g_code)"                 "ねじ切りGコード"
::msgcat::mcset pb_msg_japanese "MC(event,lathe,cons)"                   "一定"
::msgcat::mcset pb_msg_japanese "MC(event,lathe,incr)"                   "増分"
::msgcat::mcset pb_msg_japanese "MC(event,lathe,decr)"                   "減少"

### Cycle
::msgcat::mcset pb_msg_japanese "MC(event,cycle,g_code)"                 "Gコードおよびカスタマイズ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,customize,Label)"        "カスタマイズ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,customize,Context)"      "このスイッチによりサイクルをカスタマイズできます。\n\nデフォルトでは、各サイクルの基本構築は共通パラメータの設定によって定義されます。各サイクル内のこれらの共通要素は、任意の修正に限定されます。\n\nこのスイッチを切替えることで、サイクルの構成を完全に制御できます。共通パラメータへの変更はカスタマイズされたサイクルへ影響しません。"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,start,Label)"            "サイクル - 開始"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,start,Context)"          "このオプションは、サイクルが定義された後(G81...)に、サイクル開始ブロック(G79...)を使用して、サイクルを実行する工作機械をオンに切替えることができます。"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,start,text)"             "サイクル開始ブロックを使用してサイクルを実行"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,rapid_to)"               "早送り - To"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,retract_to)"             "リトラクト - To"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,plane_control)"          "サイクル - 平面制御"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,com_param,name)"         "共通パラメータ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,cycle_off,name)"         "サイクル - 停止"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,plane_chng,name)"        "サイクル - 平面の変更"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill,name)"             "ドリル"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_dwell,name)"       "ドリル - ドウェル"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_text,name)"        "ドリル - テキスト"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_csink,name)"       "ドリル - 皿座ぐり"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_deep,name)"        "ドリル - 深穴"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_brk_chip,name)"    "ドリル - 高速深穴あけ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,tap,name)"               "タップ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore,name)"              "ボア"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_dwell,name)"        "ボア - ドウェル"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_drag,name)"         "ボア - ドラッグ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_no_drag,name)"      "ボア - ドラッグなし"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_back,name)"         "ボア - バック"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_manual,name)"       "ボア - 手動"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_manual_dwell,name)" "ボア - 手動ドウェル"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,peck_drill,name)"        "深穴あけ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,break_chip,name)"        "高速深穴あけ"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_dwell_sf,name)"    "ドリルドウェル(スポットフェース)"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,drill_deep_peck,name)"   "ドリル深穴(ペック)"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_ream,name)"         "ボア(リーマ)"
::msgcat::mcset pb_msg_japanese "MC(event,cycle,bore_no-drag,name)"      "ボア - ドラッグなし"

##------------
## G Code
##
::msgcat::mcset pb_msg_japanese "MC(g_code,rapid,name)"                  "モーション - 早送り"
::msgcat::mcset pb_msg_japanese "MC(g_code,linear,name)"                 "モーション - 線形"
::msgcat::mcset pb_msg_japanese "MC(g_code,circular_clw,name)"           "円形補間 - 時計回り"
::msgcat::mcset pb_msg_japanese "MC(g_code,circular_cclw,name)"          "円形補間 - 反時計回り"
::msgcat::mcset pb_msg_japanese "MC(g_code,delay_sec,name)"              "遅延(秒)"
::msgcat::mcset pb_msg_japanese "MC(g_code,delay_rev,name)"              "遅延(回転)"
::msgcat::mcset pb_msg_japanese "MC(g_code,pln_xy,name)"                 "平面XY"
::msgcat::mcset pb_msg_japanese "MC(g_code,pln_zx,name)"                 "平面ZX"
::msgcat::mcset pb_msg_japanese "MC(g_code,pln_yz,name)"                 "平面YZ"
::msgcat::mcset pb_msg_japanese "MC(g_code,cutcom_off,name)"             "ツール径補正 - オフ"
::msgcat::mcset pb_msg_japanese "MC(g_code,cutcom_left,name)"            "ツール径補正 - 左"
::msgcat::mcset pb_msg_japanese "MC(g_code,cutcom_right,name)"           "ツール径補正 - 右"
::msgcat::mcset pb_msg_japanese "MC(g_code,length_plus,name)"            "ツール長補正 - プラス"
::msgcat::mcset pb_msg_japanese "MC(g_code,length_minus,name)"           "ツール長補正 - マイナス"
::msgcat::mcset pb_msg_japanese "MC(g_code,length_off,name)"             "ツール長補正 - オフ"
::msgcat::mcset pb_msg_japanese "MC(g_code,inch,name)"                   "インチモード"
::msgcat::mcset pb_msg_japanese "MC(g_code,metric,name)"                 "メトリックモード"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_start,name)"            "サイクル - 開始コード"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_off,name)"              "サイクル - 停止"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_drill,name)"            "サイクル - ドリル"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_drill_dwell,name)"      "サイクル - ドリルドウェル"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_drill_deep,name)"       "サイクル - ドリル深穴あけ"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_drill_bc,name)"         "サイクル - ドリル高速深穴あけ"
::msgcat::mcset pb_msg_japanese "MC(g_code,tap,name)"                    "サイクル - タップ"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore,name)"                   "サイクル - ボーリング"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_drag,name)"              "サイクル - ボーリングドラッグ"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_no_drag,name)"           "サイクル - ボーリングノードラッグ"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_dwell,name)"             "サイクル - ボーリングドウェル"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_manual,name)"            "サイクル - ボーリング手動"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_back,name)"              "サイクル - ボーリングバック"
::msgcat::mcset pb_msg_japanese "MC(g_code,bore_manual_dwell,name)"      "サイクル - ボーリング手動ドウェル"
::msgcat::mcset pb_msg_japanese "MC(g_code,abs,name)"                    "絶対モード"
::msgcat::mcset pb_msg_japanese "MC(g_code,inc,name)"                    "増分モード"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_retract_auto,name)"     "サイクル - リトラクト(AUTO)"
::msgcat::mcset pb_msg_japanese "MC(g_code,cycle_retract_manual,name)"   "サイクル - リトラクト(MANUAL)"
::msgcat::mcset pb_msg_japanese "MC(g_code,reset,name)"                  "リセット"
::msgcat::mcset pb_msg_japanese "MC(g_code,fr_ipm,name)"                 "送り速度モード - IPM"
::msgcat::mcset pb_msg_japanese "MC(g_code,fr_ipr,name)"                 "送り速度モード - IPR"
::msgcat::mcset pb_msg_japanese "MC(g_code,fr_frn,name)"                 "送り速度モード - FRM"
::msgcat::mcset pb_msg_japanese "MC(g_code,spindle_css,name)"            "スピンドルCSS"
::msgcat::mcset pb_msg_japanese "MC(g_code,spindle_rpm,name)"            "スピンドルRPM"
::msgcat::mcset pb_msg_japanese "MC(g_code,ret_home,name)"               "ホームへ戻る"
::msgcat::mcset pb_msg_japanese "MC(g_code,cons_thread,name)"            "ねじ切り - 一定"
::msgcat::mcset pb_msg_japanese "MC(g_code,incr_thread,name)"            "ねじ切り - 増分"
::msgcat::mcset pb_msg_japanese "MC(g_code,decr_thread,name)"            "ねじ切り - 減少"
::msgcat::mcset pb_msg_japanese "MC(g_code,feedmode_in,pm)"              "送り速度モード - IPM"
::msgcat::mcset pb_msg_japanese "MC(g_code,feedmode_in,pr)"              "送り速度モード - IPR"
::msgcat::mcset pb_msg_japanese "MC(g_code,feedmode_mm,pm)"              "送り速度モード - MMPM"
::msgcat::mcset pb_msg_japanese "MC(g_code,feedmode_mm,pr)"              "送り速度モード - MMPR"
::msgcat::mcset pb_msg_japanese "MC(g_code,feedmode,dpm)"                "送り速度モードDPM"

##------------
## M Code
##
::msgcat::mcset pb_msg_japanese "MC(m_code,stop_manual_tc,name)"         "停止/手動ツール交換"
::msgcat::mcset pb_msg_japanese "MC(m_code,stop,name)"                   "停止"
::msgcat::mcset pb_msg_japanese "MC(m_code,opt_stop,name)"               "オプショナルストップ"
::msgcat::mcset pb_msg_japanese "MC(m_code,prog_end,name)"               "プログラム終了"
::msgcat::mcset pb_msg_japanese "MC(m_code,spindle_clw,name)"            "スピンドルオン/時計回り"
::msgcat::mcset pb_msg_japanese "MC(m_code,spindle_cclw,name)"           "スピンドル反時計回り"
::msgcat::mcset pb_msg_japanese "MC(m_code,lathe_thread,type1)"          "ねじ切り - 一定"
::msgcat::mcset pb_msg_japanese "MC(m_code,lathe_thread,type2)"          "ねじ切り - 増分"
::msgcat::mcset pb_msg_japanese "MC(m_code,lathe_thread,type3)"          "ねじ切り - 減少"
::msgcat::mcset pb_msg_japanese "MC(m_code,spindle_off,name)"            "スピンドルオフ"
::msgcat::mcset pb_msg_japanese "MC(m_code,tc_retract,name)"             "ツール交換/リトラクト"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_on,name)"             "クーラント - オン"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_fld,name)"            "クーラント - フラッド"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_mist,name)"           "クーラント - ミスト"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_thru,name)"           "クーラント - スルー"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_tap,name)"            "クーラント - タップ"
::msgcat::mcset pb_msg_japanese "MC(m_code,coolant_off,name)"            "クーラント - オフ"
::msgcat::mcset pb_msg_japanese "MC(m_code,rewind,name)"                 "巻戻し"
::msgcat::mcset pb_msg_japanese "MC(m_code,thread_wire,name)"            "ねじ切りワイヤ"
::msgcat::mcset pb_msg_japanese "MC(m_code,cut_wire,name)"               "カットワイヤ"
::msgcat::mcset pb_msg_japanese "MC(m_code,fls_on,name)"                 "フラッシングオン"
::msgcat::mcset pb_msg_japanese "MC(m_code,fls_off,name)"                "フラッシングオフ"
::msgcat::mcset pb_msg_japanese "MC(m_code,power_on,name)"               "パワーオン"
::msgcat::mcset pb_msg_japanese "MC(m_code,power_off,name)"              "パワーオフ"
::msgcat::mcset pb_msg_japanese "MC(m_code,wire_on,name)"                "ワイヤオン"
::msgcat::mcset pb_msg_japanese "MC(m_code,wire_off,name)"               "ワイヤオフ"
::msgcat::mcset pb_msg_japanese "MC(m_code,pri_turret,name)"             "プライマリタレット"
::msgcat::mcset pb_msg_japanese "MC(m_code,sec_turret,name)"             "セカンダリタレット"

##------------
## UDE
##
::msgcat::mcset pb_msg_japanese "MC(ude,editor,enable,Label)"            "UDEエディタの使用"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,enable,as_saved,Label)"   "保存した状態と同じ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,TITLE)"                   "ユーザ定義イベント"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,no_ude)"                  "関係のあるUDEがありません!"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,int,Label)"               "整数"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,int,Context)"             "新しい整数パラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,real,Label)"              "実数"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,real,Context)"            "新しい実数パラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,txt,Label)"               "テキスト"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,txt,Context)"             "新しいストリングパラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,bln,Label)"               "ブーリアン"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,bln,Context)"             "新しいブーリアンパラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,Label)"               "オプション"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,Context)"             "新しいオプションパラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,pnt,Label)"               "点"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,pnt,Context)"             "新しい点パラメータをドラッグすることで、右のリストに追加します。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,trash,Label)"             "エディタ -- ごみ箱"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,trash,Context)"           "不要なパラメータを、右のリストからこのごみ箱へドラッグすることで、廃棄することが可能です。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,event,Label)"             "イベント"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,event,Context)"           "MB1により、ここでイベントのパラメータを編集できます。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,Label)"             "イベント -- パラメータ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,Context)"           "右クリックで各パラメータを編集したり、またはドラッグアンドドロップでパラメータの順序を変更できます。\n \nライトブルーのパラメータは、システム定義によるもので削除できません。\nバーリーウッドのパラメータは、システム定義ではなく、修正または削除が可能です。"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,edit,Label)"        "パラメータ -- オプション"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,edit,Context)"      "マウスの左ボタンをクリックして、デフォルトオプションを選択します。\n マウスの左ボタンをダブルクリックして、オプションを編集します。"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,editor,Label)"      "パラメータタイプ: "

::msgcat::mcset pb_msg_japanese "MC(ude,editor,pnt,sel,Label)"           "選択"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,pnt,dsp,Label)"           "表示"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,dlg,bck,Label)"           "戻る"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,dlg,cnl,Label)"           "キャンセル"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,PL,Label)"       "パラメータラベル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,VN,Label)"       "変数名"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,DF,Label)"       "デフォルト値"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,PL,Context)"     "パラメータラベルを指定します"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,VN,Context)"     "変数名を指定します"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,DF,Context)"     "デフォルト値を指定します"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,TG)"             "トグル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,TG,B,Label)"     "トグル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,TG,B,Context)"   "トグル値を選択"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ON,Label)"       "オン"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,OFF,Label)"      "オフ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ON,Context)"     "ONでデフォルト値を選択"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,OFF,Context)"    "OFFでデフォルト値を選択"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,OL)"             "オプションリスト"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ADD,Label)"      "追加"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,CUT,Label)"      "切取り"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,PASTE,Label)"    "貼付け"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ADD,Context)"    "アイテムを追加"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,CUT,Context)"    "アイテムを切取り"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,PASTE,Context)"  "アイテムを貼付け"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ENTRY,Label)"    "オプション"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,paramdlg,ENTRY,Context)"  "アイテムを入力"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EN,Label)"       "イベント名"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EN,Context)"     "イベント名を指定"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,PEN,Label)"      "ポスト名"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,PEN,Context)"    "ポスト名を指定します"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,PEN,C,Label)"    "ポスト名"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,PEN,C,Context)"  "このスイッチにより、ポスト名をセットできます"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EL,Label)"       "イベントラベル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EL,Context)"     "イベントラベルを指定します"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EL,C,Label)"     "イベントラベル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EL,C,Context)"   "このスイッチにより、イベントラベルをセットできます"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC,Label)"           "カテゴリ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC,Context)"         "このスイッチにより、カテゴリをセットできます"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_MILL,Label)"      "ミル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "ドリル"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "旋盤"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "WEDM"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_MILL,Context)"    "ミルカテゴリをセット"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "ドリルカテゴリをセット"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "旋盤カテゴリをセット"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "WEDMカテゴリをセット"

::msgcat::mcset pb_msg_japanese "MC(ude,editor,EDIT)"                    "イベントを編集"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,CREATE)"                  "機械制御イベントを作成"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,HELP)"              "ヘルプ"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,EDIT)"              "ユーザ定義パラメータを編集..."
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,EDIT)"              "編集..."
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,VIEW)"              "表示..."
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,DELETE)"            "削除"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,CREATE)"            "新規機械制御イベントを作成..."
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,IMPORT)"            "機械制御イベントをインポート..."
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_BLANK)"         "イベント名はブランクにできません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_SAMENAME)"      "イベント名が存在します!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,popup,MSG_SameHandler)"   "イベントハンドラが存在します! \nチェックされている場合、イベント名またはポスト名を修正してください!"
::msgcat::mcset pb_msg_japanese "MC(ude,validate)"                       "このイベントにはパラメータがありません!"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,tab,Label)"                 "ユーザ定義イベント"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,ude,Label)"                 "機械制御イベント"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,udc,Label)"                 "ユーザ定義サイクル"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,mc,Label)"                  "システム機械制御イベント"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,nmc,Label)"                 "非システム機械制御イベント"
::msgcat::mcset pb_msg_japanese "MC(udc,prev,sys,Label)"                 "システムサイクル"
::msgcat::mcset pb_msg_japanese "MC(udc,prev,nsys,Label)"                "非システムサイクル"
::msgcat::mcset pb_msg_japanese "MC(ude,prev,Status)"                    "定義するアイテムを選択"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,MSG_BLANK)"           "オプションストリングはブランクにできません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,MSG_SAME)"            "オプションストリングが存在します!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,MSG_PST_SAME)"        "貼付けるオプションは存在します!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,MSG_IDENTICAL)"       "幾つかのオプションが同一です!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,opt,NO_OPT)"              "リストにオプションがありません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_NO_VNAME)"      "変数名はブランクにできません!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,param,MSG_EXIST_VNAME)"   "変数名が存在します!"
::msgcat::mcset pb_msg_japanese "MC(ude,editor,spindle_css,INFO)"        "このイベントは、UDEと\"スピンドルRPM\"を共有しています"
::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr,Label)"               "ポストからUDEを継承"

::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr,Context)"             "このオプションは、このポストがUDE定義およびそのハンドラをポストから継承できるようにします。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,sel,Label)"               "ポストを選択"

::msgcat::mcset pb_msg_japanese "MC(ude,import,sel,Context)"             "希望するポストのPUIファイルを選択します。継承されているポストに関連するすべてのファイル(PUI、Def、TclおよびCDL)を、ランタイム利用と同じディレクトリ(フォルダ)に配置することを推奨します。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,name_cdl,Label)"          "CDLファイル名"

::msgcat::mcset pb_msg_japanese "MC(ude,import,name_cdl,Context)"        "このポストの定義ファイルで参照(INCLUDE)される選択ポストに関連するCDLファイルのパスおよびファイル名です。パス名はUG環境変数(\\\$UGII)で開始するか、何も指定しません。パスが指定されないとき、ランタイムにおけるUG/NXにより、ファイルの検索にUGII_CAM_FILE_SEARCH_PATHが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,name_def,Label)"          "定義ファイル名"
::msgcat::mcset pb_msg_japanese "MC(ude,import,name_def,Context)"        "このポストの定義ファイルで参照(INCLUDE)される選択ポストの定義ファイルのパスおよびファイル名です。パス名はUG環境変数(\\\$UGII)で開始するか、何も指定しません。パスが指定されないとき、ランタイムにおけるUG/NXにより、ファイルの検索にUGII_CAM_FILE_SEARCH_PATHが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr_pst,Label)"           "ポスト"
::msgcat::mcset pb_msg_japanese "MC(ude,import,ihr_folder,Label)"        "フォルダ"
::msgcat::mcset pb_msg_japanese "MC(ude,import,own_folder,Label)"        "フォルダ"
::msgcat::mcset pb_msg_japanese "MC(ude,import,own,Label)"               "固有のCDLファイルを含む"

::msgcat::mcset pb_msg_japanese "MC(ude,import,own,Context)"             "このオプションは、このポストが定義ファイル内のそれ固有のCDLファイルへの参照を含むことを可能にします。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,own_ent,Label)"           "固有のCDLファイル"

::msgcat::mcset pb_msg_japanese "MC(ude,import,own_ent,Context)"         "このポストの定義ファイルで参照(INCLUDE)されるポストに関連するCDLファイルのパスおよびファイル名です。実際のファイル名は、このポストの保存時に決定されます。パス名はUG環境変数(\\\$UGII)で開始するか、何も指定しません。パスが指定されないとき、ランタイムにおけるUG/NXにより、ファイルの検索にUGII_CAM_FILE_SEARCH_PATHが使用されます。"

::msgcat::mcset pb_msg_japanese "MC(ude,import,sel,pui,status)"          "PUIファイルを選択"
::msgcat::mcset pb_msg_japanese "MC(ude,import,sel,cdl,status)"          "CDLファイルを選択"

##---------
## UDC
##
::msgcat::mcset pb_msg_japanese "MC(udc,editor,TITLE)"                   "ユーザ定義サイクル"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CREATE)"                  "ユーザ定義サイクルを作成"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,TYPE)"                    "サイクル - タイプ"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,type,UDC)"                "ユーザ定義"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,type,SYSUDC)"             "システム定義"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCLBL,Label)"            "サイクル - ラベル"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCNAME,Label)"           "サイクル - 名前"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCLBL,Context)"          "サイクルラベルを指定"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCNAME,Context)"         "サイクル名を指定"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCLBL,C,Label)"          "サイクル - ラベル"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,CYCLBL,C,Context)"        "このスイッチによりサイクルラベルをセットできます"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,EDIT)"              "ユーザ定義パラメータを編集..."
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,MSG_BLANK)"         "サイクル名はブランクにできません!"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,MSG_SAMENAME)"      "サイクル名が存在します!"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,MSG_SameHandler)"   "イベントハンドラが存在します!\n サイクルイベント名を修正してください!"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,MSG_ISSYSCYC)"      "サイクル名がシステムサイクルタイプに属しています!"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "この種類のシステムサイクルは存在します!"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,EDIT)"                    "サイクルイベントを編集"
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,CREATE)"            "新規ユーザ定義サイクルを作成..."
::msgcat::mcset pb_msg_japanese "MC(udc,editor,popup,IMPORT)"            "ユーザ定義サイクルをインポート..."
::msgcat::mcset pb_msg_japanese "MC(udc,drill,csink,INFO)"               "このイベントは、ドリルとハンドラを共有しています!"
::msgcat::mcset pb_msg_japanese "MC(udc,drill,simulate,INFO)"            "これは疑似サイクルイベントです。"
::msgcat::mcset pb_msg_japanese "MC(udc,drill,dwell,INFO)"               "このイベントは、ユーザ定義サイクルを共有します "


#######
# IS&V
#######
::msgcat::mcset pb_msg_japanese "MC(isv,tab,label)"                      "仮想N/Cコントローラ"
::msgcat::mcset pb_msg_japanese "MC(isv,Status)"                         "ISVに対するパラメータを指定"
::msgcat::mcset pb_msg_japanese "MC(isv,review,Status)"                  "VNCコマンドをレビュー"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,Label)"                    "構成"
::msgcat::mcset pb_msg_japanese "MC(isv,vnc_command,Label)"              "VNCコマンド"
####################
# General Definition
####################
::msgcat::mcset pb_msg_japanese "MC(isv,select_Main)"                    "下位のVNCに対するマスタVNCファイルを選択します。"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,machine,Label)"            "工作機械"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,component,Label)"          "ツールマウント"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,mac_zcs_frame,Label)"      "プログラムゼロ参照"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,mac_zcs,Label)"            "コンポーネント"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,mac_zcs,Context)"          "ZCS参照ベースとしてコンポーネントを指定します。これは、パートが直接接続されているか、またはキネマティクスツリーにおいて間接的に接続されている非回転コンポーネントである必要があります。"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spin_com,Label)"           "コンポーネント"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spin_com,Context)"         "ツールがマウントされるコンポーネントを指定します。これは、ミルポストに対してはスピンドルコンポーネントで、旋盤ポストに対してはタレットコンポーネントである必要があります。"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,spin_jct,Label)"           "ジャンクション"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spin_jct,Context)"         "マウントツールに対するジャンクションを定義します。これは、ミルポストのスピンドルフェースの中心にあるジャンクションです。これは旋盤ポストに対するタレット回転ジャンクションです。タレットが固定されている場合は、ツールマウントジャンクションになります。"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,axis_name,Label)"          "工作機械の指定軸"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,axis_name,Context)"        "工作機械キネマティクス構成に一致する軸名を指定します"




::msgcat::mcset pb_msg_japanese "MC(isv,setup,axis_frm,Label)"           "NC軸名"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,rev_fourth,Label)"         "逆回転"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,rev_fourth,Context)"       "軸の回転方向を指定します。これは反転または標準のいずれかです。これは回転テーブルに対してのみ適用可能です。"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,rev_fifth,Label)"          "逆回転"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,fourth_limit,Label)"       "回転制限"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,fourth_limit,Context)"     "この回転軸に制限がある場合に指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,fifth_limit,Label)"        "回転制限"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,limiton,Label)"            "あり"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,limitoff,Label)"           "なし"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,fourth_table,Label)"       "第4軸"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,fifth_table,Label)"        "第5軸"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,header,Label)"             " テーブル "
::msgcat::mcset pb_msg_japanese "MC(isv,setup,intialization,Label)"      "コントローラ"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,general_def,Label)"        "初期設定"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,advanced_def,Label)"       "他のオプション"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,InputOutput,Label)"        "特殊NCコード"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,program,Label)"            "デフォルトプログラム定義"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,output,Label)"             "プログラム定義をエクスポート"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,output,Context)"           "プログラム定義をファイルに保存します"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,input,Label)"              "プログラム定義をインポート"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,input,Context)"            "ファイルからプログラム定義を呼出します"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,file_err,Msg)"             "選択したファイルはデフォルトのプログラム定義ファイルタイプと一致しません。続行しますか?"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,wcs,Label)"                "取付具オフセット"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,tool,Label)"               "ツールデータ"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,g_code,Label)"             "特殊Gコード"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,special_vnc,Label)"        "特殊NCコード"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_japanese "MC(isv,setup,initial_motion,Label)"     "モーション"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,initial_motion,Context)"   "工作機械の初期モーションを指定"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,spindle,frame,Label)"      "スピンドル"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spindle_mode,Label)"       "モード"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spindle_direction,Label)"  "回転"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,spindle,frame,Context)"    "初期スピンドル速度単位および回転方向を指定"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,feedrate_mode,Label)"      "送り速度モード"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,feedrate_mode,Context)"    "初期送り速度単位を指定"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,boolean,frame,Label)"      "ブーリアンアイテム定義"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,power_on_wcs,Label)"       "パワーオン作業座標系  "
::msgcat::mcset pb_msg_japanese "MC(isv,setup,power_on_wcs,Context)"     "0は、デフォルトの機械ゼロ座標が使用されることを示します\n 1は、最初のユーザ定義取付具オフセット(作業座標)が使用されることを示します"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,use_s_leader,Label)"       "S使用"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,use_f_leader,Label)"       "F使用"


::msgcat::mcset pb_msg_japanese "MC(isv,setup,dog_leg,Label)"            "ドッグレッグ早送り"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,dog_leg,Context)"          "ONではドッグレッグ様式で早送り移動をトラバースします。OFFでは、NCコード(点から点)に従って早送り移動をトラバースします。"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,dog_leg,yes)"              "あり"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,dog_leg,no)"               "なし"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,on_off_frame,Label)"       "ON/OFF定義"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,stroke_limit,Label)"       "ストローク限界"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,cutcom,Label)"             "ツール径補正"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,tl_adjust,Label)"          "ツール長補正"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,scale,Label)"              "スケール"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,macro_modal,Label)"        "マクロモーダル"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,wcs_rotate,Label)"         "作業座標系回転"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,cycle,Label)"              "サイクル"

::msgcat::mcset pb_msg_japanese "MC(isv,setup,initial_mode,frame,Label)"     "入力モード"
::msgcat::mcset pb_msg_japanese "MC(isv,setup,initial_mode,frame,Context)"   "絶対または増分として初期入力モードを指定します"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,rewindstop,Label)"   "巻戻し停止コード"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,rewindstop,Context)" "巻戻し停止コードを指定"

::msgcat::mcset pb_msg_japanese "MC(isv,control_var,frame,Label)"        "制御変数"

::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,convarleader,Label)"     "リーダ"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,convarleader,Context)"   "コントローラ変数を指定"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,conequ,Label)"           "等号"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,conequ,Context)"         "制御等号を指定"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,percent,Label)"          "百分率記号 %"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,leaderjing,Label)"       "シャープ #"
::msgcat::mcset pb_msg_japanese "MC(isv,sign_define,text_string,Label)"      "テキスストリング"

::msgcat::mcset pb_msg_japanese "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_japanese "MC(isv,input_mode,Label)"               "初期モード"
::msgcat::mcset pb_msg_japanese "MC(isv,absolute_mode,Label)"            "絶対"
::msgcat::mcset pb_msg_japanese "MC(isv,incremental_style,frame,Label)"  "増分モード"

::msgcat::mcset pb_msg_japanese "MC(isv,incremental_mode,Label)"         "増分"
::msgcat::mcset pb_msg_japanese "MC(isv,incremental_gcode,Label)"        "Gコード"
::msgcat::mcset pb_msg_japanese "MC(isv,incremental_gcode,Context)"      "G90 G91を使用して絶対モードまたは増分モードを差別化します"
::msgcat::mcset pb_msg_japanese "MC(isv,incremental_uvw,Label)"          "特殊リーダ"
::msgcat::mcset pb_msg_japanese "MC(isv,incremental_uvw,Context)"        "特殊リーダを使用して絶対モードまたは増分モードを差別化します。fg: リーダX Y Zは、それが絶対モードであることを示し、リーダU V Wは、それが増分モードであることを示します。"
::msgcat::mcset pb_msg_japanese "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_japanese "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_japanese "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_japanese "MC(isv,incr_a,Label)"                   "第4軸 "
::msgcat::mcset pb_msg_japanese "MC(isv,incr_b,Label)"                   "第5軸 "

::msgcat::mcset pb_msg_japanese "MC(isv,incr_x,Context)"                 "増分スタイルで使用される特殊X軸リーダを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,incr_y,Context)"                 "増分スタイルで使用される特殊Y軸リーダを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,incr_z,Context)"                 "増分スタイルで使用される特殊Z軸リーダを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,incr_a,Context)"                 "増分スタイルで使用される特殊第4軸リーダを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,incr_b,Context)"                 "増分スタイルで使用される特殊第5軸リーダを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,vnc_mes,frame,Label)"            "VNCメッセージを出力"

::msgcat::mcset pb_msg_japanese "MC(isv,vnc_message,Label)"              "VNCメッセージをリスト"
::msgcat::mcset pb_msg_japanese "MC(isv,vnc_message,Context)"            "このオプションがチェックされている場合、シミュレーション実行中に、オペレーションメッセージにすべてのVNCデバッグメッセージが表示されます。"

::msgcat::mcset pb_msg_japanese "MC(isv,vnc_mes,prefix,Label)"           "メッセージプレフィックス"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_desc,Label)"                "説明"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_codelist,Label)"            "コードリスト"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_nccode,Label)"              "NCコード/ストリング"

################
# WCS Definition
################
::msgcat::mcset pb_msg_japanese "MC(isv,machine_zero,offset,Label)"      "工作機械ゼロジャンクションからの\nマシンゼロオフセット"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,frame,Label)"         "取付具オフセット"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_leader,Label)"               " コード "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,origin_x,Label)"      " X - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,origin_y,Label)"      " Y - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,origin_z,Label)"      " Z - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,a_offset,Label)"      " A - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,b_offset,Label)"      " B - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,c_offset,Label)"      " C - オフセット  "
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,wcs_num,Label)"       "座標系"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,wcs_num,Context)"     "追加する必要がある取付具オフセット番号を指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,wcs_add,Label)"       "追加"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,wcs_add,Context)"     "新規取付具オフセット座標系を追加して、その位置を指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,wcs_offset,wcs_err,Msg)"         "この座標系番号は既に存在します!"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,frame,Label)"          "ツール情報"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,tool_entry,Label)"     "新規ツール名を入力"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,tool_name,Label)"      "       名前       "

::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,tool_num,Label)"       " ツール "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,add_tool,Label)"       "追加"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,tool_diameter,Label)"  " 直径 "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,offset_usder,Label)"   "   先端オフセット   "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,carrier_id,Label)"     " キャリアID "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,pocket_id,Label)"      " ポケットID "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,cutcom_reg,Label)"     "     ツール径補正     "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,cutreg,Label)"         "レジスタ "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,cutval,Label)"         "オフセット "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,adjust_reg,Label)"     " 長さ調整 "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,tool_type,Label)"      "   タイプ   "
::msgcat::mcset pb_msg_japanese "MC(isv,prog,setup,Label)"               "デフォルトプログラム定義"
::msgcat::mcset pb_msg_japanese "MC(isv,prog,setup_right,Label)"         "プログラム定義"
::msgcat::mcset pb_msg_japanese "MC(isv,output,setup_data,Label)"        "プログラム定義ファイルを指定"
::msgcat::mcset pb_msg_japanese "MC(isv,input,setup_data,Label)"         "プログラム定義ファイルを選択"

::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,toolnum,Label)"        "ツール番号  "
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,toolnum,Context)"      "追加する必要があるツール番号を指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,add_tool,Context)"     "新規ツールを追加して、そのパラメータを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,add_err,Msg)"          "このツール番号は既に存在します!"
::msgcat::mcset pb_msg_japanese "MC(isv,tool_info,name_err,Msg)"         "ツール名は空にできません!"

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_japanese "MC(isv,g_code,frame,Label)"             "特殊Gコード"
::msgcat::mcset pb_msg_japanese "MC(isv,g_code,frame,Context)"           "シミュレーションで使用される特殊Gコードを指定します"
::msgcat::mcset pb_msg_japanese "MC(isv,g_code,from_home,Label)"         "ホームから"
::msgcat::mcset pb_msg_japanese "MC(isv,g_code,return_home,Label)"       "ホームポジションに戻る"
::msgcat::mcset pb_msg_japanese "MC(isv,g_code,mach_wcs,Label)"          "機械データム移動"
::msgcat::mcset pb_msg_japanese "MC(isv,g_code,set_local,Label)"         "ローカル座標をセット"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,frame,Label)"       "特殊NCコマンド"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,frame,Context)"     "特殊装置に対して指定されたNCコマンド"


::msgcat::mcset pb_msg_japanese "MC(isv,spec_pre,frame,Label)"           "プリプロセスコマンド"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_pre,frame,Context)"         "コマンドリストは、座標に対してブロックが解釈の対象となる前に処理する必要があるトークンまたはシンボルすべてを示します。"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,add,Label)"         "追加"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,edit,Label)"        "編集"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,delete,Label)"      "削除"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,title,Label)"       "他の装置に対する特殊コマンド"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,add_sim,Label)"     "SIM Command @Cursorを追加"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,init_sim,Label)"    "コマンドを1つ選択してください"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,preleader,Label)"   "リーダ"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,preleader,Context)" "ユーザ定義プリプロセスコマンドのリーダを指定します。"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,precode,Label)"     "コード"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,precode,Context)"   "ユーザ定義プリプロセスコマンドのリーダを指定します。"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,leader,Label)"      "リーダ"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,leader,Context)"    "ユーザ定義コマンドのリーダを指定します。"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,code,Label)"        "コード"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,code,Context)"      "ユーザ定義コマンドのリーダを指定します。"

::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,add,Context)"       "新規ユーザ定義コマンドを追加"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,add_err,Msg)"       "このトークンは既に処理されました!"
::msgcat::mcset pb_msg_japanese "MC(isv,spec_command,sel_err,Msg)"       "コマンドを選択してください"
::msgcat::mcset pb_msg_japanese "MC(isv,export,error,title)"             "警告"

::msgcat::mcset pb_msg_japanese "MC(isv,tool_table,title,Label)"         "ツールテーブル"
::msgcat::mcset pb_msg_japanese "MC(isv,ex_editor,warning,Msg)"          "これは、システム生成のVNCコマンドです。変更内容は保存されません。"


# - Languages
#
::msgcat::mcset pb_msg_japanese "MC(language,Label)"                     "言語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_english)"                     "英語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_french)"                      "フランス語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_german)"                      "ドイツ語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_italian)"                     "イタリア語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_japanese)"                    "日本語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_korean)"                      "韓国語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_russian)"                     "ロシア語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_simple_chinese)"              "簡体字中国語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_spanish)"                     "スペイン語"
::msgcat::mcset pb_msg_japanese "MC(pb_msg_traditional_chinese)"         "繁体字中国語"

### Exit Options Dialog
::msgcat::mcset pb_msg_japanese "MC(exit,options,Label)"                 "終了オプション"
::msgcat::mcset pb_msg_japanese "MC(exit,options,SaveAll,Label)"         "すべてを保存して終了"
::msgcat::mcset pb_msg_japanese "MC(exit,options,SaveNone,Label)"        "保存せずに終了"
::msgcat::mcset pb_msg_japanese "MC(exit,options,SaveSelect,Label)"      "選択内容を保存して終了"

### OptionMenu Items
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Other)"       "その他"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,None)"        "なし"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,RT_R)"        "早送りトラバースおよびR"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Rapid)"       "早送り"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,RS)"          "早送りスピンドル"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,C_off_RS)"    "サイクルオフしてから早送りスピンドル"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Auto)"        "自動"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Abs_Inc)"     "絶対/増分"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Abs_Only)"    "絶対のみ"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Inc_Only)"    "増分のみ"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,SD)"          "最短距離"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,AP)"          "常に正"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,AN)"          "常に負"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Z_Axis)"      "Z軸"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,+X_Axis)"     "+X軸"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,-X_Axis)"     "- X軸"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,Y_Axis)"      "Y軸"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,MDD)"         "大きさにより方向を決定"
::msgcat::mcset pb_msg_japanese "MC(optionMenu,item,SDD)"         "符号により方向を決定"

