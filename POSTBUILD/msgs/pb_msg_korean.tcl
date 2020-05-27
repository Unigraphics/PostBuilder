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
#       ::msgcat::mcset pb_msg_korean "MC(main,title,Unigraphics)"  "Unigraphics"
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
::msgcat::mcset pb_msg_korean "MC(event,misc,subop_start,name)"      "Subop 경로 시작"
::msgcat::mcset pb_msg_korean "MC(event,misc,subop_end,name)"        "Subop 경로 끝"
::msgcat::mcset pb_msg_korean "MC(event,misc,contour_start,name)"    "윤곽 시작"
::msgcat::mcset pb_msg_korean "MC(event,misc,contour_end,name)"      "윤곽 끝"
::msgcat::mcset pb_msg_korean "MC(prog,tree,misc,Label)"             "기타"
::msgcat::mcset pb_msg_korean "MC(event,cycle,lathe_rough,name)"     "선반 러핑"
::msgcat::mcset pb_msg_korean "MC(main,file,properties,Label)"       "포스트 특성"

::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_CATEGORY)"    "밀링 또는 선반 포스트용 UDE는 \"Wedm\" 카테고리일 때만 지정되지 않을 수 있습니다!"

::msgcat::mcset pb_msg_korean "MC(event,cycle,plane_change,label)"   "작업 평면이 더 낮아지면 이 이벤트 트리거"
::msgcat::mcset pb_msg_korean "MC(format,check_1,error,msg)"         "형식이 수식 값과 맞지 않을 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(format,check_4,error,msg)"         "이 페이지를 나가거나 이 포스트를 저장하기 전에 관련 주소 형식을 변경하십시오!"
::msgcat::mcset pb_msg_korean "MC(format,check_5,error,msg)"         "이 페이지를 나가거나 이 포스트를 저장하기 전에 형식을 수정하십시오!"
::msgcat::mcset pb_msg_korean "MC(format,check_6,error,msg)"         "이 페이지를 입력하기 전에 주소 형식을 변경하십시오!"

::msgcat::mcset pb_msg_korean "MC(msg,old_block,maximum_length)"     "다음 블록 이름은 길이 제한을 초과했습니다."
::msgcat::mcset pb_msg_korean "MC(msg,old_address,maximum_length)"   "다음 워드 이름이 길이 제한을 초과했습니다."
::msgcat::mcset pb_msg_korean "MC(msg,block_address,check,title)"    "블록 및 워드 이름 확인"
::msgcat::mcset pb_msg_korean "MC(msg,block_address,maximum_length)" "블록 또는 워드의 일부 이름이 길이 제한을 초과했습니다."

::msgcat::mcset pb_msg_korean "MC(address,maximum_name_msg)"         "문자열이 길이 제한을 초과했습니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,oth_list,Label)"        "다른 CDL 파일 포함"
::msgcat::mcset pb_msg_korean "MC(ude,import,oth_list,Context)"      "이 포스트와 다른 CDL 파일을 포함하려면 팝업 메뉴(오른쪽 마우스 클릭)에서 \\\"새로 만들기\\\" 옵션을 선택하십시오."
::msgcat::mcset pb_msg_korean "MC(ude,import,ihr_list,Label)"        "포스트에서 UDE 상속"
::msgcat::mcset pb_msg_korean "MC(ude,import,ihr_list,Context)"      "포스트에서 UDE 정의 및 관련 핸들러를 상속하려면 팝업 메뉴(오른쪽 마우스 클릭)에서 \\\"새로 만들기\\\" 옵션을 선택하십시오."
::msgcat::mcset pb_msg_korean "MC(ude,import,up,Label)"              "위로"
::msgcat::mcset pb_msg_korean "MC(ude,import,down,Label)"            "아래로"
::msgcat::mcset pb_msg_korean "MC(msg,exist_cdl_file)"               "지정한 CDL 파일은 이미 포함되어 있습니다!"

::msgcat::mcset pb_msg_korean "MC(listing,link_var,check,Label)"     "Tcl 변수를 C 변수로 링크"
::msgcat::mcset pb_msg_korean "MC(listing,link_var,check,Context)"   "자주 변경된 Tcl 변수 세트(예: \\\"mom_pos\\\")는 포스트프로세스 실행 개선을 위해 내부 C 변수로 직접 링크될 수 있습니다. 하지만, 잠재적 오류 및 NC 출력에서의 차이를 피하기 위해 일부 제한은 준수되어야 합니다."

::msgcat::mcset pb_msg_korean "MC(msg,check_resolution,title)"       "선형/로타리 동작 해상도 확인"
::msgcat::mcset pb_msg_korean "MC(msg,check_resolution,linear)"      "형식 설정이 \"선형 동작 해상도\"를 위한 출력에 맞지 않을 수도 있습니다."
::msgcat::mcset pb_msg_korean "MC(msg,check_resolution,rotary)"      "형식 설정이 \"로타리 동작 해상도\"를 위한 출력에 맞지 않을 수도 있습니다."

::msgcat::mcset pb_msg_korean "MC(cmd,export,desc,label)"            "내보낸 사용자 정의 명령에 대한 설명 입력"
::msgcat::mcset pb_msg_korean "MC(cmd,desc_dlg,title)"               "설명"
::msgcat::mcset pb_msg_korean "MC(block,delete_row,Label)"           "이 행의 모든 활성 요소 삭제"
::msgcat::mcset pb_msg_korean "MC(block,exec_cond,set,Label)"        "출력 조건"
::msgcat::mcset pb_msg_korean "MC(block,exec_cond,new,Label)"        "새로 만들기..."
::msgcat::mcset pb_msg_korean "MC(block,exec_cond,edit,Label)"       "편집..."
::msgcat::mcset pb_msg_korean "MC(block,exec_cond,remove,Label)"     "제거..."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,name_msg_for_cond)"       "다른 이름을 지정하십시오.  \n출력 조건 명령 앞에 다음이 붙어야 합니다."

::msgcat::mcset pb_msg_korean "MC(machine,linearization,Label)"         "선형화 보간"
::msgcat::mcset pb_msg_korean "MC(machine,linearization,angle,Label)"   "로타리 각도"
::msgcat::mcset pb_msg_korean "MC(machine,linearization,angle,Context)" "보간 점은 로타리 축의 시작과 끝 각도의 분포를 기본으로 계산됩니다."
::msgcat::mcset pb_msg_korean "MC(machine,linearization,axis,Label)"    "공구 축"
::msgcat::mcset pb_msg_korean "MC(machine,linearization,axis,Context)"  "보간 점은 공구 축의 시작과 끝 벡터의 분포를 기본으로 계산됩니다."
::msgcat::mcset pb_msg_korean "MC(machine,resolution,continue,Label)"   "계속"
::msgcat::mcset pb_msg_korean "MC(machine,resolution,abort,Label)"      "중단"

::msgcat::mcset pb_msg_korean "MC(machine,axis,def_lintol,Label)"       "기본 공차"
::msgcat::mcset pb_msg_korean "MC(machine,axis,def_lintol,Context)"     "기본 선형화 공차"
::msgcat::mcset pb_msg_korean "MC(sub_post,inch,Lable)"                 " IN"
::msgcat::mcset pb_msg_korean "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_korean "MC(new_sub,title,Label)"                 "새 종속 포스트 프로세서 생성"
::msgcat::mcset pb_msg_korean "MC(new,sub_post,toggle,label)"           "종속 포스트"
::msgcat::mcset pb_msg_korean "MC(new,sub_post,toggle,tmp_label)"       "Subpost 전용 단위"
::msgcat::mcset pb_msg_korean "MC(new,unit_post,filename,msg)"          "출력 단위를 교체하기 위한 새 종속 포스트는 \n메인 포스트 이름 뒤에 \"__MM\" 또는 \"__IN\"을 붙여야 합니다."
::msgcat::mcset pb_msg_korean "MC(new,alter_unit,toggle,label)"         "교체 출력 단위"
::msgcat::mcset pb_msg_korean "MC(new,main_post,label)"                 "메인 포스트"
::msgcat::mcset pb_msg_korean "MC(new,main_post,warning_1,msg)"         "새 종속 포스트를 생성하려면 완료된 메인 포스트만 사용할 수 있습니다!"
::msgcat::mcset pb_msg_korean "MC(new,main_post,warning_2,msg)"         "메인 포스트는\nPost Builder 8.0 이상 버전에서 생성되거나 저장되어야 합니다."
::msgcat::mcset pb_msg_korean "MC(new,main_post,specify_err,msg)"       "메인 포스트는 종속 포스트 생성을 위해 지정되어야 합니다!"
::msgcat::mcset pb_msg_korean "MC(machine,gen,alter_unit,Label)"        "Subpost 출력 단위:"
::msgcat::mcset pb_msg_korean "MC(unit_related_param,tab,Label)"        "단위 매개변수"
::msgcat::mcset pb_msg_korean "MC(unit_related_param,feed_rate,Label)"  "이송률"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,frame,Label)"        "선택적 교체 단위 종속 포스트"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,default,Label)"      "기본값"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,default,Context)"    "교체 단위 종속 포스트의 기본 이름은 <post name>__MM 또는 <post name>__IN입니다."
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,specify,Label)"      "지정"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,specify,Context)"    "교체 단위 종속 포스트 이름 지정"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,select_name,Label)"  "이름 선택"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,warning_1,msg)"      "교체 단위 종속 포스트만 선택할 수 있습니다!"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,warning_2,msg)"      "선택한 종속 포스트가 이 포스트를 위한 교체 출력 단위를 지원하지 않을 수 있습니다!"

::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,post_name,Label)"    "교체 단위 종속 포스트"
::msgcat::mcset pb_msg_korean "MC(listing,alt_unit,post_name,Context)"  "NX Post는 이 포스트를 위한 교체 출력 단위를 처리하기 위해 지원되는 경우 단위 종속 포스트를 사용합니다."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,user,evt_title)"  "축 한계 위반에 대해 사용자가 정의한 조치"
::msgcat::mcset pb_msg_korean "MC(event,helix,name)"                       "나선 이동"
::msgcat::mcset pb_msg_korean "MC(event,circular,ijk_param,prefix,msg)"    "주소에 사용된 수식"
::msgcat::mcset pb_msg_korean "MC(event,circular,ijk_param,postfix,msg)"   "은(는) 이 옵션을 변경해도 영향을 받지 않습니다!"
::msgcat::mcset pb_msg_korean "MC(isv,spec_codelist,default,msg)"          "이 작업은 특수  NC 코드 리스트와\n 핸들러를 이 포스트가 열리거나 생성됐을 때의 상태로 복원합니다.\n\n 계속하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(isv,spec_codelist,restore,msg)"          "이 작업은 특수  NC 코드 리스트와\n 핸들러를 이 페이지를 마지막 방문했을 때의 상태로 복원합니다.\n\n 계속하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(msg,block_format_command,paste_err)"     "개체 이름이 존재합니다...  붙여넣기 오류!"
::msgcat::mcset pb_msg_korean "MC(main,file,open,choose_cntl_type)"        "컨트롤러  패밀리 선택"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,no_vnc_cmd,msg)"         "이 파일에는 새로운 또는 다른 VNC 명령이 포함되어 있지 않습니다!"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,no_cmd,msg)"             "이 파일에는 새로운 또는 다른 사용자 정의 명령이 포함되어 있지 않습니다!"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,name_same_err,Msg)"        "툴 이름은 달라야 합니다! "
::msgcat::mcset pb_msg_korean "MC(msg,limit_to_change_license)"            "이 포스트의 작성자가 아닙니다.\n이름을 변경하거나 라이센스를 변경할 권한이 없습니다."
::msgcat::mcset pb_msg_korean "MC(output,other_opts,validation,msg)"       "사용자 TCL 파일 이름을 지정해야 합니다. "
::msgcat::mcset pb_msg_korean "MC(machine,empty_entry_err,msg)"            "이 매개변수 페이지에 빈  항목이 있습니다."
::msgcat::mcset pb_msg_korean "MC(msg,control_v_limit)"                    "붙여넣기하려는 문자열이\n제한된 길이를 초과하거나\n  여러 행 또는 잘못된 문자를 포함하고 있습니다."
::msgcat::mcset pb_msg_korean "MC(block,capital_name_msg)"                 "블록 이름의 시작 문자는 대문자일 수 없습니다!\n 다른 이름을 지정하십시오. "
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,user,Label)"      "사용자 정의"
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,user,Handler)"    "핸들러"
::msgcat::mcset pb_msg_korean "MC(new,user,file,NOT_EXIST)"                "이 사용자 파일은 존재하지 않습니다! "
::msgcat::mcset pb_msg_korean "MC(new,include_vnc,Label)"                  "가상 NC 컨트롤러 포함"
::msgcat::mcset pb_msg_korean "MC(other,opt_equal,Label)"                  "등호 부호 (=)"
::msgcat::mcset pb_msg_korean "MC(event,nurbs,name)"                       "NURBS 이동"
::msgcat::mcset pb_msg_korean "MC(event,cycle,tap_float,name)"             "탭 유동"
::msgcat::mcset pb_msg_korean "MC(event,cycle,thread,name)"                "스레드"
::msgcat::mcset pb_msg_korean "MC(ude,editor,group,MSG_NESTED_GROUP)"      "중첩된 그룹은 지원되지 않습니다!"
::msgcat::mcset pb_msg_korean "MC(ude,editor,bmp,Label)"                   "비트맵"
::msgcat::mcset pb_msg_korean "MC(ude,editor,bmp,Context)"                 "새 비트맵 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,group,Label)"                 "그룹"
::msgcat::mcset pb_msg_korean "MC(ude,editor,group,Context)"               "새 그룹 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,DESC,Label)"         "설명"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,DESC,Context)"       "이벤트 정보 지정"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,URL,Context)"        "이벤트 설명에 대한 URL 지정 "
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "이미지 파일은 BMP 형식이어야 합니다!"
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "비트맵 파일 이름에 디렉토리 경로를 포함할 수 없습니다! "
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "변수 이름은 문자로 시작해야 합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "변수 이름에 키워드를 사용할 수 없습니다: "
::msgcat::mcset pb_msg_korean "MC(ude,editor,status_label)"                "상태"
::msgcat::mcset pb_msg_korean "MC(ude,editor,vector,Label)"                "벡터"
::msgcat::mcset pb_msg_korean "MC(ude,editor,vector,Context)"              "새 벡터 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL은 \"http://*\" 또는 \"file://*\" 형식이어야 하고 백슬래시를 사용하면 안됩니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "설명 및  URL을 지정해야 합니다! "
::msgcat::mcset pb_msg_korean "MC(new,MSG_NO_AXIS)"                        "축 구성은 기계 공구에 맞게 선택해야 합니다."
::msgcat::mcset pb_msg_korean "MC(machine,info,controller_type,Label)"     "컨트롤러  패밀리"
::msgcat::mcset pb_msg_korean "MC(block,func_combo,Label)"                 "매크로"
::msgcat::mcset pb_msg_korean "MC(block,prefix_popup,add,Label)"           "접두어 텍스트 추가"
::msgcat::mcset pb_msg_korean "MC(block,prefix_popup,edit,Label)"          "접두어 텍스트 편집"
::msgcat::mcset pb_msg_korean "MC(block,prefix,Label)"                     "접두어"
::msgcat::mcset pb_msg_korean "MC(block,suppress_popup,Label)"             "억제  순서 번호"
::msgcat::mcset pb_msg_korean "MC(block,custom_func,Label)"                "사용자 정의  매크로"
::msgcat::mcset pb_msg_korean "MC(seq,combo,macro,Label)"                  "사용자 정의  매크로"
::msgcat::mcset pb_msg_korean "MC(func,tab,Label)"                         "매크로"
::msgcat::mcset pb_msg_korean "MC(func,exp,msg)"                           "매크로 매개변수 수식은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(func,edit,name,Label)"                   "매크로  이름"
::msgcat::mcset pb_msg_korean "MC(func,disp_name,Label)"                   "출력 이름"
::msgcat::mcset pb_msg_korean "MC(func,param_list,Label)"                  "매개변수 리스트"
::msgcat::mcset pb_msg_korean "MC(func,separator,Label)"                   "분리자"
::msgcat::mcset pb_msg_korean "MC(func,start,Label)"                       "시작  문자"
::msgcat::mcset pb_msg_korean "MC(func,end,Label)"                         "끝  문자"
::msgcat::mcset pb_msg_korean "MC(func,output,name,Label)"                 "출력 속성"
::msgcat::mcset pb_msg_korean "MC(func,output,check,Label)"                "출력  매개변수 이름"
::msgcat::mcset pb_msg_korean "MC(func,output,link,Label)"                 "링크  문자"
::msgcat::mcset pb_msg_korean "MC(func,col_param,Label)"                   "매개변수"
::msgcat::mcset pb_msg_korean "MC(func,col_exp,Label)"                     "수식"
::msgcat::mcset pb_msg_korean "MC(func,popup,insert,Label)"                "새로 만들기"
::msgcat::mcset pb_msg_korean "MC(func,name,err_msg)"                      "매크로 이름에 공백을 포함할 수 없습니다!"
::msgcat::mcset pb_msg_korean "MC(func,name,blank_err)"                    "매크로 이름은 비워둘 수 없습니다!"
::msgcat::mcset pb_msg_korean "MC(func,name,contain_err)"                  "매크로 이름은 알파벳, 숫자, 밑줄 문자만 포함할 수 있습니다! "
::msgcat::mcset pb_msg_korean "MC(func,tree_node,start_err)"               "노드 이름은 대문자로 시작해야 합니다!"
::msgcat::mcset pb_msg_korean "MC(func,tree_node,contain_err)"             "노드 이름에는 알파벳, 숫자, 밑줄 문자만 사용할 수 있습니다!"
::msgcat::mcset pb_msg_korean "MC(func,help,Label)"                        "정보"
::msgcat::mcset pb_msg_korean "MC(func,help,Context)"                      "개체 정보 표시."
::msgcat::mcset pb_msg_korean "MC(func,help,MSG_NO_INFO)"                  "이 매크로에 대한 정보가 없습니다."


##------
## Title
##
::msgcat::mcset pb_msg_korean "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_korean "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_korean "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset pb_msg_korean "MC(main,title,Version)"                 "버전"
::msgcat::mcset pb_msg_korean "MC(main,default,Status)"                "파일 메뉴에서 \[새로 만들기\] 또는 \[열기\]를 선택합니다."
::msgcat::mcset pb_msg_korean "MC(main,save,Status)"                   "포스트를 저장합니다."

##------
## File
##
::msgcat::mcset pb_msg_korean "MC(main,file,Label)"                    "파일"

::msgcat::mcset pb_msg_korean "MC(main,file,Balloon)"                  "\ 새로 만들기, 열기, 저장,\n 다른 이름으로\ 저장, 닫기 및 종료"

::msgcat::mcset pb_msg_korean "MC(main,file,Context)"                  "\ 새로 만들기, 열기, 저장,\n 다른 이름으로\ 저장, 닫기 및 종료"
::msgcat::mcset pb_msg_korean "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_korean "MC(main,file,new,Label)"                "새로 만들기 ..."
::msgcat::mcset pb_msg_korean "MC(main,file,new,Balloon)"              "새 포스트를 생성합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,new,Context)"              "새 포스트를 생성합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,new,Busy)"                 "새 포스트를 생성합니다..."

::msgcat::mcset pb_msg_korean "MC(main,file,open,Label)"               "열기 ..."
::msgcat::mcset pb_msg_korean "MC(main,file,open,Balloon)"             "기존 포스트를 편집합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,open,Context)"             "기존 포스트를 편집합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,open,Busy)"                "포스트를 엽니다..."

::msgcat::mcset pb_msg_korean "MC(main,file,mdfa,Label)"               "MDFA 가져오기..."
::msgcat::mcset pb_msg_korean "MC(main,file,mdfa,Balloon)"             "MDFA에서 새 포스트를 생성합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,mdfa,Context)"             "MDFA에서 새 포스트를 생성합니다."

::msgcat::mcset pb_msg_korean "MC(main,file,save,Label)"               "저장"
::msgcat::mcset pb_msg_korean "MC(main,file,save,Balloon)"             "현재 포스트를 저장합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,save,Context)"             "현재 포스트를 저장합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,save,Busy)"                "포스트를 저장합니다..."

::msgcat::mcset pb_msg_korean "MC(main,file,save_as,Label)"            "다른 이름으로 저장 ..."
::msgcat::mcset pb_msg_korean "MC(main,file,save_as,Balloon)"          "새 이름으로 포스트를 저장합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,save_as,Context)"          "새 이름으로 포스트를 저장합니다."

::msgcat::mcset pb_msg_korean "MC(main,file,close,Label)"              "닫기"
::msgcat::mcset pb_msg_korean "MC(main,file,close,Balloon)"            "현재 포스트를 닫습니다."
::msgcat::mcset pb_msg_korean "MC(main,file,close,Context)"            "현재 포스트를 닫습니다."

::msgcat::mcset pb_msg_korean "MC(main,file,exit,Label)"               "종료"
::msgcat::mcset pb_msg_korean "MC(main,file,exit,Balloon)"             "Post Builder를 종료합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,exit,Context)"             "Post Builder를 종료합니다."

::msgcat::mcset pb_msg_korean "MC(main,file,history,Label)"            "최근에 연 포스트"
::msgcat::mcset pb_msg_korean "MC(main,file,history,Balloon)"          "앞서 방문한 포스트를 편집합니다."
::msgcat::mcset pb_msg_korean "MC(main,file,history,Context)"          "이전 Post Builder 세션에서 방문한 포스트를 편집합니다."

##---------
## Options
##
::msgcat::mcset pb_msg_korean "MC(main,options,Label)"                 "옵션"

::msgcat::mcset pb_msg_korean "MC(main,options,Balloon)"               " 사용자 정의\ 명령\ 검증, 포스트\ 백업을 수행합니다."
::msgcat::mcset pb_msg_korean "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_korean "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_korean "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_korean "MC(main,windows,Balloon)"               "포스트 리스트 편집"
::msgcat::mcset pb_msg_korean "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_korean "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_korean "MC(main,options,properties,Label)"      "특성"
::msgcat::mcset pb_msg_korean "MC(main,options,properties,Balloon)"    "특성"
::msgcat::mcset pb_msg_korean "MC(main,options,properties,Context)"    "특성"

::msgcat::mcset pb_msg_korean "MC(main,options,advisor,Label)"         "포스트 어드바이저"
::msgcat::mcset pb_msg_korean "MC(main,options,advisor,Balloon)"       "포스트 어드바이저"
::msgcat::mcset pb_msg_korean "MC(main,options,advisor,Context)"       "포스트 어드바이저를 활성화/비활성화합니다."

::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,Label)"       "사용자 정의 명령 검증"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,Balloon)"     "사용자 정의 명령 검증"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,Context)"     "사용자 정의 명령 검증 스위치입니다."

::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,syntax,Label)"   "구문 오류"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,command,Label)"  "알 수 없는 명령"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,block,Label)"    "알 수 없는 블록"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,address,Label)"  "알 수 없는 주소"
::msgcat::mcset pb_msg_korean "MC(main,options,cmd_check,format,Label)"   "알 수 없는 형식"

