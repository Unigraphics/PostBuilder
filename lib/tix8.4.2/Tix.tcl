# -*- mode: TCL; fill-column: 75; tab-width: 8; coding: iso-latin-1-unix -*-
#
#	$Id: Tix.tcl,v 1.13 2004/12/24 01:27:54 hobbs Exp $
#
# Tix.tcl --
#
#	This file implements the Tix application context class
#
# Copyright (c) 1993-1999 Ioi Kim Lam.
# Copyright (c) 2000-2001 Tix Project Group.
# Copyright (c) 2004 ActiveState
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
# Revisions:
#<08-05-06 peter> fix xpm image problem on windows in tixAppContext:getimage
#
#

tixClass tixAppContext {
    -superclass {}
    -classname  TixAppContext
    -method {
	cget configure addbitmapdir filedialog getbitmap getimage
	option platform resetoptions setbitmap initstyle
    }
    -flag {
	-binding -debug -extracmdargs -filedialog -fontset -grabmode
	-haspixmap -libdir -scheme -schemepriority -percentsubst
    }
    -readonly {
	-haspixmap
    }
    -configspec {
	{-binding    		TK}
	{-debug      		0}
	{-extracmdargs 		1}
	{-filedialog    	""}
	{-fontset    		WmDefault}
	{-grabmode 		global}
	{-haspixmap 		0}
	{-libdir     		""}
	{-percentsubst		0}
	{-scheme     		WmDefault}
	{-schemepriority     	21}
    }
    -alias {
    }
}

proc tixAppContext:Constructor {w} {
    upvar #0 $w data
    global tix_priv tix_library tixOption

    if {[info exists data(initialized)]} {
	error "tixAppContext has already be initialized"
    } else {
	set data(initialized) 1
    }

    set data(et) [string equal $tix_library ""]
    set data(image) 0

    # These options were set when Tix was loaded
    #
    set data(-binding)		$tix_priv(-binding)
    set data(-debug)		$tix_priv(-debug)
    set data(-fontset)		$tix_priv(-fontset)
    set data(-scheme)		$tix_priv(-scheme)
    set data(-schemepriority)	$tix_priv(-schemepriority)

    if {![info exists tix_priv(isSafe)]} {
	set data(-libdir)	[file normalize $tix_library]
    }
    set tixOption(prioLevel) $tix_priv(-schemepriority)

    # Compatibility stuff: the obsolete name courier_font has been changed to
    # fixed_font
    set tixOption(fixed_font) Courier
    set tixOption(courier_font) $tixOption(fixed_font)

    # Enable/Disable Intrinsics debugging
    #
    set tix_priv(debug) [string is true -strict $data(-debug)]

    tixAppContext:BitmapInit $w
    tixAppContext:FileDialogInit $w

    # Clean up any error message generated by the above loop
    set ::errorInfo ""
}

proc tixAppContext:initstyle {w} {
    # Do the init stuff here that affects styles

    upvar #0 $w data
    global tix_priv

    if {![info exists tix_priv(isSafe)]} {
	tixAppContext:config-fontset $w $data(-fontset)
	tixAppContext:config-scheme  $w $data(-scheme)
    }

    tixAppContext:BitmapInit $w
    tixAppContext:FileDialogInit $w

    # Force the "." window to accept the new Tix options
    #
    set noconfig [list -class -colormap -container -menu -screen -use -visual]
    set noconfig [lsort $noconfig]
    foreach spec [. configure] {
	set flag [lindex $spec 0]
	if {[llength $spec] != 5
	    || [lsearch -exact -sorted $noconfig $flag] != -1} {
	    continue
	}
	set name  [lindex $spec 1]
	set class [lindex $spec 2]
	set value [option get . $name $class]
	catch {. configure $flag $value}
    }
}

#----------------------------------------------------------------------
#  Configurations
#
#----------------------------------------------------------------------
proc tixAppContext:resetoptions {w scheme fontset {schemePrio ""}} {
    upvar #0 $w data

    if {! $data(et)} {
	global tixOption
	option clear

	if {$schemePrio != ""} {
	    set tixOption(prioLevel) $schemePrio
	}
	tixAppContext:config-scheme  $w $scheme
	tixAppContext:config-fontset $w $fontset
    }
}
proc tixAppContext:StartupError {args} {
    bgerror [join $args "\n"]
}

proc tixAppContext:config-fontset {w value} {
    upvar #0 $w data
    global tix_priv tixOption

    set data(-fontset) $value

    #-----------------------------------
    # Initialization of options database
    #-----------------------------------
    # Load the fontset
    #
    if {!$data(et)} {
        set prefDir [file join $data(-libdir) pref]
        set fontSetFile [file join $prefDir $data(-fontset).fsc]
	if {[file exists $fontSetFile]} {
	    source $fontSetFile
	    tixPref:InitFontSet:$data(-fontset)
	    tixPref:SetFontSet:$data(-fontset)
	} else {
	    tixAppContext:StartupError \
		"	Error: cannot use fontset \"$data(-fontset)\"" \
		"       Using default fontset "
	    tixSetDefaultFontset
	}
    } else {
	if [catch {
	    tixPref:InitFontSet:$data(-fontset)
	    tixPref:SetFontSet:$data(-fontset)
	}] {
	    # User chose non-existent fontset
	    #
	    tixAppContext:StartupError \
		"	Error: cannot use fontset \"$data(-fontset)\"" \
		"       Using default fontset "
	    tixSetDefaultFontset
	}
    }
}

