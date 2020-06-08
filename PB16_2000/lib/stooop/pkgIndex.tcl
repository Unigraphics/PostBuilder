# @mdgen EXCLUDE: xifo.tcl
# @mdgen EXCLUDE: mkpkgidx.tcl
#
# Copyright (c) 2001 by Jean-Luc Fontaine <jfontain@free.fr>.
# This code may be distributed under the same terms as Tcl.
#
# $Id:

# Since stooop redefines the proc command and the default package facility will
# only load the stooop package at the first unknown command, proc being
# obviously known by default, forcing the loading of stooop is mandatory prior
# to the first proc declaration.

package ifneeded stooop 3.6.1 [list source [file join $dir stooop.tcl]]