::msgcat::mcset pb_msg_korean "MC(main,options,backup,Label)"          "포스트 백업"
::msgcat::mcset pb_msg_korean "MC(main,options,backup,Balloon)"        "포스트 백업 방법"
::msgcat::mcset pb_msg_korean "MC(main,options,backup,Context)"        "현재 포스트를 저장하는 동안 백업 사본을 생성합니다."

::msgcat::mcset pb_msg_korean "MC(main,options,backup,one,Label)"      "원본 백업"
::msgcat::mcset pb_msg_korean "MC(main,options,backup,all,Label)"      "저장할 때마다 백업"
::msgcat::mcset pb_msg_korean "MC(main,options,backup,none,Label)"     "백업하지 않음"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_korean "MC(main,utils,Label)"                   "유틸리티"
::msgcat::mcset pb_msg_korean "MC(main,utils,Balloon)"                 "\ MOM\ 변수\ 선택, 포스트\ 설치"
::msgcat::mcset pb_msg_korean "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_korean "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_korean "MC(main,utils,etpdf,Label)"             "템플릿 포스트 데이터 파일 편집"

::msgcat::mcset pb_msg_korean "MC(main,utils,bmv,Label)"               "MOM 변수 찾아보기"
::msgcat::mcset pb_msg_korean "MC(main,utils,blic,Label)"              "라이센스 찾아보기"


##------
## Help
##
::msgcat::mcset pb_msg_korean "MC(main,help,Label)"                    "도움말"
::msgcat::mcset pb_msg_korean "MC(main,help,Balloon)"                  "도움말 옵션"
::msgcat::mcset pb_msg_korean "MC(main,help,Context)"                  "도움말 옵션"
::msgcat::mcset pb_msg_korean "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_korean "MC(main,help,bal,Label)"                "풍선도움말 팁"
::msgcat::mcset pb_msg_korean "MC(main,help,bal,Balloon)"              "아이콘 풍선 도움말 팁"
::msgcat::mcset pb_msg_korean "MC(main,help,bal,Context)"              "아이콘에 풍선도움말 팁을 표시할지 여부를 설정합니다."

::msgcat::mcset pb_msg_korean "MC(main,help,chelp,Label)"              "컨텍스트 감지 도움말"
::msgcat::mcset pb_msg_korean "MC(main,help,chelp,Balloon)"            "다이얼로그 아이템 컨텍스트 감지 도움말"
::msgcat::mcset pb_msg_korean "MC(main,help,chelp,Context)"            "다이얼로그 아이템 컨텍스트 감지 도움말"

::msgcat::mcset pb_msg_korean "MC(main,help,what,Label)"               "할 수 있는 작업"
::msgcat::mcset pb_msg_korean "MC(main,help,what,Balloon)"             "여기서 수행할 수 있는 작업"
::msgcat::mcset pb_msg_korean "MC(main,help,what,Context)"             "여기서 수행할 수 있는 작업"

::msgcat::mcset pb_msg_korean "MC(main,help,dialog,Label)"             "다이얼로그 도움말"
::msgcat::mcset pb_msg_korean "MC(main,help,dialog,Balloon)"           "다이얼로그 도움말"
::msgcat::mcset pb_msg_korean "MC(main,help,dialog,Context)"           "다이얼로그 도움말"

::msgcat::mcset pb_msg_korean "MC(main,help,manual,Label)"             "사용자 매뉴얼"
::msgcat::mcset pb_msg_korean "MC(main,help,manual,Balloon)"           "사용자 도움말 매뉴얼"
::msgcat::mcset pb_msg_korean "MC(main,help,manual,Context)"           "사용자 도움말 매뉴얼"

::msgcat::mcset pb_msg_korean "MC(main,help,about,Label)"              "Post Builder 정보"
::msgcat::mcset pb_msg_korean "MC(main,help,about,Balloon)"            "Post Builder 정보"
::msgcat::mcset pb_msg_korean "MC(main,help,about,Context)"            "Post Builder 정보"

::msgcat::mcset pb_msg_korean "MC(main,help,rel_note,Label)"           "릴리스 노트"
::msgcat::mcset pb_msg_korean "MC(main,help,rel_note,Balloon)"         "릴리스 노트"
::msgcat::mcset pb_msg_korean "MC(main,help,rel_note,Context)"         "릴리스 노트"

::msgcat::mcset pb_msg_korean "MC(main,help,tcl_man,Label)"            "Tcl/Tk 참조 매뉴얼"
::msgcat::mcset pb_msg_korean "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk 참조 매뉴얼"
::msgcat::mcset pb_msg_korean "MC(main,help,tcl_man,Context)"          "Tcl/Tk 참조 매뉴얼"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_korean "MC(tool,new,Label)"                     "새로 만들기"
::msgcat::mcset pb_msg_korean "MC(tool,new,Context)"                   "새 포스트를 생성합니다."

::msgcat::mcset pb_msg_korean "MC(tool,open,Label)"                    "열기"
::msgcat::mcset pb_msg_korean "MC(tool,open,Context)"                  "기존 포스트를 편집합니다."

::msgcat::mcset pb_msg_korean "MC(tool,save,Label)"                    "저장"
::msgcat::mcset pb_msg_korean "MC(tool,save,Context)"                  "현재 포스트를 저장합니다."

::msgcat::mcset pb_msg_korean "MC(tool,bal,Label)"                     "풍선도움말 팁"
::msgcat::mcset pb_msg_korean "MC(tool,bal,Context)"                   "아이콘에 풍선도움말 팁을 표시할지 여부를 설정합니다."

::msgcat::mcset pb_msg_korean "MC(tool,chelp,Label)"                   "컨텍스트 감지 도움말"
::msgcat::mcset pb_msg_korean "MC(tool,chelp,Context)"                 "다이얼로그 아이템 컨텍스트 감지 도움말"

::msgcat::mcset pb_msg_korean "MC(tool,what,Label)"                    "할 수 있는 작업"
::msgcat::mcset pb_msg_korean "MC(tool,what,Context)"                  "여기서 수행할 수 있는 작업"

::msgcat::mcset pb_msg_korean "MC(tool,dialog,Label)"                  "다이얼로그 도움말"
::msgcat::mcset pb_msg_korean "MC(tool,dialog,Context)"                "다이얼로그 도움말"

::msgcat::mcset pb_msg_korean "MC(tool,manual,Label)"                  "사용자 매뉴얼"
::msgcat::mcset pb_msg_korean "MC(tool,manual,Context)"                "사용자 도움말 매뉴얼"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_korean "MC(msg,error,title)"                    "Post Builder 오류"
::msgcat::mcset pb_msg_korean "MC(msg,dialog,title)"                   "Post Builder 메시지"
::msgcat::mcset pb_msg_korean "MC(msg,warning)"                        "경고"
::msgcat::mcset pb_msg_korean "MC(msg,error)"                          "오류"
::msgcat::mcset pb_msg_korean "MC(msg,invalid_data)"                   "입력한 매개변수 값이 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_browser_cmd)"            "브라우저 명령이 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,wrong_filename)"                 "파일 이름이 변경되었습니다."
::msgcat::mcset pb_msg_korean "MC(msg,user_ctrl_limit)"                "작성자가 아니면 라이센스를 받은 포스트를 컨트롤러로\n 사용하여 새 포스트를 생성할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,import_limit)"                   "이 라이센스를 받은 포스트의 작성자가 아닙니다.\n 사용자 정의 명령을 가져오기할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,limit_msg)"                      "이 라이센스를 받은 포스트의 작성자가 아닙니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_file)"                        "이 라이센스를 받은 포스트에 암호화된 파일이 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_license)"                     "이 기능을 수행할 라이센스가 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_license_title)"               "NX/Post Builder 라이센스 없이 사용"
::msgcat::mcset pb_msg_korean "MC(msg,no_license_dialog)"              "라이센스 없이 NX/Post Builder를 사용해도 좋습니다.\n하지만 라이센스 없이는 작업을 저장할 수 없습니다.\n"
::msgcat::mcset pb_msg_korean "MC(msg,pending)"                        "이 옵션과 관련한 기능은 나중 릴리스에서 제공합니다."
::msgcat::mcset pb_msg_korean "MC(msg,save)"                           "현재 포스트를 닫기 전에 \n 변경 사항을 저장하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(msg,version_check)"                  "새 버전의 Post Builder로 생성한 포스트는 이 버전에서 열 수 없습니다."

::msgcat::mcset pb_msg_korean "MC(msg,file_corruption)"                "Post Builder 세션 파일의 내용이 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,bad_tcl_file)"                   "포스트의 TCL 파일 내용이 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,bad_def_file)"                   "포스트의 정의 파일 내용이 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_post)"                   "포스트에 TCL 파일과 정의 파일을 적어도 한 세트는 정의해야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_dir)"                    "디렉토리가 존재하지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_file)"                   "파일이 없거나 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_def_file)"               "정의 파일을 열 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,invalid_tcl_file)"               "이벤트 핸들러 파일을 열 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,dir_perm)"                       "다음 디렉토리에 쓰기 권한이 없습니다:"
::msgcat::mcset pb_msg_korean "MC(msg,file_perm)"                      "다음 위치에 쓰기 권한이 없습니다:"

::msgcat::mcset pb_msg_korean "MC(msg,file_exist)"                     "이(가) 이미 존재합니다! \n교체하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(msg,file_missing)"                   "포스트 파일 일부 또는 전부가 없습니다.\n 포스트를 열 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,sub_dialog_open)"                "포스트를 저장하려면 매개변수 하위 다이얼로그를 모두 편집하고 마쳐야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,generic)"                        "현재 Post Builder는 일반 밀링 기계에 대해서만 구현되었습니다."
::msgcat::mcset pb_msg_korean "MC(msg,min_word)"                       "블록은 워드를 적어도 하나는 포함해야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,name_exists)"                    "이(가) 이미 존재합니다.\n 다른 이름을 지정하십시오."
::msgcat::mcset pb_msg_korean "MC(msg,in_use)"                         "컴포넌트가 사용 중입니다. \n 삭제할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,do_you_want_to_proceed)"         "기존 데이터 요소로 가정한 후 계속하십시오."
::msgcat::mcset pb_msg_korean "MC(msg,not_installed_properly)"         "이(가) 올바로 설치되지 않았습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_app_to_open)"                 "열 응용 프로그램이 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,save_change)"                    "변경 사항을 저장하시겠습니까?"

::msgcat::mcset pb_msg_korean "MC(msg,external_editor)"                "외부 편집기"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_korean "MC(msg,set_ext_editor)"                 "선호하는 텍스트 편집기를 사용하려면 환경 변수 EDITOR를 설정하십시오."
::msgcat::mcset pb_msg_korean "MC(msg,filename_with_space)"            "파일 이름은 공백을 포함할 수 없습니다!"
::msgcat::mcset pb_msg_korean "MC(msg,filename_protection)"            "선택한 파일을 덮어쓸 수 없습니다. 편집 중인 포스트에서 파일을 사용합니다."


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_korean "MC(msg,parent_win)"                     "임시 윈도우를 사용하려면 부모 윈도우가 있어야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,close_subwin)"                   "이 탭을 사용하려면 모든 하위 윈도우를 닫아야 합니다. "
::msgcat::mcset pb_msg_korean "MC(msg,block_exist)"                    "선택한 워드의 요소는 블록 템플릿에 있습니다."
::msgcat::mcset pb_msg_korean "MC(msg,num_gcode_1)"                    "G 코드 개수는 다음으로 제한되어 있습니다:"
::msgcat::mcset pb_msg_korean "MC(msg,num_gcode_2)"                    "/ 블록"
::msgcat::mcset pb_msg_korean "MC(msg,num_mcode_1)"                    "M 코드 개수는 다음으로 제한되어 있습니다:"
::msgcat::mcset pb_msg_korean "MC(msg,num_mcode_2)"                    "/ 블록"
::msgcat::mcset pb_msg_korean "MC(msg,empty_entry)"                    "항목을 비워둘 수 없습니다."

::msgcat::mcset pb_msg_korean "MC(msg,edit_feed_fmt)"                  "주소 \"F\"의 형식은 이송률 매개변수 페이지에서 편집할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(msg,seq_num_max)"                    "순서 번호 최대값은 주소 N의 용량을 초과할 수 없습니다. 주소 N의 용량:"

::msgcat::mcset pb_msg_korean "MC(msg,no_cdl_name)"                    "포스트 이름을 지정해야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_def_name)"                    "폴더를 지정해야 합니다!\n 또한 패턴은 다음과 같아야 합니다: \"\$UGII_*\"!"
::msgcat::mcset pb_msg_korean "MC(msg,no_own_name)"                    "폴더를 지정해야 합니다!\n 또한 패턴은 다음과 같아야 합니다: \"\$UGII_*\"!"
::msgcat::mcset pb_msg_korean "MC(msg,no_oth_ude_name)"                "다른 CDL 파일 이름을 지정하십시오!\n 또한 패턴은 다음과 같아야 합니다: \"\$UGII_*\"!"
::msgcat::mcset pb_msg_korean "MC(msg,not_oth_cdl_file)"               "CDL 파일만 허용됩니다!"
::msgcat::mcset pb_msg_korean "MC(msg,not_pui_file)"                   "PUI 파일만 허용됩니다!"
::msgcat::mcset pb_msg_korean "MC(msg,not_cdl_file)"                   "CDL 파일만 허용됩니다!"
::msgcat::mcset pb_msg_korean "MC(msg,not_def_file)"                   "DEF 파일만 허용됩니다!"
::msgcat::mcset pb_msg_korean "MC(msg,not_own_cdl_file)"               "자신의 CDL 파일만 허용됩니다!"
::msgcat::mcset pb_msg_korean "MC(msg,no_cdl_file)"                    "선택한 포스트는 연관된 CDL 파일이 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,cdl_info)"                       "선택한 포스트의 CDL 파일과 정의 파일을 이 포스트 정의 파일에서 참조(INCLUDE)합니다.\n 선택한 포스트의 TCL 파일은 이 포스트의 이벤트 파일에서 런타임으로 참조합니다."

::msgcat::mcset pb_msg_korean "MC(msg,add_max1)"                       "주소 최대 값"
::msgcat::mcset pb_msg_korean "MC(msg,add_max2)"                       "은(는) 형식 한계를 초과할 수 없습니다. 형식 한계:"


::msgcat::mcset pb_msg_korean "MC(com,text_entry_trans,title,Label)"   "항목"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_korean "MC(nav_button,no_license,Message)"      "이 기능을 수행할 라이센스가 없습니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,ok,Label)"                "확인"
::msgcat::mcset pb_msg_korean "MC(nav_button,ok,Context)"              "이 버튼은 하위 다이얼로그에서만 사용할 수 있습니다. 변경을 저장하고 다이얼로그를 닫는 버튼입니다."
::msgcat::mcset pb_msg_korean "MC(nav_button,cancel,Label)"            "취소"
::msgcat::mcset pb_msg_korean "MC(nav_button,cancel,Context)"          "이 버튼은 하위 다이얼로그에서만 사용할 수 있습니다. 다이얼로그를 닫는 버튼입니다."
::msgcat::mcset pb_msg_korean "MC(nav_button,default,Label)"           "기본값"
::msgcat::mcset pb_msg_korean "MC(nav_button,default,Context)"         "현재 다이얼로그의 매개변수 값을 기본값으로 복원합니다. 컴포넌트는 세션에서 포스트를 처음 생성했거나 열었던 상태로 되돌아갑니다. \n \n그러나 컴포넌트 이름은 가장 최근에 컴포넌트를 열었던 초기 상태로만 복원됩니다."
::msgcat::mcset pb_msg_korean "MC(nav_button,restore,Label)"           "복원"
::msgcat::mcset pb_msg_korean "MC(nav_button,restore,Context)"         "현재 다이얼로그의 매개변수 값을 가장 최근에 컴포넌트를 열었던 초기 상태로 되돌립니다."
::msgcat::mcset pb_msg_korean "MC(nav_button,apply,Label)"             "적용"
::msgcat::mcset pb_msg_korean "MC(nav_button,apply,Context)"           "현재 다이얼로그를 닫지 않고 변경 값을 저장합니다. 적용한 매개변수 값은 현재 다이얼로그의 초기 상태가 됩니다. \n \n(초기 상태는 \[복원\]에서 사용합니다.)"
::msgcat::mcset pb_msg_korean "MC(nav_button,filter,Label)"            "필터"
::msgcat::mcset pb_msg_korean "MC(nav_button,filter,Context)"          "필터를 적용하여 조건에 만족하는 파일을 표시합니다."
::msgcat::mcset pb_msg_korean "MC(nav_button,yes,Label)"               "예"
::msgcat::mcset pb_msg_korean "MC(nav_button,yes,Context)"             "예"
::msgcat::mcset pb_msg_korean "MC(nav_button,no,Label)"                "아니오"
::msgcat::mcset pb_msg_korean "MC(nav_button,no,Context)"              "아니오"
::msgcat::mcset pb_msg_korean "MC(nav_button,help,Label)"              "도움말"
::msgcat::mcset pb_msg_korean "MC(nav_button,help,Context)"            "도움말"

::msgcat::mcset pb_msg_korean "MC(nav_button,open,Label)"              "열기"
::msgcat::mcset pb_msg_korean "MC(nav_button,open,Context)"            "선택한 포스트를 엽니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,save,Label)"              "저장"
::msgcat::mcset pb_msg_korean "MC(nav_button,save,Context)"            "현재 포스트를 저장합니다. 버튼은 '다른 이름으로 저장' 다이얼로그에 있습니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,manage,Label)"            "관리 ..."
::msgcat::mcset pb_msg_korean "MC(nav_button,manage,Context)"          "최근 방문한 포스트의 히스토리를 관리합니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,refresh,Label)"           "새로 고침"
::msgcat::mcset pb_msg_korean "MC(nav_button,refresh,Context)"         "리스트를 갱신하여 개체의 최신 상태를 확인합니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,cut,Label)"               "잘라내기"
::msgcat::mcset pb_msg_korean "MC(nav_button,cut,Context)"             "리스트에서 선택한 개체를 잘라냅니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,copy,Label)"              "복사"
::msgcat::mcset pb_msg_korean "MC(nav_button,copy,Context)"            "선택한 개체를 복사합니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,paste,Label)"             "붙여넣기"
::msgcat::mcset pb_msg_korean "MC(nav_button,paste,Context)"           "버퍼에 있는 개체를 리스트로 붙여넣습니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,edit,Label)"              "편집"
::msgcat::mcset pb_msg_korean "MC(nav_button,edit,Context)"            "버퍼에 있는 개체를 편집합니다."

::msgcat::mcset pb_msg_korean "MC(nav_button,ex_editor,Label)"         "외부 편집기 사용"

##------------
## New dialog
##
::msgcat::mcset pb_msg_korean "MC(new,title,Label)"                    "새 포스트 프로세서 생성"
::msgcat::mcset pb_msg_korean "MC(new,Status)"                         "새 포트트의 이름을 입력한 후 매개변수를 선택하십시오."

::msgcat::mcset pb_msg_korean "MC(new,name,Label)"                     "포스트 이름"
::msgcat::mcset pb_msg_korean "MC(new,name,Context)"                   "생성할 포스트 프로세서 이름"

::msgcat::mcset pb_msg_korean "MC(new,desc,Label)"                     "설명"
::msgcat::mcset pb_msg_korean "MC(new,desc,Context)"                   "생성할 포스트 프로세서 설명"

#Description for each selection
::msgcat::mcset pb_msg_korean "MC(new,mill,desc,Label)"                "밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,lathe,desc,Label)"               "선반 기계"
::msgcat::mcset pb_msg_korean "MC(new,wedm,desc,Label)"                "와이어 EDM 기계"

::msgcat::mcset pb_msg_korean "MC(new,wedm_2,desc,Label)"              "2축 와이어 EDM 기계"
::msgcat::mcset pb_msg_korean "MC(new,wedm_4,desc,Label)"              "4축 와이어 EDM 기계"
::msgcat::mcset pb_msg_korean "MC(new,lathe_2,desc,Label)"             "2축 수평 선반 기계"
::msgcat::mcset pb_msg_korean "MC(new,lathe_4,desc,Label)"             "4축 종속 선반 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_3,desc,Label)"              "3축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_3MT,desc,Label)"            "3축 밀링-선삭 (XZC)"
::msgcat::mcset pb_msg_korean "MC(new,mill_4H,desc,Label)"             "로타리 헤드가 있는 \n 3축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_4T,desc,Label)"             "로타리 테이블이 있는 \n 4축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_5TT,desc,Label)"            "이중 로타리 테이블이 있는 \n 5축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_5HH,desc,Label)"            "이중 로타리 헤드가 있는 \n 5축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,mill_5HT,desc,Label)"            "로타리 헤드와 테이블이 있는 \n 5축 밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,punch,desc,Label)"               "펀치 기계"

::msgcat::mcset pb_msg_korean "MC(new,post_unit,Label)"                "포스트 출력 단위"

::msgcat::mcset pb_msg_korean "MC(new,inch,Label)"                     "인치"
::msgcat::mcset pb_msg_korean "MC(new,inch,Context)"                   "포스트 프로세서 출력 단위 인치"
::msgcat::mcset pb_msg_korean "MC(new,millimeter,Label)"               "밀리미터"
::msgcat::mcset pb_msg_korean "MC(new,millimeter,Context)"             "포스트 프로세서 출력 단위 밀리미터"

::msgcat::mcset pb_msg_korean "MC(new,machine,Label)"                  "기계 공구"
::msgcat::mcset pb_msg_korean "MC(new,machine,Context)"                "포스트 포로세서를 생성할 기계 공구 유형"

::msgcat::mcset pb_msg_korean "MC(new,mill,Label)"                     "밀링"
::msgcat::mcset pb_msg_korean "MC(new,mill,Context)"                   "밀링 기계"
::msgcat::mcset pb_msg_korean "MC(new,lathe,Label)"                    "선반"
::msgcat::mcset pb_msg_korean "MC(new,lathe,Context)"                  "선반 기계"
::msgcat::mcset pb_msg_korean "MC(new,wire,Label)"                     "와이어 EDM"
::msgcat::mcset pb_msg_korean "MC(new,wire,Context)"                   "와이어 EDM 기계"
::msgcat::mcset pb_msg_korean "MC(new,punch,Label)"                    "펀치"

::msgcat::mcset pb_msg_korean "MC(new,axis,Label)"                     "기계 축 선택"
::msgcat::mcset pb_msg_korean "MC(new,axis,Context)"                   "기계 축 수와 유형"

