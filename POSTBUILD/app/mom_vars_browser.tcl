#=======================================================================
#
#
#
#
#=======================================================================

#=======================================================================
proc MR_readCSVFile { } {
  global __hello_var_names   __hello_class_names __hello_des_names;
  global __hello_value_names __hello_type_names  __hello_def_names;
  global MR_file;
  global env PB_HOME gPB_mom_var_values;
  if { [info exists env(PB_HOME)] } { ;
     set fid [open $gPB_mom_var_values];
  } elseif { [file exists $MR_file] } {
          set fid [open $MR_file];
  } elseif { [info exists gPB_mom_var_values] } {
           set fid [open $gPB_mom_var_values];
        } ;
  if { ![info exists fid] } { return 0; } ;
  while { ![eof $fid] } {
    gets $fid line;
    set line [string trim $line];
    if { $line != "" && ![string match "#*" $line] } {
      if { [MR_stringEqual $line "Mom" 2] } {
      } else {
        if { [MR_stringEqual \" $line 0] } {
          set ind1 1;
          set quoted [string range $line 1 end];
          set ind2 [string first \" $quoted];
          incr ind2 -1;
          set var_name [string range $quoted 0 $ind2];
          set inc $ind2;
          set ind3 [incr inc 4];
        } elseif { [MR_stringEqual "MOM_" $line 3] } {
                  set ind1 [string first "MOM_" $line];
                  if { [string first "," $line] != -1 } {
                     set ind2 [string first "," $line];
                     incr ind2 -1;
                  } else {
                     set ind2 [string wordend $line 0];
                     incr ind2 1;
                  } ;
                  set var_name [string range $line $ind1 $ind2];
                  set inc $ind2;
                  set ind3 [incr inc 2];
              } elseif { [string length $line] != 0 } {
                        set ind1 [string first "mom_" $line];
                        if { [string first "," $line] != -1 } {
                           set ind2 [string first "," $line];
                           incr ind2 -1;
                        } else {
                           set ind2 [string wordend $line 0];
                           incr ind2 1;
                        } ;
                        set var_name [string range $line $ind1 $ind2];
                        set inc $ind2;
                        set ind3 [incr inc 2];
                    } ;
        set __hello_var_names($var_name) $var_name;
        if { [string index $line $ind3] == "" } {
          set __hello_class_names($var_name) "";
          set __hello_des_names($var_name) "";
          set __hello_value_names($var_name) "";
          set __hello_type_names($var_name) "";
        } elseif { [MR_stringEqual $var_name "" end] } {
              } else {
                set class_line [string range $line $ind3 end];
                set ind4 [string first "," $class_line];
                set inc $ind4;
                incr ind4 -1;
                if { [MR_stringEqual $ind3 $ind4 end] } {
                  set class_name "";
                } elseif { [string index $class_line $inc] != "," } {
                        incr inc -1;
                        set class_name [string range $class_line 0 $inc];
                      } else {
                        set class_name [string range $class_line 0 $ind4];
                      } ;
                set __hello_class_names($var_name) $class_name;
                set __hello_class_names($class_name) $class_name;
                set ind5 [incr ind4 2];
                set new_line [string range $class_line $ind5 end];
                if { [MR_stringCompareLength \" $new_line 0] == 0 } {
                  set quoted [string range $new_line 1 end];
                  set ind6 [string first \" $quoted];
                  incr ind6 -1;
                  set des_name [string range $quoted 0 $ind6];
                  incr ind6 2;
                } elseif { [string length $new_line] != 0 } {
                        if { ![MR_stringEqual $var_name "" end] } {
                          set ind6 [string first "," $new_line];
                          incr ind6 -1;
                          if { [MR_stringEqual $ind5 $ind6 end] } {
                            set des_name "";
                          } else {
                            set des_name [string range $new_line 0 $ind6];
                          }
                        }
                    } else { set des_name ""; } ;
                set __hello_des_names($var_name) $des_name;
                set ind7 [incr ind6 2];
                set new_line2 [string range $new_line $ind7 end];
                set endFlag 0;
                if { [string first \" $new_line2] == 0 } {
                  set quoted [string range $new_line2 1 end];
                  set endQuote [string first \" $quoted];
                  set value_name [string range $new_line2 1 $endQuote];
                  set inc $ind7;
                  set ind8 [incr inc [string length $value_name]];
                  incr ind8 2;
                } elseif { [string first "," $new_line2] == 0 } {
                        set value_name "";
                        set ind8 $ind7;
                      } elseif { [string length $new_line2] != 0 } {
                               if { [string first "," $new_line2] == -1 } {
                                 set value_name [string range $new_line2 0 end];
                                 set endFlag 1;
                               } else {
                                 set endLine [string first "," $new_line2];
                                 incr endLine -1;
                                 set value_name [string range $new_line2 0 $endLine];
                               } ;
                               set inc $ind7;
                               set ind8 [incr inc [string length $value_name]];
                            } else {
                               set value_name "";
                               set ind8 $ind7;
                            } ;
                set __hello_value_names($var_name) $value_name;
                set ind9 [incr ind8 1];
                set new_line3 [string range $new_line $ind9 end];
                if { $endFlag == 1 } {
                  set type_name "";
                } elseif { [string first \" $new_line3] == 0 } {
                        set quoted [string range $new_line3 1 end];
                        set endQuote [string first \" $quoted];
                        set type_name [string range $new_line3 1 $endQuote];
                        set inc $ind9;
                        set ind10 [incr inc [string length $value_name]];
                      } elseif { [string first "," $new_line3] == -1 } {
                              set type_name $new_line3;
                              set inc $ind9;
                              set ind10 [incr inc [string length $type_name]];
                           } elseif { [string length $new_line3] != 0 } {
                                    set endLine [string first "," $new_line3];
                                    incr endLine -1;
                                    set type_name [string range $new_line3 0 $endLine];
                                    set inc $ind9;
                                    set ind10 [incr inc [string length $type_name]];
                                    incr ind10 -1;
                                    if { [string index $new_line $ind10] == "," } {
                                      set type_name "";
                                      incr ind10 -1;
                                    }
                                 } else { set type_name "";  } ;
                set __hello_type_names($var_name) $type_name;
                set ind11 [incr ind10 2];
                set new_line4 [string range $new_line $ind11 end];
                if { $endFlag == 1 } {
                  set def_name "";
                } elseif { [string first \" $new_line4] == 0 } {
                        set quoted [string range $new_line4 1 end];
                        set endQuote [string first \" $quoted];
                        set def_name [string range $new_line4 1 $endQuote];
                        set inc $ind11;
                        set ind12 [incr inc [string length $def_name]];
                      } elseif { [string first "," $new_line4] == 0 } {
                              if { [MR_stringEqual "," $new_line4 end] } {
                                set def_name "";
                                set ind12 $ind11;
                              } else {
                                incr ind11 1;
                                set new_line4 [string range $new_line $ind11 end];
                                set def_name $new_line4;
                              }
                            } elseif { [string first "," $new_line2] == -1 } {
                                    set def_name $new_line2;
                                  } elseif { [string length $new_line4] != 0 } {
                                          set def_name $new_line4;
                                        } else { set def_name ""; } ;
                set __hello_def_names($var_name) $def_name;
            }
        }
    }
  } ;
  close $fid;
  return 1;
} ;

#=======================================================================
proc CMD_FOUND { cmd args } {
  if { [llength [info commands "$cmd"] ] } {
    return 1;
  } else {
    return 0;
  }
} ;


#=======================================================================
proc MR_textLoadFile { wlist wclass } {
  global __hello_var_names   __hello_class_names __hello_des_names;
  global __hello_value_names __hello_type_names  __hello_def_names;
  global MR_curr;
  if { ![array exists __hello_des_names] } {
    if { [info exists __hello_des_names] } { unset __hello_des_names; }
  } ;

  if { ![info exists __hello_des_names] } {
    if [MR_readCSVFile] {
      if [CMD_FOUND UI_PB_debug_ForceMsg] {
         UI_PB_debug_ForceMsg "\n+++ MR_readCSVFile ran Ok! +++\n"
      } else {
        if [CMD_FOUND UI_PB_debug_ForceMsg] {
           UI_PB_debug_ForceMsg "\n+++ MR_readCSVFile failed! +++\n"
        } ;
        return 0;
      }
    }
  } ;

  if 0 {
    global MR_file;
    global PB_HOME gPB_mom_var_values;
    if { [info exists fid] } { unset fid } ;
    if { [info exists PB_HOME] } {
      set fid [open $gPB_mom_var_values];
    } elseif { [file exists $MR_file] } {
            set fid [open $MR_file];
          } elseif { [info exists gPB_mom_var_values] } {
                  set fid [open $gPB_mom_var_values];
                } ;
    if { ![info exists fid] } { return; } ;

    while {![eof $f]} {
      gets $f line;
      set line [string trim $line];
      if { $line != "" } {
         if {[MR_stringEqual $line "Mom" 2]} {
         } else {
            if {[MR_stringEqual \" $line 0]} {
               set ind1 1;
               set quoted [string range $line 1 end];
               set ind2 [string first \" $quoted];
               incr ind2 -1;
               set var_name [string range $quoted 0 $ind2];
               set inc $ind2;
               set ind3 [incr inc 4];
            } elseif {[MR_stringEqual "MOM_" $line 3]} {
                     set ind1 [string first "MOM_" $line];
                     if {[string first "," $line] != -1} {
                        set ind2 [string first "," $line];
                        incr ind2 -1;
                     } else {
                        set ind2 [string wordend $line 0];
                        incr ind2 1;
                     } ;
                     set var_name [string range $line $ind1 $ind2];
                     set inc $ind2;
                     set ind3 [incr inc 2];
                  } elseif {[string length $line] != 0} {
                            set ind1 [string first "mom_" $line];
                            if {[string first "," $line] != -1} {
                               set ind2 [string first "," $line];
                               incr ind2 -1;
                            } else {
                               set ind2 [string wordend $line 0];
                               incr ind2 1;
                            } ;
                            set var_name [string range $line $ind1 $ind2];
                            set inc $ind2;
                            set ind3 [incr inc 2];
                         } ;
            set __hello_var_names($var_name) $var_name;
            if {[string index $line $ind3] == ""} {
               set __hello_class_names($var_name) "";
               set __hello_des_names($var_name) "";
               set __hello_value_names($var_name) "";
               set __hello_type_names($var_name) "";
            } elseif {[MR_stringEqual $var_name "" end]} {
                  } else {
                      set class_line [string range $line $ind3 end];
                      set ind4 [string first "," $class_line];
                      set inc $ind4;
                      incr ind4 -1;
                      if {[MR_stringEqual $ind3 $ind4 end]} {
                         set class_name "";
                      } elseif {[string index $class_line $inc] != ","} {
                               incr inc -1;
                               set class_name [string range $class_line 0 $inc];
                            } else {
                               set class_name [string range $class_line 0 $ind4];
                            } ;
                      set __hello_class_names($var_name) $class_name;
                      set __hello_class_names($class_name) $class_name;
                      set ind5 [incr ind4 2];
                      set new_line [string range $class_line $ind5 end];
                      if {[MR_stringCompareLength \" $new_line 0] == 0} {
                         set quoted [string range $new_line 1 end];
                         set ind6 [string first \" $quoted];
                         incr ind6 -1;
                         set des_name [string range $quoted 0 $ind6];
                         incr ind6 2;
                      } elseif {[string length $new_line] != 0} {
                               if {![MR_stringEqual $var_name "" end]} {
                                   set ind6 [string first "," $new_line];
                                   incr ind6 -1;
                                   if {[MR_stringEqual $ind5 $ind6 end]} {
                                       set des_name "";
                                   } else {
                                       set des_name [string range $new_line 0 $ind6];
                                   }
                               }
                            } else { set des_name ""; } ;
                      set __hello_des_names($var_name) $des_name;
                      set ind7 [incr ind6 2];
                      set new_line2 [string range $new_line $ind7 end];
                      set endFlag 0;
                      if {[string first \" $new_line2] == 0} {
                          set quoted [string range $new_line2 1 end];
                          set endQuote [string first \" $quoted];
                          set value_name [string range $new_line2 1 $endQuote];
                          set inc $ind7;
                          set ind8 [incr inc [string length $value_name]];
                          incr ind8 2;
                      } elseif {[string first "," $new_line2] == 0} {
                               set value_name "";
                               set ind8 $ind7;
                            } elseif {[string length $new_line2] != 0} {
                                     if {[string first "," $new_line2] == -1} {
                                          set value_name [string range $new_line2 0 end];
                                          set endFlag 1;
                                     } else {
                                          set endLine [string first "," $new_line2];
                                          incr endLine -1;
                                          set value_name [string range $new_line2 0 $endLine];
                                     } ;
                                     set inc $ind7;
                                     set ind8 [incr inc [string length $value_name]];
                                   } else {
                                      set value_name "";
                                      set ind8 $ind7;
                                  } ;
                      set __hello_value_names($var_name) $value_name;
                      set ind9 [incr ind8 1];
                      set new_line3 [string range $new_line $ind9 end];
                      if {$endFlag == 1} {
                         set type_name "";
                      } elseif {[string first \" $new_line3] == 0} {
                               set quoted [string range $new_line3 1 end];
                               set endQuote [string first \" $quoted];
                               set type_name [string range $new_line3 1 $endQuote];
                               set inc $ind9;
                               set ind10 [incr inc [string length $value_name]];
                            } elseif {[string first "," $new_line3] == -1} {
                                      set type_name $new_line3;
                                      set inc $ind9;
                                      set ind10 [incr inc [string length $type_name]];
                                  } elseif {[string length $new_line3] != 0} {
                                           set endLine [string first "," $new_line3];
                                           incr endLine -1;
                                           set type_name [string range $new_line3 0 $endLine];
                                           set inc $ind9;
                                           set ind10 [incr inc [string length $type_name]];
                                           incr ind10 -1;
                                           if {[string index $new_line $ind10] == ","} {
                                               set type_name "";
                                               incr ind10 -1;
                                           }
                                        } else { set type_name "";  } ;
                     set __hello_type_names($var_name) $type_name;
                     set ind11 [incr ind10 2];
                     set new_line4 [string range $new_line $ind11 end];
                     if {$endFlag == 1} {
                        set def_name "";
                     } elseif {[string first \" $new_line4] == 0} {
                              set quoted [string range $new_line4 1 end];
                              set endQuote [string first \" $quoted];
                              set def_name [string range $new_line4 1 $endQuote];
                              set inc $ind11;
                              set ind12 [incr inc [string length $def_name]];
                           } elseif {[string first "," $new_line4] == 0} {
                                   if {[MR_stringEqual "," $new_line4 end]} {
                                       set def_name "";
                                       set ind12 $ind11;
                                   } else {
                                       incr ind11 1;
                                       set new_line4 [string range $new_line $ind11 end];
                                       set def_name $new_line4;
                                   }
                                 } elseif {[string first "," $new_line2] == -1} {
                                          set def_name $new_line2;
                                       } elseif {[string length $new_line4] != 0} {
                                                set def_name $new_line4;
                                             } else { set def_name ""; } ;
                     set __hello_def_names($var_name) $def_name;
                    }
            }
      }
    } ;

  }

  set var_list [lsort -dictionary [array get __hello_var_names]];
  foreach {key value} $var_list { if {![MR_stringEqual "" $value end]} { $wlist insert end $value; } } ;
  $wclass delete 0;
  $wclass add radiobutton -label "All" -variable MR_curr -command "MR_loadClassVars1 $wclass $wlist";
  set var_list [lsort -dictionary [array get __hello_var_names]];
  set var_list2 [array get __hello_class_names];
  set cur_class_values "";
  foreach {key value} [lsort -dictionary $var_list2] {
     if {[string match "," $value]} {
     } elseif {[string match "" $value]} {
           } elseif {[string first $value $cur_class_values] != -1} {
                       if {[MR_stringEqual $key $value end]} {
                       }
                 } elseif {[MR_stringEqual $key $value end]} {
                          $wclass add radiobutton -label "$value" -variable MR_curr -command "MR_loadClassVars1 $wclass $wlist";
                          append cur_class_values $value " ";
                       } else { }
  } ;
  ##close $f;
  $wclass invoke 0;
  $wlist selection set 0;
} ;

#=======================================================================
proc MR_stringEqual {string1 string2 len} {
    set str1 [string range $string1 0 $len];
    set str2 [string range $string2 0 $len];
    if {[string compare $str1 $str2] == 0} { return 1; } else { return 0; }
} ;

#=======================================================================
proc MR_stringCompareLength {string1 string2 len} {
    set str1 [string range $string1 0 $len];
    set str2 [string range $string2 0 $len];
    if {[string match $str1 $str2]} { return 0; } else { return -1; }
} ;

#=======================================================================
proc MR_stringCompareLengthNocase {string1 string2 len} {
    set str1 [string range $string1 0 $len];
    set str2 [string range $string2 0 $len];
    set str1 [string tolower $str1];
    set str2 [string tolower $str2];
    if {[string match $str1 $str2]} { return 0; } else { return -1; }
} ;

#=======================================================================
proc MR_loadDescription {wdes wclass wlist} {
    global __hello_des_names MR_curr;
    $wdes config -state normal;
    $wdes delete 1.0 end;
    if {![string match "" [$wlist curselection]]} {
       set var_name [$wlist get [$wlist curselection]];
       set new_var $__hello_des_names($var_name);
       if {[string match "" $new_var]} { } else { $wdes insert end $new_var; }
    } ;
    $wdes config -state disabled;
} ;

#=======================================================================
proc MR_loadClassVars {wclass wlist} {
    global __hello_var_names __hello_class_names MR_curr;
    foreach {key value} [array get __hello_class_names] {
       if {[string match "" $value]} {
          set curSel [$wclass get [$wclass curselection]];
          set MR_curr [$wclass curselection];
          $wclass see $MR_curr;
          $wlist delete 0 end;
          if {[string match "" $curSel]} {
          } elseif {[MR_stringEqual "All" $curSel end]} {
                 set var_list [lsort -dictionary [array get __hello_var_names]];
                 foreach {key value} $var_list {
                    if {![MR_stringEqual "" $value end]} {
                        $wlist insert end $value;
                    }
                 }
                } elseif {[MR_stringEqual "None" $curSel end]} {
                      } elseif {![MR_stringEqual "" $curSel end]} {
                               set class_name [$wclass get [$wclass curselection]];
                               set new_list "";
                               set var_list [array get __hello_class_names];
                               foreach {key value} $var_list {
                                  if {[MR_stringCompareLengthNocase "mom_" $key 3] == 0} {
                                      if {[MR_stringEqual $class_name $value end]} {
                                         if {![MR_stringEqual $key $value end]} { set new_list [lappend $var_list $key]; }
                                      }
                                  }
                               } ;
                               foreach {key} [lsort -dictionary $new_list] {
                                  if {[string first $key $new_list] != -1} { $wlist insert end $key; }
                               } ;
                               break;
                            } else {
                             }
       }
    } ;
    $wlist activate active;
    focus $wlist;
} ;

#=======================================================================
proc MR_loadClassVars1 {wclass wlist} {
    global __hello_var_names __hello_class_names MR_curr;
    foreach {key value} [array get __hello_class_names] {
       if {[string match "" $value]} {
         if 0 {
            set curSel [$wclass get [$wclass curselection]];
            set MR_curr [$wclass curselection];
            $wclass see $MR_curr;
         } ;
         set curSel $MR_curr;
         $wlist delete 0 end;
         if {[string match "" $curSel]} {
         } elseif {[MR_stringEqual "All" $curSel end]} {
                 set var_list [lsort -dictionary [array get __hello_var_names]];
                 foreach {key value} $var_list {
                    if {![MR_stringEqual "" $value end]} {
                       $wlist insert end $value;
                    }
                 }
               } elseif {[MR_stringEqual "None" $curSel end]} {
                     } elseif {![MR_stringEqual "" $curSel end]} {
                             set class_name $MR_curr;
                             set new_list "";
                             set var_list [array get __hello_class_names];
                             foreach {key value} $var_list {
                                if {[MR_stringCompareLengthNocase "mom_" $key 3] == 0} {
                                   if {[MR_stringEqual $class_name $value end]} {
                                      if {![MR_stringEqual $key $value end]} {
                                         set new_list [lappend $var_list $key];
                                      }
                                   }
                                }
                             } ;
                             foreach {key} [lsort -dictionary $new_list] {
                                if {[string first $key $new_list] != -1} { $wlist insert end $key; }
                             } ;
                             break;
                           } else {
                            }
       }
    } ;
    focus $wlist;
    $wlist selection set 0;
    $wlist activate 0;
    eval [bind $wlist <ButtonRelease-1>];
} ;

#=======================================================================
proc MR_loadDefault {wdefault wlist} {
    global __hello_def_names;
    $wdefault config -state normal;
    $wdefault delete 1.0 end;
    if {![string match "" [$wlist curselection]]} {
       set var_name [$wlist get [$wlist curselection]];
       if {[info exists __hello_def_names($var_name)]} {
          set new_var $__hello_def_names($var_name);
          if {[string match "," $new_var]} { } elseif {[string match "" $new_var]} { } else { $wdefault insert end $new_var; }
       }
    } ;
    $wdefault config -state disabled;
} ;

#=======================================================================
proc MR_loadValues {wvalue wlist} {
    global __hello_value_names;
    $wvalue config -state normal;
    $wvalue delete 1.0 end;
    if {![string match "" [$wlist curselection]]} {
       set var_name [$wlist get [$wlist curselection]];
       if {[info exists __hello_value_names($var_name)]} {
          set new_var $__hello_value_names($var_name);
          if {![string match "" $new_var]} { $wvalue insert end $new_var; } else {}
       }
    } ;
    $wvalue config -state disabled;
} ;

#=======================================================================
proc MR_loadCate {wcate wlist} {
    global __hello_class_names;
    $wcate config -state normal;
    $wcate delete 1.0 end;
    if {![string match "" [$wlist curselection]]} {
       set var_name [$wlist get [$wlist curselection]];
       set new_var $__hello_class_names($var_name);
       if {![string match "" $new_var]} { $wcate insert end $new_var; } else { }
    } ;
    $wcate config -state disabled;
} ;

#=======================================================================
proc MR_loadType {wtype wlist} {
    global __hello_type_names;
    $wtype config -state normal;
    $wtype delete 1.0 end;
    if {![string match "" [$wlist curselection]]} {
       set var_name [$wlist get [$wlist curselection]];
       set new_var $__hello_type_names($var_name);
       if {![string match "" $new_var]} { $wtype insert end $new_var; } else { }
    } ;
    $wtype config -state disabled;
} ;

#=======================================================================
proc MR_forceLoad {wlist wdes wvalue wcate wtype wdefault} {
    global __hello_type_names;
    if {![string match "" [$wlist curselection]]} {
       MR_loadDescription $wdes $wclass $wlist;
       MR_loadValues $wvalue $wlist;
       MR_loadCate $wcate $wlist;
       MR_loadType $wtype $wlist;
       MR_loadDefault $wdefault $wlist;
    }
} ;

#=======================================================================
proc MR_search2 {wclass wlist g} {
    global __hello_var_names __hello_des_names __hello_value_names;
    global __hello_def_names __hello_type_names;
    global __hello_class_names MR_curr;
    set keyWord [string tolower [$g get]];
    if [string match "" $keyWord] {
       focus $wlist;
    } else {
       set var_list [array get __hello_var_names];
       set new_list "";
       $wlist delete 0 end;
       foreach {key value} $var_list {
           if {[string first $keyWord $value] != -1} {
              lappend new_list $value;
           } elseif {[string first [string toupper $keyWord] [string toupper $value]] != -1} {
                   lappend new_list $key;
           } elseif {[MR_stringCompareLengthNocase $keyWord *$value* end] == 0} {
                   lappend new_list $key;
                  }
       } ;
       set var_list [array get __hello_des_names];
       foreach {key value} $var_list {
           if {[string first $keyWord $value] != -1} {
              lappend new_list $key;
           } elseif {[MR_stringCompareLengthNocase $keyWord *$value* end] == 0} {
                   lappend new_list $key;
                 }
       } ;
       set var_list [array get __hello_value_names];
       foreach {key value} $var_list {
          if {[string first $keyWord $value] != -1} {
             lappend new_list $key;
          } elseif {[string first [string toupper $keyWord] [string toupper $value]] != -1} {
                   lappend new_list $key;
                 } elseif {[MR_stringCompareLengthNocase $keyWord *$value* end] == 0} {
                          lappend new_list $key;
                       }
       } ;
       set var_list [array get __hello_type_names];
       foreach {key value} $var_list {
          if {[string first $keyWord $value] != -1} {
             lappend new_list $key;
          } elseif {[string first [string toupper $keyWord] [string toupper $value]] != -1} {
                    lappend new_list $key;
                } elseif {[MR_stringCompareLengthNocase $keyWord *$value* end] == 0} {
                         lappend new_list $key;
                      }
       } ;
       set var_list [array get __hello_def_names];
       foreach {key value} $var_list {
          if {[string first $keyWord $value] != -1} {
             lappend new_list $key;
          } elseif {[string first [string toupper $keyWord] [string toupper $value]] != -1} {
                   lappend new_list $key;
                } elseif {[MR_stringCompareLengthNocase $keyWord *$value* end] == 0} {
                         lappend new_list $key;
                      }
       } ;
       foreach var $new_list { set var_arr($var) $var; } ;
       set var_list [array get var_arr];
       foreach {key value} [lsort -dictionary $var_list] {
          if [string match "All" $MR_curr] {
             $wlist insert end $key;
          } elseif [string match "$MR_curr" $__hello_class_names($key)] {
                   $wlist insert end $key;
                }
       } ;
       $wlist selection set 0;
       $wlist activate 0;
       eval [bind $wlist <ButtonRelease-1>];
    } ;
    focus $wlist;
} ;

#=======================================================================
proc MR_fileDialog {wlist wclass wdes} {
   set types { {"Text files"           {.txt .doc}     } {"Text files"           {}              TEXT} } ;
   global env MR_file;
   if {[string compare $env(UGII_BASE_DIR) ""] != 0} {
       set file [tk_getOpenFile -filetypes $types -parent $wlist  -initialdir $env(UGII_BASE_DIR) -initialfile $MR_file];
   } else {
       set file [tk_getOpenFile -filetypes $types -parent $wlist  -initialfile $MR_file];
   } ;
   if {[string compare $file ""] != 0} {
     set MR_file $file;
     MR_textLoadFile $wlist $wclass ;
   }
} ;

#=======================================================================
proc __mvb_Popup { wlist X Y x y } {
    global gPB;
    set sel [$wlist curselection];
    if { ![string match "" $sel] } {
       $wlist selection clear $sel;
    } ;
    set sel [$wlist nearest $y];
    $wlist selection set $sel;
    $wlist activate $sel;
    set br1_cb [bind $wlist <ButtonRelease-1>];
    eval $br1_cb;
    set popup $wlist.pop;
    set popup $wlist.pop;
    $popup delete 0 end;
    $popup add command -label "$gPB(nav_button,copy,Label)" -state normal  -command "__mvb_Copy $wlist";
    tk_popup $popup $X $Y;
} ;

#=======================================================================
proc __mvb_Copy { wlist } {
    if {[selection own -displayof $wlist] == "$wlist"} {
       clipboard clear -displayof $wlist;
       clipboard append -type STRING -displayof $wlist -- [selection get -displayof $wlist];
    }
} ;

#=======================================================================
proc _mom_chm_reader { w } {
    global gPB;
    global tcl_platform;
    if [string match "windows" $tcl_platform(platform)] {
       set __font(normal)        {ansi 9} ;
       set __font(bold)          {ansi 9 bold} ;
       set __font(italic)        {ansi 9 italic bold} ;
       set __font(fixed)         {courier 10} } else { set __font(normal)        {arial 11} ;
       set __font(bold)          {arial 11 bold} ;
       set __font(italic)        {arial 11 italic bold} ;
       set __font(fixed)         {courier 11}
    } ;
    if { $w == "" } {
       set ww .;
    } else {
       set ww $w;
       if { ![string match "." $w] } {
           if [winfo exists $w] {
             raise $w;
             update;
             return
           } ;
           toplevel $w;
       }
    } ;
    wm title $ww "$gPB(mvb,title,Label)";
    wm resizable $ww 0 0;
    if ![string compare $::tix_version 8.4] {
       bind all <Enter> {} ;
       wm protocol $ww WM_DELETE_WINDOW   "tk_focusFollowsMouse; destroy $ww ";
    } ;
    frame $w.regulars -relief sunken -bd 2 -bg gold1;
    pack $w.regulars -side bottom -fill x -ipadx 10 -ipady 10 -padx 3 -pady 3;
    if { [string match $::tix_version "8.4"] } {
       button $w.regulars.dismiss -text "$gPB(nav_button,ok,Label)" -width 10 -font $__font(bold)  -bg #d0c690 -command  "tk_focusFollowsMouse; destroy $ww";
     } else {
       button $w.regulars.dismiss -text "$gPB(nav_button,ok,Label)" -width 10 -font $__font(bold)  -bg #d0c690 -command  "destroy $ww";
    } ;
    pack $w.regulars.dismiss -expand yes;
    frame $w.top;
    pack $w.top -side top -fill both;
    frame $w.top.container -relief raised -bd 3;
    pack $w.top.container -side right -padx 10 -pady 10 -fill y;
    frame $w.top.var;
    pack $w.top.var -side left -padx 10 -pady 10 -fill y;
    frame $w.top.var.list;
    pack $w.top.var.list -side bottom;
    set bg_color aliceBlue;
    scrollbar $w.top.var.list.yscroll -command "$w.top.var.list.display yview";
    scrollbar $w.top.var.list.xscroll -orient horizontal -command "$w.top.var.list.display xview";
    listbox $w.top.var.list.display -width 34 -height 21 -setgrid 1 -selectmode browse  -yscroll "$w.top.var.list.yscroll set" -xscroll "$w.top.var.list.xscroll set"  -font $__font(normal) -bg $bg_color -highlightcolor gray;
    grid $w.top.var.list.display $w.top.var.list.yscroll;
    grid $w.top.var.list.display -sticky news;
    grid $w.top.var.list.yscroll -sticky ns;
    grid $w.top.var.list.xscroll -sticky ew;
    text $w.text -yscrollcommand "$w.scroll set" -setgrid true;
    scrollbar $w.scroll -command "$w.text yview";
    set wlist $w.top.var.list.display;
    set popup [menu $wlist.pop -tearoff 0];
    bind $wlist <3> "__mvb_Popup $wlist %X %Y %x %y";
    frame $w.top.var.s -relief groove -bd 2;
    pack $w.top.var.s -side top -fill x;
    frame $w.top.var.s.class;
    pack $w.top.var.s.class -side top -fill x -padx 5 -pady 3;
    label $w.top.var.s.class.label -text "$gPB(mvb,cat,Label)  " -anchor w -font $__font(italic);
    if 0 {
        scrollbar $w.top.var.s.class.yscroll -command "$w.top.var.s.class.combo yview";
    } ;
    set bg_color lightCyan;
    if 0 {
      listbox $w.top.var.s.class.combo -width 22 -height 3 -setgrid 1 -selectmode browse  -yscroll "$w.top.var.s.class.yscroll set" -font $__font(bold) -bg $bg_color;
      set wclass $w.top.var.s.class.combo;
    } ;
    global MR_curr;
    set MR_curr All;
    set opt_menu $w.top.var.s.class.combo;
    set wclass [tk_optionMenu $opt_menu MR_curr ""];
    $opt_menu config -font $__font(bold);
    if 0 {
       bind $opt_menu <1> "$opt_menu config -indicatoron 0; $wclass post %X %Y; $opt_menu config -indicatoron 1";
    } ;
    bind $opt_menu <1> "$wclass post %X %Y";
    pack $w.top.var.s.class.label -side left -fill x;
    if 0 {
       pack $w.top.var.s.class.yscroll $w.top.var.s.class.combo  -side right -fill both;
    } ;
    pack $w.top.var.s.class.combo -side right -expand yes -fill x;
    text $w.top.var.s.class.text1 -yscrollcommand "$w.top.var.s.class.scroll1 set" -setgrid true;
    scrollbar $w.top.var.s.class.scroll1 -command "$$w.top.var.s.class.text1 yview";
    frame $w.top.var.s.search;
    pack $w.top.var.s.search -side bottom -fill x -padx 5 -pady 3;
    entry $w.top.var.s.search.entry -width 20 -textvariable editChanged -font $__font(fixed) -bg white;
    set searchEntry $w.top.var.s.search.entry;
    button $w.top.var.s.search.option -height 1 -text "$gPB(mvb,search,Label)" -width 8  -font $__font(bold) -fg yellow -bg royalBlue  -command "MR_search2 $wclass $wlist $searchEntry";
    pack $w.top.var.s.search.entry -side left -fill x;
    pack $w.top.var.s.search.option -side right -fill x;
    bind $w.top.var.s.search.entry <Return> "MR_search2 $wclass $wlist $searchEntry";
    frame $w.top.container.default;
    pack $w.top.container.default -side top -fill x -padx 5 -pady 5;
    label $w.top.container.default.label -text "$gPB(mvb,defv,Label)"  -font $__font(italic);
    scrollbar $w.top.container.default.yscroll -command "$w.top.container.default.option yview";
    scrollbar $w.top.container.default.xscroll -orient horizontal  -command "$w.top.container.default.option xview";
    set bg_color lightYellow;
    text $w.top.container.default.option -width 47 -height 2 -wrap word -bg $bg_color  -font $__font(normal) -yscroll "$w.top.container.default.yscroll set";
    pack $w.top.container.default.label;
    pack $w.top.container.default.option $w.top.container.default.yscroll -side left  -fill both;
    text $w.let -yscrollcommand "$w.get set" -setgrid true;
    scrollbar $w.get -command "$w.let yview";
    set wdefault $w.top.container.default.option;
    frame $w.top.container.options;
    pack $w.top.container.options -side top -fill x -padx 5 -pady 5;
    label $w.top.container.options.label -text "$gPB(mvb,posv,Label)"  -font $__font(italic);
    button $w.top.container.options.paste -text "Paste" -width 13;
    scrollbar $w.top.container.options.yscroll -command "$w.top.container.options.option yview";
    scrollbar $w.top.container.options.xscroll -orient horizontal -command "$w.top.container.options.option xview";
    text $w.top.container.options.option -width 47 -height 3 -wrap word -bg $bg_color  -font $__font(normal) -yscroll "$w.top.container.options.yscroll set";
    pack $w.top.container.options.label;
    pack $w.top.container.options.option $w.top.container.options.yscroll -side left  -fill both;
    text $w.word -yscrollcommand "$w.roll set" -setgrid true;
    scrollbar $w.roll -command "$w.word yview";
    set wvalue $w.top.container.options.option;
    frame $w.top.container.frm;
    frame $w.top.container.frm.type;
    pack $w.top.container.frm.type -side left -fill x -padx 5 -pady 5;
    frame $w.top.container.frm.cate;
    pack $w.top.container.frm.cate -side right -fill x -padx 5 -pady 5;
    label $w.top.container.frm.type.label -text "$gPB(mvb,data,Label)" -font $__font(italic);
    label $w.top.container.frm.cate.label -text "$gPB(mvb,cat,Label)"  -font $__font(italic);
    text $w.top.container.frm.type.option -width 25 -height 1 -wrap word -bg $bg_color -font $__font(normal);
    text $w.top.container.frm.cate.option -width 21 -height 1 -wrap word -bg $bg_color  -font $__font(normal);
    pack $w.top.container.frm;
    pack $w.top.container.frm.type.label;
    pack $w.top.container.frm.type.option -fill both;
    pack $w.top.container.frm.cate.label;
    pack $w.top.container.frm.cate.option -fill both;
    set wtype $w.top.container.frm.type.option;
    set wcate $w.top.container.frm.cate.option;
    frame $w.top.container.display;
    pack $w.top.container.display -side bottom -padx 5 -pady 5;
    scrollbar $w.top.container.display.yscroll -command "$w.top.container.display.list yview";
    scrollbar $w.top.container.display.xscroll -orient horizontal  -command "$w.top.container.display.list xview";
    label $w.top.container.display.text -text "$gPB(mvb,desc,Label)" -font $__font(italic);
    set bg_color lightYellow;
    text $w.top.container.display.list -width 47 -height 15 -wrap word  -font $__font(normal)  -yscroll "$w.top.container.display.yscroll set" -bg $bg_color;
    pack $w.top.container.display.text;
    pack $w.top.container.display.list $w.top.container.display.yscroll -side left -fill both;
    text $w.text2 -yscrollcommand "$w.scroll2 set" -setgrid true;
    scrollbar $w.scroll2 -command "$w.text2 yview";
    set wdes $w.top.container.display.list;
    global MR_curr;
    bind $wlist <ButtonRelease-1> "MR_loadDescription $wdes $wclass $wlist;  MR_loadValues $wvalue $wlist;  MR_loadCate $wcate $wlist;  MR_loadType $wtype $wlist;  MR_loadDefault $wdefault $wlist; focus $wlist";
    bind $wlist <<Copy>> "__mvb_Copy %W";
    focus $wlist;
    bind $w.top.var.list.yscroll <ButtonRelease-1> "+focus $wlist";
    bind $w.top.var.list.xscroll <ButtonRelease-1> "+focus $wlist";
    global env MR_file PB_HOME gPB_mom_var_values gPB_mom_var_browser;
    set namePat "mom_vars_csv.txt";
    set MR_file "mom_vars_csv.txt";
    set mom_vars_browser "";
    set mom_vars_csv_found 0;
    if [info exists gPB_mom_var_values] {
      set mom_vars_browser $gPB_mom_var_values;
      if [file exists $mom_vars_browser] { set mom_vars_csv_found 1; }
    } ;
    if { !$mom_vars_csv_found } {
      if [file exists $MR_file] {
         set mom_vars_browser $MR_file;
         if [file exists $mom_vars_browser] { set mom_vars_csv_found 1; }
      }
    } ;
    if { !$mom_vars_csv_found } {
      if [info exists env(UGII_BASE_DIR)] {
         set mom_vars_browser $env(UGII_BASE_DIR)/postbuild/app/$namePat;
         if [file exists $mom_vars_browser] { set mom_vars_csv_found 1; }
      }
    } ;
    if { !$mom_vars_csv_found } {
      if [info exists env(UGII_CAM_AUXILIARY_DIR)] {
         set mom_vars_browser $env(UGII_CAM_AUXILIARY_DIR)/$namePat;
         if [file exists $mom_vars_browser] { set mom_vars_csv_found 1; }
      }
    } ;
    if { $mom_vars_csv_found } {
       set MR_file $mom_vars_browser;
       MR_textLoadFile $wlist $wclass;
     } else {
       tk_messageBox -message "MOM variables file is not found in current search path.  Please specify.";
       MR_fileDialog $wlist $wclass $wdes;
       raise $ww;
       return;
    } ;
    $wlist selection set active;
    if {1} {
       $wlist activate active;
       MR_loadDescription $wdes $wclass $wlist;
       MR_loadValues $wvalue $wlist;
       MR_loadCate $wcate $wlist;
       MR_loadType $wtype $wlist;
       MR_loadDefault $wdefault $wlist;
    } ;
    raise $ww;
} ;


 if [info exists gPB_mom_var_browser] { return } ;

 if ![info exists gPB(mvb,title,Label)] {
  set gPB(mvb,title,Label) "MOM Variables Browser - Standalone";
  set gPB(nav_button,copy,Label) "Copy";
  set gPB(nav_button,ok,Label)   "OK";
  set gPB(mvb,cat,Label)         "Categary";
  set gPB(mvb,search,Label)      "Search";
  set gPB(mvb,defv,Label)        "Default Value";
  set gPB(mvb,posv,Label)        "Possible Values";
  set gPB(mvb,data,Label)        "Data Type";
  set gPB(mvb,desc,Label)        "Description";
 } ;
 if ![info exists tix_version] { set tix_version "8.0"; } ;

 _mom_chm_reader "";
