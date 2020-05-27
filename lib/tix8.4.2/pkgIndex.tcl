# in tix84
#package ifneeded Tix 8.4 [list load [file join $dir tix84.dll] Tix]

# in bin
package ifneeded Tix 8.2 [list load "[file join [file dirname [file dirname $dir]] bin tix84.dll]" Tix]

#package ifneeded stooop 4.4.1 [list source [file join $dir .. .. exe stooop.tcl]]
