###############################################################################
###                  U G P O S T _ B A S E _ M A T H . T C L
###############################################################################
#
# 
#


# Global vars
set mom_system_tolerance               0.0000001
set PI      [expr {2.0 * asin(1.0)}]               ; # Value of PI
set RAD2DEG [expr {90.0 / asin(1.0)}]              ; # Multiplier to convert radians to degrees
set DEG2RAD [expr {asin(1.0) / 90.0}]              ; # Multiplier to convert degrees to radians

###############################################################################
#
# DESCRIPTION
#
#  Procs used to detect equality & inequality between scalars of real data type.
#  Argument "tol" is optional; if not specified, it's default to mom_system_tolerance.
#
#  global mom_system_tolerance
#
#  EQ_is_zero  ( s, tol )         ( abs(s)   <  tol )  Returns true if scalar is zero
#  EQ_is_equal ( s, t, tol )      ( abs(s-t) <= tol )  Returns true if scalars are equal
#  EQ_is_ge    ( s, t, tol )      ( s > t - tol )      Returns true if s is greater than or equal to t
#  EQ_is_gt    ( s, t, tol )      ( s > t + tol )      Returns true if s is greater than t
#  EQ_is_le    ( s, t, tol )      ( s < t + tol )      Returns true if s is less than or equal to t
#  EQ_is_lt    ( s, t, tol )      ( s < t - tol )      Returns true if s is less than t
#
#  ==> Next 2 commands should be used in this file, because large number of PB created posts
#      still contain EQ_is_zero & EQ_is_equal that override the same commands defined here.
#      * PB v11.0 will remove the override of EQ_is_zero & EQ_is_equal from the posts when resaved.
#  EQ_is_zero_tol  ( s, tol )     ( abs(s)   <  tol )  Returns true if scalar is zero
#  EQ_is_equal_tol ( s, t, tol )  ( abs(s-t) <= tol )  Returns true if scalars are equal
#
################################################################################
if 0 { ;# Old version
proc EQ_is_zero { s } {
   expr { abs($s) <= $::mom_system_tolerance }
}

proc EQ_is_equal { s t } {
   expr { abs($s - $t) <= $::mom_system_tolerance }
}
}

#<11-20-12 gsl> new version to include "tol"
# Variable $mom_system_tolerance as default value for "tol" is evaluated when command is defined (only once).
# Alternative would be to use constant "0.0000001" for the default value for "tol".
#
proc EQ_is_zero [list s [list tol $mom_system_tolerance]] {
   expr { abs($s) <= $tol }
}

proc EQ_is_equal [list s t [list tol $mom_system_tolerance]] {
	expr { abs($s - $t) <= $tol }
}

proc EQ_is_ge [list s t [list tol $mom_system_tolerance]] {
	expr { $s > ($t - $tol) } 
}

proc EQ_is_gt [list s t [list tol $mom_system_tolerance]] {
	expr { $s > ($t + $tol) }
}

proc EQ_is_le [list s t [list tol $mom_system_tolerance]] {
	expr { $s < ($t + $tol) } 
}

proc EQ_is_lt [list s t [list tol $mom_system_tolerance]] {
	expr { $s < ($t - $tol) } 
}

#<11-20-12 gsl> With changes to the original commands, we may not need the new ones after all.
proc EQ_is_zero_tol { s tol } {
   expr { abs($s) <= $tol }
}

proc EQ_is_equal_tol { s t tol } {
   expr { abs($s - $t) <= $tol }
}