#Axis Number
::msgcat::mcset pb_msg_korean "MC(new,axis_2,Label)"                   "2축"
::msgcat::mcset pb_msg_korean "MC(new,axis_3,Label)"                   "3축"
::msgcat::mcset pb_msg_korean "MC(new,axis_4,Label)"                   "4축"
::msgcat::mcset pb_msg_korean "MC(new,axis_5,Label)"                   "5축"
::msgcat::mcset pb_msg_korean "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_korean "MC(new,mach_axis,Label)"                "기계 공구 축"
::msgcat::mcset pb_msg_korean "MC(new,mach_axis,Context)"              "기계 공구 축 선택"
::msgcat::mcset pb_msg_korean "MC(new,lathe_2,Label)"                  "2축"
::msgcat::mcset pb_msg_korean "MC(new,mill_3,Label)"                   "3축"
::msgcat::mcset pb_msg_korean "MC(new,mill_3MT,Label)"                 "3축 밀링-선삭 (XZC)"
::msgcat::mcset pb_msg_korean "MC(new,mill_4T,Label)"                  "4축 + 로타리 테이블"
::msgcat::mcset pb_msg_korean "MC(new,mill_4H,Label)"                  "4축 + 로타리 헤드"
::msgcat::mcset pb_msg_korean "MC(new,lathe_4,Label)"                  "4축"
::msgcat::mcset pb_msg_korean "MC(new,mill_5HH,Label)"                 "5축 + 이중 로타리 헤드"
::msgcat::mcset pb_msg_korean "MC(new,mill_5TT,Label)"                 "5축 + 이중 로타리 테이블"
::msgcat::mcset pb_msg_korean "MC(new,mill_5HT,Label)"                 "5축 + 로타리 헤드와 테이블"
::msgcat::mcset pb_msg_korean "MC(new,wedm_2,Label)"                   "2축"
::msgcat::mcset pb_msg_korean "MC(new,wedm_4,Label)"                   "4축"
::msgcat::mcset pb_msg_korean "MC(new,punch,Label)"                    "펀치"

::msgcat::mcset pb_msg_korean "MC(new,control,Label)"                  "컨트롤러"
::msgcat::mcset pb_msg_korean "MC(new,control,Context)"                "포스트 컨트롤러 선택"

#Controller Type
::msgcat::mcset pb_msg_korean "MC(new,generic,Label)"                  "일반"
::msgcat::mcset pb_msg_korean "MC(new,library,Label)"                  "라이브러리"
::msgcat::mcset pb_msg_korean "MC(new,user,Label)"                     "사용자"
::msgcat::mcset pb_msg_korean "MC(new,user,browse,Label)"              "찾아보기"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_korean "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_korean "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_korean "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_korean "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_korean "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_korean "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_korean "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_korean "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_korean "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_korean "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_korean "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_korean "MC(new,seimens,Label)"                  "Seimens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_korean "MC(open,title,Label)"                   "포스트 편집"
::msgcat::mcset pb_msg_korean "MC(open,Status)"                        "열려는 PUI 파일을 선택합니다."
::msgcat::mcset pb_msg_korean "MC(open,file_type_pui)"                 "Post Builder 세션 파일"
::msgcat::mcset pb_msg_korean "MC(open,file_type_tcl)"                 "TCI 스크립트 파일"
::msgcat::mcset pb_msg_korean "MC(open,file_type_def)"                 "정의 파일"
::msgcat::mcset pb_msg_korean "MC(open,file_type_cdl)"                 "CDL 파일"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_korean "MC(open_save,dlg,title,Label)"          "파일 선택"
::msgcat::mcset pb_msg_korean "MC(exp_cc,dlg,title,Label)"             "사용자 정의 명령 내보내기"
::msgcat::mcset pb_msg_korean "MC(show_mt,title,Label)"                "기계 공구"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_korean "MC(mvb,title,Label)"                    "MOM 변수 브라우저"
::msgcat::mcset pb_msg_korean "MC(mvb,cat,Label)"                      "카테고리"
::msgcat::mcset pb_msg_korean "MC(mvb,search,Label)"                   "검색"
::msgcat::mcset pb_msg_korean "MC(mvb,defv,Label)"                     "기본 값"
::msgcat::mcset pb_msg_korean "MC(mvb,posv,Label)"                     "가능한 값"
::msgcat::mcset pb_msg_korean "MC(mvb,data,Label)"                     "데이터 유형"
::msgcat::mcset pb_msg_korean "MC(mvb,desc,Label)"                     "설명"

::msgcat::mcset pb_msg_korean "MC(inposts,title,Label)"                "편집 템플릿_post.dat"
::msgcat::mcset pb_msg_korean "MC(tpdf,text,Label)"                    "템플릿 포스트 데이터 파일"
::msgcat::mcset pb_msg_korean "MC(inposts,edit,title,Label)"           "행 편집"
::msgcat::mcset pb_msg_korean "MC(inposts,edit,post,Label)"            "포스트"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_korean "MC(save_as,title,Label)"                "다른 이름으로 저장"
::msgcat::mcset pb_msg_korean "MC(save_as,name,Label)"                 "포스트 이름"
::msgcat::mcset pb_msg_korean "MC(save_as,name,Context)"               "포스트 프로세서를 저장할 새 파일 이름입니다."
::msgcat::mcset pb_msg_korean "MC(save_as,Status)"                     "새 포스트 파일 이름을 입력합니다."
::msgcat::mcset pb_msg_korean "MC(save_as,file_type_pui)"              "Post Builder 세션 파일"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_korean "MC(common,entry,Label)"                 "항목"
::msgcat::mcset pb_msg_korean "MC(common,entry,Context)"               "각 항목 필드에 새 값을 지정합니다."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_korean "MC(nbook,tab,Label)"                    "노트북 탭"
::msgcat::mcset pb_msg_korean "MC(nbook,tab,Context)"                  "원하는 매개변수 페이지로 가려면 해당 탭을 선택합니다. \n \n탭에 표시되는 매개변수는 그룹으로 나눠지기도 합니다. 각 매개변수 그룹은 별개 탭으로 액세스할 수 있습니다."

##------
## Tree
##
::msgcat::mcset pb_msg_korean "MC(tree,select,Label)"                  "컴포넌트 트리"
::msgcat::mcset pb_msg_korean "MC(tree,select,Context)"                "내용이나 매개변수를 보거나 편집할 컴포넌트를 선택합니다."
::msgcat::mcset pb_msg_korean "MC(tree,create,Label)"                  "생성"
::msgcat::mcset pb_msg_korean "MC(tree,create,Context)"                "선택한 아이템을 복사하여 새 컴포넌트를 생성합니다."
::msgcat::mcset pb_msg_korean "MC(tree,cut,Label)"                     "잘라내기"
::msgcat::mcset pb_msg_korean "MC(tree,cut,Context)"                   "컴포넌트를 잘라냅니다."
::msgcat::mcset pb_msg_korean "MC(tree,paste,Label)"                   "붙여넣기"
::msgcat::mcset pb_msg_korean "MC(tree,paste,Context)"                 "컴포넌트를 붙여넣습니다."
::msgcat::mcset pb_msg_korean "MC(tree,rename,Label)"                  "이름변경"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_korean "MC(encrypt,browser,Label)"              "라이센스 리스트"
::msgcat::mcset pb_msg_korean "MC(encrypt,title,Label)"                "라이센스 선택"
::msgcat::mcset pb_msg_korean "MC(encrypt,output,Label)"               "출력 암호화"
::msgcat::mcset pb_msg_korean "MC(encrypt,license,Label)"              "라이센스:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_korean "MC(machine,tab,Label)"                  "기계 공구"
::msgcat::mcset pb_msg_korean "MC(machine,Status)"                     "기계 운동학 매개변수를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(msg,no_display)"                     "기계 공구 구성 이미지를 사용할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_4th_ctable)"                  "4축 C 테이블은 허용되지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_4th_max_min)"                 "4축 최대 축 한계는 최소 축 한계와 달라야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_4th_both_neg)"                "4축 한계는 둘 다 음수일 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_4th_5th_plane)"               "4축 평면은 5축 평면과 달라야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_4thT_5thH)"                   "4축 테이블과 5축 헤드는 허용되지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_5th_max_min)"                 "5축 최대 축 한계는 최소 축 한계와 달라야 합니다."
::msgcat::mcset pb_msg_korean "MC(msg,no_5th_both_neg)"                "5축 한계는 둘 다 음수일 수 없습니다."

##---------
# Post Info
##
::msgcat::mcset pb_msg_korean "MC(machine,info,title,Label)"           "포스트 정보"
::msgcat::mcset pb_msg_korean "MC(machine,info,desc,Label)"            "설명"
::msgcat::mcset pb_msg_korean "MC(machine,info,type,Label)"            "기계 유형"
::msgcat::mcset pb_msg_korean "MC(machine,info,kinematics,Label)"      "운동학"
::msgcat::mcset pb_msg_korean "MC(machine,info,unit,Label)"            "출력 단위"
::msgcat::mcset pb_msg_korean "MC(machine,info,controller,Label)"      "컨트롤러"
::msgcat::mcset pb_msg_korean "MC(machine,info,history,Label)"         "히스토리"

##---------
## Display
##
::msgcat::mcset pb_msg_korean "MC(machine,display,Label)"              "기계 공구 표시"
::msgcat::mcset pb_msg_korean "MC(machine,display,Context)"            "기계 공구 표시 옵션"
::msgcat::mcset pb_msg_korean "MC(machine,display_trans,title,Label)"  "기계 공구"


##---------------
## General parms
##
::msgcat::mcset pb_msg_korean "MC(machine,gen,Label)"                      "일반 매개변수"
    
::msgcat::mcset pb_msg_korean "MC(machine,gen,out_unit,Label)"             "포스트 출력 단위:"
::msgcat::mcset pb_msg_korean "MC(machine,gen,out_unit,Context)"           "포스트 프로세서 출력 단위"
::msgcat::mcset pb_msg_korean "MC(machine,gen,out_unit,inch,Label)"        "인치법" 
::msgcat::mcset pb_msg_korean "MC(machine,gen,out_unit,metric,Label)"      "미터법"

::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,Label)"         "선형 축 이동 한계"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,Context)"       "선형 축 이동 한계"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,x,Context)"     "X 축으로 기계가 이동하는 한계 지정"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,y,Context)"     "Y 축으로 기계가 이동하는 한계 지정"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_korean "MC(machine,gen,travel_limit,z,Context)"     "Z 축으로 기계가 이동하는 한계 지정"

::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,Label)"             "홈  위치"
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,Context)"           "홈  위치"
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,x,Context)"         "X축의 기계 홈 위치(축의 물리적 0 위치 기준). 자동 공구 변경 후 기계는 이 위치로 돌아옵니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,y,Context)"         "Y축의 기계 홈 위치(축의 물리적 0 위치 기준). 자동 공구 변경 후 기계는 이 위치로 돌아옵니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_korean "MC(machine,gen,home_pos,z,Context)"         "Z축의 기계 홈 위치(축의 물리적 0 위치 기준). 자동 공구 변경 후 기계는 이 위치로 돌아옵니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,step_size,Label)"            "선형 동작 해상도"
::msgcat::mcset pb_msg_korean "MC(machine,gen,step_size,min,Label)"        "최소"
::msgcat::mcset pb_msg_korean "MC(machine,gen,step_size,min,Context)"      "최소 해상도"

::msgcat::mcset pb_msg_korean "MC(machine,gen,traverse_feed,Label)"        "이동 이송율"
::msgcat::mcset pb_msg_korean "MC(machine,gen,traverse_feed,max,Label)"    "최대"
::msgcat::mcset pb_msg_korean "MC(machine,gen,traverse_feed,max,Context)"  "최대 이송율"

::msgcat::mcset pb_msg_korean "MC(machine,gen,circle_record,Label)"        "원형 레코드 출력"
::msgcat::mcset pb_msg_korean "MC(machine,gen,circle_record,yes,Label)"    "예"
::msgcat::mcset pb_msg_korean "MC(machine,gen,circle_record,yes,Context)"  "원형 레코드 출력"
::msgcat::mcset pb_msg_korean "MC(machine,gen,circle_record,no,Label)"     "아니오"
::msgcat::mcset pb_msg_korean "MC(machine,gen,circle_record,no,Context)"   "선형 레코드 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,config_4and5_axis,oth,Label)"    "기타"

# Wire EDM parameters
::msgcat::mcset pb_msg_korean "MC(machine,gen,wedm,wire_tilt)"             "와이어 기울기 제어"
::msgcat::mcset pb_msg_korean "MC(machine,gen,wedm,angle)"                 "각도"
::msgcat::mcset pb_msg_korean "MC(machine,gen,wedm,coord)"                 "좌표"

# Lathe parameters
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,Label)"               "터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,Context)"             "터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,conf,Label)"          "구성"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,conf,Context)"        "2 터릿을 선택한 경우 이 옵션을 사용하면 매개변수를 구성할 수 있습니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,one,Label)"           "1 터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,one,Context)"         "1 터릿 선반 기계"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,two,Label)"           "2 터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,two,Context)"         "2 터릿 선반 기계"

::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,conf_trans,Label)"    "터릿 구성"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,prim,Label)"          "1차 터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,prim,Context)"        "1차 터릿 지정 선택"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,sec,Label)"           "2차 터릿"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,sec,Context)"         "2차 터릿 지정 선택"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,designation,Label)"   "지정"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,xoff,Label)"          "X 옵셋"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,xoff,Context)"        "X 옵셋 지정"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,zoff,Label)"          "Z 옵셋"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,zoff,Context)"        "Z 옵셋 지정"

::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,front,Label)"         "정면"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,rear,Label)"          "후방"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,right,Label)"         "오른쪽"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,left,Label)"          "왼쪽"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,side,Label)"          "측면"
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret,saddle,Label)"        "새들"

::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,Label)"           "축 승수"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,dia,Label)"       "직경 프로그래밍"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,dia,Context)"     "N/C 출력에서 선택한 값을 두배로 증가하여 직경 프로그래밍을 수행합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2x,Context)"      "N/C 출력에서 X축 좌표 값을 두배로 증가하여 직경 프로그래밍을 수행합니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2y,Context)"      "N/C 출력에서 Y축 좌표 값을 두배로 증가하여 직경 프로그래밍을 수행합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2i,Context)"      "직경 프로그래밍에서 원형 레코드의 I 값을 두 배로 증가시킵니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,2j,Context)"      "직경 프로그래밍에서 원형 레코드의 J 값을 두 배로 증가시킵니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,mir,Label)"       "출력 대칭"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,mir,Context)"     "N/C 출력에서 선택한 값을 반전하여 대칭시킵니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,x,Context)"       "N/C 출력에서 X축 좌표를 반전합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,y,Context)"       "N/C 출력에서 Y축 좌표를 반전합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,z,Context)"       "N/C 출력에서 Z축 좌표를 반전합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,i,Context)"       "N/C 출력에서 원형 레코드의 I 값을 반전합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,j,Context)"       "N/C 출력에서 원형 레코드의 J 값을 반전합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_korean "MC(machine,gen,axis_multi,k,Context)"       "N/C 출력에서 원형 레코드의 K 값을 반전합니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,output,Label)"               "출력 방법"
::msgcat::mcset pb_msg_korean "MC(machine,gen,output,Context)"             "출력 방법"
::msgcat::mcset pb_msg_korean "MC(machine,gen,output,tool_tip,Label)"      "공구 팁"
::msgcat::mcset pb_msg_korean "MC(machine,gen,output,tool_tip,Context)"    "공구 팁을 기준으로 출력"
::msgcat::mcset pb_msg_korean "MC(machine,gen,output,turret_ref,Label)"    "터릿 참조"
::msgcat::mcset pb_msg_korean "MC(machine,gen,output,turret_ref,Context)"  "터릿 참조를 기준으로 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,lathe_turret,msg)"           "1차 터릿 지정은 2차 터릿 지정과 달라야 합니다."
::msgcat::mcset pb_msg_korean "MC(machine,gen,turret_chg,msg)"             "이 옵션을 변경할 경우 공구 변경 이벤트에서 G92 블록을 추가하거나 삭제해야 할지도 모릅니다."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_korean "MC(machine,gen,spindle_axis,Label)"             "초기 스핀들 축"
::msgcat::mcset pb_msg_korean "MC(machine,gen,spindle_axis,Context)"           "라이브 밀링 공구의 초기 스핀들 축은 Z축에 평행하거나 수직으로 지정할 수 있습니다. 이 오퍼레이션의 공구 축은 지정한 스핀들 축과 동일해야 합니다. 포스트가 지정한 스핀들 축으로 위치를 설정하지 못할 경우 오류가 발생합니다.\n초기 스핀들 축은 헤드 개체가 있는 스핀들 축으로 재정의해도 됩니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,position_in_yaxis,Label)"        "Y축 방향 지정"
::msgcat::mcset pb_msg_korean "MC(machine,gen,position_in_yaxis,Context)"      "기계에 프로그래밍이 가능한 Y축이 있어서 윤곽 그리기 오퍼레이션 중 Y축 방향을 지정할 수 있습니다. 이 옵션은 스핀들 축이 Z축 방향이 아닌 경우에만 사용할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,Label)"                "기계 모드"
::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,Context)"              "XZC-밀링 모드 또는 단순 밀링-선삭 모드 중 한 값을 가집니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC 밀링"
::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,xzc_mill,Context)"     "XZC 밀링은 밀링-선삭 기계에 로타리 C 축으로 고정된 테이블이나 척킹 면(chuck face)이 있습니다. 모든 XY 이동은 X와 C로 변환됩니다. 여기서 X는 반경 값을 가리키고 C는 각도를 가리킵니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,mill_turn,Label)"      "단순 밀링-선삭"
::msgcat::mcset pb_msg_korean "MC(machine,gen,mach_mode,mill_turn,Context)"    "이 XZC 밀링 포스트는 선반 포스트에 연결되어 있으며 밀링 오퍼레이션과 선삭 오퍼레이션을 모두 포함하는 프로그램을 처리합니다. N/C 출력에 사용되는 포스트는 오퍼레이션 유형에 따라 결정됩니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,mill_turn,lathe_post,Label)"     "선반 포스트"
::msgcat::mcset pb_msg_korean "MC(machine,gen,mill_turn,lathe_post,Context)"   "단순 밀링-선삭 포스트에서 프로그램에 포함된 선삭 오퍼레이션을 수행하려면 선반 포스트가 필요합니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,lathe_post,select_name,Label)"   "이름 선택"
::msgcat::mcset pb_msg_korean "MC(machine,gen,lathe_post,select_name,Context)" "단순 밀링-선삭 포스트에서 사용할 선반 포스트 이름을 선택합니다. 잠정적으로 선반 포스트는 NX/Post 런타임 시 \\\$UGII_CAM_POST_DIR에서 찾을 수 있습니다. 해당 디렉토리에서 포스트를 찾지 못하는 경우 밀링 포스트가 있는 디렉토리에서 이름이 같은 포스트를 찾아서 사용합니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,Label)"               "기본 좌표 모드"
::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,Context)"             "기본적인 좌표 출력 모드를 정의합니다. 값은 극좌표 (XZC) 또는 직교좌표 (XYZ) 중 하나입니다. 이 모드는 오퍼레이션에 프로그래밍된 \\\"SET/POLAR, ON\\\" UDE로 변경할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,polar,Label)"         "극좌표"
::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,polar,Context)"       "XZC 좌표로 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,cart,Label)"          "직교좌표"
::msgcat::mcset pb_msg_korean "MC(machine,gen,coord_mode,cart,Context)"        "XYZ 좌표로 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,Label)"             "원형 레코드 모드"
::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,Context)"           "원형 레코드를 출력할 좌표 모드를 정의합니다. 값은 극좌표 (XCR) 또는 직교좌표 (XYIJ) 중 하나입니다. "

::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,polar,Label)"       "극좌표"
::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,polar,Context)"     "XCR 좌표로 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,cart,Label)"        "직교좌표"
::msgcat::mcset pb_msg_korean "MC(machine,gen,xzc_arc_mode,cart,Context)"      "XYIJ 좌표로 출력"

::msgcat::mcset pb_msg_korean "MC(machine,gen,def_spindle_axis,Label)"         "초기 스핀들 축"
::msgcat::mcset pb_msg_korean "MC(machine,gen,def_spindle_axis,Context)"       "초기 스핀들 축은 헤드 개체가 있는 스핀들 축으로 재정의해도 됩니다.\n벡터는 단위 벡터가 아니어도 됩니다."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_korean "MC(machine,axis,fourth,Label)"              "4축"

::msgcat::mcset pb_msg_korean "MC(machine,axis,radius_output,Label)"       "반경 출력"
::msgcat::mcset pb_msg_korean "MC(machine,axis,radius_output,Context)"     "공구 축이 Z방향인 경우 출력할 극좌표 반경(X)을 선택할 수 있습니다. 값은 \\\"항상 양수\\\", \\\"항상 음수\\\", \\\"최단 거리\\\" 중 하나입니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,type_head,Label)"           "헤드"
::msgcat::mcset pb_msg_korean "MC(machine,axis,type_table,Label)"          "테이블"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_korean "MC(machine,axis,fifth,Label)"               "5축"

::msgcat::mcset pb_msg_korean "MC(machine,axis,rotary,Label)"              "로타리 축"

::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,Label)"              "기계 0에서 로타리 축 중심까지"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,4,Label)"            "기계 0에서 4축 중심까지"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,5,Label)"            "4축 중심에서 5축 중심까지"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,x,Label)"            "X 옵셋"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,x,Context)"          "로타리 축 X 옵셋을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,y,Label)"            "Y 옵셋"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,y,Context)"          "로타리 축 Y 옵셋을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,z,Label)"            "Z 옵셋"
::msgcat::mcset pb_msg_korean "MC(machine,axis,offset,z,Context)"          "로타리 축 Z 옵셋을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,rotation,Label)"            "축 회전"
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotation,norm,Label)"       "법선"
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotation,norm,Context)"     "축 회전 방향을 법선으로 설정합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotation,rev,Label)"        "반전"
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotation,rev,Context)"      "축 회전 방향을 반전으로 설정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,direction,Label)"           "축 방향"
::msgcat::mcset pb_msg_korean "MC(machine,axis,direction,Context)"         "축 방향을 선택합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,con_motion,Label)"              "연속적인 로타리 동작"
::msgcat::mcset pb_msg_korean "MC(machine,axis,con_motion,combine,Label)"      "결합"
::msgcat::mcset pb_msg_korean "MC(machine,axis,con_motion,combine,Context)"    "선형화를 활성화/비활성화합니다. 공차 옵션을 켜그나 끕니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,con_motion,tol,Label)"      "공차"
::msgcat::mcset pb_msg_korean "MC(machine,axis,con_motion,tol,Context)"    "결합 옵션이 켜져 있는 경우에만 활성화됩니다. 공차를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,Label)"           "축 한계 위반 처리"
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,warn,Label)"      "경고"
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,warn,Context)"    "축 한계 위반 시 경고를 출력합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,ret,Label)"       "진출 / 재진입"
::msgcat::mcset pb_msg_korean "MC(machine,axis,violation,ret,Context)"     "축 한계 위반 시 진출했다가 다시 진입합니다. \n \n원하는 대로 이동을 제어하려면 PB_CMD_init_rotaty 사용자 정의 명령에서 다음 매개변수를 조정합니다: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_korean "MC(machine,axis,limits,Label)"              "축 한계 (도)"
::msgcat::mcset pb_msg_korean "MC(machine,axis,limits,min,Label)"          "최소"
::msgcat::mcset pb_msg_korean "MC(machine,axis,limits,min,Context)"        "최소 로타리 축 한계를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,limits,max,Label)"          "최대"
::msgcat::mcset pb_msg_korean "MC(machine,axis,limits,max,Context)"        "최대 로타리 축 한계를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,incr_text)"                 "로타리 축 증분 가능"

