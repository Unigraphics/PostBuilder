################################################################################
#
# (C) dCADE Gesellschaft fuer Produktionsinformatik mbH, 1996
# Gustav-Meyer-Allee 25
# D-13355 Berlin
#
# File name:			math.tcl
#
# File description:	This file contains mathematical procedures for the 
# 							TCL high level motion commands
#							for IS&V
#
#
#===============================================================================
#	Revision	Date				Name					Reason
#	00			07-Aug-2000		Frank Armbrust		Initial
#   01          04-Oct-2001     Yakove Dayan        Changed  MOM_SIM_VNormL
#   02          28-Dec-2001     Yakove Dayan        Added MOM_SIM_VScale
#   03          02-Jul-2002     Yakove Dayan        Fixed MOM_SIM_VScaleL
#$HISTORY$
#
################################################################################


# puts -nonewline [format "%-70s" "Source [info script]..."]

#-------------------------------------------------------------------------------
#MOM_SIM_MatMultVector
#MOM_SIM_MatMultVectorL
#
#	Modul: 					math
#
#	Task:						multiply matrix with vector 
#								array syntax
#								list syntax
#
#	Arguments:				matrix and vector 
#
#	Results:					vector 
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_MatMultVector { result matrix vector } {
	upvar 1 $matrix MAT
	upvar 1 $vector VEC
	upvar 1 $result RESULT
	set length [array size VEC]

	for {set j 1} {$j<=$length} {incr j} {
		set tvector 0
		for {set i 1} {$i<=$length} {incr i} {
			set tvector [expr $tvector+ $MAT($j,$i)*$VEC($i)]
		}
		set RESULT($j) $tvector
	}
}
# End of procedure

proc MOM_SIM_MatMultVectorL { matrix vector } {
	set length [llength $vector]

	MOM_SIM_listToMatrix MAT $matrix $length

	MOM_SIM_listToVector VEC $vector $length

	MOM_SIM_MatMultVector RESULT MAT VEC 
	
	return [MOM_SIM_vectorToList RESULT $length]
}
# End of procedure


#-------------------------------------------------------------------------------
#MOM_SIM_MatMultMat
#MOM_SIM_MatMultMatL
#
#	Modul: 					math
#
#	Task:						multiply matrix with matrix 
#								(only valid for symmetric matrix)
#								array syntax 
#								list syntax
#
#	Arguments:				result matrix, matrix 1 and matrix 2	
#
#	Results:					matrix
#			
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_MatMultMat {result matrix1 matrix2} \
{
	upvar 1 $matrix1 MAT1
	upvar 1 $matrix2 MAT2
	upvar 1 $result  RESULT

	set length [expr int(sqrt([array size MAT1]))]
	for {set i 1} {$i<=$length} {incr i} \
	{
		for {set j 1} {$j<=$length} {incr j} \
		{
			set val 0
			for {set k 1} {$k<=$length} {incr k} \
			{
				set val [expr $val + $MAT1($i,$k) * $MAT2($k,$j)]
			}
			set RESULT($i,$j) $val
		}
	}
}
# End of procedure