proc tixAppContext:config-scheme {w value} {
    upvar #0 $w data
    global tix_priv

    set data(-scheme) $value

    # Load the color scheme
    #
    if {!$data(et)} {
	set schemeName [file join [file join $data(-libdir) pref] \
	    $data(-scheme).csc]
	if {[file exists $schemeName]} {
	    source $schemeName
	    tixPref:SetScheme-Color:$data(-scheme)
	} else {
	    tixAppContext:StartupError \
		"	Error: cannot use color scheme \"$data(-scheme)\"" \
		"       Using default color scheme"
	    tixSetDefaultScheme-Color
	}
    } else {
	if [catch {tixPref:SetScheme-Color:$data(-scheme)}] {
	    # User chose non-existent color scheme
	    #
	    tixAppContext:StartupError \
		"	Error: cannot use color scheme \"$data(-scheme)\"" \
		"       Using default color scheme"
	    tixSetDefaultScheme-Color
	}
    }
}

#----------------------------------------------------------------------
#  Private methods
#
#----------------------------------------------------------------------
proc tixAppContext:BitmapInit {w} {
    upvar #0 $w data

    # See whether we have pixmap extension
    #
    set data(-haspixmap) true

    # Dynamically set the bitmap directory
    #
    if {! $data(et)} {
	set data(bitmapdirs) [list [file join $data(-libdir) bitmaps]]
    } else {
	set data(bitmapdirs) ""
    }
}

proc tixAppContext:FileDialogInit {w} {
    upvar #0 $w data

    if {$data(-filedialog) == ""} {
	set data(-filedialog) [option get . fileDialog FileDialog]
    }
    if {$data(-filedialog) == ""} {
	set data(-filedialog) tixFileSelectDialog
    }
}

#----------------------------------------------------------------------
# 	Public methods
#----------------------------------------------------------------------
proc tixAppContext:addbitmapdir {w bmpdir} {
    upvar #0 $w data

    if {[lsearch $data(bitmapdirs) $bmpdir] == -1} {
	lappend data(bitmapdirs) $bmpdir
    }
}

proc tixAppContext:getimage {w name} {
    upvar #0 $w data
    global tix_priv

    if {[info exists data(img:$name)]} {
	return $data(img:$name)
    }

    if {![info exists tix_priv(isSafe)]} {
	foreach dir $data(bitmapdirs) {
	    foreach {ext type} {
		xpm pixmap
		gif photo
		ppm photo
		xbm bitmap
		""  bitmap
	    } {
		set file [file join $dir $name.$ext]
     if ![string match $type "pixmap"] {
		if {[file exists $file]
		    && ![catch {
			set img tiximage$data(image)
			set data(img:$name) \
			    [image create $type $img -file $file]
		    }]} {
		    incr data(image)
		    break
		}
	 } else {
       #<08-05-06 peter>fix xpm problem on windows
      if [file exists $file] {
       set fid [open $file r]
       fconfigure $fid -translation binary
       set img tiximage$data(image)
       set data(img:$name) \
           [image create pixmap $img -data [read $fid]]
       close $fid
       incr data(image)
       break
     }
   }
     }

	    if {[info exists data(img:$name)]} {
		return $data(img:$name)
	    }
	}
    }

    if {![info exists data(img:$name)]} {
	catch {
	    set img tiximage$data(image)
	    # This is for compiled-in images
	    set data(img:$name) [image create pixmap $img -id $name]
	} err
	if {[string match internal* $err]} {
	    error $err
	} else {
	    incr data(image)
	}
    }

    if {[info exists data(img:$name)]} {
	return $data(img:$name)
    } else {
	error "image file \"$name\" cannot be found"
    }
}


proc tixAppContext:getbitmap {w bitmapname} {
    upvar #0 $w data
    global tix_priv

    if {[info exists data(bmp:$bitmapname)]} {
	return $data(bmp:$bitmapname)
    } else {
	set ext [file extension $bitmapname]
	if {$ext == ""} {
	    set ext .xbm
	}

	# This is the fallback value. If we can't find the bitmap in
	# the bitmap directories, then use the name of the bitmap
	# as the default value.
	#
	set data(bmp:$bitmapname) $bitmapname

	if {[info exists tix_priv(isSafe)]} {
	    return $data(bmp:$bitmapname)
	}

	foreach dir $data(bitmapdirs) {
	    if {$ext eq ".xbm" &&
		[file exists [file join $dir $bitmapname.xbm]]} {
		set data(bmp:$bitmapname) \
		    @[file join $dir $bitmapname.xbm]
		break
	    }
	    if {[file exists [file join $dir $bitmapname]]} {
		set data(bmp:$bitmapname) @[file join $dir $bitmapname]
		break
	    }
	}

	return $data(bmp:$bitmapname)
    }
}

proc tixAppContext:filedialog {w {type tixFileSelectDialog}} {
    upvar #0 $w data

    if {$type == ""} {
	set type $data(-filedialog)
    }
    if {![info exists data(filedialog,$type)]} {
	set data(filedialog,$type) ""
    }

    if {$data(filedialog,$type) == "" || \
	    ![winfo exists $data(filedialog,$type)]} {
	set data(filedialog,$type) [$type .tixapp_filedialog_$type]
    }

    return $data(filedialog,$type)
}

proc tixAppContext:option {w action {option ""} {value ""}} {
    global tixOption

    if {$action eq "get"} {
	if {$option == ""} {return [lsort [array names tixOption]]}
	return $tixOption($option)
    }
}

proc tixAppContext:platform {w} {
    return $::tcl_platform(platform)
}

proc tixDebug {message {level "1"}} {
    set debug [tix cget -debug]
    if {![string is true -strict $debug]} { return }

    if {$debug > 0} {
	# use $level here
	if {[catch {fconfigure stderr}]} {
	    # This will happen under PYTHONW.EXE or frozen Windows apps
	    proc tixDebug args {} 
	} else {
	    puts stderr $message
	}
    }
}

if {![llength [info commands toplevel]]} {
    interp alias {} toplevel {} frame
}
