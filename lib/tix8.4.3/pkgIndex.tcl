if {[catch {package require Tcl 8.4}]} return
package ifneeded Tix 8.4.3  [list load [file join $dir tix843.dll] Tix]

#<Feb-27-2018 gsl> Cloned from tix8.4.2 (May not be needed here)
#package ifneeded stooop 4.4.1 [list source [file join $dir .. .. exe stooop.tcl]]