::msgcat::mcset pb_msg_korean "MC(machine,axis,rotary_res,Label)"          "로타리 동작 해상도 (도)"
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotary_res,Context)"        "로타리 동작 해상도를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,ang_offset,Label)"          "각도 옵셋 (도)"
::msgcat::mcset pb_msg_korean "MC(machine,axis,ang_offset,Context)"        "축 각도 옵셋을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,pivot,Label)"               "피봇 거리"
::msgcat::mcset pb_msg_korean "MC(machine,axis,pivot,Context)"             "피봇 거리를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,max_feed,Label)"            "최대 이송률 (도/분)"
::msgcat::mcset pb_msg_korean "MC(machine,axis,max_feed,Context)"          "최대 이송률을 지정합니다. 단위는 도/분입니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,Label)"               "회전 평면"
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,Context)"             "회전 평면을 선택합니다. XY, YZ, ZX, 기타 중 하나를 선택합니다. \\\"기타\\\" 옵션을 선택하면 임의의 벡터를 지정할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,normal,Label)"        "평면 법선 벡터"
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,normal,Context)"      "회전 축으로 사용할 평면 법선 벡터를 지정합니다. \n단위 벡터일 필요는 없습니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,4th,Label)"           "4축 평면 법선"
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,4th,Context)"         "4축 회전에 사용할 평면 법선 벡터를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,5th,Label)"           "5축 평면 법선"
::msgcat::mcset pb_msg_korean "MC(machine,axis,plane,5th,Context)"         "5축 회전에 사용할 평면 법선 벡터를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,leader,Label)"              "워드 리더"
::msgcat::mcset pb_msg_korean "MC(machine,axis,leader,Context)"            "워드 리더를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,config,Label)"              "구성"
::msgcat::mcset pb_msg_korean "MC(machine,axis,config,Context)"            "4축과 5축 매개변수를 정의합니다."

::msgcat::mcset pb_msg_korean "MC(machine,axis,r_axis_conf_trans,Label)"   "로타리 축 구성"
::msgcat::mcset pb_msg_korean "MC(machine,axis,4th_axis,Label)"            "4축"
::msgcat::mcset pb_msg_korean "MC(machine,axis,5th_axis,Label)"            "5축"
::msgcat::mcset pb_msg_korean "MC(machine,axis,head,Label)"                " 헤드 "
::msgcat::mcset pb_msg_korean "MC(machine,axis,table,Label)"               " 테이블 "

::msgcat::mcset pb_msg_korean "MC(machine,axis,rotary_lintol,Label)"       "기본 선형화 공차"
::msgcat::mcset pb_msg_korean "MC(machine,axis,rotary_lintol,Context)"     "현재 혹은 다음 오퍼레이션에 LINTOL/ON 포스트 명령이 지정되어 있는 경우 이 값을 사용하여 로타리 이동을 선형화합니다. LINTOL/ON 명령에서 선형화 공차 값을 직접 지정할 수도 있습니다."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_korean "MC(progtpth,tab,Label)"                 "프로그램 및 공구 경로"

##---------
## Program
##
::msgcat::mcset pb_msg_korean "MC(prog,tab,Label)"                     "프로그램"
::msgcat::mcset pb_msg_korean "MC(prog,Status)"                        "이벤트 출력을 정의합니다."

::msgcat::mcset pb_msg_korean "MC(prog,tree,Label)"                    "프로그램 - 순서 트리"
::msgcat::mcset pb_msg_korean "MC(prog,tree,Context)"                  "N/C 프로그램은 5 세그먼트, 즉 네 순서와 공구 경로 바디로 나눠집니다. \n \n * 프로그램 시작 순서 \n * 오퍼레이션 시작 순서\n * 공구 경로 \n * 오퍼레이션 끝 순서 \n * 프로그램 끝 순서 \n \n각 순서는 일련의 마커로 구성됩니다. 각 마커는 프로그래밍 가능하며 N/C 프로그램의 특정 단계에서 발생하는 이벤트를 뜻합니다. 프로그램을 포스트 프로세싱할 때 출력할 N/C 코드 조합을 각 마커에 첨부해도 됩니다. \n \n공구 경로는 수많은 이벤트로 구성됩니다. 이벤트는 세 가지 그룹으로 나눌 수 있습니다: \n \n * 기계 제어 \n * 동작 \n * 사이클 \n"

::msgcat::mcset pb_msg_korean "MC(prog,tree,prog_strt,Label)"          "프로그램 시작 순서"
::msgcat::mcset pb_msg_korean "MC(prog,tree,prog_end,Label)"           "프로그램 끝 순서"
::msgcat::mcset pb_msg_korean "MC(prog,tree,oper_strt,Label)"          "오퍼레이션 시작 순서"
::msgcat::mcset pb_msg_korean "MC(prog,tree,oper_end,Label)"           "오퍼레이션 끝 순서"
::msgcat::mcset pb_msg_korean "MC(prog,tree,tool_path,Label)"          "공구 경로"
::msgcat::mcset pb_msg_korean "MC(prog,tree,tool_path,mach_cnt,Label)" "기계 제어"
::msgcat::mcset pb_msg_korean "MC(prog,tree,tool_path,motion,Label)"   "동작"
::msgcat::mcset pb_msg_korean "MC(prog,tree,tool_path,cycle,Label)"    "잠긴 사이클"
::msgcat::mcset pb_msg_korean "MC(prog,tree,linked_posts,Label)"       "연결된 포스트 순서"

::msgcat::mcset pb_msg_korean "MC(prog,add,Label)"                     "순서 - 블록 추가"
::msgcat::mcset pb_msg_korean "MC(prog,add,Context)"                   "새 블록을 순서에 추가하려면 버튼을 클릭하여 새 블록을 생성한 후 원하는 마커로 끌어다 놓습니다. 새 블록을 기존 블록 옆, 위, 아래에 첨부할 수도 있습니다."

::msgcat::mcset pb_msg_korean "MC(prog,trash,Label)"                   "순서 - 휴지통"
::msgcat::mcset pb_msg_korean "MC(prog,trash,Context)"                 "원하지 않는 블록을 제거하려면 순서에서 블록을 선택하여 휴지통으로 끌어다 버립니다. "

::msgcat::mcset pb_msg_korean "MC(prog,block,Label)"                   "순서 - 블록"
::msgcat::mcset pb_msg_korean "MC(prog,block,Context)"                 "원하지 않는 블록을 제거하려면 순서에서 블록을 선택하여 휴지통으로 끌어다 버립니다.  \n \n또한 마우스 오른쪽 버튼을 클릭하면 팝업 메뉴가 뜹니다. 메뉴는 다음 작업을 포함합니다: \n \n * 편집 \n * 강제 출력 \n * 잘라내기 \n * 다른 이름으로 복사하기 \n * 붙여넣기 \n * 삭제 \n"

::msgcat::mcset pb_msg_korean "MC(prog,select,Label)"                  "순서 - 블록 선택"
::msgcat::mcset pb_msg_korean "MC(prog,select,Context)"                "순서에 추가할 블록 유형을 선택합니다. \n\A추가할 수 있는 유형은 다음과 같습니다: \n \n * 새 블록 \n * 기존 N/C 블록 \n * 연산자 메시지 \n * 사용자 정의 명령\n"

::msgcat::mcset pb_msg_korean "MC(prog,oper_temp,Label)"               "순서 템플릿 선택"
::msgcat::mcset pb_msg_korean "MC(prog,add_block,Label)"               "블록 추가"
::msgcat::mcset pb_msg_korean "MC(prog,seq_comb_nc,Label)"             "결합된 N/C 코드 블록 표시"
::msgcat::mcset pb_msg_korean "MC(prog,seq_comb_nc,Context)"           "블록 또는 N/C 코드 형태로 순서 내용을 표시합니다. \n \nN/C 코드는 순서에 따라 워드로 표시됩니다."

::msgcat::mcset pb_msg_korean "MC(prog,plus,Label)"                    "프로그램 - 확장/축소 스위치"
::msgcat::mcset pb_msg_korean "MC(prog,plus,Context)"                  "컴포넌트 분기를 확장하거나 축소합니다."

::msgcat::mcset pb_msg_korean "MC(prog,marker,Label)"                  "순서 - 마커"
::msgcat::mcset pb_msg_korean "MC(prog,marker,Context)"                "마커는 프로그래밍 가능하며 N/C 프로그램의 특정 단계에서 발생하는 이벤트를 뜻합니다. \n \n각 마커에 출력될 블록을 첨부하거나 배열할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(prog,event,Label)"                   "프로그램 - 이벤트"
::msgcat::mcset pb_msg_korean "MC(prog,event,Context)"                 "마우스 왼쪽 버튼을 한 번만 클릭하면 이벤트를 편집할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(prog,nc_code,Label)"                 "프로그램 - N/C 코드"
::msgcat::mcset pb_msg_korean "MC(prog,nc_code,Context)"               "이 마커 혹은 이 이벤트에서 출력될 N/C 코드를 표시합니다."
::msgcat::mcset pb_msg_korean "MC(prog,undo_popup,Label)"              "실행 취소"

## Sequence
##
::msgcat::mcset pb_msg_korean "MC(seq,combo,new,Label)"                "새 블록"
::msgcat::mcset pb_msg_korean "MC(seq,combo,comment,Label)"            "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(seq,combo,custom,Label)"             "사용자 정의 명령"

::msgcat::mcset pb_msg_korean "MC(seq,new_trans,title,Label)"          "블록"
::msgcat::mcset pb_msg_korean "MC(seq,cus_trans,title,Label)"          "사용자 정의 명령"
::msgcat::mcset pb_msg_korean "MC(seq,oper_trans,title,Label)"         "연산자 메시지"

::msgcat::mcset pb_msg_korean "MC(seq,edit_popup,Label)"               "편집"
::msgcat::mcset pb_msg_korean "MC(seq,force_popup,Label)"              "강제 출력"
::msgcat::mcset pb_msg_korean "MC(seq,rename_popup,Label)"             "이름변경"
::msgcat::mcset pb_msg_korean "MC(seq,rename_popup,Context)"           "컴포넌트 이름을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(seq,cut_popup,Label)"                "잘라내기"
::msgcat::mcset pb_msg_korean "MC(seq,copy_popup,Label)"               "다른 이름으로 복사"
::msgcat::mcset pb_msg_korean "MC(seq,copy_popup,ref,Label)"           "참조된 블록"
::msgcat::mcset pb_msg_korean "MC(seq,copy_popup,new,Label)"           "새 블록"
::msgcat::mcset pb_msg_korean "MC(seq,paste_popup,Label)"              "붙여넣기"
::msgcat::mcset pb_msg_korean "MC(seq,paste_popup,before,Label)"       "이전"
::msgcat::mcset pb_msg_korean "MC(seq,paste_popup,inline,Label)"       "인라인"
::msgcat::mcset pb_msg_korean "MC(seq,paste_popup,after,Label)"        "이후"
::msgcat::mcset pb_msg_korean "MC(seq,del_popup,Label)"                "삭제"

::msgcat::mcset pb_msg_korean "MC(seq,force_trans,title,Label)"        "한 번만 강제 출력"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_korean "MC(tool,event_trans,title,Label)"       "이벤트"

::msgcat::mcset pb_msg_korean "MC(tool,event_seq,button,Label)"        "이벤트 템플릿 선택"
::msgcat::mcset pb_msg_korean "MC(tool,add_word,button,Label)"         "워드 추가"

::msgcat::mcset pb_msg_korean "MC(tool,format_trans,title,Label)"      "형식"

::msgcat::mcset pb_msg_korean "MC(tool,circ_trans,title,Label)"        "원형 이동 - 평면 코드"
::msgcat::mcset pb_msg_korean "MC(tool,circ_trans,frame,Label)"        " 평면 G 코드 "
::msgcat::mcset pb_msg_korean "MC(tool,circ_trans,xy,Label)"           "XY 평면"
::msgcat::mcset pb_msg_korean "MC(tool,circ_trans,yz,Label)"           "YZ 평면"
::msgcat::mcset pb_msg_korean "MC(tool,circ_trans,zx,Label)"           "ZX 평면"

::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,arc_start,Label)"          "원호 시작에서 중심까지"
::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,arc_center,Label)"         "원호 중심에서 시작까지"
::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,u_arc_start,Label)"        "원호 시작에서 중심까지 (부호 없음)"
::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,absolute,Label)"           "원호 중심 (절대값)"
::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,long_thread_lead,Label)"   "길이 방향 스레드 리드"
::msgcat::mcset pb_msg_korean "MC(tool,ijk_desc,tran_thread_lead,Label)"   "가로 방향 스레드 리드"

::msgcat::mcset pb_msg_korean "MC(tool,spindle,range,type,Label)"              "스핀들 범위 유형"
::msgcat::mcset pb_msg_korean "MC(tool,spindle,range,range_M,Label)"           "개별 범위 M 코드 (M41)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle,range,with_spindle_M,Label)"    "스핀들 M 코드 범위 번호 (M13)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle,range,hi_lo_with_S,Label)"      "S 코드 고/저 범위 (S+100)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle,range,nonzero_range,msg)"       "스핀들 범위 번호는 0보다 커야 합니다."

::msgcat::mcset pb_msg_korean "MC(tool,spindle_trans,title,Label)"         "스핀들 범위 코드 테이블"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_trans,range,Label)"         "범위"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_trans,code,Label)"          "코드"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_trans,min,Label)"           "최소 (RPM)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_trans,max,Label)"           "최대 (RPM)"

::msgcat::mcset pb_msg_korean "MC(tool,spindle_desc,sep,Label)"            " 개별 범위 M 코드 (M41, M42...) "
::msgcat::mcset pb_msg_korean "MC(tool,spindle_desc,range,Label)"          " 스핀들 범위 번호 M 코드 (M13, M23...)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_desc,high,Label)"           " S 코드 고/저 범위 (S+100/S-100)"
::msgcat::mcset pb_msg_korean "MC(tool,spindle_desc,odd,Label)"            " S 코드 홀수/짝수 범위"


::msgcat::mcset pb_msg_korean "MC(tool,config,mill_opt1,Label)"            "공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,config,mill_opt2,Label)"            "공구 번호 및 길이 옵셋 번호"
::msgcat::mcset pb_msg_korean "MC(tool,config,mill_opt3,Label)"            "길이 옵셋 번호 및 공구 번호"

::msgcat::mcset pb_msg_korean "MC(tool,config,title,Label)"                "공구 코드 구성"
::msgcat::mcset pb_msg_korean "MC(tool,config,output,Label)"               "출력"

::msgcat::mcset pb_msg_korean "MC(tool,config,lathe_opt1,Label)"           "공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,config,lathe_opt2,Label)"           "공구 번호 및 길이 옵셋 번호"
::msgcat::mcset pb_msg_korean "MC(tool,config,lathe_opt3,Label)"           "터릿 색인 및 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,config,lathe_opt4,Label)"           "터릿 색인 공구 번호 및 길이 옵셋 번호"

::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,num,Label)"               "공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,next_num,Label)"          "다음 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,index_num,Label)"         "터릿 색인 및 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,index_next_num,Label)"    "터릿 색인 및 다음 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,num_len,Label)"           "공구 번호 및 길이 옵셋 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,next_num_len,Label)"      "다음 공구 번호 및 길이 옵셋 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,len_num,Label)"           "길이 옵셋 번호 및 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,len_next_num,Label)"      "길이 옵셋 번호 및 다음 공구 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,index_num_len,Label)"     "터릿 색인, 공구 번호 및 길이 옵셋 번호"
::msgcat::mcset pb_msg_korean "MC(tool,conf_desc,index_next_num_len,Label)"    "터릿 색인, 다음 공구 번호 및 길이 옵셋 번호"

::msgcat::mcset pb_msg_korean "MC(tool,oper_trans,title,Label)"            "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(tool,cus_trans,title,Label)"             "사용자 정의 명령"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_korean "MC(event,feed,IPM_mode)"                "IPM (인치/분) 모드"

##---------
## G Codes
##
::msgcat::mcset pb_msg_korean "MC(gcode,tab,Label)"                    "G 코드"
::msgcat::mcset pb_msg_korean "MC(gcode,Status)"                       "G 코드를 지정하십시오."

##---------
## M Codes
##
::msgcat::mcset pb_msg_korean "MC(mcode,tab,Label)"                    "M 코드"
::msgcat::mcset pb_msg_korean "MC(mcode,Status)"                       "M 코드를 지정하십시오."

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_korean "MC(addrsum,tab,Label)"                  "워드 요약"
::msgcat::mcset pb_msg_korean "MC(addrsum,Status)"                     "매개변수를 지정하십시오."

::msgcat::mcset pb_msg_korean "MC(addrsum,col_addr,Label)"             "워드"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_addr,Context)"           "워드 주소를 클릭하려면 왼쪽 마우스 버튼으로 워드 이름을 클릭합니다."
::msgcat::mcset pb_msg_korean "MC(addrsum,col_lead,Label)"             "리더/코드"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_data,Label)"             "데이터 유형"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_plus,Label)"             "양수 (+)"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_lzero,Label)"            "0으로 시작"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_int,Label)"              "정수"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_dec,Label)"              "소수점 (.)"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_frac,Label)"             "분수"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_tzero,Label)"            "0으로 끝남"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_modal,Label)"            "모달 ?"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_min,Label)"              "최소"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_max,Label)"              "최대"
::msgcat::mcset pb_msg_korean "MC(addrsum,col_trail,Label)"            "접미어"

::msgcat::mcset pb_msg_korean "MC(addrsum,radio_text,Label)"           "텍스트"
::msgcat::mcset pb_msg_korean "MC(addrsum,radio_num,Label)"            "숫자"

::msgcat::mcset pb_msg_korean "MC(addrsum,addr_trans,title,Label)"     "워드"
::msgcat::mcset pb_msg_korean "MC(addrsum,other_trans,title,Label)"    "기타 데이터 요소"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_korean "MC(wseq,tab,Label)"                     "워드 순서 지정"
::msgcat::mcset pb_msg_korean "MC(wseq,Status)"                        "워드 순서를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(wseq,word,Label)"                    "마스터 워드 순서"
::msgcat::mcset pb_msg_korean "MC(wseq,word,Context)"                  "N/C 출력에 표시되는 워드 순서를 제어하려면 원하는 위치에 워드를 끌어다 놓습니다. \n \n워드를 다른 워드에 끌어다 놓으면 두 워드의 위치가 바귑니다. 워드를 두 워드 사이에 끌어다 놓으면 선택한 워드는 두 워드 사이에 삽입됩니다. \n \nNC/출력에 워드를 표시하지 않으려면 해당 워드를 마우스 왼쪽 버튼으로 클릭하여 억제합니다. \n \n또한 마우스 오른쪽 버튼 메뉴를 사용하여 다음 작업을 수행할 수 있습니다: \n \n * 새로 만들기 \n * 편집\n * 삭제 \n * 모두 활성화 \n"

::msgcat::mcset pb_msg_korean "MC(wseq,active_out,Label)"              " 출력 - 활성     "
::msgcat::mcset pb_msg_korean "MC(wseq,suppressed_out,Label)"          " 출력 - 억제됨 "

::msgcat::mcset pb_msg_korean "MC(wseq,popup_new,Label)"               "새로 만들기"
::msgcat::mcset pb_msg_korean "MC(wseq,popup_undo,Label)"              "실행 취소"
::msgcat::mcset pb_msg_korean "MC(wseq,popup_edit,Label)"              "편집"
::msgcat::mcset pb_msg_korean "MC(wseq,popup_delete,Label)"            "삭제"
::msgcat::mcset pb_msg_korean "MC(wseq,popup_all,Label)"               "모두 활성화"
::msgcat::mcset pb_msg_korean "MC(wseq,transient_win,Label)"           "워드"
::msgcat::mcset pb_msg_korean "MC(wseq,cannot_suppress_msg)"           "을(를) 억제할 수 없습니다. 다음에서 단일 요소로 사용되었습니다:"
::msgcat::mcset pb_msg_korean "MC(wseq,empty_block_msg)"               "이 주소의 출력을 억제하면 유효하지 않은 빈 블록이 남습니다."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_korean "MC(cust_cmd,tab,Label)"                 "사용자 정의 명령"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,Status)"                    "사용자 정의 명령을 정의합니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,name,Label)"                "명령 이름"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,name,Context)"              "실제 명령 이름은 사용자가 입력하는 이름 앞에 PB_CMD_가 붙습니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,proc,Label)"                "프로시저"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,proc,Context)"              "이 명령의 기능을 정의하는 TCL 스크립트를 입력합니다. \n \n * Post Builder는 스크립트 내용을 구문 분석하지 않고 TCL 파일에 그대로 저장합니다. 그러므로 스크립트 구문이 타당한지 여부는 사용자가 확인해야 합니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,name_msg)"                  "사용자 정의 명령이 올바르지 않습니다.\n 다른 이름을 지정하십시오."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,name_msg_1)"                "은(는) 특수 사용자 정의 명령으로 예약된 이름입니다.\n 다른 이름을 지정하십시오."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,name_msg_2)"                "PB_CMD_vnc_______ *와 같은 \n VNC 명령만 허용됩니다.\n 다른 이름을 지정하십시오."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,Label)"              "가져오기"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,Context)"            "선택한 TCL 파일에서 현재 포스트로 사용자 정의 명령을 가져오기합니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,export,Label)"              "내보내기"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,export,Context)"            "현재 포트스에서 TCL 파일로 사용자 정의 명령을 내보내기합니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,tree,Label)"         "사용자 정의 명령 가져오기"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,tree,Context)"       "이 리스트는 가져오기로 지정한 파일에 포함된 사용자 정의 명령 프로시저와 기타 TCL 프로시저를 열거합니다. 리스트에서 아이템을 클릭하면 각 프로시저 내용을 확인할 수 있습니다. 현재 포스트에 이미 존재하는 프로시저는 <존재함> 표시기가 표시됩니다. 리스트에서 아이템을 두 번 클릭하면 왼쪽에 있는 확인란이 선택되거나 해제되는데, 이 확인란은 가져오기할 프로시저를 나타냅니다. 기본적으로는 모든 프로시저가 선택되어 있습니다. 기존 프로시저를 덮어쓰지 않으려면 해당 항목의 확인란을 해제합니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,export,tree,Label)"         "사용자 정의 명령 내보내기"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,export,tree,Context)"       "이 리스트는 현재 포스트에 존재하는 사용자 정의 명령 프로시저와 기타 TCL 프로시저를 열거합니다. 리스트에서 아이템을 클릭하면 각 프로시저 내용을 확인할 수 있습니다. 마우스를 두 번 클릭하면 왼쪽에 있는 확인란이 선택되거나 해제되는데, 이 확인란을 선택하여 내보내기할 프로시저를 지정할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,error,title)"               "사용자 정의 명령 오류"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,error,msg)"                 "사용자 정의 명령 검증을 활성화하거나 비활성화하려면 \"옵션 -> 사용자 정의 명령 검증\"에 있는 스위치를 사용합니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,select_all,Label)"          "모두 선택"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,select_all,Context)"        "가져오기나 내보내기에 표시되는 명령을 모두 선택합니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,deselect_all,Label)"        "모두 선택취소"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,deselect_all,Context)"      "모든 명령의 선택을 취소합니다."

