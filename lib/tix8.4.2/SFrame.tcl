if {[info exists ::scrolledframe::version]} { return }
  namespace eval ::scrolledframe \
  {
    namespace export scrolledframe

  set version 0.9.1

    package provide Scrolledframe $version

    proc scrolledframe {w args} \
    {
      variable {}
      # create a scrolled frame
      frame $w  -takefocus 1
      # trap the reference
      rename $w ::scrolledframe::_$w
      # redirect to dispatch
      interp alias {} $w {} ::scrolledframe::dispatch $w
      # create scrollable internal frame
      frame $w.scrolled -highlightthickness 0 -takefocus 0
      # place it
      place $w.scrolled -in $w -x 0 -y -0
      # init internal data
      set ($w:vheight) 0
      set ($w:vwidth) 0
      set ($w:vtop) 0
      set ($w:vleft) 0
      set ($w:xscroll) ""
      set ($w:yscroll) ""
      # configure
      if {$args != ""} { uplevel 1 ::scrolledframe::config $w $args }
      # bind <Configure>
      bind $w <Configure> [namespace code [list vresize $w]]
      bind $w.scrolled <Configure> [namespace code [list resize $w]]
      # return widget ref
      return $w
    }

    proc dispatch {w cmd args} \
    {
      variable {}
      switch -glob -- $cmd \
      {
        con*    { uplevel 1 [linsert $args 0 ::scrolledframe::config $w] }
        xvi*    { uplevel 1 [linsert $args 0 ::scrolledframe::xview  $w] }
        yvi*    { uplevel 1 [linsert $args 0 ::scrolledframe::yview  $w] }
        default { uplevel 1 [linsert $args 0 ::scrolledframe::_$w    $cmd] }
      }
    }


    proc config {w args} \
    {
      variable {}
      set options {}
      set flag 0
      foreach {key value} $args \
      {
        switch -glob -- $key \
        {
          -xsc*   \
          {
            # new xscroll option
            set ($w:xscroll) $value
            set flag 1
          }
          -ysc*   \
          {
            # new yscroll option
            set ($w:yscroll) $value
            set flag 1
          }
          default { lappend options $key $value }
        }
      }
      # check if needed
      if {!$flag || $options != ""} \
      {
        # call frame config
        uplevel 1 [linsert $options 0 ::scrolledframe::_$w config]
      }
    }


    proc resize {w} \
    {
      variable {}
      # compute new height & width
      set ($w:vheight) [winfo reqheight $w.scrolled]
      set ($w:vwidth) [winfo reqwidth $w.scrolled]
      # resize the scroll bars
      vresize $w
    }

    # --------------
    # vresize proc
    #
    # resize the visible part
    # --------------
    # parm1: widget name
    # --------------
    proc vresize {w} \
    {
      xview $w scroll 0 unit
      yview $w scroll 0 unit
      xset $w
      yset $w
    }


    proc xset {w} \
    {
      variable {}
      # call the xscroll command
      set cmd $($w:xscroll)
      if {$cmd != ""} { catch { eval $cmd [xview $w] } }
    }


    proc yset {w} \
    {
      variable {}
      # call the yscroll command
      set cmd $($w:yscroll)
      if {$cmd != ""} { catch { eval $cmd [yview $w] } }
    }


    proc xview {w {cmd ""} args} \
    {
      variable {}
      # check args
      set len [llength $args]
      switch -glob -- $cmd \
      {
        ""      {}
        mov*    \
        { if {$len != 1} { error "wrong # args: should be \"$w xview moveto fraction\"" } }
        scr*    \
        { if {$len != 2} { error "wrong # args: should be \"$w xview scroll count unit\"" } }
        default \
        { error "unknown operation \"$cmd\": should be empty, moveto or scroll" }
      }
      # save old values
      set _vleft $($w:vleft)
      set _vwidth $($w:vwidth)
      set _width [winfo width $w]
      # compute new vleft
      set count ""
      switch $len \
      {
        0       \
        {
          # return fractions
          if {$_vwidth == 0} { return {0 1} }
          set first [expr {double($_vleft) / $_vwidth}]
          set last [expr {double($_vleft + $_width) / $_vwidth}]
          if {$last > 1.0} { return {0 1} }
          return [list [format %g $first] [format %g $last]]
        }
        1       \
        {
          # absolute movement
          set vleft [expr {int(double($args) * $_vwidth)}]
        }
        2       \
        {
          # relative movement
          foreach {count unit} $args break
          if {[string match p* $unit]} { set count [expr {$count * 9}] }
          set vleft [expr {$_vleft + $count * 0.1 * $_width}]
        }
      }
      if {$vleft < 0} { set vleft 0 }
      if {$vleft + $_width > $_vwidth} { set vleft [expr {$_vwidth - $_width}] }
      if {$vleft != $_vleft || $count == 0} \
      {
        set ($w:vleft) $vleft
        xset $w
        place $w.scrolled -in $w -x [expr {-$vleft} / 2]
      }
    }


    proc yview {w {cmd ""} args} \
    {
      variable {}
      # check args
      set len [llength $args]
      switch -glob -- $cmd \
      {
        ""      {}
        mov*    \
        { if {$len != 1} { error "wrong # args: should be \"$w yview moveto fraction\"" } }
        scr*    \
        { if {$len != 2} { error "wrong # args: should be \"$w yview scroll count unit\"" } }
        default \
        { error "unknown operation \"$cmd\": should be empty, moveto or scroll" }
      }
      # save old values
      set _vtop $($w:vtop)
      set _vheight $($w:vheight)
      set _height [winfo height $w]
      # compute new vtop
      set count ""
      switch $len \
      {
        0       \
        {
          # return fractions
          if {$_vheight == 0} { return {0 1} }
          set first [expr {double($_vtop) / $_vheight}]
          set last [expr {double($_vtop + $_height) / $_vheight}]
          if {$last > 1.0} { return {0 1} }
          return [list [format %g $first] [format %g $last]]
        }
        1       \
        {
          # absolute movement
          set vtop [expr {int(double($args) * $_vheight)}]
        }
        2       \
        {
          # relative movement
          foreach {count unit} $args break
          if {[string match p* $unit]} { set count [expr {$count * 9}] }
          set vtop [expr {$_vtop + $count * 0.1 * $_height}]
        }
      }
      if {$vtop < 0} { set vtop 0 }
      if {$vtop + $_height > $_vheight} { set vtop [expr {$_vheight - $_height}] }
      if {$vtop != $_vtop || $count == 0} \
      {
        set ($w:vtop) $vtop
        yset $w
#08-15-05 peter---------for UDE----------------------------------------
        set gg [winfo height $w]
        set hh [winfo reqheight $w.scrolled]
        set ff [expr $gg - $hh]
        if [expr $gg <= $hh] {set ff 0}
#peter-------------------------------------------------------- 
        place $w.scrolled -in $w -y [expr {-$vtop} - $ff]
      }
    }

  # end of ::scrolledframe namespace definition
  }

namespace import ::scrolledframe::scrolledframe