################################################################################
#
# DESCRIPTION
#
#  Procs used to manipulate vectors
#
#  VEC3_add      ( u, v, w )          w = u + v            Vector addition
#  VEC3_cross    ( u, v, w )          w = ( u X v )        Vector cross product
#  VEC3_dot      ( u, v )             ( u . v )            Vector dot product. - Returns result
#  VEC3_init     ( x, y, z, w )       w = ( x, y, z )      Initialize a vector from coordinates
#  VEC3_is_equal ( u, v, tol )        ( ||(u-v)|| < tol )  Are vectors equal? - Returns 1/0
#  VEC3_is_zero  ( u, tol )           ( || u || < tol )    Is vector zero? - Returns 1/0
#  VEC3_mag      ( u )                ( || u || )          Vector magnitude. - Returns result
#  VEC3_negate   ( u, w )             w = ( -u )           Vector negate
#  VEC3_scale    ( s, u, w )          w = ( s*u )          Vector scale
#  VEC3_sub      ( u, v, w )          w = u - v            Vector subtraction
#  VEC3_unitize  ( u, w, tol )        len = || u ||        Vector unitization
#                                     w = u / len          - Returns original length
#
################################################################################
proc VEC3_add { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(0) + $v1(0) }]
	set w1(1) [expr { $u1(1) + $v1(1) }]
	set w1(2) [expr { $u1(2) + $v1(2) }]
}

proc VEC3_cross { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(1) * $v1(2) - $u1(2) * $v1(1) }]
	set w1(1) [expr { $u1(2) * $v1(0) - $u1(0) * $v1(2) }]
	set w1(2) [expr { $u1(0) * $v1(1) - $u1(1) * $v1(0) }]
}

proc VEC3_dot { u v } {
	upvar $u u1 ; upvar $v v1
	
	expr { $u1(0) * $v1(0) + $u1(1) * $v1(1) + $u1(2) * $v1(2) }
}

proc VEC3_init { x y z w } {
	upvar $x x1 ; upvar $y y1 ; upvar $z z1 ; upvar $w w1
	
	set w1(0) $x1 ; set w1(1) $y1 ; set w1(2) $z1
}

proc VEC3_is_equal [list u v [list tol $mom_system_tolerance]] {
	upvar $u u1 ; upvar $v v1
	
   expr { [EQ_is_equal_tol $u1(0) $v1(0) $tol] && [EQ_is_equal_tol $u1(1) $v1(1) $tol] && [EQ_is_equal_tol $u1(2) $v1(2) $tol] }
}

proc VEC3_is_zero [list u [list tol $mom_system_tolerance]] {
	upvar $u u1
	
   expr { [EQ_is_zero_tol $u1(0) $tol] && [EQ_is_zero_tol $u1(1) $tol] && [EQ_is_zero_tol $u1(2) $tol] }
}

proc VEC3_mag { u } {
	upvar $u u1
	
	expr { sqrt( [VEC3_dot u1 u1] ) }
}

proc VEC3_negate { u w } {
	upvar $u u1 ; upvar $w w1
	
	set w1(0) [expr { -$u1(0) }]
	set w1(1) [expr { -$u1(1) }]
	set w1(2) [expr { -$u1(2) }]
}

proc VEC3_scale { s u w } {
	upvar $s s1 ; upvar $u u1 ; upvar $w w1

	set w1(0) [expr { $s1 * $u1(0) }]
	set w1(1) [expr { $s1 * $u1(1) }]
	set w1(2) [expr { $s1 * $u1(2) }]
}

proc VEC3_sub { u v w } {
	upvar $u u1 ; upvar $v v1 ; upvar $w w1
	
	set w1(0) [expr { $u1(0) - $v1(0) }]
	set w1(1) [expr { $u1(1) - $v1(1) }]
	set w1(2) [expr { $u1(2) - $v1(2) }]
}

proc VEC3_unitize [list u w [list tol $mom_system_tolerance]] {
	upvar $u u1 ; upvar $w w1
	
	if { [VEC3_is_zero u1 $tol] } {
		set len 0.0
		set w1(0) 0.0; set w1(1) 0.0; set w1(2) 0.0
	} else {
		set len [VEC3_mag u1]
		set scale [expr { 1.0 / $len }]
		VEC3_scale scale u1 w1
	}

	return $len
}