::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,warning,title)"      "사용자 정의 명령 가져오기/내보내기 경고"
::msgcat::mcset pb_msg_korean "MC(cust_cmd,import,warning,msg)"        "가져오기 혹은 내보내기할 아이템을 선택하지 않았습니다."



::msgcat::mcset pb_msg_korean "MC(cust_cmd,cmd,msg)"                   "명령 : "
::msgcat::mcset pb_msg_korean "MC(cust_cmd,blk,msg)"                   "블록 : "
::msgcat::mcset pb_msg_korean "MC(cust_cmd,add,msg)"                   "주소 : "
::msgcat::mcset pb_msg_korean "MC(cust_cmd,fmt,msg)"                   "형식 : "
::msgcat::mcset pb_msg_korean "MC(cust_cmd,referenced,msg)"            "은(는) 사용자 정의 명령에서 참조하고 있습니다. "
::msgcat::mcset pb_msg_korean "MC(cust_cmd,not_defined,msg)"           "은(는) 현재 포스트 범위에서 정의되지 않았습니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,cannot_delete,msg)"         "을(를) 삭제할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(cust_cmd,save_post,msg)"             "그래도 이 포스트를 저장하시겠습니까?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_korean "MC(opr_msg,text,Label)"                 "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(opr_msg,text,Context)"               "연산자 메시지로 표시되는 텍스트입니다. 메시지 시작과 끝에 필요한 특수 문자는 Post Builder가 자동으로 추가합니다. 이들 특수 문자는 \"N/C 데이터 정의\" 탭의 \"기타 데이터 요소\" 매개변수 페이지에 정의되어 있습니다."

::msgcat::mcset pb_msg_korean "MC(opr_msg,name,Label)"                 "메시지 이름"
::msgcat::mcset pb_msg_korean "MC(opr_msg,empty_operator)"             "연산자 메시지는 비워둘 수 없습니다."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_korean "MC(link_post,tab,Label)"                "연결된 포스트"
::msgcat::mcset pb_msg_korean "MC(link_post,Status)"                   "연결된 포스트를 정의합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,toggle,Label)"             "다른 포스트를 이 포스트에 연결"
::msgcat::mcset pb_msg_korean "MC(link_post,toggle,Context)"           "단순한 선삭 모드나 밀링 모드보다 복잡한 기계 공구를 처리하기 위해 다른 포스트를 이 포스트에 연결할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(link_post,head,Label)"               "헤드"
::msgcat::mcset pb_msg_korean "MC(link_post,head,Context)"             "복잡한 기계 공구는 다양한 가공 모드에서 다양한 운동학 세트를 사용하여 가공 오퍼레이션을 수행합니다. NX/Post에서는 각 운동학 세트를 독립적인 헤드로 취급합니다. 같은 헤드로 수행하는 가공 오퍼레이션은 기계 공구나 가공 방법 뷰에서 한 그룹으로 배치됩니다. 그런 다음 \\\"헤드\\\" UDE가 할당되어 그룹 이름을 지정하게 됩니다."

::msgcat::mcset pb_msg_korean "MC(link_post,post,Label)"               "포스트"
::msgcat::mcset pb_msg_korean "MC(link_post,post,Context)"             "N/C 코드를 생성하기 위해 헤드에 할당된 포스트입니다."

::msgcat::mcset pb_msg_korean "MC(link_post,link,Label)"               "연결된 포스트"
::msgcat::mcset pb_msg_korean "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_korean "MC(link_post,new,Label)"                "새로 만들기"
::msgcat::mcset pb_msg_korean "MC(link_post,new,Context)"              "새 링크를 생성합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,edit,Label)"               "편집"
::msgcat::mcset pb_msg_korean "MC(link_post,edit,Context)"             "링크를 편집합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,delete,Label)"             "삭제"
::msgcat::mcset pb_msg_korean "MC(link_post,delete,Context)"           "링크를 삭제합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,select_name,Label)"        "이름 선택"
::msgcat::mcset pb_msg_korean "MC(link_post,select_name,Context)"      "헤드에 할당할 포스트 이름을 선택합니다. 잠정적으로 이 포스트는 NX/Post 런타임 시 메인 포스트와 같은 디렉토리에서 찾을 수 있습니다. 해당 디렉토리에서 포스트를 찾지 못하는 경우 \\\$UGII_CAM_POST_DIR 디렉토리에서 이름이 같은 포스트를 찾아서 사용합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,start_of_head,Label)"      "헤드 시작"
::msgcat::mcset pb_msg_korean "MC(link_post,start_of_head,Context)"    "헤드 시작에 실행할 N/C 코드나 작업을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(link_post,end_of_head,Label)"        "헤드 끝"
::msgcat::mcset pb_msg_korean "MC(link_post,end_of_head,Context)"      "헤드 끝에 실행할 N/C 코드나 작업을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(link_post,dlg,head,Label)"           "헤드"
::msgcat::mcset pb_msg_korean "MC(link_post,dlg,post,Label)"           "포스트"
::msgcat::mcset pb_msg_korean "MC(link_post,dlg,title,Label)"          "연결된 포스트"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_korean "MC(nc_data,tab,Label)"                  "N/C 데이터 정의"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_korean "MC(block,tab,Label)"                    "블록"
::msgcat::mcset pb_msg_korean "MC(block,Status)"                       "블록 템플릿을 정의합니다."

::msgcat::mcset pb_msg_korean "MC(block,name,Label)"                   "블록 이름"
::msgcat::mcset pb_msg_korean "MC(block,name,Context)"                 "블록 이름을 입력합니다."

::msgcat::mcset pb_msg_korean "MC(block,add,Label)"                    "워드 추가"
::msgcat::mcset pb_msg_korean "MC(block,add,Context)"                  "버튼을 클릭하여 새 워드를 생성한 후 블록으로 끌어다 놓는 방버으로 블록에 새 워드를 추가합니다. 새로 생성할 워드 유형은 버튼 옆에 있는 리스트에서 선택합니다."

::msgcat::mcset pb_msg_korean "MC(block,select,Label)"                 "블록 - 워드 선택"
::msgcat::mcset pb_msg_korean "MC(block,select,Context)"               "블록에 추가할 워드 유형을 리스트에서 선택합니다."

::msgcat::mcset pb_msg_korean "MC(block,trash,Label)"                  "블록 - 휴지통"
::msgcat::mcset pb_msg_korean "MC(block,trash,Context)"                "원하지 않는 워드를 제거하려면 블록에서 워드를 선택한 후 휴지통으로 끌어다 버립니다."

::msgcat::mcset pb_msg_korean "MC(block,word,Label)"                   "블록 - 워드"
::msgcat::mcset pb_msg_korean "MC(block,word,Context)"                 "원하지 않는 워드를 제거하려면 블록에서 워드를 선택한 후 휴지통으로 끌어다 버립니다. \n \n또한 마우스 오른쪽 버튼을 클릭하면 팝업 메뉴가 뜹니다. 메뉴는 다음 작업을 포함합니다: \n \n * 편집 \n * 요소 변경 -> \n * 선택적 \n * 워드 분리자 없음 \n * 강제 출력 \n * 삭제 \n"

::msgcat::mcset pb_msg_korean "MC(block,verify,Label)"                 "블록 - 워드 검증"
::msgcat::mcset pb_msg_korean "MC(block,verify,Context)"               "블록에서 선택한 워드에 대해 출력될 N/C 코드를 표시합니다."

::msgcat::mcset pb_msg_korean "MC(block,new_combo,Label)"              "새 주소"
::msgcat::mcset pb_msg_korean "MC(block,text_combo,Label)"             "텍스트"
::msgcat::mcset pb_msg_korean "MC(block,oper_combo,Label)"             "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(block,comm_combo,Label)"             "명령"

::msgcat::mcset pb_msg_korean "MC(block,edit_popup,Label)"             "편집"
::msgcat::mcset pb_msg_korean "MC(block,view_popup,Label)"             "뷰"
::msgcat::mcset pb_msg_korean "MC(block,change_popup,Label)"           "요소 변경"
::msgcat::mcset pb_msg_korean "MC(block,user_popup,Label)"             "사용자 정의 수식"
::msgcat::mcset pb_msg_korean "MC(block,opt_popup,Label)"              "선택적"
::msgcat::mcset pb_msg_korean "MC(block,no_sep_popup,Label)"           "워드 분리자 없음"
::msgcat::mcset pb_msg_korean "MC(block,force_popup,Label)"            "강제 출력"
::msgcat::mcset pb_msg_korean "MC(block,delete_popup,Label)"           "삭제"
::msgcat::mcset pb_msg_korean "MC(block,undo_popup,Label)"             "실행 취소"
::msgcat::mcset pb_msg_korean "MC(block,delete_all,Label)"             "모든 활성 요소 삭제"

::msgcat::mcset pb_msg_korean "MC(block,cmd_title,Label)"              "사용자 정의 명령"
::msgcat::mcset pb_msg_korean "MC(block,oper_title,Label)"             "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(block,addr_title,Label)"             "워드"

::msgcat::mcset pb_msg_korean "MC(block,new_trans,title,Label)"        "워드"

::msgcat::mcset pb_msg_korean "MC(block,new,word_desc,Label)"          "새 주소"
::msgcat::mcset pb_msg_korean "MC(block,oper,word_desc,Label)"         "연산자 메시지"
::msgcat::mcset pb_msg_korean "MC(block,cmd,word_desc,Label)"          "사용자 정의 명령"
::msgcat::mcset pb_msg_korean "MC(block,user,word_desc,Label)"         "사용자 정의 수식"
::msgcat::mcset pb_msg_korean "MC(block,text,word_desc,Label)"         "텍스트 문자열"

::msgcat::mcset pb_msg_korean "MC(block,user,expr,Label)"              "수식"

::msgcat::mcset pb_msg_korean "MC(block,msg,min_word)"                 "블록은 워드를 적어도 하나는 포함해야 합니다."

::msgcat::mcset pb_msg_korean "MC(block,name_msg)"                     "블록 이름이 올바르지 않습니다.\n 다른 이름을 지정하십시오."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_korean "MC(address,tab,Label)"                  "워드"
::msgcat::mcset pb_msg_korean "MC(address,Status)"                     "워드 정의"

::msgcat::mcset pb_msg_korean "MC(address,name,Label)"                 "워드 이름"
::msgcat::mcset pb_msg_korean "MC(address,name,Context)"               "워드 이름을 편집합니다."

::msgcat::mcset pb_msg_korean "MC(address,verify,Label)"               "워드 - 검증"
::msgcat::mcset pb_msg_korean "MC(address,verify,Context)"             "워드에 대해 출력될 N/C 코드를 표시합니다."

::msgcat::mcset pb_msg_korean "MC(address,leader,Label)"               "리더"
::msgcat::mcset pb_msg_korean "MC(address,leader,Context)"             "워드 리더로 사용할 문자 수를 입력하거나 마우스 오른쪽 버튼의 팝업 메뉴에서 문자를 선택합니다."

::msgcat::mcset pb_msg_korean "MC(address,format,Label)"               "형식"
::msgcat::mcset pb_msg_korean "MC(address,format,edit,Label)"          "편집"
::msgcat::mcset pb_msg_korean "MC(address,format,edit,Context)"        "워드에서 사용하는 형식을 편집합니다."
::msgcat::mcset pb_msg_korean "MC(address,format,new,Label)"           "새로 만들기"
::msgcat::mcset pb_msg_korean "MC(address,format,new,Context)"         "새 형식을 생성합니다."

::msgcat::mcset pb_msg_korean "MC(address,format,select,Label)"        "워드 - 형식 선택"
::msgcat::mcset pb_msg_korean "MC(address,format,select,Context)"      "다른 워드 형식을 선택합니다."

::msgcat::mcset pb_msg_korean "MC(address,trailer,Label)"              "접미어"
::msgcat::mcset pb_msg_korean "MC(address,trailer,Context)"            "워드 접미어로 사용할 문자 수를 입력하거나 마우스 오른쪽 버튼의 팝업 메뉴에서 문자를 선택합니다."

::msgcat::mcset pb_msg_korean "MC(address,modality,Label)"             "모달 ?"
::msgcat::mcset pb_msg_korean "MC(address,modality,Context)"           "워드의 모달성을 설정합니다."

::msgcat::mcset pb_msg_korean "MC(address,modal_drop,off,Label)"       "끄기"
::msgcat::mcset pb_msg_korean "MC(address,modal_drop,once,Label)"      "한 번"
::msgcat::mcset pb_msg_korean "MC(address,modal_drop,always,Label)"    "항상"

::msgcat::mcset pb_msg_korean "MC(address,max,value,Label)"            "최대"
::msgcat::mcset pb_msg_korean "MC(address,max,value,Context)"          "워드 최대 값을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(address,value,text,Label)"           "값"

::msgcat::mcset pb_msg_korean "MC(address,trunc_drop,Label)"           "값 자르기"
::msgcat::mcset pb_msg_korean "MC(address,warn_drop,Label)"            "사용자에게 경고"
::msgcat::mcset pb_msg_korean "MC(address,abort_drop,Label)"           "프로세스 중단"

::msgcat::mcset pb_msg_korean "MC(address,max,error_handle,Label)"     "위반 처리"
::msgcat::mcset pb_msg_korean "MC(address,max,error_handle,Context)"   "이 버튼을 사용하면 최대 값 위반 시 처리 방법을 지정할 수 있습니다: \n \n * 값 자르기\n * 사용자에게 경고 \n * 프로세스 중단 \n"

::msgcat::mcset pb_msg_korean "MC(address,min,value,Label)"            "최소"
::msgcat::mcset pb_msg_korean "MC(address,min,value,Context)"          "워드 최소 값을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(address,min,error_handle,Label)"     "위반 처리"
::msgcat::mcset pb_msg_korean "MC(address,min,error_handle,Context)"   "이 버튼을 사용하면 최소 값 위반 시 처리 방법을 지정할 수 있습니다: \n \n * 값 자르기\n * 사용자에게 경고 \n * 프로세스 중단 \n"

::msgcat::mcset pb_msg_korean "MC(address,format_trans,title,Label)"   "형식 "
::msgcat::mcset pb_msg_korean "MC(address,none_popup,Label)"           "없음"

::msgcat::mcset pb_msg_korean "MC(address,exp,Label)"                  "수식"
::msgcat::mcset pb_msg_korean "MC(address,exp,Context)"                "블록에 수식을 지정하거나 상수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(address,exp,msg)"                    "블록 수식은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(address,exp,space_only)"             "숫자 형식을 사용하는 블록 수식은 공백으로만 이루어질 수 없습니다."

## No translation is needed for this string.
::msgcat::mcset pb_msg_korean "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_korean "MC(address,exp,spec_char_msg)"          "특수 문자 \n [::msgcat::mc MC(address,exp,spec_char)] \n은(는) 숫자 데이터를 표현하는 수식에 사용할 수 없습니다."



::msgcat::mcset pb_msg_korean "MC(address,name_msg)"                   "워드 이름이 올바르지 않습니다.\n 다른 이름을 지정하십시오."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_korean "MC(address,rapid_add_name_msg)"         "rapid1, rapid2, rapid3는 Post Builder에서 내부적으로 사용하는 예약된 이름입니다. \n 다른 이름을 지정하십시오."

::msgcat::mcset pb_msg_korean "MC(address,rapid1,desc)"                "길이 방향으로 급속 위치 지정"
::msgcat::mcset pb_msg_korean "MC(address,rapid2,desc)"                "가로 방향으로 급속 위치 지정"
::msgcat::mcset pb_msg_korean "MC(address,rapid3,desc)"                "스핀들 축 방향으로 급속 위치 지정"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_korean "MC(format,tab,Label)"                   "형식"
::msgcat::mcset pb_msg_korean "MC(format,Status)"                      "형식을 정의합니다."

::msgcat::mcset pb_msg_korean "MC(format,verify,Label)"                "형식 - 검증"
::msgcat::mcset pb_msg_korean "MC(format,verify,Context)"              "지정한 형식을 사용하여 출력될 N/C 코드를 표시합니다."

::msgcat::mcset pb_msg_korean "MC(format,name,Label)"                  "형식 이름"
::msgcat::mcset pb_msg_korean "MC(format,name,Context)"                "형식 이름 편집"

::msgcat::mcset pb_msg_korean "MC(format,data,type,Label)"             "데이터 유형"
::msgcat::mcset pb_msg_korean "MC(format,data,type,Context)"           "형식 데이터 유형 지정"
::msgcat::mcset pb_msg_korean "MC(format,data,num,Label)"              "숫자"
::msgcat::mcset pb_msg_korean "MC(format,data,num,Context)"            "형식의 데이터 유형을 숫자로 정의합니다."
::msgcat::mcset pb_msg_korean "MC(format,data,num,integer,Label)"      "형식 - 정수 자리수"
::msgcat::mcset pb_msg_korean "MC(format,data,num,integer,Context)"    "정수 혹은 실수의 정수 부분 자리수를 지정합니다. "
::msgcat::mcset pb_msg_korean "MC(format,data,num,fraction,Label)"     "형식 - 소숫점 이하 자리수"
::msgcat::mcset pb_msg_korean "MC(format,data,num,fraction,Context)"   "실수의 소수 부분 자리수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(format,data,num,decimal,Label)"      "소수점 출력"
::msgcat::mcset pb_msg_korean "MC(format,data,num,decimal,Context)"    "N/C 코드에서 소수점을 출력하니다."
::msgcat::mcset pb_msg_korean "MC(format,data,num,lead,Label)"         "시작 0 출력"
::msgcat::mcset pb_msg_korean "MC(format,data,num,lead,Context)"       "N/C 코드에서 숫자 앞에 0을 추가합니다."
::msgcat::mcset pb_msg_korean "MC(format,data,num,trail,Label)"        "끝 0 출력"
::msgcat::mcset pb_msg_korean "MC(format,data,num,trail,Context)"      "N/C 코드에서 실수 끝에 0을 추가합니다."
::msgcat::mcset pb_msg_korean "MC(format,data,text,Label)"             "텍스트"
::msgcat::mcset pb_msg_korean "MC(format,data,text,Context)"           "형식의 데이터 유형을 문자열로 정의합니다."
::msgcat::mcset pb_msg_korean "MC(format,data,plus,Label)"             "시작 양수 부호 출력"
::msgcat::mcset pb_msg_korean "MC(format,data,plus,Context)"           "N/C 코드에서 양수 부호를 출력하니다."
::msgcat::mcset pb_msg_korean "MC(format,zero_msg)"                    "0 형식을 복사할 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(format,zero_cut_msg)"                "0 형식을 삭제할 수 없습니다."

::msgcat::mcset pb_msg_korean "MC(format,data,dec_zero,msg)"           "소수점, 시작 0, 끝 0  옵션 중 적어도 하나는 선택해야 합니다."

::msgcat::mcset pb_msg_korean "MC(format,data,no_digit,msg)"           "정수 자리수와 분수 자리수 중 적어도 하나는 0이 아니어야 합니다."

::msgcat::mcset pb_msg_korean "MC(format,name_msg)"                    "형식 이름이 올바르지 않습니다.\n 다른 이름을 지정하십시오."
::msgcat::mcset pb_msg_korean "MC(format,error,title)"                 "형식 오류"
::msgcat::mcset pb_msg_korean "MC(format,error,msg)"                   "주소에서 사용 중인 형식입니다."

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_korean "MC(other,tab,Label)"                    "기타 데이터 요소"
::msgcat::mcset pb_msg_korean "MC(other,Status)"                       "매개변수를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(other,seq_num,Label)"                "순서 번호"
::msgcat::mcset pb_msg_korean "MC(other,seq_num,Context)"              "N/C 코드에서 순서 번호 출력을 활성화하거나 비활성화합니다."
::msgcat::mcset pb_msg_korean "MC(other,seq_num,start,Label)"          "순서 번호 시작"
::msgcat::mcset pb_msg_korean "MC(other,seq_num,start,Context)"        "순서 번호 시작을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,seq_num,inc,Label)"            "순서 번호 증분"
::msgcat::mcset pb_msg_korean "MC(other,seq_num,inc,Context)"          "순서 번호 증분을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,seq_num,freq,Label)"           "순서 번호 빈도수"
::msgcat::mcset pb_msg_korean "MC(other,seq_num,freq,Context)"         "N/C 코드에 순서 번호가 나타나는 빈도를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,seq_num,max,Label)"            "순서 번호 최대값"
::msgcat::mcset pb_msg_korean "MC(other,seq_num,max,Context)"          "순서 번호 최대값을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(other,chars,Label)"                  "특수 문자"
::msgcat::mcset pb_msg_korean "MC(other,chars,word_sep,Label)"         "워드 분리자"
::msgcat::mcset pb_msg_korean "MC(other,chars,word_sep,Context)"       "워드 분리자로 사용할 문자를 지정하니다."
::msgcat::mcset pb_msg_korean "MC(other,chars,decimal_pt,Label)"       "소수점"
::msgcat::mcset pb_msg_korean "MC(other,chars,decimal_pt,Context)"     "소수점으로 사용할 문자를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,chars,end_of_block,Label)"     "블록 끝"
::msgcat::mcset pb_msg_korean "MC(other,chars,end_of_block,Context)"   "블록 끝을 나타낼 문자를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,chars,comment_start,Label)"    "메시지 시작"
::msgcat::mcset pb_msg_korean "MC(other,chars,comment_start,Context)"  "연산자 메시지 행의 시작을 나타낼 문자를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,chars,comment_end,Label)"      "메시지 끝"
::msgcat::mcset pb_msg_korean "MC(other,chars,comment_end,Context)"    "연산자 메시지 행의 끝을 나타낼 문자를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_korean "MC(other,opskip,leader,Label)"          "행 리더"
::msgcat::mcset pb_msg_korean "MC(other,opskip,leader,Context)"        "OPSKIP 행 리더"

