# de_crypt_block1.tcl :
# че, 2004 year

global rseed ;
set rseed 0 ;

proc UIPB__random { } {
  global rseed
  set rseed [ expr  int($rseed) ] ;
  set rseed [ expr  abs((37 * $rseed + 67) % 27) ] ;
  return $rseed ;
}

## proc for de_crypt
proc UIPB__decrypt { src_file dst_file } {
  global rseed
  set dc [ open $dst_file "w" ] ;
  set src [ open $src_file "r" ] ;

  set rseedint 0 ; ## number coding

  set k  -1 ;
  while { ![ eof $src ] } {
    incr k;
    gets $src line ;
    if {[ eof $src ]} { break; }
    set l [ string length $line ]
    set c  '' ;
    if {$k} {
      set v4 [ UIPB__random ];
      set line1 [ string range $line $v4 end ]
      set s1 [ string length $line1 ] ;
      set s2 [ UIPB__random ] ;
      set sl [ expr ( $s1 - $s2 ) ];
      set line2 "";
      for { set i 0 } { $i<$sl } { incr i } {
        set j [ expr ($sl - $i - 1) ] ;
        set c [ string index $line1  $j ] ;
        set c [ expr  158 - [ scan $c "%c" ] ];
        set c [ format "%c" $c ]
        append line2 $c ;
      }
      ;#if {$sl>0} { set sl [ expr $sl - 1 ] ; }
      set line2 [ string range $line2 0 $sl ]
      ;# append line2 "\n\0" ;
      puts $dc $line2
    } else {
      set cseed "" ;
      set rseed  0 ;
      set sl [ string length $line ] ;
      for { set i 0 } { $i<$sl } { incr i } {
        set c [ string index $line  $i ] ;
        set c [ expr  158 - [ scan $c "%c" ] ];
        append cseed [ format "%c" $c ] ;
      }
      set rseed [ expr ceil($cseed) ] ;
      set rseedint [ expr int($rseed) ] ;
    }
  }

  close $src

  flush $dc
  close $dc

  puts "\n First number N=$rseedint \n $src_file -> $dst_file = done \n" ;

  return 0;
}

## proc for crypt
proc UIPB__crypt { rnd src_file dst_file } {
  global rseed
  set dc [ open $dst_file "w" ] ;
  set src [ open $src_file "r" ] ;

  set rseed  $rnd ;

  set line "$rseed" ;
  set cseed  "" ;
  set sl [ string length $line ] ;
  for { set i 0 } { $i<$sl } { incr i } {
    set c [ string index $line  $i ] ;
    set c [ expr  158 - [ scan $c "%c" ] ];
    append cseed [ format "%c" $c ] ;
  }
  puts $dc $cseed ;

  while { ![ eof $src ] } {
    gets $src line ;
    if {[ eof $src ]} { break; }
    set l [ string length $line ]
    set c  '' ;

    set sl $l
    set line1 $line
  
    set line2 "";
    for { set i 0 } { $i<$sl } { incr i } {
     set j [ expr ($sl - $i - 1) ] ;
     set c [ string index $line1  $j ] ;
     set c [ expr  158 - [ scan $c "%c" ] ];
     set c [ format "%c" $c ]
     append line2 $c ;
    }
    set line2 [ string range $line2 0 $sl ]

    set f1 [ UIPB__random ];
    set str1 ""
    for { set i 0 } { $i<$f1 } { incr i } {
        append str1 "0" ;
    }
    set f2 [ UIPB__random ];
    set str2 ""
    for { set i 0 } { $i<$f2 } { incr i } {
        append str2 "0" ;
    }
    puts $dc "${str1}${line2}${str2}"
  }

  close $src

  flush $dc
  close $dc

  puts "\n First number N=$rnd \n $src_file -> $dst_file = done \n" ;

  return 0;
}


#===========================
proc main { } {
#===========================
    set rnd 99 ;
    set file_name1 "file_name1"
    set file_name2 "file_name2"

## Crypt
##    UIPB__crypt $rnd $file_name1 $file_name2 ;

## DeCrypt
##    UIPB__decrypt $file_name1 $file_name2 ;

    return 0;
}


 set script [info script]
 if {$script != {}} {
   set dir [file dirname $script]
 } else {
   set dir [pwd]
 }

 set ext ".tcl"
 foreach fn [glob -nocomplain -directory $dir *.txt] {
    set tclFile [file rootname $fn]$ext
    if {![file exists $tclFile]} {
        puts "UIPB__decrypt $fn -> $tclFile" ;
        UIPB__decrypt $fn $tclFile ;
    } else {
    	puts " ------ $tclFile - exists" ;
    }
 }