################################################################################
#
# DESCRIPTION
#
#  Procs used to manipulate matrices
#
#  MTX3_init_x_y_z   ( u, v, w, r, tol )   r = ( u, v, w )      Initialize a matrix from
#                                                               given x, y & z vectors and
#                                                               tol to determine zero vector
#                                                               - Returns 1/0 to indicate success or failure
#
#  MTX3_is_equal     ( m, n, tol )         ( m == n )           Determine if two matrices
#                                                               are equal to within a given tolerance
#                                                               - Returns 1/0
#
#  MTX3_multiply     ( m, n, r )           r = ( m X n )        Matrix multiplication
#  MTX3_transpose    ( m, r )              r = trns( m )        Transpose of matrix
#  MTX3_scale        ( s, r )              r = ( s*(u) )        Scale a matrix by s
#  MTX3_sub          ( m, n, r )           r = ( m - n )        Matrix subtraction
#  MTX3_add          ( m, n, r )           r = ( m - n )        Matrix addition
#  MTX3_vec_multiply ( u, m, w )           w = ( u X m )        Vector/matrix multiplication
#  MTX3_x            ( m, w )              w = ( 1st column )   First column vector of matrix
#  MTX3_y            ( m, w )              w = ( 2nd column )   Second column vector of matrix
#  MTX3_z            ( m, w )              w = ( 3rd column )   Third column vector of matrix
#
################################################################################

#  MTX3_init_x_y_z (u, v, w, r) r = (u, v, w)      Initialize a matrix from
#                                                  given x, y and z vectors
proc MTX3_init_x_y_z [list u v w r [list tol $mom_system_tolerance]] {
    upvar $u u1 ; upvar $v v1 ; upvar $w w1 ; upvar $r r1

    set status 0

   # Unitize input vectors
    set lx [VEC3_unitize u1 xxxxx $tol]
    set ly [VEC3_unitize v1 yyyyy $tol]
    set lz [VEC3_unitize w1 zzzzz $tol]

   # Proceed when none of vectors is zero,
    if { !( [EQ_is_zero_tol $lx $tol] || [EQ_is_zero_tol $ly $tol] || [EQ_is_zero_tol $lz $tol] ) } {

       # Input vectors are orthogonal
        if { [EQ_is_zero_tol [VEC3_dot xxxxx yyyyy] $tol] && \
             [EQ_is_zero_tol [VEC3_dot xxxxx zzzzz] $tol] && \
             [EQ_is_zero_tol [VEC3_dot yyyyy zzzzz] $tol] } {

           # Cross the unitized input vectors and initialize the matrix
           # Orthogonolity test is stricter than EQ_ask_systol, so
           # recalculate y and z.

            set status 1

            VEC3_cross xxxxx yyyyy zzzzz
            VEC3_unitize zzzzz zzzzz $tol
            VEC3_cross zzzzz xxxxx yyyyy

            set r1(0) $xxxxx(0)
            set r1(1) $xxxxx(1)
            set r1(2) $xxxxx(2)
            set r1(3) $yyyyy(0)
            set r1(4) $yyyyy(1)
            set r1(5) $yyyyy(2)
            set r1(6) $zzzzz(0)
            set r1(7) $zzzzz(1)
            set r1(8) $zzzzz(2)
        }
    }

    return $status
}

#  MTX3_is_equal(m,n)         (m == n)             Determine if two matrices
#                                                  are equal to within a given
#                                                  tolerance
proc MTX3_is_equal [list m n [list tol $mom_system_tolerance]] {
    upvar $m m1 ; upvar $n n1

    for { set ii 0 } { $ii < 9 } { incr ii } {
        if { ![EQ_is_equal_tol $m1($ii) $n1($ii) $tol] } { return 0 }
    }

    return 1
}