::msgcat::mcset pb_msg_korean "MC(other,gm_codes,Label)"               "블록 당 G 및 M 코드 출력"
::msgcat::mcset pb_msg_korean "MC(other,g_codes,Label)"                "블록 당 G 코드 수"
::msgcat::mcset pb_msg_korean "MC(other,g_codes,Context)"              "이 스위치를 사용하면 N/C 출력 블록 당 G 코드 수를 제어할 수 있습니다."
::msgcat::mcset pb_msg_korean "MC(other,g_codes,num,Label)"            "G 코드 수"
::msgcat::mcset pb_msg_korean "MC(other,g_codes,num,Context)"          "N/C 출력 블록 당 G 코드 수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(other,m_codes,Label)"                "M 코드 수"
::msgcat::mcset pb_msg_korean "MC(other,m_codes,Context)"              "이 스위치를 사용하면 N/C 출력 블록 당 M 코드 수를 제어할 수 있습니다."
::msgcat::mcset pb_msg_korean "MC(other,m_codes,num,Label)"            "블록 당 M 코드 수"
::msgcat::mcset pb_msg_korean "MC(other,m_codes,num,Context)"          "N/C 출력 블록 당 M 코드 수를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(other,opt_none,Label)"               "없음"
::msgcat::mcset pb_msg_korean "MC(other,opt_space,Label)"              "공간"
::msgcat::mcset pb_msg_korean "MC(other,opt_dec,Label)"                "소수점 (.)"
::msgcat::mcset pb_msg_korean "MC(other,opt_comma,Label)"              "쉼표 (,)"
::msgcat::mcset pb_msg_korean "MC(other,opt_semi,Label)"               "세미콜론(;)"
::msgcat::mcset pb_msg_korean "MC(other,opt_colon,Label)"              "콜론(:)"
::msgcat::mcset pb_msg_korean "MC(other,opt_text,Label)"               "텍스트 문자열"
::msgcat::mcset pb_msg_korean "MC(other,opt_left,Label)"               "왼쪽 괄호 ("
::msgcat::mcset pb_msg_korean "MC(other,opt_right,Label)"              "오른쪽 괄호 )"
::msgcat::mcset pb_msg_korean "MC(other,opt_pound,Label)"              "파운드 기호 (\#)"
::msgcat::mcset pb_msg_korean "MC(other,opt_aster,Label)"              "별표 (*)"
::msgcat::mcset pb_msg_korean "MC(other,opt_slash,Label)"              "슬래시 (/)"
::msgcat::mcset pb_msg_korean "MC(other,opt_new_line,Label)"           "새 행(\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_korean "MC(other,ude,Label)"                    "사용자 정의 이벤트"
::msgcat::mcset pb_msg_korean "MC(other,ude_include,Label)"            "다른 CDL 파일 포함"
::msgcat::mcset pb_msg_korean "MC(other,ude_include,Context)"          "포스트 정의 파일에 다른 CDF 파일을 참조합니다."

::msgcat::mcset pb_msg_korean "MC(other,ude_file,Label)"               "CDF 파일 이름"
::msgcat::mcset pb_msg_korean "MC(other,ude_file,Context)"             "이 포스트의 정의 파일에서 참조할(INCLUDE) CDL 파일 이름과 경로입니다. 경로 이름을 지정하는 경우 경로 이름은 UG 환경 변수(\\\$UGII)로 시작해야 합니다. 경로를 지정하지 않으면 UG/NX 런타임 시 UGII_CAM_FILE_SEARCH_PATH를 사용하여 파일을 검색합니다."
::msgcat::mcset pb_msg_korean "MC(other,ude_select,Label)"             "이름 선택"
::msgcat::mcset pb_msg_korean "MC(other,ude_select,Context)"           "이 포스트의 정의 파일에서 참조할(INCLUDE) CDL 파일을 선택합니다. 기본적으로 선택한 파일 이름 앞에는 \\\$UGII_CAM_USER_DEF_EVENT_DIR/이 붙습니다. 파일을 선택한 후 필요하다면 경로 이름을 편집할 수 있습니다."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_korean "MC(output,tab,Label)"                   "출력 설정값"
::msgcat::mcset pb_msg_korean "MC(output,Status)"                      "출력 매개변수를 구성합니다."

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_korean "MC(output,vnc,Label)"                   "가상 N/C 컨트롤러"
::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,std,Label)"          "독립형"
::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,sub,Label)"          "종속형"
::msgcat::mcset pb_msg_korean "MC(output,vnc,status,Label)"            "VNC 파일 선택"
::msgcat::mcset pb_msg_korean "MC(output,vnc,mis_match,Label)"         "선택한 파일이 기본 VNC 파일 이름과 일치하지 않습니다.\n 다른 파일을 선택하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(output,vnc,output,Label)"            "가상 N/C 컨트롤러(VNC) 생성"
::msgcat::mcset pb_msg_korean "MC(output,vnc,output,Context)"          "가상 N/C 컨트롤러(VNC) 생성을 활성화합니다. VNC를 활성화한 상태에서 생성한 포스트는 ISV에 사용할 수 있습니다."
::msgcat::mcset pb_msg_korean "MC(output,vnc,main,Label)"              "마스터 VNC"
::msgcat::mcset pb_msg_korean "MC(output,vnc,main,Context)"            "종속 VNC가 참조하는 마스터 VNC 이름입니다. 잠정적으로 이 포스트는 ISV 런타임 시 종속 VNC가 있는 디렉토리에서 찾을 수 있습니다. 해당 디렉토리에서 포스트를 찾지 못하는 경우 \\\$UGII_CAM_POST_DIR 디렉토리에서 이름이 같은 포스트를 찾아서 사용합니다."


::msgcat::mcset pb_msg_korean "MC(output,vnc,main,err_msg)"                 "종속 VNC에 마스터 VNC를 지정해야 합니다."
::msgcat::mcset pb_msg_korean "MC(output,vnc,main,select_name,Label)"       "이름 선택"
::msgcat::mcset pb_msg_korean "MC(output,vnc,main,select_name,Context)"     "종속 VNC가 참조하는 VNC 이름을 선택합니다. 잠정적으로 이 포스트는 ISV 런타임 시 종속 VNC가 있는 디렉토리에서 찾을 수 있습니다. 해당 디렉토리에서 포스트를 찾지 못하는 경우 \\\$UGII_CAM_POST_DIR 디렉토리에서 이름이 같은 포스트를 찾아서 사용합니다."

::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,Label)"                   "가상 N/C 컨트롤러 모드"
::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,Context)"                 "가상 N/C 컨트롤러는 마스터 VNC에 독립적이거나 종속적입니다."
::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,std,Context)"             "독립형 VNC는 마스터 VNC가 필요하지 않습니다."
::msgcat::mcset pb_msg_korean "MC(output,vnc,mode,sub,Context)"             "종속 VNC는 마스터 VNC가 필요합니다. ISV 런타임 시 마스터 VNC를 참조합니다."
::msgcat::mcset pb_msg_korean "MC(output,vnc,pb_ver,msg)"                   "가상 N/C 컨트롤러는 Post Builder와 함께 생성됩니다. "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_korean "MC(listing,tab,Label)"                  "리스트 파일"
::msgcat::mcset pb_msg_korean "MC(listing,Status)"                     "리스트 파일 매개변수를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,gen,Label)"                  "리스트 파일 생성"
::msgcat::mcset pb_msg_korean "MC(listing,gen,Context)"                "리스트 파일 출력을 활성화하거나 비활성화합니다."

::msgcat::mcset pb_msg_korean "MC(listing,Label)"                      "리스트 파일 요소"
::msgcat::mcset pb_msg_korean "MC(listing,parms,Label)"                "컴포넌트"

::msgcat::mcset pb_msg_korean "MC(listing,parms,x,Label)"              "X 좌표"
::msgcat::mcset pb_msg_korean "MC(listing,parms,x,Context)"            "X 좌표를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,y,Label)"              "Y 좌표"
::msgcat::mcset pb_msg_korean "MC(listing,parms,y,Context)"            "Y 좌표를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,z,Label)"              "Z 좌표"
::msgcat::mcset pb_msg_korean "MC(listing,parms,z,Context)"            "Z 좌표를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,4,Label)"              "4축 각도"
::msgcat::mcset pb_msg_korean "MC(listing,parms,4,Context)"            "4축 각도를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,5,Label)"              "5축 각도"
::msgcat::mcset pb_msg_korean "MC(listing,parms,5,Context)"            "5축 각도를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,feed,Label)"           "이송"
::msgcat::mcset pb_msg_korean "MC(listing,parms,feed,Context)"         "이송률을 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,parms,speed,Label)"          "속도"
::msgcat::mcset pb_msg_korean "MC(listing,parms,speed,Context)"        "스핀들 속도를 리스트 파일에 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,extension,Label)"            "리스트 파일 확장자"
::msgcat::mcset pb_msg_korean "MC(listing,extension,Context)"          "리스트 파일 확장자를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,nc_file,Label)"              "N/C 출력 파일 확장자"
::msgcat::mcset pb_msg_korean "MC(listing,nc_file,Context)"            "N/C 출력 파일 확장자를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,header,Label)"               "프로그램 머리글"
::msgcat::mcset pb_msg_korean "MC(listing,header,oper_list,Label)"     "오퍼레이션 리스트"
::msgcat::mcset pb_msg_korean "MC(listing,header,tool_list,Label)"     "공구 리스트"

::msgcat::mcset pb_msg_korean "MC(listing,footer,Label)"               "프로그램 바닥글"
::msgcat::mcset pb_msg_korean "MC(listing,footer,cut_time,Label)"      "전체 가공 시간"

::msgcat::mcset pb_msg_korean "MC(listing,format,Label)"                   "페이지 형식"
::msgcat::mcset pb_msg_korean "MC(listing,format,print_header,Label)"      "페이지 머리글 인쇄"
::msgcat::mcset pb_msg_korean "MC(listing,format,print_header,Context)"    "이 스위치를 사용하면 리스트 파일에 페이지 머리글을 인쇄할지 여부를 설정할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(listing,format,length,Label)"        "페이지 길이 (행)"
::msgcat::mcset pb_msg_korean "MC(listing,format,length,Context)"      "리스트 파일에서 페이지 당 행 수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(listing,format,width,Label)"         "페이지 폭 (열)"
::msgcat::mcset pb_msg_korean "MC(listing,format,width,Context)"       "리스트 파일에서 페이지 당 열 수를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,other,tab,Label)"            "기타 옵션"
::msgcat::mcset pb_msg_korean "MC(listing,output,Label)"               "출력 제어 요소"

::msgcat::mcset pb_msg_korean "MC(listing,output,warning,Label)"       "출력 경고 메시지"
::msgcat::mcset pb_msg_korean "MC(listing,output,warning,Context)"     "포스트프로세스 도중 경고 메시지를 출력할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,output,review,Label)"        "검토 도구 활성화"
::msgcat::mcset pb_msg_korean "MC(listing,output,review,Context)"      "포스트프로세스 도중 검토 도구를 활성화할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,output,group,Label)"         "그룹 출력 생성"
::msgcat::mcset pb_msg_korean "MC(listing,output,group,Context)"       "포스트 프로세스 중에 그룹 출력을 활성화할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(listing,output,verbose,Label)"       "상세 오류 메시지 표시"
::msgcat::mcset pb_msg_korean "MC(listing,output,verbose,Context)"     "오류 메시지를 상세히 표시할지 여부를 지정합니다. 이 옵션을 켜면 포스트프로세스 속력이 느려집니다."

::msgcat::mcset pb_msg_korean "MC(listing,oper_info,Label)"            "오퍼레이션 정보"
::msgcat::mcset pb_msg_korean "MC(listing,oper_info,parms,Label)"      "오퍼레이션 매개변수"
::msgcat::mcset pb_msg_korean "MC(listing,oper_info,tool,Label)"       "공구 매개변수"
::msgcat::mcset pb_msg_korean "MC(listing,oper_info,cut_time,,Label)"  "가공 시간"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_korean "MC(listing,user_tcl,frame,Label)"       "사용자 TCL 원본"
::msgcat::mcset pb_msg_korean "MC(listing,user_tcl,check,Label)"       "사용자 TCL 파일 원본"
::msgcat::mcset pb_msg_korean "MC(listing,user_tcl,check,Context)"     "사용자의 TCL 파일을 원본으로 사용할 수 있습니다."
::msgcat::mcset pb_msg_korean "MC(listing,user_tcl,name,Label)"        "파일 이름"
::msgcat::mcset pb_msg_korean "MC(listing,user_tcl,name,Context)"      "포스트에서 원본으로 사용할 TCL 파일 이름을 지정합니다."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_korean "MC(preview,tab,Label)"                  "포스트 파일 미리보기"
::msgcat::mcset pb_msg_korean "MC(preview,new_code,Label)"             "새 코드"
::msgcat::mcset pb_msg_korean "MC(preview,old_code,Label)"             "이전 코드"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_korean "MC(event_handler,tab,Label)"            "이벤트 핸들러"
::msgcat::mcset pb_msg_korean "MC(event_handler,Status)"               "프로시저를 확인할 이벤트를 선택합니다."

##---------------------
## Definition
##
::msgcat::mcset pb_msg_korean "MC(definition,tab,Label)"               "정의"
::msgcat::mcset pb_msg_korean "MC(definition,Status)"                  "내용을 확인할 아이템을 선택합니다."

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_korean "MC(advisor,tab,Label)"                  "포스트 어드바이저"
::msgcat::mcset pb_msg_korean "MC(advisor,Status)"                     "포스트 어드바이저"

::msgcat::mcset pb_msg_korean "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_korean "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_korean "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_korean "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_korean "MC(definition,format_txt,Label)"        "형식"
::msgcat::mcset pb_msg_korean "MC(definition,addr_txt,Label)"          "워드"
::msgcat::mcset pb_msg_korean "MC(definition,block_txt,Label)"         "블록"
::msgcat::mcset pb_msg_korean "MC(definition,comp_txt,Label)"          "복합 블록"
::msgcat::mcset pb_msg_korean "MC(definition,post_txt,Label)"          "포스트 블록"
::msgcat::mcset pb_msg_korean "MC(definition,oper_txt,Label)"          "연산자 메시지"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_korean "MC(msg,odd)"                            "옵션 인수 개수가 올바르지 않습니다."
::msgcat::mcset pb_msg_korean "MC(msg,wrong_list_1)"                   "알 수 없는 옵션입니다."
::msgcat::mcset pb_msg_korean "MC(msg,wrong_list_2)"                   "다음 옵션이어야 합니다:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_korean "MC(event,start_prog,name)"              "프로그램 시작"

### Operation Start
::msgcat::mcset pb_msg_korean "MC(event,opr_start,start_path,name)"    "경로 시작"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,from_move,name)"     "시작 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,fst_tool,name)"      "첫 번째 공구"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,auto_tc,name)"       "자동 공구 변경"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,manual_tc,name)"     "수동 공구 변경"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,init_move,name)"     "초기 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,fst_move,name)"      "첫 번째 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,appro_move,name)"    "접근 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,engage_move,name)"   "진입 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,fst_cut,name)"       "첫 번째 절삭"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,fst_lin_move,name)"  "첫 번째 선형 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,start_pass,name)"    "패스 시작"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,cutcom_move,name)"   "공구 보정 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_start,lead_move,name)"     "리드 인 이동"

### Operation End
::msgcat::mcset pb_msg_korean "MC(event,opr_end,ret_move,name)"        "리드 아웃 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_end,rtn_move,name)"        "복귀 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_end,goh_move,name)"        "Gohome 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_end,end_path,name)"        "경로 끝"
::msgcat::mcset pb_msg_korean "MC(event,opr_end,lead_move,name)"       "리드 아웃 이동"
::msgcat::mcset pb_msg_korean "MC(event,opr_end,end_pass,name)"        "패스 끝"

### Program End
::msgcat::mcset pb_msg_korean "MC(event,end_prog,name)"                "프로그램 끝"


### Tool Change
::msgcat::mcset pb_msg_korean "MC(event,tool_change,name)"             "공구 변경"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,m_code)"           "M 코드"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,m_code,tl_chng)"   "공구 변경"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,m_code,pt)"        "1차 터릿"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,m_code,st)"        "2차 터릿"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,t_code)"           "T 코드"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,t_code,conf)"      "구성"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,t_code,pt_idx)"    "1차 터릿 색인"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,t_code,st_idx)"    "2차 터릿 색인"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,tool_num)"         "공구 번호"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,tool_num,min)"     "최소"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,tool_num,max)"     "최대"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,time)"             "시간 (초)"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,time,tl_chng)"     "공구 변경"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,retract)"          "진출"
::msgcat::mcset pb_msg_korean "MC(event,tool_change,retract_z)"        "진출 깊이 Z"

### Length Compensation
::msgcat::mcset pb_msg_korean "MC(event,length_compn,name)"            "길이 보정"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,g_code)"          "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,g_code,len_adj)"  "공구 길이 조정"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,t_code)"          "T 코드"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,t_code,conf)"     "구성"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,len_off)"         "길이 옵셋 등록"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,len_off,min)"     "최소"
::msgcat::mcset pb_msg_korean "MC(event,length_compn,len_off,max)"     "최대"

### Set Modes
::msgcat::mcset pb_msg_korean "MC(event,set_modes,name)"               "모드 설정"
::msgcat::mcset pb_msg_korean "MC(event,set_modes,out_mode)"           "출력 모드"
::msgcat::mcset pb_msg_korean "MC(event,set_modes,g_code)"             "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,set_modes,g_code,absolute)"    "절대"
::msgcat::mcset pb_msg_korean "MC(event,set_modes,g_code,incremental)" "증분"
::msgcat::mcset pb_msg_korean "MC(event,set_modes,rotary_axis)"        "로타리 축 증분 가능"

### Spindle RPM
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,name)"                     "스핀들 RPM"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,dir_m_code)"               "스핀들 방향 M 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,dir_m_code,cw)"            "시계 방향 (CW)"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,dir_m_code,ccw)"           "반시계 방향 (CCW)"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,range_control)"            "스핀들 범위 제어"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,range_control,dwell_time)" "범위 변경 드웰 시간 (초)"
::msgcat::mcset pb_msg_korean "MC(event,spindle_rpm,range_control,range_code)" "범위 코드 지정"

### Spindle CSS
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,name)"             "스핀들 CSS"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,g_code)"           "스핀들 G 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,g_code,const)"     "상수 곡면 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,g_code,max)"       "최대 RPM 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,g_code,sfm)"       "SFM 취소 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,max)"              "CSS 동안 최대 RPM"
::msgcat::mcset pb_msg_korean "MC(event,spindle_css,sfm)"              "항상 SFM IPR 모드 유지"

### Spindle Off
::msgcat::mcset pb_msg_korean "MC(event,spindle_off,name)"             "스핀들 끄기"
::msgcat::mcset pb_msg_korean "MC(event,spindle_off,dir_m_code)"       "스핀들 방향 M 코드"
::msgcat::mcset pb_msg_korean "MC(event,spindle_off,dir_m_code,off)"   "끄기"

### Coolant On
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,name)"              "냉각수 설정"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code)"            "M 코드"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code,on)"         "시작"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code,flood)"      "유동형"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code,mist)"       "분무형"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code,thru)"       "통과"
::msgcat::mcset pb_msg_korean "MC(event,coolant_on,m_code,tap)"        "탭"

### Coolant Off
::msgcat::mcset pb_msg_korean "MC(event,coolant_off,name)"             "냉각수 해제"
::msgcat::mcset pb_msg_korean "MC(event,coolant_off,m_code)"           "M 코드"
::msgcat::mcset pb_msg_korean "MC(event,coolant_off,m_code,off)"       "끄기"

### Inch Metric Mode
::msgcat::mcset pb_msg_korean "MC(event,inch_metric_mode,name)"            "인치계 미터계 모드"
::msgcat::mcset pb_msg_korean "MC(event,inch_metric_mode,g_code)"          "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,inch_metric_mode,g_code,english)"  "인치계 (인치)"
::msgcat::mcset pb_msg_korean "MC(event,inch_metric_mode,g_code,metric)"   "미터계 (밀리미터)"

### Feedrates
::msgcat::mcset pb_msg_korean "MC(event,feedrates,name)"               "이송률"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,ipm_mode)"           "IPM 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,ipr_mode)"           "IPR 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,dpm_mode)"           "DPM 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mmpm_mode)"          "MMPM 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mmpr_mode)"          "MMPR 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,frn_mode)"           "FRN 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,g_code)"             "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,format)"             "형식"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,max)"                "최대"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,min)"                "최소"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,label)"         "가공속도 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,lin)"           "선형만"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,rot)"           "로타리만"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,lin_rot)"       "선형 및 로타리"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,rap_lin)"       "급속 선형만"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,rap_rot)"       "급속 로타리만"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,mode,rap_lin_rot)"   "급속 선형 및 로타리"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,cycle_mode)"         "사이클 이송률 모드"
::msgcat::mcset pb_msg_korean "MC(event,feedrates,cycle)"              "사이클"

### Cutcom On
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,name)"               "공구 보정 켜기"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,g_code)"             "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,left)"               "왼쪽"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,right)"              "오른쪽"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,app_planes)"         "적용 가능한 평면"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,edit_planes)"        "평면 코드 편집"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,reg)"                "공구 보정 등록"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,min)"                "최소"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,max)"                "최대"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_on,bef)"                "변경 전 공구 보정 끄기"

### Cutcom Off
::msgcat::mcset pb_msg_korean "MC(event,cutcom_off,name)"              "공구 보정 끄기"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_off,g_code)"            "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,cutcom_off,off)"               "끄기"

### Delay
::msgcat::mcset pb_msg_korean "MC(event,delay,name)"                   "지연"
::msgcat::mcset pb_msg_korean "MC(event,delay,seconds)"                "초"
::msgcat::mcset pb_msg_korean "MC(event,delay,seconds,g_code)"         "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,delay,seconds,format)"         "형식"
::msgcat::mcset pb_msg_korean "MC(event,delay,out_mode)"               "출력 모드"
::msgcat::mcset pb_msg_korean "MC(event,delay,out_mode,sec)"           "초만"
::msgcat::mcset pb_msg_korean "MC(event,delay,out_mode,rev)"           "회전만"
::msgcat::mcset pb_msg_korean "MC(event,delay,out_mode,feed)"          "이송률에 의존"
::msgcat::mcset pb_msg_korean "MC(event,delay,out_mode,ivs)"           "시간 반전"
::msgcat::mcset pb_msg_korean "MC(event,delay,revolution)"             "회전"
::msgcat::mcset pb_msg_korean "MC(event,delay,revolution,g_code)"      "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,delay,revolution,format)"      "형식"

### Option Stop
::msgcat::mcset pb_msg_korean "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_korean "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_korean "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_korean "MC(event,loadtool,name)"                "공구 로드"

### Stop
::msgcat::mcset pb_msg_korean "MC(event,stop,name)"                    "정지"

### Tool Preselect
::msgcat::mcset pb_msg_korean "MC(event,toolpreselect,name)"           "공구 미리 선택"

### Thread Wire
::msgcat::mcset pb_msg_korean "MC(event,threadwire,name)"              "스레드 와이어"

### Cut Wire
::msgcat::mcset pb_msg_korean "MC(event,cutwire,name)"                 "절삭 와이어"

### Wire Guides
::msgcat::mcset pb_msg_korean "MC(event,wireguides,name)"              "와이어 가이드"

### Linear Move
::msgcat::mcset pb_msg_korean "MC(event,linear,name)"                  "선형 이동"
::msgcat::mcset pb_msg_korean "MC(event,linear,g_code)"                "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,linear,motion)"                "선형 이동"
::msgcat::mcset pb_msg_korean "MC(event,linear,assume)"                "최대 가로 방향 이송률에서 가정된 급속 모드"

