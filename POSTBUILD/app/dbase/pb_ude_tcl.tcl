#23
proc PB_ude_UdeInitParse {this POST_OBJ} {
upvar $POST_OBJ post_obj
set event_start_flag 0
set param_start_flag 0
set event_create_flag 0
set param_create_flag 0
set param_attr ""
set event_attr ""
set param_obj_list ""
set event_obj_list ""
set ude_obj_list ""
while { [gets $File::($this,FilePointer) line] >= 0 }\
{
set line [string trimleft $line " "]
set comnt_check [string index $line 0]
if {[string compare $comnt_check #] == 0||[string compare $comnt_check ""] == 0}\
{
continue
} else\
{
set line_length [string length $line]
set last_char_test [string index $line [expr $line_length - 1]]
if {[string compare $last_char_test \\] == 0}\
{
set line_wo_sl [string range $line 0 [expr $line_length - 2]]
append temp_line $line_wo_sl
continue
} elseif {[info exists temp_line]}\
{
append temp_line $line
set line $temp_line
unset temp_line
}
PB_ude_UdeSecParse line event_start_flag param_start_flag \
event_create_flag param_create_flag \
event_attr param_attr param_obj_list \
event_obj_list
}
}
PB_ude_CreateLastParamEvtObj param_attr param_obj_list event_attr \
event_obj_list ude_obj_list
set Post::($post_obj,ude_obj) $ude_obj_list
}
proc PB_ude_UdeSecParse {LINE EVENT_START_FLAG PARAM_START_FLAG \
EVENT_CREATE_FLAG PARAM_CREATE_FLAG \
EVENT_ATTR PARAM_ATTR PARAM_OBJ_LIST \
EVENT_OBJ_LIST} {
upvar $LINE line
upvar $EVENT_START_FLAG event_start_flag
upvar $PARAM_START_FLAG param_start_flag
upvar $EVENT_CREATE_FLAG event_create_flag
upvar $PARAM_CREATE_FLAG param_create_flag
upvar $EVENT_ATTR event_attr
upvar $PARAM_ATTR param_attr
upvar $PARAM_OBJ_LIST param_obj_list
upvar $EVENT_OBJ_LIST event_obj_list
switch -glob $line\
{
EVENT*      {
set event_start_flag 1
if {$event_create_flag}\
{
if {$param_create_flag}\
{
PB_ude_CreateParamObjAttr param_attr param_obj_list
unset param_attr
set param_create_flag 0
}
PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list
unset event_attr
set param_start_flag 0
set event_create_flag 0
}
}
}
if {$event_start_flag}\
{
set event_create_flag 1
if {!$param_start_flag}\
{
switch -glob $line\
{
EVENT*         {
lappend event_attr $line
}
POST_EVENT*    {
lappend event_attr $line
}
UI_LABEL*      {
lappend event_attr $line
}
CATEGORY*      {
lappend event_attr $line
}
}
}
switch -glob $line\
{
PARAM*    {
set param_start_flag 1
if {$param_create_flag}\
{
PB_ude_CreateParamObjAttr param_attr param_obj_list
unset param_attr
set param_create_flag 0
}
lappend param_attr $line
}
}
if {$param_start_flag}\
{
switch -glob $line\
{
TYPE*         {
lappend param_attr $line
}
DEFVAL*       {
lappend param_attr $line
}
OPTIONS*      {
lappend param_attr $line
}
UI_LABEL*     {
lappend param_attr $line
}
TOGGLE*       {
lappend param_attr $line
}
}
set param_create_flag 1
}
}
}
proc PB_ude_CreateEventObjAttr {ATTR_LIST PARAM_OBJ_LIST EVENT_OBJ_LIST} {
upvar $ATTR_LIST attr_list
upvar $PARAM_OBJ_LIST param_obj_list
upvar $EVENT_OBJ_LIST event_obj_list
set pevt_srch [lsearch $attr_list POST_EVENT*]
set lbl_srch [lsearch $attr_list UI_LABEL*]
set cat_srch [lsearch $attr_list CATEGORY*]
if {$pevt_srch == -1}\
{
lappend attr_list {POST_EVENT ""}
}
if {$lbl_srch == -1}\
{
lappend attr_list {UI_LABEL ""}
}
if {$cat_srch == -1}\
{
lappend attr_list {CATEGORY ""}
}
foreach attr $attr_list\
{
switch -glob $attr\
{
EVENT*      {
set event_obj_attr(0) [lindex $attr 1]
}
POST_EVENT* {
set event_obj_attr(1) [lindex $attr 1]
}
UI_LABEL*   {
set event_obj_attr(2) [lindex $attr 1]
}
CATEGORY*   {
set event_obj_attr(3) [lrange $attr 1 end]
}
}
}
set event_obj_attr(4) $param_obj_list
unset param_obj_list
PB_ude_CreateEventObj event_obj_attr event_obj_list
}
proc PB_ude_CreateParamObjAttr {ATTR_LIST PARAM_OBJ_LIST} {
upvar $ATTR_LIST attr_list
upvar $PARAM_OBJ_LIST param_obj_list
PB_ude_InitParamAttr attr_list
foreach attr $attr_list\
{
switch -glob $attr\
{
PARAM*    {
set param_obj_attr(0) [lindex $attr 1]
}
TYPE*     {
set param_obj_attr(1) [lindex $attr 1]
}
DEFVAL*   {
set param_obj_attr(2) [lindex $attr 1]
}
OPTIONS*  {
set param_obj_attr(3) [string trimleft $attr "OPTIONS "]
}
TOGGLE*   {
if {![string compare $param_obj_attr(1) s]}\
{
set param_obj_attr(2) [lindex $attr 1]
} else\
{
set param_obj_attr(3) [lindex $attr 1]
}
}
UI_LABEL* {
if {[string compare $param_obj_attr(1) s] == 0 || \
[string compare $param_obj_attr(1) b] == 0}\
{
set param_obj_attr(3) [lindex $attr 1]
} elseif {[string compare $param_obj_attr(1) p] == 0}\
{
set param_obj_attr(2) [lindex $attr 1]
} else\
{
set param_obj_attr(4) [lindex $attr 1]
}
}
}
}
PB_ude_CreateParamObj param_obj_attr param_obj_list
}
proc PB_ude_InitParamAttr {ATTR_LIST} {
upvar $ATTR_LIST attr_list
set test [lsearch $attr_list TYPE*]
set type_elem [lindex $attr_list $test]
set dtype [lindex $type_elem 1]
switch $dtype\
{
i - d - \
o - b     {
set dval_srch [lsearch $attr_list DEFVAL*]
if {$dval_srch == -1}\
{
lappend attr_list {DEFVAL ""}
}
switch $dtype\
{
i - d  {
set tog_srch [lsearch $attr_list TOGGLE*]
if {$tog_srch == -1}\
{
lappend attr_list {TOGGLE ""}
}
}
}
}
s         {
set tog_srch [lsearch $attr_list TOGGLE*]
if {$tog_srch == -1}\
{
lappend attr_list {TOGGLE ""}
}
}
}
set lbl_srch [lsearch $attr_list UI_LABEL*]
if {$lbl_srch == -1}\
{
lappend attr_list {UI_LABEL ""}
}
}
proc PB_ude_CreateLastParamEvtObj {PARAM_ATTR PARAM_OBJ_LIST EVENT_ATTR \
EVENT_OBJ_LIST UDE_OBJ_LIST} {
upvar $PARAM_ATTR param_attr
upvar $PARAM_OBJ_LIST param_obj_list
upvar $EVENT_ATTR event_attr
upvar $EVENT_OBJ_LIST event_obj_list
upvar $UDE_OBJ_LIST ude_obj_list
PB_ude_CreateParamObjAttr param_attr param_obj_list
PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list
set ude_obj_attr(0) DEFALUT
set ude_obj_attr(1) $event_obj_list
PB_ude_CreateUdeObject ude_obj_attr ude_obj_list
}
proc PB_ude_CreateParamObj { OBJ_ATTR OBJ_LIST } {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set object [param::CreateObject obj_attr(1)]
lappend obj_list $object
param::ObjectSetValue $object obj_attr
}
proc PB_ude_CreateEventObj { OBJ_ATTR OBJ_LIST } {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set object [new ude_event]
lappend obj_list $object
ude_event::setvalue $object obj_attr
}
proc PB_ude_CreateUdeObject { OBJ_ATTR OBJ_LIST } {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set object [new ude]
lappend obj_list $object
ude::setvalue $object obj_attr
}