#  MTX3_multiply(m, n, r)       r = ( m X n )      Matrix multiplication
proc MTX3_multiply { m n r } {
    upvar $m m1 ; upvar $n n1 ; upvar $r r1
    set r1(0) [expr ($m1(0) * $n1(0) + $m1(3) * $n1(1) + $m1(6) * $n1(2))]
    set r1(1) [expr ($m1(1) * $n1(0) + $m1(4) * $n1(1) + $m1(7) * $n1(2))]
    set r1(2) [expr ($m1(2) * $n1(0) + $m1(5) * $n1(1) + $m1(8) * $n1(2))]
    set r1(3) [expr ($m1(0) * $n1(3) + $m1(3) * $n1(4) + $m1(6) * $n1(5))]
    set r1(4) [expr ($m1(1) * $n1(3) + $m1(4) * $n1(4) + $m1(7) * $n1(5))]
    set r1(5) [expr ($m1(2) * $n1(3) + $m1(5) * $n1(4) + $m1(8) * $n1(5))]
    set r1(6) [expr ($m1(0) * $n1(6) + $m1(3) * $n1(7) + $m1(6) * $n1(8))]
    set r1(7) [expr ($m1(1) * $n1(6) + $m1(4) * $n1(7) + $m1(7) * $n1(8))]
    set r1(8) [expr ($m1(2) * $n1(6) + $m1(5) * $n1(7) + $m1(8) * $n1(8))]
}

#  MTX3_transpose(m, r)         r = trns(m)        Transpose of matrix
proc MTX3_transpose { m r } {
    upvar $m m1 ; upvar $r r1
    set r1(0) $m1(0)
    set r1(1) $m1(3)
    set r1(2) $m1(6)
    set r1(3) $m1(1)
    set r1(4) $m1(4)
    set r1(5) $m1(7)
    set r1(6) $m1(2)
    set r1(7) $m1(5)
    set r1(8) $m1(8)
}

#  MTX3_scale(s,r)              r = (s*(u))        Scale a matrix by s
proc MTX3_scale { s r } {
    upvar $r r1
    for { set ii 0 } { $ii < 9 } { incr ii } {
        set r1($ii) [expr ($s * $r1($ii))]
    }
}

#  MTX3_sub(m,n,r)              r = (m - n)        Matrix subtraction
proc MTX3_sub { m n r } {
    upvar $m m1 ; upvar $n n1 ; upvar $r r1
    for { set ii 0 } { $ii < 9 } { incr ii } {
        set r1($ii) [expr ($m1($ii) - $n1($ii))]
    }
}

#  MTX3_add(m,n,r)              r = (m + n)        Matrix addition
proc MTX3_add { m n r } {
    upvar $m m1 ; upvar $n n1 ; upvar $r r1
    for { set ii 0 } { $ii < 9 } { incr ii } {
        set r1($ii) [expr ($m1($ii) + $n1($ii))]
    }
}

#  MTX3_vec_multiply(u, m, w)   w = (u X m)        Vector/matrix multiplication
proc MTX3_vec_multiply { u m w } {
    upvar $u u1 ; upvar $m m1 ; upvar $w w1
    set w1(0) [expr ($u1(0) * $m1(0) + $u1(1) * $m1(1) + $u1(2) * $m1(2))]
    set w1(1) [expr ($u1(0) * $m1(3) + $u1(1) * $m1(4) + $u1(2) * $m1(5))]
    set w1(2) [expr ($u1(0) * $m1(6) + $u1(1) * $m1(7) + $u1(2) * $m1(8))]
}

#  MTX3_x(m, w)                 w = (1st column)   First column vector of matrix
proc MTX3_x { m w } {
    upvar $m m1 ; upvar $w w1
    set w1(0) $m1(0)
    set w1(1) $m1(1)
    set w1(2) $m1(2)
}

#  MTX3_y(m, w)                 w = (2nd column)   Second column vector of matrix
proc MTX3_y { m w } {
    upvar $m m1 ; upvar $w w1
    set w1(0) $m1(3)
    set w1(1) $m1(4)
    set w1(2) $m1(5)
}

#  MTX3_z(m, w)                 w = (3rd column)   Third column vector of matrix
proc MTX3_z { m w } {
    upvar $m m1 ; upvar $w w1
    set w1(0) $m1(6)
    set w1(1) $m1(7)
    set w1(2) $m1(8)
}