### Circular Move
::msgcat::mcset pb_msg_korean "MC(event,circular,name)"                "원형 이동"
::msgcat::mcset pb_msg_korean "MC(event,circular,g_code)"              "동작 G 코드"
::msgcat::mcset pb_msg_korean "MC(event,circular,clockwise)"           "시계 방향(CLW)"
::msgcat::mcset pb_msg_korean "MC(event,circular,counter-clock)"       "반시계 방향(CCLW)"
::msgcat::mcset pb_msg_korean "MC(event,circular,record)"              "원형 레코드"
::msgcat::mcset pb_msg_korean "MC(event,circular,full_circle)"         "전체 원"
::msgcat::mcset pb_msg_korean "MC(event,circular,quadrant)"            "사분원"
::msgcat::mcset pb_msg_korean "MC(event,circular,ijk_def)"             "IJK 정의"
::msgcat::mcset pb_msg_korean "MC(event,circular,ij_def)"              "IJ 정의"
::msgcat::mcset pb_msg_korean "MC(event,circular,ik_def)"              "IK 정의"
::msgcat::mcset pb_msg_korean "MC(event,circular,planes)"              "적용 가능한 평면"
::msgcat::mcset pb_msg_korean "MC(event,circular,edit_planes)"         "평면 코드 편집"
::msgcat::mcset pb_msg_korean "MC(event,circular,radius)"              "반경"
::msgcat::mcset pb_msg_korean "MC(event,circular,min)"                 "최소"
::msgcat::mcset pb_msg_korean "MC(event,circular,max)"                 "최대"
::msgcat::mcset pb_msg_korean "MC(event,circular,arc_len)"             "최소 원호 길이"

### Rapid Move
::msgcat::mcset pb_msg_korean "MC(event,rapid,name)"                   "급속 이동"
::msgcat::mcset pb_msg_korean "MC(event,rapid,g_code)"                 "G 코드"
::msgcat::mcset pb_msg_korean "MC(event,rapid,motion)"                 "급속 동작"
::msgcat::mcset pb_msg_korean "MC(event,rapid,plane_change)"           "작업 평면 변경"

### Lathe Thread
::msgcat::mcset pb_msg_korean "MC(event,lathe,name)"                   "선반 스레드"
::msgcat::mcset pb_msg_korean "MC(event,lathe,g_code)"                 "스레드 G 코드"
::msgcat::mcset pb_msg_korean "MC(event,lathe,cons)"                   "상수"
::msgcat::mcset pb_msg_korean "MC(event,lathe,incr)"                   "증분"
::msgcat::mcset pb_msg_korean "MC(event,lathe,decr)"                   "감소"

### Cycle
::msgcat::mcset pb_msg_korean "MC(event,cycle,g_code)"                 "G 코드 및 사용자 정의"
::msgcat::mcset pb_msg_korean "MC(event,cycle,customize,Label)"        "사용자 정의"
::msgcat::mcset pb_msg_korean "MC(event,cycle,customize,Context)"      "사이클을 사용자 정의하는 스위치입니다. \n\n기본적으로 각 사이클은 공통 매개변수에 정의된 값을 따릅니다. 일반적으로 공통 매개변수는 사이클에서 변경할 수 없습니다.\n\n그러나 이 스위치를 사용하면 사이클 구성을 사용자가 완전히 제어할 수 있습니다. 사용자 정의된 사이클은 공통 매개변수에서 값을 변경해도 영향을 받지 않습니다. "
::msgcat::mcset pb_msg_korean "MC(event,cycle,start,Label)"            "사이클 시작"
::msgcat::mcset pb_msg_korean "MC(event,cycle,start,Context)"          "사이클을 정의한(G81) 후 사이클 시작 블록(G79)으로 사이클을 실행하는 기계 공구에서 이 옵션을 사용합니다."
::msgcat::mcset pb_msg_korean "MC(event,cycle,start,text)"             "사이클 시작 블록을 사용하여 사이클 실행"
::msgcat::mcset pb_msg_korean "MC(event,cycle,rapid_to)"               "급속 이동 위치"
::msgcat::mcset pb_msg_korean "MC(event,cycle,retract_to)"             "진출 위치"
::msgcat::mcset pb_msg_korean "MC(event,cycle,plane_control)"          "사이클 평면 제어"
::msgcat::mcset pb_msg_korean "MC(event,cycle,com_param,name)"         "공통 매개변수"
::msgcat::mcset pb_msg_korean "MC(event,cycle,cycle_off,name)"         "사이클 끄기"
::msgcat::mcset pb_msg_korean "MC(event,cycle,plane_chng,name)"        "사이클 평면 변경"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill,name)"             "드릴"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_dwell,name)"       "드릴 드웰"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_text,name)"        "드릴 텍스트"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_csink,name)"       "드릴 카운터 싱크"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_deep,name)"        "드릴 깊이"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_brk_chip,name)"    "드릴 분할 칩"
::msgcat::mcset pb_msg_korean "MC(event,cycle,tap,name)"               "탭"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore,name)"              "보어"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_dwell,name)"        "보어 드웰"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_drag,name)"         "보어 끌기"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_no_drag,name)"      "보어 끌기 없음"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_back,name)"         "보어 뒤로"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_manual,name)"       "보어 수동"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_manual_dwell,name)" "보어 수동 드웰"
::msgcat::mcset pb_msg_korean "MC(event,cycle,peck_drill,name)"        "펙 드릴"
::msgcat::mcset pb_msg_korean "MC(event,cycle,break_chip,name)"        "분할 칩"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_dwell_sf,name)"    "드릴 드웰 (소포트 면)"
::msgcat::mcset pb_msg_korean "MC(event,cycle,drill_deep_peck,name)"   "드릴 깊이 (펙)"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_ream,name)"         "보어 (리밍)"
::msgcat::mcset pb_msg_korean "MC(event,cycle,bore_no-drag,name)"      "보어 끌기 없음"

##------------
## G Code
##
::msgcat::mcset pb_msg_korean "MC(g_code,rapid,name)"                  "동작 급속"
::msgcat::mcset pb_msg_korean "MC(g_code,linear,name)"                 "동작 선형"
::msgcat::mcset pb_msg_korean "MC(g_code,circular_clw,name)"           "원형 보간 CLW"
::msgcat::mcset pb_msg_korean "MC(g_code,circular_cclw,name)"          "원형 보간 CCLW"
::msgcat::mcset pb_msg_korean "MC(g_code,delay_sec,name)"              "지연 (초)"
::msgcat::mcset pb_msg_korean "MC(g_code,delay_rev,name)"              "지연 (회전)"
::msgcat::mcset pb_msg_korean "MC(g_code,pln_xy,name)"                 "평면 XY"
::msgcat::mcset pb_msg_korean "MC(g_code,pln_zx,name)"                 "평면 ZX"
::msgcat::mcset pb_msg_korean "MC(g_code,pln_yz,name)"                 "평면 YZ"
::msgcat::mcset pb_msg_korean "MC(g_code,cutcom_off,name)"             "공구 보정 끄기"
::msgcat::mcset pb_msg_korean "MC(g_code,cutcom_left,name)"            "공구 보정 왼쪽"
::msgcat::mcset pb_msg_korean "MC(g_code,cutcom_right,name)"           "공구 보정 오른쪽"
::msgcat::mcset pb_msg_korean "MC(g_code,length_plus,name)"            "공구 길이 조정 더하기"
::msgcat::mcset pb_msg_korean "MC(g_code,length_minus,name)"           "공구 길이 조정 빼기"
::msgcat::mcset pb_msg_korean "MC(g_code,length_off,name)"             "공구 길이 조정 끄기"
::msgcat::mcset pb_msg_korean "MC(g_code,inch,name)"                   "인치계 모드"
::msgcat::mcset pb_msg_korean "MC(g_code,metric,name)"                 "미터계 모드"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_start,name)"            "사이클 시작 코드"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_off,name)"              "사이클 끄기"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_drill,name)"            "사이클 드릴"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_drill_dwell,name)"      "사이클 드릴 스웰"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_drill_deep,name)"       "사이클 드릴 깊이"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_drill_bc,name)"         "사이클 드릴 분할 칩"
::msgcat::mcset pb_msg_korean "MC(g_code,tap,name)"                    "사이클 탭"
::msgcat::mcset pb_msg_korean "MC(g_code,bore,name)"                   "사이클 보어"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_drag,name)"              "사이클 보어 끌기"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_no_drag,name)"           "사이클 보어 끌기 없음"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_dwell,name)"             "사이클 보어 드웰"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_manual,name)"            "사이클 보어 수동"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_back,name)"              "사이클 보어 뒤로"
::msgcat::mcset pb_msg_korean "MC(g_code,bore_manual_dwell,name)"      "사이클 보어 수동 드웰"
::msgcat::mcset pb_msg_korean "MC(g_code,abs,name)"                    "절대 모드"
::msgcat::mcset pb_msg_korean "MC(g_code,inc,name)"                    "증분 모드"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_retract_auto,name)"     "사이클 진출 (자동)"
::msgcat::mcset pb_msg_korean "MC(g_code,cycle_retract_manual,name)"   "사이클 진출 (수동)"
::msgcat::mcset pb_msg_korean "MC(g_code,reset,name)"                  "재설정"
::msgcat::mcset pb_msg_korean "MC(g_code,fr_ipm,name)"                 "가공속도 모드 IPM"
::msgcat::mcset pb_msg_korean "MC(g_code,fr_ipr,name)"                 "가공속도 모드 IPR"
::msgcat::mcset pb_msg_korean "MC(g_code,fr_frn,name)"                 "가공속도 모드 FRN"
::msgcat::mcset pb_msg_korean "MC(g_code,spindle_css,name)"            "스핀들 CSS"
::msgcat::mcset pb_msg_korean "MC(g_code,spindle_rpm,name)"            "스핀들 RPM"
::msgcat::mcset pb_msg_korean "MC(g_code,ret_home,name)"               "홈으로 돌아가기"
::msgcat::mcset pb_msg_korean "MC(g_code,cons_thread,name)"            "상수 스레드"
::msgcat::mcset pb_msg_korean "MC(g_code,incr_thread,name)"            "증분 스레드"
::msgcat::mcset pb_msg_korean "MC(g_code,decr_thread,name)"            "감소 스레드"
::msgcat::mcset pb_msg_korean "MC(g_code,feedmode_in,pm)"              "가공속도 모드 IPM"
::msgcat::mcset pb_msg_korean "MC(g_code,feedmode_in,pr)"              "가공속도 모드 IPR"
::msgcat::mcset pb_msg_korean "MC(g_code,feedmode_mm,pm)"              "가공속도 모드 MMPM"
::msgcat::mcset pb_msg_korean "MC(g_code,feedmode_mm,pr)"              "가공속도 모드 MMPR"
::msgcat::mcset pb_msg_korean "MC(g_code,feedmode,dpm)"                "가공속도 모드 DPM"

##------------
## M Code
##
::msgcat::mcset pb_msg_korean "MC(m_code,stop_manual_tc,name)"         "정지/수동 공구 변경"
::msgcat::mcset pb_msg_korean "MC(m_code,stop,name)"                   "정지"
::msgcat::mcset pb_msg_korean "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_korean "MC(m_code,prog_end,name)"               "프로그램 끝"
::msgcat::mcset pb_msg_korean "MC(m_code,spindle_clw,name)"            "스핀들 켜기/CLW"
::msgcat::mcset pb_msg_korean "MC(m_code,spindle_cclw,name)"           "스핀들 CCLW"
::msgcat::mcset pb_msg_korean "MC(m_code,lathe_thread,type1)"          "상수 스레드"
::msgcat::mcset pb_msg_korean "MC(m_code,lathe_thread,type2)"          "증분 스레드"
::msgcat::mcset pb_msg_korean "MC(m_code,lathe_thread,type3)"          "감소 스레드"
::msgcat::mcset pb_msg_korean "MC(m_code,spindle_off,name)"            "스핀들 끄기"
::msgcat::mcset pb_msg_korean "MC(m_code,tc_retract,name)"             "공구 변경/진출"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_on,name)"             "냉각수 설정"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_fld,name)"            "냉각수 유동형"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_mist,name)"           "냉각수 분무형"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_thru,name)"           "냉각수 통과"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_tap,name)"            "냉각수 탭"
::msgcat::mcset pb_msg_korean "MC(m_code,coolant_off,name)"            "냉각수 해제"
::msgcat::mcset pb_msg_korean "MC(m_code,rewind,name)"                 "되감기"
::msgcat::mcset pb_msg_korean "MC(m_code,thread_wire,name)"            "스레드 와이어"
::msgcat::mcset pb_msg_korean "MC(m_code,cut_wire,name)"               "절삭 와이어"
::msgcat::mcset pb_msg_korean "MC(m_code,fls_on,name)"                 "플러시 켜기"
::msgcat::mcset pb_msg_korean "MC(m_code,fls_off,name)"                "플러시 끄기"
::msgcat::mcset pb_msg_korean "MC(m_code,power_on,name)"               "전원 켜기"
::msgcat::mcset pb_msg_korean "MC(m_code,power_off,name)"              "전력 끄기"
::msgcat::mcset pb_msg_korean "MC(m_code,wire_on,name)"                "와이어 켜기"
::msgcat::mcset pb_msg_korean "MC(m_code,wire_off,name)"               "와이어 끄기"
::msgcat::mcset pb_msg_korean "MC(m_code,pri_turret,name)"             "1차 터릿"
::msgcat::mcset pb_msg_korean "MC(m_code,sec_turret,name)"             "2차 터릿"

##------------
## UDE
##
::msgcat::mcset pb_msg_korean "MC(ude,editor,enable,Label)"            "UDE 편집기 사용"
::msgcat::mcset pb_msg_korean "MC(ude,editor,enable,as_saved,Label)"   "저장된 대로"
::msgcat::mcset pb_msg_korean "MC(ude,editor,TITLE)"                   "사용자 정의 이벤트"

::msgcat::mcset pb_msg_korean "MC(ude,editor,no_ude)"                  "관련 UDE가 없습니다!"

::msgcat::mcset pb_msg_korean "MC(ude,editor,int,Label)"               "정수"
::msgcat::mcset pb_msg_korean "MC(ude,editor,int,Context)"             "새 정수 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,real,Label)"              "실수"
::msgcat::mcset pb_msg_korean "MC(ude,editor,real,Context)"            "새 실수 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,txt,Label)"               "텍스트"
::msgcat::mcset pb_msg_korean "MC(ude,editor,txt,Context)"             "새 문자열 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,bln,Label)"               "부울"
::msgcat::mcset pb_msg_korean "MC(ude,editor,bln,Context)"             "새 부울 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,Label)"               "옵션"
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,Context)"             "새 옵션 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,pnt,Label)"               "점"
::msgcat::mcset pb_msg_korean "MC(ude,editor,pnt,Context)"             "새 점 매개변수를 오른쪽 리스트에 끌어다 놓아서 추가합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,trash,Label)"             "편집기 - 휴지통"
::msgcat::mcset pb_msg_korean "MC(ude,editor,trash,Context)"           "원하지 않는 매개변수를 제거하려면 오른쪽 리스트에서 매개변수를 선택하여 휴지통으로 끌어다 버립니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,event,Label)"             "이벤트"
::msgcat::mcset pb_msg_korean "MC(ude,editor,event,Context)"           "여기서는 MB1을 클릭해서 이벤트 매개변수를 편집할 수 없습니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,param,Label)"             "이벤트 - 매개변수"
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,Context)"           "매개변수를 편집하려면 마우스 오른쪽 버튼을 클릭합니다. 순서를 변경하려면 해당 매개변수를 끌어서 원하는 위치에 가져다 놓습니다.\n \n밝은 푸른색 매개변수는 시스템에서 정의하는 매개변수로 삭제할 수 없습니다. \n연한 갈색 매개변수는 수정하거나 삭제할 수 있습니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,param,edit,Label)"        "매개변수 - 옵션"
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,edit,Context)"      "기본 옵션을 선택하려면 MB1을 클릭합니다.\n 옵션을 편집하려면 MB1을 두 번 클릭합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,editor,Label)"      "매개변수 유형: "

::msgcat::mcset pb_msg_korean "MC(ude,editor,pnt,sel,Label)"           "선택"
::msgcat::mcset pb_msg_korean "MC(ude,editor,pnt,dsp,Label)"           "화면표시"

::msgcat::mcset pb_msg_korean "MC(ude,editor,dlg,ok,Label)"            "확인"
::msgcat::mcset pb_msg_korean "MC(ude,editor,dlg,bck,Label)"           "뒤로"
::msgcat::mcset pb_msg_korean "MC(ude,editor,dlg,cnl,Label)"           "취소"

::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,PL,Label)"       "매개변수 레이블"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,VN,Label)"       "변수 이름"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,DF,Label)"       "기본 값"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,PL,Context)"     "매개변수 레이블을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,VN,Context)"     "변수 이름을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,DF,Context)"     "기본 값을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,TG)"             "토글"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,TG,B,Label)"     "토글"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,TG,B,Context)"   "토글 값을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ON,Label)"       "켜기"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,OFF,Label)"      "끄기"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ON,Context)"     "'켜기'을 기본값으로 설정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,OFF,Context)"    "'끄기'를 기본값으로 설정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,OL)"             "옵션 리스트"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ADD,Label)"      "추가"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,CUT,Label)"      "잘라내기"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,PASTE,Label)"    "붙여넣기"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ADD,Context)"    "아이템을 추가합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,CUT,Context)"    "아이템을 잘라냅니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,PASTE,Context)"  "아이템을 붙여넣습니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ENTRY,Label)"    "옵션"
::msgcat::mcset pb_msg_korean "MC(ude,editor,paramdlg,ENTRY,Context)"  "아이템을 입력합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EN,Label)"       "이벤트 이름"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EN,Context)"     "이벤트 이름을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,PEN,Label)"      "포스트 이름"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,PEN,Context)"    "포스트 이름을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,PEN,C,Label)"    "포스트 이름"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,PEN,C,Context)"  "포스트 이름을 설정할지 여부를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EL,Label)"       "이벤트 레이블"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EL,Context)"     "이벤트 레이블을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EL,C,Label)"     "이벤트 레이블"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EL,C,Context)"   "이벤트 레이블을 설정할지 여부를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC,Label)"           "카테고리"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC,Context)"         "카테고리를 설정할지 여부를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_MILL,Label)"      "밀링"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "드릴"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "선반"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "WEDM"
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_MILL,Context)"    "밀링 카테고리를 설정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "드릴 카테고리를 설정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "선반 카테고리를 설정합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "WEDM 카테고리를 설정합니다."

::msgcat::mcset pb_msg_korean "MC(ude,editor,EDIT)"                    "이벤트 편집"
::msgcat::mcset pb_msg_korean "MC(ude,editor,CREATE)"                  "기계 제어 이벤트 생성"
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,HELP)"              "도움말"
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,EDIT)"              "사용자 정의 매개변수 편집..."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,EDIT)"              "편집..."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,VIEW)"              "뷰..."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,DELETE)"            "삭제"
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,CREATE)"            "새 기계 제어 이벤트 생성..."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,IMPORT)"            "기계 제어 이벤트 가져오기..."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_BLANK)"         "이벤트 이름은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_SAMENAME)"      "이벤트 이름이 존재합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,popup,MSG_SameHandler)"   "이벤트 핸들러가 존재하지 않습니다! \n선택된 이벤트 이름이나 포스트 이름을 수정하십시오."
::msgcat::mcset pb_msg_korean "MC(ude,validate)"                       "이벤트에 매개변수가 없습니다."
::msgcat::mcset pb_msg_korean "MC(ude,prev,tab,Label)"                 "사용자 정의 이벤트"
::msgcat::mcset pb_msg_korean "MC(ude,prev,ude,Label)"                 "기계 제어 이벤트"
::msgcat::mcset pb_msg_korean "MC(ude,prev,udc,Label)"                 "사용자 정의 사이클"
::msgcat::mcset pb_msg_korean "MC(ude,prev,mc,Label)"                  "시스템 기계 제어 이벤트"
::msgcat::mcset pb_msg_korean "MC(ude,prev,nmc,Label)"                 "비-시스템 기계 제어 이벤트"
::msgcat::mcset pb_msg_korean "MC(udc,prev,sys,Label)"                 "시스템 사이클"
::msgcat::mcset pb_msg_korean "MC(udc,prev,nsys,Label)"                "비-시스템 사이클"
::msgcat::mcset pb_msg_korean "MC(ude,prev,Status)"                    "정의할 아이템을 선택하십시오."
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,MSG_BLANK)"           "옵션 문자열은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,MSG_SAME)"            "옵션 문자열이 존재합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,MSG_PST_SAME)"        "붙여넣기한 옵션이 존재합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,MSG_IDENTICAL)"       "일부 옵션이 동일합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,opt,NO_OPT)"              "리스트에 옵션이 없습니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_NO_VNAME)"      "변수 이름은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,param,MSG_EXIST_VNAME)"   "변수 이름이 존재합니다."
::msgcat::mcset pb_msg_korean "MC(ude,editor,spindle_css,INFO)"        "이벤트가 UDE와 \"스핀들 RPM\"을 공유합니다."
::msgcat::mcset pb_msg_korean "MC(ude,import,ihr,Label)"               "포스트에서 UDE 상속"

::msgcat::mcset pb_msg_korean "MC(ude,import,ihr,Context)"             "다른 포스트에서 UDE 정의와 핸들러를 상속합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,sel,Label)"               "포스트 선택"

::msgcat::mcset pb_msg_korean "MC(ude,import,sel,Context)"             "원하는 포스트의 PUI 파일을 선택합니다. 성능을 높이려면 상속하려는 포스트와 관련된 파일(PUI, DEF, TCL, CDL)을 모두 같은 디렉토리에 넣어두는 편이 바람직합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,name_cdl,Label)"          "CDF 파일 이름"

::msgcat::mcset pb_msg_korean "MC(ude,import,name_cdl,Context)"        "선택한 포스트의 CDL 파일과 경로 이름을 이 포스트의 정의 파일에서 참조합니다(INCLUDE). 경로 이름을 지정하는 경우 경로 이름은 UG 환경 변수(\\\$UGII)로 시작해야 합니다. 경로가 없으면 UG/NX 런타임 시 UGII_CAM_FILE_SEARCH_PATH를 사용하여 파일을 검색합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,name_def,Label)"          "정의 파일 이름"
::msgcat::mcset pb_msg_korean "MC(ude,import,name_def,Context)"        "선택한 포스트의 정의 파일과 경로 이름을 이 포스트의 정의 파일에서 참조합니다(INCLUDE). 경로 이름을 지정하는 경우 경로 이름은 UG 환경 변수(\\\$UGII)로 시작해야 합니다. 경로가 없으면 UG/NX 런타임 시 UGII_CAM_FILE_SEARCH_PATH를 사용하여 파일을 검색합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_korean "MC(ude,import,ihr_pst,Label)"           "포스트"
::msgcat::mcset pb_msg_korean "MC(ude,import,ihr_folder,Label)"        "폴더"
::msgcat::mcset pb_msg_korean "MC(ude,import,own_folder,Label)"        "폴더"
::msgcat::mcset pb_msg_korean "MC(ude,import,own,Label)"               "자신의 CDL 파일 포함"