proc MOM_SIM_MatMultMatL {matrix1 matrix2} \
{
	set length [expr int(sqrt([llength $matrix1]))]
	
	MOM_SIM_listToMatrix MAT1 $matrix1 $length
	MOM_SIM_listToMatrix MAT2 $matrix2 $length

	MOM_SIM_MatMultMat MAT MAT1 MAT2

	return [MOM_SIM_matrixToList MAT $length]
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VNorm
#MOM_SIM_VNormL
#
#	Modul: 					math
#
#	Task:						create normalize vector					
#								array syntax
#								list syntax
#
#	Arguments:				result vector, vector
#
#	Results:					vector
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VNorm { result vector } {
	upvar 1 $vector VEC
	upvar 1 $result RESULT
	set vlength [expr sqrt(pow($VEC(1),2)+pow($VEC(2),2)+pow($VEC(3),2))]

	if {$vlength>0.0} {
		for {set i 1} {$i<=3} {incr i} {
			set RESULT($i) [expr $VEC($i)/$vlength]
		}
	}
}
# End of procedure

proc MOM_SIM_VNormL { vector } {
	set length [expr sqrt(pow([lindex $vector 0],2)+pow([lindex $vector 1],2) \
			+ pow([lindex $vector 2],2))]
    

	if {$length>0.0} {
		for {set i 0} {$i<3} {incr i} {
			lappend nvector [expr [lindex $vector $i]/$length]
		}
	} else {
        set nvector $vector
    }
	return $nvector
}
# End of procedure


#-------------------------------------------------------------------------------
#MOM_SIM_VAddAndMultiply
#MOM_SIM_VAddAndMultiplyL
#
#	Modul: 					math
#
#	Task:						v = v1+k*v2
#								array syntax
#								list syntax
#
#	Arguments:				result vector, vector1, vector2, scalar
#
#	Results:					vector	
#			
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VAddAndMultiply { result vector1 vector2 scalar} {
	upvar 1 $vector1 VEC1
	upvar 1 $vector2 VEC2
	upvar 1 $result RESULT
	for {set i 1} {$i<=3} {incr i} {
		set RESULT($i) [expr $VEC1($i)+$scalar*$VEC2($i)]
	}
}
# End of procedure

proc MOM_SIM_VAddAndMultiplyL { vector1 vector2 scalar} {
	for {set i 0} {$i<3} {incr i} {
		lappend result [expr [lindex $vector1 $i]+$scalar*[lindex $vector2 $i]]
	}
	return $result
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VMultiply
#MOM_SIM_VMultiplyL
#
#	Modul: 					math
#
#	Task:						multiply vector with vector				
#								array syntax
#								list syntax
#
#	Arguments:				vector1, vector2	
#
#	Results:					scalar
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VMultiply { vector1 vector2 } {
	upvar 1 $vector1 VEC1
	upvar 1 $vector2 VEC2
	set result 0
	for {set i 1} {$i<=3} {incr i} {
		set result [expr $result+$VEC1($i)*$VEC2($i)]
	}
	return $result
}
# End of procedure

proc MOM_SIM_VMultiplyL { vector1 vector2 } {
	set result 0
	for {set i 0} {$i<3} {incr i} {
		set result [expr $result+[lindex $vector1 $i]*[lindex $vector2 $i]]
	}
	return $result
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VDiff
#MOM_SIM_VDiffL
#
#	Modul: 					math
#
#	Task:						difference beetween two vectors
#								array syntax	
#								list syntax	
#
#	Arguments:				result vector, vector1, vector2	
#
#	Results:					vector	
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VDiff { result vector1 vector2 } {
	upvar 1 $vector1 VEC1
	upvar 1 $vector2 VEC2
	upvar 1 $result  RESULT
	for {set i 1} {$i<=3} {incr i} {
		set RESULT($i) [expr $VEC1($i)-$VEC2($i)]
	}
}
# End of procedure

proc MOM_SIM_VDiffL { vector1 vector2 } {
	for {set i 0} {$i<3} {incr i} {
		lappend vector [expr [lindex [join $vector1] $i]-[lindex [join $vector2] $i]]
	}
	return $vector
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VAdd
#MOM_SIM_VAddL
#
#	Modul: 					math
#
#	Task:						sum of two vectors
#								array syntax	
#								list syntax	
#
#	Arguments:				return vector, vector1, vector2	
#
#	Results:					vector	
#			
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VAdd { result vector1 vector2 } {
	upvar 1 $vector1 VEC1
	upvar 1 $vector2 VEC2
	upvar 1 $result  RESULT
	for {set i 1} {$i<=3} {incr i} {
		set RESULT($i) [expr $VEC1($i)+$VEC2($i)]
	}
}
# End of procedure

proc MOM_SIM_VAddL { vector1 vector2 } {
	for {set i 0} {$i<3} {incr i} {
		lappend vector [expr [lindex [join $vector1] $i]+[lindex [join $vector2] $i]]
	}
	return $vector
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VLength
#MOM_SIM_VLengthL
#
#	Modul: 					math
#
#	Task:						calculate vector length
#								array syntax	
#								list syntax	
#
#	Arguments:				vector
#
#	Results:					scalar	
#			
#		
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VLength { vector } {
	upvar 1 $vector VEC
	set scalar 0
	for {set i 1} {$i<=3} {incr i} {
		set scalar [expr $scalar+pow($VEC($i),2)]
	}
	return [expr sqrt($scalar)]
}
# End of procedure

proc MOM_SIM_VLengthL { vector } {
	set scalar 0
	for {set i 0} {$i<3} {incr i} {
		set scalar [expr $scalar+[lindex $vector $i]*[lindex $vector $i]]
	}
	return [expr sqrt($scalar)]
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VCross
#MOM_SIM_VCrossL
#
#	Modul: 					math
#
#	Task:						vector cross product
#								array syntax	
#								list syntax	
#
#	Arguments:				result vector, vector1, vector2	
#
#	Results:					vector
#			
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_VCross { result vector1 b } {
	upvar $vector1 VEC1
	upvar $vector2 VEC2
	upvar $result RESULT
	set RESULT(1) [expr $VEC1(2)*$VEC2(3)-$VEC1(3)*$VEC2(2)]
	set RESULT(2) [expr $VEC1(3)*$VEC2(1)-$VEC1(1)*$VEC2(3)]
	set RESULT(3) [expr $VEC1(1)*$VEC2(2)-$VEC1(2)*$VEC2(1)]
}
# End of procedure

proc MOM_SIM_VCrossL { vector1 vector2 } {
	lappend result [expr [lindex $vector1 1]*[lindex $vector2 2]- \
		[lindex $vector1 2]*[lindex $vector2 1]]
	lappend result [expr [lindex $vector1 2]*[lindex $vector2 0]- \
		[lindex $vector1 0]*[lindex $vector2 2]]
	lappend result [expr [lindex $vector1 0]*[lindex $vector2 1]- \
		[lindex $vector1 1]*[lindex $vector2 0]]
	return $result
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_MatInvert
#MOM_SIM_MatInvertL
#
#	Modul: 					math
#
#	Task:						invert 3x3 matrix
#								array syntax	
#								list syntax	
#
#	Arguments:				result matrix, matrix	
#
#	Results:					matrix	
#			
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_MatInvert { result matrix } \
{
	upvar 1 $matrix MAT
	upvar 1 $result RESULT

	set DET [expr $MAT(1,1)*$MAT(2,2)*$MAT(3,3)+ \
	              $MAT(1,2)*$MAT(2,3)*$MAT(3,1)+ \
					  $MAT(1,3)*$MAT(2,1)*$MAT(3,2)- \
					  $MAT(1,1)*$MAT(2,3)*$MAT(3,2)- \
					  $MAT(1,2)*$MAT(2,1)*$MAT(3,3)- \
					  $MAT(1,3)*$MAT(2,2)*$MAT(3,1)]

	if {[expr abs($DET)]<0.000003} \
	{
		error "Error: Matrix singularity!"
		return -code error
	}

	set D1 [expr $MAT(2,2)*$MAT(3,3)-$MAT(2,3)*$MAT(3,2)]
	set D2 [expr $MAT(2,3)*$MAT(3,1)-$MAT(2,1)*$MAT(3,3)]
	set D3 [expr $MAT(2,1)*$MAT(3,2)-$MAT(2,2)*$MAT(3,1)]
	set D4 [expr $MAT(3,2)*$MAT(1,3)-$MAT(3,3)*$MAT(1,2)]
	set D5 [expr $MAT(3,3)*$MAT(1,1)-$MAT(3,1)*$MAT(1,3)]
	set D6 [expr $MAT(3,1)*$MAT(1,2)-$MAT(3,2)*$MAT(1,1)]
	set D7 [expr $MAT(1,2)*$MAT(2,3)-$MAT(1,3)*$MAT(2,2)]
	set D8 [expr $MAT(1,3)*$MAT(2,1)-$MAT(1,1)*$MAT(2,3)]
	set D9 [expr $MAT(1,1)*$MAT(2,2)-$MAT(1,2)*$MAT(2,1)]

	set RESULT(1,1) [expr $D1/$DET]
	set RESULT(1,2) [expr $D4/$DET]
	set RESULT(1,3) [expr $D7/$DET]
	set RESULT(2,1) [expr $D2/$DET]
	set RESULT(2,2) [expr $D5/$DET]
	set RESULT(2,3) [expr $D8/$DET]
	set RESULT(3,1) [expr $D3/$DET]
	set RESULT(3,2) [expr $D6/$DET]
	set RESULT(3,3) [expr $D9/$DET]
}
# End of procedure

proc MOM_SIM_MatInvertL { matrix } \
{
	MOM_SIM_listToMatrix MAT $matrix 3

	MOM_SIM_MatInvert RESULT MAT

	return [MOM_SIM_matrixToList RESULT 3]
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_listToMatrix
#
#	Modul: 					math
#
#	Task:						convert list to matrix
#
#	Arguments:				result matrix, matrix (list), number of rows
#
#	Results:					matrix
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_listToMatrix {result matrix length} {

	upvar 1 $result MAT
	
	if {[llength $matrix] == 1} \
	{
		set matrix [lindex $matrix 0]
	}

	set index 0
	for {set i 1} {$i<=$length} {incr i} {
		for {set j 1} {$j<=$length} {incr j} {
			set MAT($i,$j) [lindex $matrix $index]
			incr index
		}
	}
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_listToVector
#
#	Modul: 					math
#
#	Task:						convert list to vector 
#
#	Arguments:				result vector, vector (list), number of rows	
#
#	Results:					vector
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_listToVector {result liste length} {

	upvar 1 $result VEC
	
	if {[llength $liste] == 1} \
	{
		set liste [lindex $liste 0]
	}

	set index 0
	for {set i 1} {$i<=$length} {incr i} {
		set VEC($i) [lindex $liste $index]
		incr index
	}
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_matrixToList
#
#	Modul: 					math
#
#	Task:						convert matrix to list
#
#	Arguments:				matrix, number of rows
#
#	Results:					matrix (list)	
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_matrixToList {matrix length} {

	upvar 1 $matrix MAT
	
	for {set i 1} {$i<=$length} {incr i} \
	{
		for {set j 1} {$j<=$length} {incr j} \
		{
			lappend mmatrix $MAT($i,$j)
		}
	}
	return $mmatrix
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_vectorToList
#
#	Modul: 					math
#
#	Task:						convert vector to list
#
#	Arguments:				vector, number of rows		
#
#	Results:					vector (list)	
#
# 	Last modification:	07.08.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc	MOM_SIM_vectorToList { vector length } \
{
	upvar 1 $vector VEC
	for {set i 1} {$i<=$length} {incr i} \
	{
		lappend nvector $VEC($i)
	}
	return $nvector
}

# End of procedure

proc MOM_SIM_max { liste } \
{
	return [lindex [lsort -real $liste] end]
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_VScale
#MOM_SIM_VScaleL
#
#	Modul: 					math
#
#	Task:						v = k*v
#								array syntax
#								list syntax
#
#	Arguments:				result vector, scalar
#
#	Results:					vector	
#			
# 	Last modification:	
#	
# 	Owner:				
#-------------------------------------------------------------------------------

proc MOM_SIM_VScale { result vector scalar} {
	upvar 1 $vector VEC
	upvar 1 $result RESULT
	for {set i 1} {$i<=3} {incr i} {
		set RESULT($i) [expr $scalar*$VEC($i)]
	}
}
# End of procedure

proc MOM_SIM_VScaleL { vector scalar} {
	for {set i 0} {$i<3} {incr i} {
		lappend result [expr {$scalar*[lindex $vector $i]}]
	}
	return $result
}
# End of procedure

# puts "Done"
