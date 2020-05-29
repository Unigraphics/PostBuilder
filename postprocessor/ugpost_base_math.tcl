###############################################################################
###                  U G P O S T _ B A S E _ M A T H . T C L
###############################################################################

#<12-10-2012 gsl> Access global vars via :: to reduce initialization of globals in each command.
#                 This may not work for older versions (v7.6) of Tcl (on unix).

# Global vars
set mom_system_tolerance               0.0000001
set PI      [expr {2.0 * asin(1.0)}]               ; # Value of PI
set RAD2DEG [expr {90.0 / asin(1.0)}]              ; # Multiplier to convert radians to degrees
set DEG2RAD [expr {asin(1.0) / 90.0}]              ; # Multiplier to convert degrees to radians

###############################################################################
#
# DESCRIPTION
#
#   Procs used to detect equality between scalars of real data type.
#
#  global mom_system_tolerance
#
#  EQ_is_equal(s, t)  (abs(s-t) <= mom_system_tolerance) Return true if scalars are equal
#  EQ_is_ge(s, t)     (s > t - mom_system_tolerance)     Return true if s is greater than
#                                            or equal to t
#  EQ_is_gt(s, t)     (s > t + mom_system_tolerance)     Return true if s is greater than t
#  EQ_is_le(s, t)     (s < t + mom_system_tolerance)     Return true if s is less than or
#                                            equal to t
#  EQ_is_lt(s, t)     (s < t - mom_system_tolerance)     Return true if s is less than t
#  EQ_is_zero(s)      (abs(s) < mom_system_tolerance)    Return true if scalar is zero
#  EQ_is_zero_tol(s, tol)  (abs(s) < tol)                Return true if scalar is zero
#  EQ_is_equal_tol(s, t, tol)  (abs(s-t) <= tol)         Return true if scalars are equal
#
################################################################################
if 0 { ;# Old version
proc  EQ_is_zero { s } {
   expr { abs($s) <= $::mom_system_tolerance }
}

proc  EQ_is_equal { s t } {
   expr { abs($s - $t) <= $::mom_system_tolerance }
}
}

#<11-20-12 gsl> new version to include "tol"
# Variable as default value for "tol" is evaluated when command is defined (only once).
# Alternative would be to use constant "0.0000001" for the default value for "tol".
#
proc  EQ_is_zero [list s [list tol $mom_system_tolerance]] {
   expr { abs($s) <= $tol }
}

proc  EQ_is_equal [list s t [list tol $mom_system_tolerance]] {
	expr { abs($s - $t) <= $tol }
}

proc  EQ_is_ge { s t } {
	expr { $s > ($t - $::mom_system_tolerance) } 
}

proc  EQ_is_gt { s t } {
	expr { $s > ($t + $::mom_system_tolerance) }
}

proc  EQ_is_le { s t } {
	expr { $s < ($t + $::mom_system_tolerance) } 
}

proc  EQ_is_lt { s t } {
	expr { $s < ($t - $::mom_system_tolerance) } 
}

#<11-20-12 gsl> With changes to the original commands, we may not need the new ones after all.
proc  EQ_is_zero_tol { s tol } {
   expr { abs($s) <= $tol }
}

proc  EQ_is_equal_tol { s t tol } {
   expr { abs($s - $t) <= $tol }
}

################################################################################
#
# DESCRIPTION
#
#   Procs used to manipulate vectors
#
#  VEC3_add(u,v,w)                  w = u + v          Vector addition
#  VEC3_cross(u,v,w)                w = ( u X v )      Vector cross product
#  VEC3_dot(u,v)                    (u dot v)          Vector dot product
#  VEC3_init(x,y,z,w)               w = (x, y, z)      Initialize a vector from
#                                                      coordinates
#  VEC3_is_equal(u,v,tol)           (||(u-v)|| < tol)  Are vectors equal?
#  VEC3_is_zero(u,tol)              (|| u || < tol)    Is vector zero?
#  VEC3_mag(u)                      ( || u || )        Vector magnitude
#  VEC3_negate(u,w)                 w = (-u)           Vector negate
#  VEC3_scale(s,u,w)                w = (s*u)          Vector scale
#  VEC3_sub(u,v,w)                  w = u - v          Vector subtraction
#  VEC3_unitize(u,tol,len,w)        *len = || u ||     Vector unitization
#                                   w = u / *len
################################################################################
proc  VEC3_add { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(0) + $v1(0) }]
	set w1(1) [expr { $u1(1) + $v1(1) }]
	set w1(2) [expr { $u1(2) + $v1(2) }]
}

proc  VEC3_cross { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(1) * $v1(2) - $u1(2) * $v1(1) }]
	set w1(1) [expr { $u1(2) * $v1(0) - $u1(0) * $v1(2) }]
	set w1(2) [expr { $u1(0) * $v1(1) - $u1(1) * $v1(0) }]
}

proc  VEC3_dot { u v } {
	upvar $u u1 ; upvar $v v1
	
	expr { $u1(0) * $v1(0) + $u1(1) * $v1(1) + $u1(2) * $v1(2) }
}

proc  VEC3_init { x y z w } {
	upvar $x x1 ; upvar $y y1 ; upvar $z z1 ; upvar $w w1
	
	set w1(0) $x1 ; set w1(1) $y1 ; set w1(2) $z1
}

proc  VEC3_is_equal { u v } {
	upvar $u u1 ; upvar $v v1
	
   expr { [EQ_is_equal $u1(0) $v1(0)] && [EQ_is_equal $u1(1) $v1(1)] && [EQ_is_equal $u1(2) $v1(2)] }
}

proc  VEC3_is_zero { u } {
	upvar $u u1
	
   expr { [EQ_is_zero $u1(0)] && [EQ_is_zero $u1(1)] && [EQ_is_zero $u1(2)] }
}

proc  VEC3_mag { u } {
	upvar $u u1
	
	expr { sqrt([VEC3_dot u1 u1]) }
}

proc  VEC3_negate { u w } {
	upvar $u u1 ; upvar $w w1
	
	set w1(0) [expr { -$u1(0) }]
	set w1(1) [expr { -$u1(1) }]
	set w1(2) [expr { -$u1(2) }]
}

proc  VEC3_scale { s u w } {
	upvar $s s1 ; upvar $u u1 ; upvar $w w1

	set w1(0) [expr { $s1 * $u1(0) }]
	set w1(1) [expr { $s1 * $u1(1) }]
	set w1(2) [expr { $s1 * $u1(2) }]
}

proc  VEC3_sub { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(0) - $v1(0) }]
	set w1(1) [expr { $u1(1) - $v1(1) }]
	set w1(2) [expr { $u1(2) - $v1(2) }]
}

proc  VEC3_unitize { u w } {
	upvar $u u1 ; upvar $w w1
	
	if { [VEC3_is_zero u1] } {
		set len 0.0
		set w1(0) 0.0
		set w1(1) 0.0
		set w1(2) 0.0
	} else {
		set len [VEC3_mag u1]
		set scale [expr { 1.0/$len }]
		VEC3_scale scale u1 w1
	}

	return $len
}