::msgcat::mcset pb_msg_korean "MC(ude,import,own,Context)"             "포스트 정의 파일에 자신의 CDF 파일을 참조합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,own_ent,Label)"           "자신의 CDL 파일"

::msgcat::mcset pb_msg_korean "MC(ude,import,own_ent,Context)"         "이 포스트의 정의 파일에서 참조할(INCLUDE) CDL 파일 이름과 경로입니다. 실제 파일 이름은 포스트를 저장할 때 결정됩니다. 경로 이름을 지정하는 경우 경로 이름은 UG 환경 변수(\\\$UGII)로 시작해야 합니다. 경로를 지정하지 않으면 UG/NX 런타임 시 UGII_CAM_FILE_SEARCH_PATH를 사용하여 파일을 검색합니다."

::msgcat::mcset pb_msg_korean "MC(ude,import,sel,pui,status)"          "PUI 파일을 선택합니다."
::msgcat::mcset pb_msg_korean "MC(ude,import,sel,cdl,status)"          "CDL 파일을 선택합니다."

##---------
## UDC
##
::msgcat::mcset pb_msg_korean "MC(udc,editor,TITLE)"                   "사용자 정의 사이클"
::msgcat::mcset pb_msg_korean "MC(udc,editor,CREATE)"                  "사용자 정의 사이클 생성"
::msgcat::mcset pb_msg_korean "MC(udc,editor,TYPE)"                    "사이클 유형"
::msgcat::mcset pb_msg_korean "MC(udc,editor,type,UDC)"                "사용자 정의"
::msgcat::mcset pb_msg_korean "MC(udc,editor,type,SYSUDC)"             "시스템 정의"
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCLBL,Label)"            "사이클 레이블"
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCNAME,Label)"           "사이클 이름"
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCLBL,Context)"          "사이클 레이블을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCNAME,Context)"         "사이클 이름을 지정합니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCLBL,C,Label)"          "사이클 레이블"
::msgcat::mcset pb_msg_korean "MC(udc,editor,CYCLBL,C,Context)"        "사이클 레이블을 설정하는 스위치입니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,EDIT)"              "사용자 정의 매개변수 편집..."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,MSG_BLANK)"         "사이클 이름은 비워둘 수 없습니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,MSG_SAMENAME)"      "사이클 이름이 존재합니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,MSG_SameHandler)"   "이벤트 핸들러가 존재합니다!\n 사이클 이벤트 이름을 변경하십시오."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,MSG_ISSYSCYC)"      "사이클 이름이 시스템 사이클 유형에 속합니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "이미 존재하는 시스템 사이클 유형입니다."
::msgcat::mcset pb_msg_korean "MC(udc,editor,EDIT)"                    "사이클 이벤트 편집"
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,CREATE)"            "새 사용자 정의 사이클 생성..."
::msgcat::mcset pb_msg_korean "MC(udc,editor,popup,IMPORT)"            "사용자 정의 사이클 가져오기..."
::msgcat::mcset pb_msg_korean "MC(udc,drill,csink,INFO)"               "이 이벤트는 드릴과 핸들러를 공유합니다."
::msgcat::mcset pb_msg_korean "MC(udc,drill,simulate,INFO)"            "이 이벤트는 시뮬레이션된 사이클의 일종입니다."
::msgcat::mcset pb_msg_korean "MC(udc,drill,dwell,INFO)"               "이 이벤트는 다음과 사용자 정의 사이클을 공유합니다: "


#######
# IS&V
#######
::msgcat::mcset pb_msg_korean "MC(isv,tab,label)"                      "가상 N/C 컨트롤러"
::msgcat::mcset pb_msg_korean "MC(isv,Status)"                         "ISV 매개변수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(isv,review,Status)"                  "VNC 명령을 검토합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,Label)"                    "구성"
::msgcat::mcset pb_msg_korean "MC(isv,vnc_command,Label)"              "VNC 명령"
####################
# General Definition
####################
::msgcat::mcset pb_msg_korean "MC(isv,select_Main)"                    "종속 VNC의 마스터가 될 VNC 파일을 선택합니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,machine,Label)"            "기계 공구"
::msgcat::mcset pb_msg_korean "MC(isv,setup,component,Label)"          "공구 마운팅"
::msgcat::mcset pb_msg_korean "MC(isv,setup,mac_zcs_frame,Label)"      "프로그램 0 참조"
::msgcat::mcset pb_msg_korean "MC(isv,setup,mac_zcs,Label)"            "컴포넌트"
::msgcat::mcset pb_msg_korean "MC(isv,setup,mac_zcs,Context)"          "ZCS 참조 기준으로 사용할 컴포넌트를 지정합니다. 운동학 트리에서 파트가 직접 혹은 간접적으로 연결되어 있으며 회전하지 않는 컴포넌트라야 합니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,spin_com,Label)"           "컴포넌트"
::msgcat::mcset pb_msg_korean "MC(isv,setup,spin_com,Context)"         "공구를 장착할 컴포넌트를 지정합니다. 밀링 포스트에서는 스핀들 컴포넌트, 선반 포스트에서는 터릿 컴포넌트라야 합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,spin_jct,Label)"           "연결"
::msgcat::mcset pb_msg_korean "MC(isv,setup,spin_jct,Context)"         "공구를 장착할 연결부를 정의합니다. 밀링 포스트에서는 스핀들 면의 중심 연결부입니다. 선반 포스트에서는 터릿 회전 연결부입니다. 터릿이 고정된 경우는 공구 장착 연결부입니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,axis_name,Label)"          "기계 공구에 지정된 축"
::msgcat::mcset pb_msg_korean "MC(isv,setup,axis_name,Context)"        "기계 공구 운동학 구성과 일치시킬 축 이름을 지정합니다."




::msgcat::mcset pb_msg_korean "MC(isv,setup,axis_frm,Label)"           "NC 축 이름"
::msgcat::mcset pb_msg_korean "MC(isv,setup,rev_fourth,Label)"         "회전 반전"
::msgcat::mcset pb_msg_korean "MC(isv,setup,rev_fourth,Context)"       "축 회전 방향을 지정합니다. 역방향이라도 상관이 업습니다. 이 값은 로타리 테이블에만 적용됩니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,rev_fifth,Label)"          "회전 반전"

::msgcat::mcset pb_msg_korean "MC(isv,setup,fourth_limit,Label)"       "로타리 한계"
::msgcat::mcset pb_msg_korean "MC(isv,setup,fourth_limit,Context)"     "로타리 축에 한계가 있는지 여부를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,fifth_limit,Label)"        "로타리 한계"
::msgcat::mcset pb_msg_korean "MC(isv,setup,limiton,Label)"            "예"
::msgcat::mcset pb_msg_korean "MC(isv,setup,limitoff,Label)"           "아니오"
::msgcat::mcset pb_msg_korean "MC(isv,setup,fourth_table,Label)"       "4축"
::msgcat::mcset pb_msg_korean "MC(isv,setup,fifth_table,Label)"        "5축"
::msgcat::mcset pb_msg_korean "MC(isv,setup,header,Label)"             " 테이블 "
::msgcat::mcset pb_msg_korean "MC(isv,setup,intialization,Label)"      "컨트롤러"
::msgcat::mcset pb_msg_korean "MC(isv,setup,general_def,Label)"        "초기 설정"
::msgcat::mcset pb_msg_korean "MC(isv,setup,advanced_def,Label)"       "기타 옵션"
::msgcat::mcset pb_msg_korean "MC(isv,setup,InputOutput,Label)"        "측수 NC 코드"

::msgcat::mcset pb_msg_korean "MC(isv,setup,program,Label)"            "기본 프로그램 정의"
::msgcat::mcset pb_msg_korean "MC(isv,setup,output,Label)"             "프로그램 정의 내보내기"
::msgcat::mcset pb_msg_korean "MC(isv,setup,output,Context)"           "프로그램 정의를 파일에 저장합니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,input,Label)"              "프로그램 정의 가져오기"
::msgcat::mcset pb_msg_korean "MC(isv,setup,input,Context)"            "파일에서 프로그램 정의를 가져옵니다."
::msgcat::mcset pb_msg_korean "MC(isv,setup,file_err,Msg)"             "선택한 파일은 기본 프로그램 정의 파일 유형이 아닙니다. 계속하시겠습니까?"
::msgcat::mcset pb_msg_korean "MC(isv,setup,wcs,Label)"                "치공구 옵셋"
::msgcat::mcset pb_msg_korean "MC(isv,setup,tool,Label)"               "공구 데이터"
::msgcat::mcset pb_msg_korean "MC(isv,setup,g_code,Label)"             "특수 G 코드"
::msgcat::mcset pb_msg_korean "MC(isv,setup,special_vnc,Label)"        "특수 NC 코드"

::msgcat::mcset pb_msg_korean "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_korean "MC(isv,setup,initial_motion,Label)"     "동작"
::msgcat::mcset pb_msg_korean "MC(isv,setup,initial_motion,Context)"   "기계 공구의 초기 동작을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,spindle,frame,Label)"      "스핀들"
::msgcat::mcset pb_msg_korean "MC(isv,setup,spindle_mode,Label)"       "모드"
::msgcat::mcset pb_msg_korean "MC(isv,setup,spindle_direction,Label)"  "방향"
::msgcat::mcset pb_msg_korean "MC(isv,setup,spindle,frame,Context)"    "초기 스핀들 속도 단위와 로타리 방향을 지정합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,feedrate_mode,Label)"      "이송률 모드"
::msgcat::mcset pb_msg_korean "MC(isv,setup,feedrate_mode,Context)"    "초기 이송율 단위를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,boolean,frame,Label)"      "부울 아이템 정의"
::msgcat::mcset pb_msg_korean "MC(isv,setup,power_on_wcs,Label)"       "전원 WCS  "
::msgcat::mcset pb_msg_korean "MC(isv,setup,power_on_wcs,Context)"     "0  - 기본 기계 0 좌표를 사용합니다.\n 1 - 첫 번째 사용자 정의 치공구 옵셋을 사용합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,use_s_leader,Label)"       "S 사용"
::msgcat::mcset pb_msg_korean "MC(isv,setup,use_f_leader,Label)"       "F 사용"


::msgcat::mcset pb_msg_korean "MC(isv,setup,dog_leg,Label)"            "도그레그 급속"
::msgcat::mcset pb_msg_korean "MC(isv,setup,dog_leg,Context)"          "On - 도그레그 형식으로 급속 이동합니다. OFF - NC 코드에 따라 (점 대 점으로) 급속 이동합니다."

::msgcat::mcset pb_msg_korean "MC(isv,setup,dog_leg,yes)"              "예"
::msgcat::mcset pb_msg_korean "MC(isv,setup,dog_leg,no)"               "아니오"

::msgcat::mcset pb_msg_korean "MC(isv,setup,on_off_frame,Label)"       "켜짐/꺼짐 정의"
::msgcat::mcset pb_msg_korean "MC(isv,setup,stroke_limit,Label)"       "스트로크 한계"
::msgcat::mcset pb_msg_korean "MC(isv,setup,cutcom,Label)"             "공구 보정"
::msgcat::mcset pb_msg_korean "MC(isv,setup,tl_adjust,Label)"          "공구 길이 조정"
::msgcat::mcset pb_msg_korean "MC(isv,setup,scale,Label)"              "배율"
::msgcat::mcset pb_msg_korean "MC(isv,setup,macro_modal,Label)"        "매크로 모달"
::msgcat::mcset pb_msg_korean "MC(isv,setup,wcs_rotate,Label)"         "WCS 회전"
::msgcat::mcset pb_msg_korean "MC(isv,setup,cycle,Label)"              "사이클"

::msgcat::mcset pb_msg_korean "MC(isv,setup,initial_mode,frame,Label)"     "입력 모드"
::msgcat::mcset pb_msg_korean "MC(isv,setup,initial_mode,frame,Context)"   "초기 입력 모드를 지정합니다. 값은 절대 혹은 증분 중 하나입니다."

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,rewindstop,Label)"   "되감기 정지 코드"
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,rewindstop,Context)" "되감기 정지 코드를 지정합니다."

::msgcat::mcset pb_msg_korean "MC(isv,control_var,frame,Label)"        "제어 변수"

::msgcat::mcset pb_msg_korean "MC(isv,sign_define,convarleader,Label)"     "리더"
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,convarleader,Context)"   "컨트롤러 변수를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,conequ,Label)"           "등호 부호"
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,conequ,Context)"         "제어 등호 부호를 지정합니다."
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,percent,Label)"          "백분율 기호 %"
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,leaderjing,Label)"       "샤프 #"
::msgcat::mcset pb_msg_korean "MC(isv,sign_define,text_string,Label)"      "텍스트 문자열"

::msgcat::mcset pb_msg_korean "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_korean "MC(isv,input_mode,Label)"               "초기 모드"
::msgcat::mcset pb_msg_korean "MC(isv,absolute_mode,Label)"            "절대"
::msgcat::mcset pb_msg_korean "MC(isv,incremental_style,frame,Label)"  "증분 모드"

::msgcat::mcset pb_msg_korean "MC(isv,incremental_mode,Label)"         "증분"
::msgcat::mcset pb_msg_korean "MC(isv,incremental_gcode,Label)"        "G 코드"
::msgcat::mcset pb_msg_korean "MC(isv,incremental_gcode,Context)"      "절대 모드와 증분 모드를 구분하기 위해 G90 G91을 사용합니다."
::msgcat::mcset pb_msg_korean "MC(isv,incremental_uvw,Label)"          "특수 리더"
::msgcat::mcset pb_msg_korean "MC(isv,incremental_uvw,Context)"        "절대 모드와 증분 모드를 구분하기 위해 특수 리더를 사용합니다. 예를 들면, 리더 X Y Z는 절대 모드를 나타내고, 리더 U V W는 증분 모드를 나타냅니다."
::msgcat::mcset pb_msg_korean "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_korean "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_korean "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_korean "MC(isv,incr_a,Label)"                   "4축 "
::msgcat::mcset pb_msg_korean "MC(isv,incr_b,Label)"                   "5축 "

::msgcat::mcset pb_msg_korean "MC(isv,incr_x,Context)"                 "증분 스타일에서 사용되는 특수 X 축 리더 지정"
::msgcat::mcset pb_msg_korean "MC(isv,incr_y,Context)"                 "증분 스타일에서 사용되는 특수 Y 축 리더 지정"
::msgcat::mcset pb_msg_korean "MC(isv,incr_z,Context)"                 "증분 스타일에서 사용되는 특수 Z 축 리더 지정"
::msgcat::mcset pb_msg_korean "MC(isv,incr_a,Context)"                 "증분 스타일에서 사용되는 특수 4축 리더 지정"
::msgcat::mcset pb_msg_korean "MC(isv,incr_b,Context)"                 "증분 스타일에서 사용되는 특수 5축 리더 지정"
::msgcat::mcset pb_msg_korean "MC(isv,vnc_mes,frame,Label)"            "VNC 메시지 출력"

::msgcat::mcset pb_msg_korean "MC(isv,vnc_message,Label)"              "VNC 메시지 리스트"
::msgcat::mcset pb_msg_korean "MC(isv,vnc_message,Context)"            "이 옵션을 선택하면 시뮬레이션 중 오퍼레이션 메시지 윈도우에 VNC 디버그 메시지가 모두 출력됩니다."

::msgcat::mcset pb_msg_korean "MC(isv,vnc_mes,prefix,Label)"           "메시지 접두어"
::msgcat::mcset pb_msg_korean "MC(isv,spec_desc,Label)"                "설명"
::msgcat::mcset pb_msg_korean "MC(isv,spec_codelist,Label)"            "코드 리스트"
::msgcat::mcset pb_msg_korean "MC(isv,spec_nccode,Label)"              "NC 코드 / 문자열"

################
# WCS Definition
################
::msgcat::mcset pb_msg_korean "MC(isv,machine_zero,offset,Label)"      "기계 공구 0 연결에서\n기계 공구 0 옵셋"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,frame,Label)"         "치공구 옵셋"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_leader,Label)"               " 코드 "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,origin_x,Label)"      " X-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,origin_y,Label)"      " Y-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,origin_z,Label)"      " Z-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,a_offset,Label)"      " A-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,b_offset,Label)"      " B-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,c_offset,Label)"      " C-옵셋  "
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,wcs_num,Label)"       "좌표계"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,wcs_num,Context)"     "추가할 고정 옵셋 번호 지정"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,wcs_add,Label)"       "추가"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,wcs_add,Context)"     "새 고정 옵셋 좌표계 추가 및 위치 지정"
::msgcat::mcset pb_msg_korean "MC(isv,wcs_offset,wcs_err,Msg)"         "이미 존재하는 좌표계입니다."
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,frame,Label)"          "공구 정보"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,tool_entry,Label)"     "새 공구 이름 입력"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,tool_name,Label)"      "       이름       "

::msgcat::mcset pb_msg_korean "MC(isv,tool_info,tool_num,Label)"       " 공구 "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,add_tool,Label)"       "추가"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,tool_diameter,Label)"  " 직경 "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,offset_usder,Label)"   "   공구 팁 옵셋   "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,carrier_id,Label)"     " 캐리어 ID "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,pocket_id,Label)"      " 포켓 ID "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,cutcom_reg,Label)"     "     공구 보정     "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,cutreg,Label)"         "등록 "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,cutval,Label)"         "옵셋 "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,adjust_reg,Label)"     " 길이 조정 "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,tool_type,Label)"      "   유형   "
::msgcat::mcset pb_msg_korean "MC(isv,prog,setup,Label)"               "기본 프로그램 정의"
::msgcat::mcset pb_msg_korean "MC(isv,prog,setup_right,Label)"         "프로그램 정의"
::msgcat::mcset pb_msg_korean "MC(isv,output,setup_data,Label)"        "프로그램 정의 파일 지정"
::msgcat::mcset pb_msg_korean "MC(isv,input,setup_data,Label)"         "프로그램 정의 파일 선택"

::msgcat::mcset pb_msg_korean "MC(isv,tool_info,toolnum,Label)"        "공구 번호  "
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,toolnum,Context)"      "추가할 공구 번호 지정"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,add_tool,Context)"     "새 공구를 추가하고 매개변수 지정"
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,add_err,Msg)"          "공구 번호가 이미 존재합니다."
::msgcat::mcset pb_msg_korean "MC(isv,tool_info,name_err,Msg)"         "공구 이름은 비워둘 수 없습니다!"

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_korean "MC(isv,g_code,frame,Label)"             "특수 G 코드"
::msgcat::mcset pb_msg_korean "MC(isv,g_code,frame,Context)"           "시뮬레이션에서 사용할 특수 G 코드 지정"
::msgcat::mcset pb_msg_korean "MC(isv,g_code,from_home,Label)"         "홈에서 시작"
::msgcat::mcset pb_msg_korean "MC(isv,g_code,return_home,Label)"       "홈으로 돌아가기"
::msgcat::mcset pb_msg_korean "MC(isv,g_code,mach_wcs,Label)"          "기계 데이텀 이동"
::msgcat::mcset pb_msg_korean "MC(isv,g_code,set_local,Label)"         "로컬 좌표 설정"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,frame,Label)"       "특수 NC 명령"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,frame,Context)"     "특수 디바이스에 사용되는 NC 명령"


::msgcat::mcset pb_msg_korean "MC(isv,spec_pre,frame,Label)"           "프리프로세스 명령"
::msgcat::mcset pb_msg_korean "MC(isv,spec_pre,frame,Context)"         "블록 좌표를 구문 분석하기 전에 처리해야 할 토큰이나 심볼을 포함하는 명령 리스트입니다."

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,add,Label)"         "추가"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,edit,Label)"        "편집"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,delete,Label)"      "삭제"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,title,Label)"       "기타 디바이스의 특수 명령"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,add_sim,Label)"     "SIM 명령 @커서 추가"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,init_sim,Label)"    "명령 하나를 선택하십시오."

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,preleader,Label)"   "리더"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,preleader,Context)" "사용자 정의 프리프로세스 명령의 리더 지정"

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,precode,Label)"     "코드"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,precode,Context)"   "사용자 정의 프리프로세스 명령의 리더 지정"

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,leader,Label)"      "리더"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,leader,Context)"    "사용자 정의 명령의 리더 지정"

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,code,Label)"        "코드"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,code,Context)"      "사용자 정의 명령의 리더 지정"

::msgcat::mcset pb_msg_korean "MC(isv,spec_command,add,Context)"       "새로운 사용자 정의 명령 추가"
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,add_err,Msg)"       "이미 처리된 토큰입니다."
::msgcat::mcset pb_msg_korean "MC(isv,spec_command,sel_err,Msg)"       "명령을 선택하십시오."
::msgcat::mcset pb_msg_korean "MC(isv,export,error,title)"             "경고"

::msgcat::mcset pb_msg_korean "MC(isv,tool_table,title,Label)"         "공구 테이블"
::msgcat::mcset pb_msg_korean "MC(isv,ex_editor,warning,Msg)"          "시스템에서 생성한 VNC 명령입니다. 변경을 저장할 수 없습니다."


# - Languages
#
::msgcat::mcset pb_msg_korean "MC(language,Label)"                     "언어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_english)"                     "영어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_french)"                      "불어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_german)"                      "독어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_italian)"                     "이탈리아어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_japanese)"                    "일본어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_korean)"                      "한국어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_russian)"                     "러시아어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_simple_chinese)"              "중국어 간체"
::msgcat::mcset pb_msg_korean "MC(pb_msg_spanish)"                     "스페인어"
::msgcat::mcset pb_msg_korean "MC(pb_msg_traditional_chinese)"         "번체"

### Exit Options Dialog
::msgcat::mcset pb_msg_korean "MC(exit,options,Label)"                 "종료 옵션"
::msgcat::mcset pb_msg_korean "MC(exit,options,SaveAll,Label)"         "모두 저장 후 종료"
::msgcat::mcset pb_msg_korean "MC(exit,options,SaveNone,Label)"        "저장하지 않고 종료"
::msgcat::mcset pb_msg_korean "MC(exit,options,SaveSelect,Label)"      "선택한 항목만 저장하고 종료"

### OptionMenu Items
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Other)"       "기타"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,None)"        "없음"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,RT_R)"        "급속 이동 및 R"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Rapid)"       "급속"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,RS)"          "급속 스핀들"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,C_off_RS)"    "사이클을 끈 후 급속 스핀들"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Auto)"        "자동"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Abs_Inc)"     "절대/증분"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Abs_Only)"    "절대만"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Inc_Only)"    "증분만"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,SD)"          "최단 거리"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,AP)"          "항상 양수"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,AN)"          "항상 음수"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Z_Axis)"      "Z 축"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,+X_Axis)"     "+X 축"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,-X_Axis)"     "-X 축"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,Y_Axis)"      "Y 축"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,MDD)"         "크기로 방향 결정"
::msgcat::mcset pb_msg_korean "MC(optionMenu,item,SDD)"         "부호로 방향 결정"
