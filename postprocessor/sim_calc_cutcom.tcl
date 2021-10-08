################################################################################
#
#	Copyright (c) 2005 Unigraphics Solutions GmbH
#
#	Alt-Moabit 96 C
#	D-10559 Berlin
#
#	Filename:		sim_calc_cutcom.tcl
#
#	Description:	This file includes all necessary TCL procedures to do the
#						radius cutter compensation, based on 3 points (previous, 
#						actual and next) in a 2-D space calculation algorithm.
#
################################################################################

################################################################################
# Revisions
#
#	Date				Who					Reason
#	03-Mar-2003		Thomas Schulz		Initial Version
#	07-Apr-2003		Thomas Schulz		Finish updates with additional motion option
#	29-Oct-2003		Thomas Schulz		Add generic proc for RCC
#	23-Jul-2004		Thomas Schulz		Allow more circular interp. modes (CIP_mode)
#	04-Mar-2005		Thomas Schulz		Change ANWAHL/ABWAHL for GG
#	07-Mar-2005		Thomas Schulz		Change Calc_centerpoint due to different
#												behaviour betw. ANWAHL and ABWAHL
#	08-Mar-2005		Thomas Schulz		Change ABWAHL for KG
#	11-Mar-2005		Thomas Schulz		Reworked the KG and GK functions, due to
#												Tolerance problems. And change the
#												tolerance check in GG
#	16-Mar-2005		Thomas Schulz		Change case ANWAHL if line-circle GK
#	18-Mar-2005		Thomas Schulz		Change case KK add additional circle 
#												motion for all necessary cases.
#	22-Mar-2005		Thomas Schulz		Special handling for entire circle in KK
#												and KG - take old values instead of calc.
#	23-Feb-2006		Thomas Schulz		Fix some tolerance bugs related to scalar
#												product and acos, as well as compare 
#												tolerace for two vectors
#	18-Jan-2007		Thomas Schulz		Fix special case in circle-circle transition
#  10-Oct-2007		Thomas Schulz		rename DEBUG varaibel to avoid conflicts
#  11-Jun-2012		Thomas Schulz		Add optional parameter to not add circles
#												in case of GG. Fix PR1865763
#
################################################################################
proc Message { level str } \
{
	#	save the name of the function (without arguments) which calls Message
	if {[info level] > 1} \
	{
		set caller [lindex [info level -1] 0]
	} \
	else \
	{
		set caller ""
	}


	switch -- $level \
	{
		{0} \
		{
			#	Error level -> abort of the program
			MOM_output_to_listing_device  "ERROR: $str"
			return -code error	
		}
		{1} \
		{
			#	Warning level -> continue of the program
			MOM_output_to_listing_device "WARNING: $str"
		}
		{2} \
		{
			#	Information level -> continue of the program
			MOM_output_to_listing_device $str
		}
		{3} \
		{
			#	Source level -> continue of the program
			MOM_output_to_listing_device $str
		}
	}
}


################################################################################
################################################################################
#
# This part is responible for special radius_cutter_compensation handling
#
################################################################################
################################################################################
proc RCC_Calculate_values {	U0 V0 U1 V1 U2 V2 ipmode1 ipmode2 \
										toolradius CIP_mode rcc_mode \
										{A1 ""} {B1 ""} {A2 ""} {B2 ""} \
										{RADIUS1 ""} {RADIUS2 ""} \
										{ABWAHL 0} {ANWAHL 0} \
										{U0_corr ""} {V0_corr ""} \
										{GG_TYPE 0} } \
{
#-------------------------------------------------------------------------------
#
#	Return		0				-	No radius correction is done due to errors
#										The errors are given via procedure Message
#					1				-	Radius correction is done. Correction values
#										are stored in globals. See bellow
#					2				-	Radius correction is done. An additional circle
#										motion is necessary between the motions 
#										0-1 and 1-2	The vales are stored in globals
#
#	Parameter:	U0 V0 		-	previous 2D-Position
#
#					U1 V1			-	actual 2D-Position
#
#					U2 V2			-	next 2D-Position
#
#					ipmode1		-	Interpolation mode of first Motion 0-1
#					ipmode2		-	Interpolation mode of second Motion 1-2
#										ipmode 0 / 1	-> Linear Motion
#										ipmode 2			-> Circular Motion CW
#										ipmode 3			-> Circular Motion CCW
#
#					toolradius	-	radius of the actual tool
#
#					CIP_mode		-	mode of the circular interpolation
#										I, J, K (A,B)
#										1 absolute 
# 										2 incremental - I,J,K values
#										  Vector - Arc Start to Center
# 										3 incremental - I,J,K values
#										  Vector - Arc Center to Start
#										4 incremental - I,J,K values
#										  Unsigned Vector - Arc Start to Center
#
#					rcc_mode		-	The radius cutter compensation mode.
#										1 for right to contour in motion direction (G42)
#										-1 for left to contour in motion direction (G41)
#
#					U/V0_corr	-	This are the values of the previous corrected 
#										position. This values are necessary for the 
#										calculation in some specific cases
#										e.g. ABWAHL GG with no move...
#										If these values are not set the system sets as
#										default the uncorrected prevois position U/V0
#
#	Optional Parameter
#
#					A1 B1			-	center of the circle from 0-1
#					A2 B2			-	center of the circle from 1-2
#					RADIUS1		-	radius of the circle from 0-1
#					RADIUS2		-	radius of the circle from 1-2
#										If a circular motion is valid the procedure
#										needs A and B or RADIUS values. The procedure
#										first checks the A and B values. If they are not
#										given, the system calculates them out of the
#										RADIUS value.
#
#					ABWAHL		-	For the last correction before the correction
#										mode is switched of (G40). If ABWAHL is set to 1
#										then the previous corrected position is necessary
#										U0_corr and V0_corr to calculate the center of the
#										corrected circle motion
#
#					ANWAHL		-	For the first correction after the correction
#										mode is switched on. If this is done via a circle
#										motion the system calculates the center of the 
#										corrected circle motion.
#					GG_TYPE		-  Defined how system should combine two linear
#										motions. If set to "1" system will not add
#										additional circle motions.
#
#	RETURN VALUES				The calculated values are stored in global variables
#
#									-	DATA(RCC,U) DATA(RCC,V)
#										These are the main values. The offset correction
#										values due to the actual position! This means the
#										corrected actual position is:
#										$U1 + $DATA(RCC,U) 
#										$V1 + $DATA(RCC,V)
#
#									-	DATA(RCC,OLD_U) DATA(RCC,OLD_V)
#										This is the previous corrected position and is
#										used for the next call of the function
#
#										If an error occurs the data is set to:
#										DATA(RCC,U) = 0.0      DATA(RCC,V) = 0.0
#										DATA(RCC,OLD_U) = U0   DATA(RCC,OLD_U)	= V0
#
#									For some cases an additional motion between the 
#									two motions 0-1 1-2 are necessary. This is a
#									circular motion. The function return 2 for that case.
#									The following variable contains inforamtion about the
#									additionla motion.
#									-	DATA(RCC,GG,ADD_MOVE) 0/1
#									-	DATA(RCC,GK,ADD_MOVE) 0/1
#									-	DATA(RCC,KG,ADD_MOVE) 0/1
#									-	DATA(RCC,KK,ADD_MOVE) 0/1
#										If one of these varables is set to 1 this 
#										indicates, the additional motion.
#										GG -> 0-1 linear 1-2 linear
#										GK -> 0-1 linear 1-2 circle
#										KG -> 0-1 circle 1-2 linear
#										KK -> 0-1 circle 1-2 circle
#
#									-	DATA(RCC,ADD_MOVE,CENTER,U) 
#									-	DATA(RCC,ADD_MOVE,CENTER,V)
#										The position of the addinonal circle motion
#
#									-	DATA(RCC,ADD_MOVE,ROT) 2/3
#										The type or direction of the circle motion
#										2 -> CW
#										3 -> CCW
#
#									-	DATA(RCC,NEW_CP,U) DATA(RCC,NEW_CP,V) 
#									If ANWAHL or ABWAHL is set to 1 and a circular motion
#									is used for this motion then the a new corrected 
#									center point of the circle is calculated and stored
#
#	Used global variables	Some additional global variables are used
#
#									-	DATA(RCC,KK) 0/1
#
#									-	DEBUG_CUTCOM_NX(2) default value is 0 
#										This values can be set to output with Message 3
#										a lot of debug information (in german)
#
#									-	For Motion Type Circle-Linear and circle-cicrle
#										the corrected center point of the circle motion
#										will be stored if given via U/V0_corr in
#										DATA(RCC,OLD_CIRC_U)
#										DATA(RCC,OLD_CIRC_V)
#
#	Used Subfunctions			-	Message
#									-	Calc_centerpoint
#									-	circ_ip_mode_reset_values_to_abs
#									-	Calc_Center_from_Radius
#									-	CalcRadiusCorrGG
#									-	CalcRadiusCorrGK
#									-	CalcRadiusCorrKG
#									-	CalcRadiusCorrKK
#									-	KK_sub1
#
#-------------------------------------------------------------------------------
	global DEBUG_CUTCOM_NX
	global DATA

	set DATA(RCC,KK) 0
	set DATA(RCC,GK,ADD_MOVE) 0
	set DATA(RCC,KG,ADD_MOVE) 0
	set DATA(RCC,KK,ADD_MOVE) 0
	set DATA(RCC,GG,ADD_MOVE) 0
	
	if {[info exists DEBUG_CUTCOM_NX(2)] == 0} { set DEBUG_CUTCOM_NX(2) 0}

	# set DEBUG_CUTCOM_NX(1) 1
	# set DEBUG_CUTCOM_NX(2) 1

	# Display Input Values:
	if {$DEBUG_CUTCOM_NX(2)} \
	{
		Message 3 "---------- Input Parameter ---------"
		Message 3 "Punkt 0: $U0 $V0"
		Message 3 "Punkt 1: $U1 $V1"
		Message 3 "Punkt 2: $U2 $V2"
		Message 3 "IP-Mode 0-1:$ipmode1 1-2:$ipmode2"
		Message 3 "Radius: $toolradius CIP-Mode: $CIP_mode RCC-Mode: $rcc_mode"
		Message 3 "Kreis 1: $A1 $B1 "
		Message 3 "Kreis 2: $A2 $B2 "
		Message 3 "Kresiradien: $RADIUS1 $RADIUS2 "
		Message 3 "An-Abfahren: $ABWAHL $ANWAHL "
		Message 3 "Alter Corr-Wert: $U0_corr $V0_corr "
	}
	set DATA(RCC,ANWAHL) $ANWAHL
	set DATA(RCC,ABWAHL) $ABWAHL

	# Optional parameter for motion type in GG case
	set DATA(RCC,GG_MOTION_TYPE) $GG_TYPE

	if {$toolradius < 0.001 } \
	{
		# Add 04.03.2003 TS
		# Leave cutter compensation if radius is to small
		Message 2 "Radius to small -> No cutter compensation"
		return 0
	}

	if {[info exists DATA(PI)] == 0} \
		{ set DATA(PI) 3.1415926535897932384626433832795 }

	# Set default fpr previous corrected position
	if {[info exists U0_corr] == 0 } \
	{
		Message 2 "OLD corrected circle position is not set. Use U0"
		set DATA(RCC,OLD_U) $U0
	} \
	else \
		{ set DATA(RCC,OLD_U) $U0_corr }

	if {[info exists V0_corr] == 0 } \
	{
		Message 2 "OLD corrected circle position is not set. Use V0"
		set DATA(RCC,OLD_V) $V0
	} \
	else \
		{ set DATA(RCC,OLD_V) $V0_corr }

	set DATA(RCC,MODE) $rcc_mode

	if { $ipmode1 < 2 && $ipmode2 < 2} \
	{
	#--------Uebergang GERADE nach GERADE ----------

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall Gerade -> Gerade "}

		CalcRadiusCorrGG	$toolradius $U1 $V1 $U2 $V2 $U0 $V0

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  U $DATA(RCC,U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  V $DATA(RCC,V)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD V: $DATA(RCC,OLD_V)"}
	}

	if {$ipmode1 < 2 && $ipmode2 > 1} \
	{
	#--------Uebergang GERADE nach KREIS ----------

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall Gerade -> Kreis "}

		# Check if all data for circle interpolation is set in the NC-Block

		if {$A2 == "" && $B2 == "" } \
		{
			# Check data for center position
			if {$RADIUS2 == ""} \
			{
				Message 2 "WARNING: To less data for circle movement"
				return 0
			}

			# Calculate Centerposition from radius

			set c_pos [Calc_Center_from_Radius	$U1 $V1 $U2 $V2 $RADIUS2 \
															$ipmode2 $CIP_mode]

			set A2 [lindex $c_pos 0]
			set B2 [lindex $c_pos 1]
		} \
		else \
		{
			if { $A2 == ""} \
				{ if {$CIP_mode == 1} { set A2 $U1 } { set A2 0.0 } }

			if { $B2 == ""} \
				{ if {$CIP_mode == 1} { set B2 $V1 } { set B2 0.0 } }
		}

		# gesammt Korrekturrechnung beruht auf incrementale KB (mode 2)
		# Bei anderem mode deshalb A2 und B2 umsetzen
		set result [circ_ip_mode_reset_values_to_abs $A2 $B2 $U1 $V1 $U2 $V2 $CIP_mode]

		if {[lindex $result 0] == 0} \
			{ return 0} \
		else \
			{set A2 [lindex $result 1]; set B2 [lindex $result 2]}

		CalcRadiusCorrGK	$ipmode2 $toolradius $U1 $V1 $U0 $V0 $A2 $B2

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  U $DATA(RCC,U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  V $DATA(RCC,V)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD V: $DATA(RCC,OLD_V)"}

		if {$DATA(RCC,ABWAHL)} \
		{
			# Richtungsvektor vom programmierten Startpunkt zum Mittelpunkt
			set nemu	[expr ($U1 + $A2) - $U1]
			set nemv	[expr ($V1 + $B2) - $V1]
			
			set rad_circ	[expr sqrt([expr $A2*$A2+$B2*$B2])]
			
			set nemu [expr $nemu / $rad_circ] 
			set nemv [expr $nemv / $rad_circ] 
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nemu = $nemu und nemv = $nemv"}

			Calc_centerpoint	$DATA(RCC,OLD_U) $DATA(RCC,OLD_V) \
									$U2 $V2 $nemu $nemv AB
		}
	}

	if {$ipmode1 > 1 && $ipmode2 < 2} \
	{
	#--------Uebergang KREIS nach GERADE ----------

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall Kreis -> Gerade "}

		# Check if all data for circle interpolation is set in the NC-Block

		if {$A1 == "" && $B1 == "" } \
		{
			# Check data for center position
			if {$RADIUS1 == ""} \
			{
				Message 2 "WARNING: To less data for circle movement"
				return 0 
			}

			# Calculate Centerposition from radius

			set c_pos [Calc_Center_from_Radius	$U0 $V0 $U1 $V1 $RADIUS1 \
															$ipmode1 $CIP_mode]

			set A1 [lindex $c_pos 0]
			set B1 [lindex $c_pos 1]
		} \
		else \
		{
			if { $A1 == ""} \
				{ if {$CIP_mode == 1} { set A1 $U0 } { set A1 0.0 } }

			if { $B1 == ""} \
				{ if {$CIP_mode == 1} { set B1 $V0 } { set B1 0.0 } }
		}

		# gesammt Korrekturrechnung beruht auf incrementale KB (mode 2)
		# Bei anderem mode deshalb A1 und B1 umsetzen
		set result [circ_ip_mode_reset_values_to_abs $A1 $B1 $U0 $V0 $U1 $V1 $CIP_mode]

		if {[lindex $result 0] == 0} \
			{ return 0} \
		else \
			{set A1 [lindex $result 1]; set B1 [lindex $result 2]}

		# den alten korrigierten Startpunkt merken, fuer KBI
		set DATA(RCC,OLD_CIRC_U)	$DATA(RCC,OLD_U)
		set DATA(RCC,OLD_CIRC_V)	$DATA(RCC,OLD_V)
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD CIRC U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD CIRC V: $DATA(RCC,OLD_V)"}

		CalcRadiusCorrKG	$ipmode1 $toolradius $U1 $V1 $U2 $V2 $U0 $V0 $A1 $B1

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  U $DATA(RCC,U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  V $DATA(RCC,V)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD V: $DATA(RCC,OLD_V)"}

		if {$DATA(RCC,ANWAHL)} \
		{
			# Fuer die KBI im Fall, dass der Kreis die Anwahlbewegung ist, 
			# den neuen Kreismittelpunkt errechnen.

			# Richtungsvektor vom programmierten Endpunkt zum Mittelpunkt
			set nemu	[expr ($U0 + $A1) - $U1]
			set nemv	[expr ($V0 + $B1) - $V1]
			
			set rad_circ	[expr sqrt([expr $A1*$A1+$B1*$B1])]
			
			set nemu [expr $nemu / $rad_circ] 
			set nemv [expr $nemv / $rad_circ] 
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nemu = $nemu und nemv = $nemv"}

			Calc_centerpoint	$U0 $V0 $DATA(RCC,OLD_U) $DATA(RCC,OLD_V) \
									$nemu $nemv AN
		}
	}

	if {$ipmode1 > 1 && $ipmode2 > 1} \
	{
	#--------Uebergang KREIS nach KREIS ----------

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall Kreis -> Kreis "}

		# Check if all data for circle interpolation is set for the
		# actual motion
		if {$A1 == "" && $B1 == "" } \
		{
			# Check data for center position
			if {$RADIUS1 == ""} \
			{
				Message 2 "WARNING: To less data for circle movement"
				return 0
			}

			# Calculate Centerposition from radius

			set c_pos [Calc_Center_from_Radius	$U0 $V0 $U1 $V1 $RADIUS1 \
															$ipmode1 $CIP_mode]

			set A1 [lindex $c_pos 0]
			set B1 [lindex $c_pos 1]
		} \
		else \
		{
			if { $A1 == ""} \
				{ if {$CIP_mode == 1} { set A1 $U0 } { set A1 0.0 } }

			if { $B1 == ""} \
				{ if {$CIP_mode == 1} { set B1 $V0 } { set B1 0.0 } }
		}

		# gesammt Korrekturrechnung beruht auf incrementale KB (mode 2)
		# Bei anderem mode deshalb A1 und B1 umsetzen
		set result [circ_ip_mode_reset_values_to_abs $A1 $B1 $U0 $V0 $U1 $V1 $CIP_mode]

		if {[lindex $result 0] == 0} \
			{ return 0} \
		else \
			{set A1 [lindex $result 1]; set B1 [lindex $result 2]}

		# Check if all data for circle interpolation is set in
		# the look ahead motion
		if {$A2 == "" && $B2 == "" } \
		{
			# Check data for center position
			if {$RADIUS2 == ""} \
			{
				Message 2 "WARNING: To less data for circle movement"
				return 0
			}

			# Calculate Centerposition from radius

			set c_pos [Calc_Center_from_Radius	$U1 $V1 $U2 $V2 $RADIUS2 \
															$ipmode2 $CIP_mode]

			set A2 [lindex $c_pos 0]
			set B2 [lindex $c_pos 1]
		} \
		else \
		{
			if { $A2 == ""} \
				{ if {$CIP_mode == 1} { set A2 $U1 } { set A2 0.0 } }

			if { $B2 == ""} \
				{ if {$CIP_mode == 1} { set B2 $V1 } { set B2 0.0 } }
		}

		# gesammt Korrekturrechnung beruht auf incrementale KB (mode 2)
		# Bei anderem mode deshalb A2 und B2 umsetzen
		set result [circ_ip_mode_reset_values_to_abs $A2 $B2 $U1 $V1 $U2 $V2 $CIP_mode]

		if {[lindex $result 0] == 0} \
			{ return 0} \
		else \
			{set A2 [lindex $result 1]; set B2 [lindex $result 2]}

		# den alten korrigierten Startpunkt merken, fuer KBI
		set DATA(RCC,OLD_CIRC_U)	$DATA(RCC,OLD_U)
		set DATA(RCC,OLD_CIRC_V)	$DATA(RCC,OLD_V)
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD CIRC U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD CIRC V: $DATA(RCC,OLD_V)"}

		CalcRadiusCorrKK	$toolradius $ipmode1 $ipmode2 \
								$U0 $V0 $U1 $V1 $A1 $B1 $A2 $B2

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  U $DATA(RCC,U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Corr  V $DATA(RCC,V)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD U: $DATA(RCC,OLD_U)"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "OLD V: $DATA(RCC,OLD_V)"}

		if {$DATA(RCC,ANWAHL)} \
		{
			# Fuer den Fall, dass der Kreis die Anwahlbewegung ist, neuen 
			# Mittelpunkt errechnen

			# Richtungsvektor vom programmierten Endpunkt zum Mittelpunkt
			set nemu	[expr ($U0 + $A1) - $U1]
			set nemv	[expr ($V0 + $B1) - $V1]
			
			set rad_circ	[expr sqrt([expr $A1*$A1+$B1*$B1])]
			
			set nemu [expr $nemu / $rad_circ] 
			set nemv [expr $nemv / $rad_circ] 
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nemu = $nemu und nemv = $nemv"}

			Calc_centerpoint	$U0 $V0 [expr $U1 + $DATA(RCC,U)] \
									[expr $V1 + $DATA(RCC,V)] $nemu $nemv AN
		}

		if {$DATA(RCC,ABWAHL)} \
		{
			# Fuer den Fall, dass die folgene Kreisbewegung die Abwahlbewegung
			# ist, neuen Mittelpunkt errechnen

			# Richtungsvektor vom programmierten Startpunkt zum Mittelpunkt
			set nemu	[expr ($U1 + $A2) - $U1]
			set nemv	[expr ($V1 + $B2) - $V1]
			
			set rad_circ	[expr sqrt([expr $A2*$A2+$B2*$B2])]
			
			set nemu [expr $nemu / $rad_circ] 
			set nemv [expr $nemv / $rad_circ] 
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nemu = $nemu und nemv = $nemv"}

			Calc_centerpoint	$DATA(RCC,OLD_U) $DATA(RCC,OLD_V) \
									$U2 $V2 $nemu $nemv AB
		}
	}

	if {	$DATA(RCC,GG,ADD_MOVE) || $DATA(RCC,GK,ADD_MOVE) || \
			$DATA(RCC,KG,ADD_MOVE) || $DATA(RCC,KK,ADD_MOVE)} \
				{ return 2 }

	return 1
}


proc circ_ip_mode_reset_values_to_abs {A B Su Sv Eu Ev CIP_mode} \
{
		# Return value is a list:
		# Index 1:	Error (0) or OK (1) status
		# Index 2:  A in increment as described in mode 2
		# Index 3:  B in increment as described in mode 2
		#
		# Input CIP_mode interpretation
		# 1 absolute 
		# 2 incremental - I,J,K values Vector - Arc Start to Center
		# 3 incremental - I,J,K values Vector - Arc Center to Start
		# 4 incremental - I,J,K values Unsigned Vector - Arc Start to Center

		switch $CIP_mode \
		{
			1 { set A [expr $A - $Su]; set B [expr $B - $Sv] }
			2 { }
			3 { set A [expr -1.0 * $A]; set B [expr -1.0 * $B] }
			4 \
			{ 
				# !!!!! This case isn't tested !!!!
				#
				# Endposition necessary !
				# 1. Calculate all 4 possible absolute center positions

				set C_A1 [expr $Su + $A]
				set C_B1 [expr $Sv + $B]

				set C_A2 [expr $Su - $A]
				set C_B2 [expr $Sv - $B]

				set C_A3 [expr $Su - $A]
				set C_B3 [expr $Sv + $B]

				set C_A4 [expr $Su + $A]
				set C_B4 [expr $Sv - $B]

				# Calculate Vector from 4 possible center points to the end point

				set E_U1 [expr $Eu - $C_A1]
				set E_V1 [expr $Ev - $C_B1]

				set E_U2 [expr $Eu - $C_A2]
				set E_V2 [expr $Ev - $C_B2]

				set E_U3 [expr $Eu - $C_A3]
				set E_V3 [expr $Ev - $C_B3]

				set E_U4 [expr $Eu - $C_A4]
				set E_V4 [expr $Ev - $C_B4]

				# Calculate the lenght of the vectors

				set EC1_len [expr sqrt($E_U1*$E_U1+$E_V1*$E_V1)]
				set EC2_len [expr sqrt($E_U2*$E_U2+$E_V2*$E_V2)]
				set EC3_len [expr sqrt($E_U3*$E_U3+$E_V3*$E_V3)]
				set EC4_len [expr sqrt($E_U4*$E_U4+$E_V4*$E_V4)]
				
				# Calculate the length of th vector Start->Center

				set compare_radius [expr sqrt($A*$A+$B*$B)]
				
				# Compare vectors End-Center. Only one is correct

				set right_endpos ""

				if {			[expr abs($compare_radius - $EC1_len)] < 0.001} \
					{ set right_endpos 1 } \
				else if {	[expr abs($compare_radius - $EC2_len)] < 0.001} \
					{ set right_endpos 2 } \
				else if {	[expr abs($compare_radius - $EC3_len)] < 0.001} \
					{ set right_endpos 3 } \
				else if {	[expr abs($compare_radius - $EC4_len)] < 0.001} \
					{ set right_endpos 4 } 

				if {$right_endpos == ""} \
				{
					Message 2 "WARNING: Given Start-, End- and Centerpoint not fit"
					return 0
				}

				# Now the right center point is found
				set A [expr [set C_A$right_endpos] - $U1]
				set B [expr [set C_B$right_endpos] - $V1]
			}

			default \
			{
				Message 2 "WARNING: Wrong CIP given. Mode $CIP_mode unknown"
				return "0 0.0 0.0"
			}
		}

		return "1 $A $B"
}


proc Calc_Center_from_Radius {ps1 ps2 pe1 pe2 radius motiontype ijk_mode} \
{
	global DEBUG_CUTCOM_NX

	# Mittelpunktskoordinaten in der Ebene ermitteln 
	if {$DEBUG_CUTCOM_NX(1)} \
		{Message 3 "Start $ps1|$ps2 End $pe1|$pe2 R: $radius M: $motiontype"}
			
	set du_se	[expr $pe1 - $ps1]
	set dv_se	[expr $pe2 - $ps2]
	set lse		[expr sqrt($du_se*$du_se + $dv_se*$dv_se)] 

	# Check if entire cirlce is programmed. If so the radius is not
	# enough to identify a unique circle.
	if {$lse < 0.001} \
	{
		Message 2 "WARNING: Programming entire circle only R value is not unique"
		Message 2 "WARNING: Center pos can't calculated -> no motion"

		return "0.0 0.0"
	}
	
	set lse_2	[expr 0.5 * $lse]
	set nu1		[expr $du_se / $lse] 
	set nv1		[expr $dv_se / $lse] 

	set pu_mit	[expr $ps1 + $lse_2 * $nu1]
	set pv_mit	[expr $ps2 + $lse_2 * $nv1]

	if {$motiontype == 2} \
		{if {$radius > 0.0 } {set direct 1.0} else {set direct -1.0}} \
	else \
		{if {$radius > 0.0 } {set direct -1.0} else {set direct 1.0}} \

	set nu2		[expr $direct *			$nv1]
	set nv2		[expr $direct * -1.0 *	$nu1]

	set lm		[expr sqrt(pow($radius,2)-$lse_2*$lse_2)] 

	set mit1		[expr $pu_mit + $lm * $nu2]
	set mit2		[expr $pv_mit + $lm * $nv2]

	# 1 absolute 
	# 2 incremental - I,J,K values Vector - Arc Start to Center
	# 3 incremental - I,J,K values Vector - Arc Center to Start
	# 4 incremental - I,J,K values Unsigned Vector - Arc Start to Center

	switch $ijk_mode \
	{
		1 { }
		2 { set mit1 [expr $mit1 - $ps1]; set mit2 [expr $mit2 - $ps2] }
		3 { set mit1 [expr $ps1 - $mit1]; set mit2 [expr $ps2 - $mit2] }
		4 { set mit1 [expr abs($ps1 - $mit1)]; set mit2 [expr abs($ps2 - $mit2)] }

		default \
		{
			Message 2 "WARNING: Wrong ijk_mode given. Mode $ijk_mode unknown"
			Message 2 "WARNING: Center pos can't calculated -> no motion"
			return "0.0 0.0"
		}
	}

	return "$mit1 $mit2"
}


proc Calc_centerpoint {Us Vs Ue Ve nu nv mode} \
{
	global DATA DEBUG_CUTCOM_NX

	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Nun in Calc_centerpoint"}
	# Kreismittelpunkt errechnen bei gegebenen zwei Punkten und einer Geraden 
	# die durch den Endpunkt (bei ABWAHL durch den Startunkt) und den 
	# gesuchten Mittelpunkt geht

	# Die Laenge von End-Start
	set ESu [expr $Us - $Ue]
	set ESv [expr $Vs - $Ve]
	set len	[expr sqrt ($ESu*$ESu + $ESv*$ESv)]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " len = $len"}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " ESu = $ESu -- ESv = $ESv"}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " val = [expr (($ESu * $nu + $ESv * $nv) / $len)]"}

	# 22-Feb 2006 TS Safety check for COS 
	set check_value [expr (($ESu * $nu + $ESv * $nv) / $len)]
	if {[expr abs($check_value)] > 1.0} \
	{
		# Value for acos is out of range
		if {$check_value > 1.0} \
			{ set check_value 1.0 } \
		elseif {$check_value < -1.0} \
			{ set check_value -1.0 }
	}

	# Winkel zwischen Vektor ES und n mit Skalarprodukt
	set beta [expr acos($check_value)]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " beta = $beta"}

	set alpha [expr $DATA(PI) - 2 * $beta]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " alpha = $alpha"}

	set radius_neu [expr sqrt(($len*$len)/(2.0 * (1.0-cos($alpha))))]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " radius_neu = $radius_neu"}

	if {$mode == "AN"} \
	{
		set DATA(RCC,NEW_CP,U) [expr $Ue + $radius_neu * $nu]
		set DATA(RCC,NEW_CP,V) [expr $Ve + $radius_neu * $nv]
	} \
	else \
	{
		set DATA(RCC,NEW_CP,U) [expr $Us + $radius_neu * $nu]
		set DATA(RCC,NEW_CP,V) [expr $Vs + $radius_neu * $nv]
	}
}


proc CalcRadiusCorrGG {radius U0 V0 U1 V1 OLD_U OLD_V} \
{
	global DEBUG_CUTCOM_NX DATA

	set du01 [expr $U0 - $OLD_U]
	set dv01 [expr $V0 - $OLD_V]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " du01 = $du01 und dv01 = $dv01"}

	# TS 10.03.2005 Change this check with telerance instead of = 0.
	if {[expr abs($du01)] < 0.01 && [expr abs($dv01)] < 0.01} \
	{
		# Auf dem letzten korrigierten Punkt stehen bleiben

		set DATA(RCC,U) [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V) [expr $DATA(RCC,OLD_V) - $V0]

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kein Delta von 0 nach 1"}

		return
	}

	set l1   [expr sqrt ($du01*$du01 + $dv01*$dv01)]
	set nu1  [expr $du01 / $l1]
	set nv1  [expr $dv01 / $l1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nu1 = $nu1 und nv1 = $nv1"}

	set du12 [expr $U1 - $U0]
	set dv12 [expr $V1 - $V0]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " du12 = $du12 und dv12 = $dv12"}
	
	# TS 10.03.2005 Change this check with telerance instead of = 0.
	if {[expr abs($du12)] < 0.01 && [expr abs($dv12)] < 0.01} \
	{
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kein Delta von 1 nach 2"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "senkrecht zur Bewegung korrigieren"}

		set DATA(RCC,OLD_U)	[expr $U0 + $DATA(RCC,MODE) * $radius * $nv1]
		set DATA(RCC,OLD_V)	[expr $V0 - $DATA(RCC,MODE) * $radius * $nu1]

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	set l2   [expr sqrt ($du12*$du12 + $dv12*$dv12)]
	set nu2  [expr $du12 / $l2]
	set nv2  [expr $dv12 / $l2]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nu2 = $nu2 und nv2 = $nv2"}

	if {$DATA(RCC,ANWAHL)} \
	{
		# TS 04.03.05 
		# Bei der Anwahl im standard Modus nur die Zweite Bewegung
		# Analysieren (1-2) und rechtwicklig dazu um den Radius
		# korrigieren.

		set DATA(RCC,OLD_U) [expr $U0 + $DATA(RCC,MODE) * $radius * $nv2]
		set DATA(RCC,OLD_V) [expr $V0 - $DATA(RCC,MODE) * $radius * $nu2]

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall ANWAHL bei Gerade-Gerade"}

		return
	}

	if {$DATA(RCC,ABWAHL)} \
	{
		# TS 04.03.05 
		# Bei der Abwahl im standard Modus nur die aktuelle Bewegung
		# Analysieren (0-1) und den programmierten Endpunkt rechtwicklig 
		# dazu um den Radius korrigieren.

		set DATA(RCC,OLD_U) [expr $U0 + $DATA(RCC,MODE) * $radius * $nv1]
		set DATA(RCC,OLD_V) [expr $V0 - $DATA(RCC,MODE) * $radius * $nu1]

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fall ABWAHL bei Gerade-Gerade"}

		return
	}

	# Winkel zwischen den Geraden ermitteln.
	# 1. Drehsinn mit dem Kreuzprodukt
	set drehsinn [expr $nu1*$nv2-$nu2*$nv1]
	if {$drehsinn < 0} {set dreh -1} {set dreh 1}

	# 22-Feb 2006 TS Safety check for COS 
	set check_value [expr $nu1*$nu2+$nv1*$nv2]
	if {[expr abs($check_value)] > 1.0} \
	{
		# Value for acos is out of range
		if {$check_value > 1.0} \
			{ set check_value 1.0 } \
		elseif {$check_value < -1.0} \
			{ set check_value -1.0 }
	}

	set alpha [expr $DATA(PI) + $DATA(RCC,MODE)*$dreh*acos($check_value)]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " alpha ist: [expr $alpha * 180.0 / $DATA(PI)]"}
	
	# Anhand des Winkels entscheiden, wie verfahren wird.
	# kleiner 180 -> Schnittpunkt der korrigierten Geraden anfahren
	# 180 (Parallele Bewegung) -> nur senkrecht um WKZG-Radius korrigieren.
	# groesser 180 -> mit zusaetzlicher Kreisuebergangsbewegung.

	if {[expr abs($alpha)] < 0.01 || [expr abs($alpha - $DATA(PI))] < 0.01} \
	{
		# Parallele Bewegungen
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kein Delta von 1 nach 2"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "senkrecht zur Bewegung korrigieren"}

		set DATA(RCC,OLD_U)	[expr $U0 + $DATA(RCC,MODE) * $radius * $nv1]
		set DATA(RCC,OLD_V)	[expr $V0 - $DATA(RCC,MODE) * $radius * $nu1]

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]
	} \
	else \
	{
		# ------------------------------------------------------------------------
		# Schnittberechnung zweier Geraden durch gleichsetzen d. Geradengl.
		#
		# G1 	(U0)           (nu1)   (U1)           (nu2)
		# 		(  ) + lamb1 * (   ) = (  ) + lamb2 * (   )
		# G2 	(V0)           (nv1)   (U1)           (nu2)
		#
		# 1. G2 nach lamb2 aufloesen
		# 2. lamb2 in G1 einsetzen (G3)
		# 3. G3 nach lamb1 aufloesen
		# 4. lamb1 in Geradengleichung einsetzen und Punkt ermitteln
		# ------------------------------------------------------------------------

		# Startpunkt der Geraden 1 - OLD_U/V senkrecht korrigiert zu n1
		set pu0  [expr $OLD_U + $DATA(RCC,MODE) * $radius * $nv1]
		set pv0  [expr $OLD_V - $DATA(RCC,MODE) * $radius * $nu1]
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pu0 = $pu0 und pv0 = $pv0"}

		# Startpunkt der Geraden 2 - U/V0 senkrecht korrigiert zu n2
		set pu1  [expr $U0 + $DATA(RCC,MODE) * $radius * $nv2]
		set pv1  [expr $V0 - $DATA(RCC,MODE) * $radius * $nu2]
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pu1 = $pu1 und pv1 = $pv1"}

		set du01 [expr $pu1 -$pu0]
		set dv01 [expr $pv1 -$pv0]

		if {		[expr abs($nv2)] < 0.001} \
			{ set lamb1 [expr $dv01 / $nv1] } \
		elseif {	[expr abs($nu2)] < 0.001} \
			{ set lamb1 [expr $du01 / $nu1] } \
		else \
		{
			set tmp1 	[expr $du01 * $nv2]
			set tmp2 	[expr $dv01 * $nu2]
			set tmp3		[expr $nu1 * $nv2 - $nv1 * $nu2]
			set lamb1	[expr ($tmp1 - $tmp2) / $tmp3]
		}

		# TS 2012-06-11
		# Working on PR1865763
		# It is wrong to add circle if angle is larger than 180 for all cases
		# Idea for additional check if circle should be: 
		# Check the distance between intersection point and previous start point.
		# If these distance is samller than the radius do not add additonal 
		# circle motion, but use the intersection point directly

		set duspcp [expr $DATA(RCC,OLD_U) - ($pu0 + $lamb1 * $nu1)]
		set dvspcp [expr $DATA(RCC,OLD_V) - ($pv0 + $lamb1 * $nv1)]
		set length [expr sqrt ($duspcp*$duspcp + $dvspcp*$dvspcp)]

		# Another case is if the length of the programed point (1) and next 
		# point (2) is smaller than the radius. Use l2 to identify
		# If these distance is samller than the radius do not add additonal 
		# circle motion, but use the intersection point directly

		if {$alpha < $DATA(PI) || $length <= $radius || $l2 <= $radius || $DATA(RCC,GG_MOTION_TYPE)} \
		{
			# 	Use intersection point of two lines 
			set DATA(RCC,OLD_U) [expr $pu0 + $lamb1 * $nu1]
			set DATA(RCC,OLD_V) [expr $pv0 + $lamb1 * $nv1]

			set DATA(RCC,U) [expr $DATA(RCC,OLD_U) - $U0]
			set DATA(RCC,V) [expr $DATA(RCC,OLD_V) - $V0]
		} \
		else \
		{
			# alpha ist groesser als 180 Grad -> Kreisuebergangsbewegung

			set DATA(RCC,GG,ADD_MOVE) 1

			# Programmierter Schnitpunkt - senkrecht zu n1
			set pu1  [expr $U0 + $DATA(RCC,MODE) * $radius * $nv1]
			set pv1  [expr $V0 - $DATA(RCC,MODE) * $radius * $nu1]
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pu1 = $pu1 und pv1 = $pv1"}

			# Programmierter Schnitpunkt - senkrecht zu n2
			set pu2  [expr $U0 + $DATA(RCC,MODE) * $radius * $nv2]
			set pv2  [expr $V0 - $DATA(RCC,MODE) * $radius * $nu2]
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pu2 = $pu2 und pv2 = $pv2"}

			set DATA(RCC,OLD_U) $pu2
			set DATA(RCC,OLD_V) $pv2

			set DATA(RCC,U) [expr $pu1 - $U0]
			set DATA(RCC,V) [expr $pv1 - $V0]

			# Mittelpunkt merken fuer Uebergangsbewegung
			set DATA(RCC,ADD_MOVE,CENTER,U) $U0
			set DATA(RCC,ADD_MOVE,CENTER,V) $V0

			if {$DATA(RCC,MODE) < 0} \
				{ set DATA(RCC,ADD_MOVE,ROT) 2} \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 3}
		}
	}
}


proc CalcRadiusCorrGK {ipmode radius U0 V0 OLD_U OLD_V A B} \
{
	global DEBUG_CUTCOM_NX DATA

	set du01 [expr $U0 - $OLD_U]
	set dv01 [expr $V0 - $OLD_V]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " du01 = $du01 und dv01 = $dv01"}

	# Mittelpunkt ist P0 + delta (IJK), da incrementale KB
	set pmu	[expr $U0 + $A]
	set pmv	[expr $V0 + $B]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pmu = $pmu und pmv = $pmv"}

	if {[expr abs($du01)] < 0.01 && [expr abs($dv01)] < 0.01} \
	{
		# Quasi keine linear Bewegung -> stehen bleiben
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kein Delta von 0 nach 1"}

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	set l1   [expr sqrt ($du01*$du01 + $dv01*$dv01)]
	set nu1  [expr $du01 / $l1]
	set nv1  [expr $dv01 / $l1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nu1 = $nu1 und nv1 = $nv1"}

	# Radius vom Kreis
	set rad_circ	[expr sqrt([expr $A*$A+$B*$B])]
	set rad_circ_org $rad_circ
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius = $rad_circ"}

	# Korrigiert mit WKZRadius
	if {$ipmode == 2} {set ccw -1} else {set ccw 1}
	set rad_circ	[expr $rad_circ + $DATA(RCC,MODE) * $ccw * $radius]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius Korrigiert = $rad_circ"}

	# TS 10.03.2005 Zur Sicherheit den Nullfall abfangen!
	# z.B: rad_circ ist -0.008
	if {[expr abs($rad_circ)] > 0.01 && $rad_circ < 0.01} \
	{
		# Negativer Radius des korrigierten Kreises!
		# -> programmierter Kreis mit gegebenen WKZK-Radius nicht fraesbar

		Message 1 "ERROR: RCC Motion line-circle: programed circle not machinable"
		Message 1 "       Corrected circle lower zero -> Tool to big"

		set DATA(RCC,U) 0.0
		set DATA(RCC,V) 0.0

		# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
		set DATA(RCC,OLD_U)	$U0
		set DATA(RCC,OLD_V)	$V0

		return
	}

	# Sowohl den Schnittpunkt zw. korrigierten Kreis und korrigierter Gerade
	# ermitteln als auch den senkrecht zur Gerade korrigierten Endpunkt ermitteln
	# Entscheidung Anhand der Laengen vom Startpunkt zu den ermittelten Punkten
	# treffen, welcher der zu nehmende Punkt ist. Mit Hilfe des korrigerten
	# Kreisradius feststellen, ob eine Uebergangsbewegung noetig ist.

	# Ermittlung der Schnittpunkte
	#-----------------------------

	# TS 10.03.2005 P0 rechtwinklig zu n1 korrigiert nehmen.
	set U1_corr  [expr $U0 + $DATA(RCC,MODE) * $radius * $nv1]
	set V1_corr  [expr $V0 - $DATA(RCC,MODE) * $radius * $nu1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "U1_corr = $U1_corr und V1_corr = $V1_corr"}

	# Normale von P0 in Richtung Mittelpunkt PM
	set nu [expr $pmu - $U0]
	set nv [expr $pmv - $V0]
	set nlen	[expr sqrt($nu*$nu + $nv*$nv)]
	set nu	[expr $nu / $nlen]
	set nv	[expr $nv / $nlen]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Normale U0/V0 -> M1: U: $nu V: $nv"}

	# Unterscheiden, ob der korrigierte Kreis kleiner oder groesser ist.
	if { $rad_circ < $rad_circ_org} {set fact -1} {set fact 1}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fact is: $fact"}
	
	# Schnittpunkt vom korrigerten Kreis mit der Gerade P0 -> PM
	set Uendcor [expr $U0 - $fact * $radius * $nu]
	set Vendcor [expr $V0 - $fact * $radius * $nv]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "kor. Punkt senk: U: $Uendcor V: $Vendcor"}
	
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Werkzeugradius ist: $radius"}

	# TS 16.03.2005 Der Fall Anfahren:
	# Es wird immer der P korr sekecht angefahren
	if {$DATA(RCC,ANWAHL)} \
	{
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Anfahren!"}

		set DATA(RCC,OLD_U)	$Uendcor
		set DATA(RCC,OLD_V)	$Vendcor

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	# Ohne viele Laengen zu errechnen, kann hier schon getestet werden, ob der
	# Tangentialfall vorliegt. Das ist der Fall, wenn P-CORR-Senkrecht und
	# P1-Corr identisch sind. Bei der weiterfuehrenden Laengenrechnung werden
	# Toleranzbreiche zu gross.

	# TS 22-Feb-2006 selbst diese Toleranzbereiche sind schon zu groß, wenn die 
	# Gerade sehr kurz ist und der Normalvektor errechnet wird 
	# Aendern von 0.01 auf 0.1 -> Keine Endgültige Lösung!

	if {	[expr abs($U1_corr - $Uendcor)] < 0.1 && \
			[expr abs($V1_corr - $Vendcor)] < 0.1 } \
	{
		# Tangentialfall -> ein Schnittpunkt
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 " Tangentialschnittpunkt"}

		set DATA(RCC,OLD_U)	$U1_corr
		set DATA(RCC,OLD_V)	$V1_corr

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	# Vektor von P1 korrigiert zum Mittelpunkt
	set Vmu	[expr $pmu - $U1_corr]
	set Vmv	[expr $pmv - $V1_corr]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Vmu = $Vmu und Vmv = $Vmv"}

	# die Laenge von Vm
	set len_vm	[expr sqrt([expr $Vmu*$Vmu+$Vmv*$Vmv])]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge Vm = $len_vm"}

	# Laenge von P1 korrigiert zum Lotpunkt mit Skalarprodukt
	set len_1l	[expr $Vmu * $nu1 + $Vmv * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge 0-Lot = $len_1l"}

	# Laenge vom Mittelpunkt zum Lotpunkt
	set len_ml	[expr sqrt([expr $len_vm*$len_vm-$len_1l*$len_1l])]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge M-Lot = $len_ml"}

	# Anhand des Betrages von len_1l kann unterschieden werden, ob die
	# Gerade in den Kreis rein oder raus geht.
	# Ist len_1l positiv, dann geht die Folgegerade 'raus' aus dem Kreis
	if {$len_1l > 0.01 } \
		{ set schnitt_dir 1 } \
	else \
		{ set schnitt_dir -1 }
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Richtung ist = $schnitt_dir (raus = 1 rein = -1)"}

	if {[expr abs($rad_circ)] < 0.01} \
	{
		# Korrigierter Kreis ist quais keiner mehr -> Mittelpunkt anfahren
		# Pruefen, ob eine Zusatzbewegung noetig ist. Das ist nur der Fall, wenn
		# der korrigierte Kreis kleiner ist und die Gerade 'raus' aus dem
		# Kreis geht.

		if {$schnitt_dir == 1} \
		{
			# zusaetzliche Kreisbewegung. Programmierter Endpunkt ist der
			# Mittelpunkt der zusaetzlichen K-Bewegung. Startpunkt ist der 
			# Schnittpunkt des korrigieren Kreises mit der Geraden vom Mittelpunkt
			# zum programmierten Startpunkt des Kreises. In diesem Fall der
			# Mittelpunkt. Endpunkt ist der Endpunkt der Gerade senkrecht um 
			# den WKZG-Radius korrigert.

			set DATA(RCC,GK,ADD_MOVE) 1

			# Drehrichtung der zusaetzlichen Bewegung speichern
			# Wenn eine Uebergangbewegung bei groesserem korrigierten Kreisradius 
			# stattdindet, dann ist die zusaetzliche Kreisbewegung in der gleichen
			# Drehrichtung (G2/G3) wie der Kreis. Ansonsten immer umgekehrt
			# TS 10.03.2005 Da dieser Fall nur fuer kleinere Korrigierte Kreise
			# (eigentlich keine Kreise mehr) gilt ist die Drehrichtung hier immer
			# entgegengesetzt der des programmierten Kreises
			if {$ipmode == 2} \
				{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 2 }

			# 1. korrigierter Punkt Fall GK:
			set DATA(RCC,U)  [expr $U1_corr - $U0]
			set DATA(RCC,V)  [expr $V1_corr - $V0]

			# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
			# Der Endpunkt fuer den Uebergangskreis
			set DATA(RCC,OLD_U)  $pmu
			set DATA(RCC,OLD_V)  $pmv

			# Programmierten Endpunkt der Geraden als Mittelpunkt merken
			set DATA(RCC,ADD_MOVE,CENTER,U) $U0
			set DATA(RCC,ADD_MOVE,CENTER,V) $V0
		} \
		else \
		{
			# Den Mittelpunkt anfahren (bzw. muesste er dort bereits stehen)
			# Keine zusaetzliche Bewegung

			set DATA(RCC,OLD_U)	$pmu
			set DATA(RCC,OLD_V)	$pmv

			set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
			set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]
		}

		return
	}

	if {$len_ml > $rad_circ} \
	{
		# Kein Schnittpunkt - das darf nur sein, wenn korrigierter Kreis kleiner 
		# ist als programmierter und die Gerade 'raus' geht.

		if {$rad_circ > $rad_circ_org || $schnitt_dir == -1} \
		{
			Message 1 "ERROR: RCC Motion line-circle: Not possible"
			Message 1 "       No intersection between corrected circle and line,"
			Message 1 "       althought corrected circle is bigger than programmed"
			Message 1 "       or althought line goes in dircetion 'in' of circle"

			set DATA(RCC,U) 0.0
			set DATA(RCC,V) 0.0

			# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
			set DATA(RCC,OLD_U)	$U0
			set DATA(RCC,OLD_V)	$V0

			return
		}

		# Zusaetzliche Kreisuebergangsbewegung:

		set DATA(RCC,GK,ADD_MOVE) 1

		# Drehrichtung der zusaetzlichen Bewegung speichern
		# Drehrichtung ist umgekehrt zum programmierten Kreis, da der korrigierte
		# Kreis hier immer kleiner ist.
		if {$ipmode == 2} \
			{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
		else \
			{ set DATA(RCC,ADD_MOVE,ROT) 2 }

		# 1. korrigierter Punkt:
		set DATA(RCC,U)  [expr $U1_corr - $U0]
		set DATA(RCC,V)  [expr $V1_corr - $V0]

		# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
		set DATA(RCC,OLD_U)  $Uendcor
		set DATA(RCC,OLD_V)  $Vendcor

		# Programmierten Endpunkt der Geraden als Mittelpunkt merken
		set DATA(RCC,ADD_MOVE,CENTER,U) $U0
		set DATA(RCC,ADD_MOVE,CENTER,V) $V0
	
		return
	}

	# Zwei Schnittpunkte
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Zwei Schnittpunkte"}

	# Lotpunkt ermitteln
	# Diese Laenge ist Vorzeichen behaftet!
	set plu	[expr $U1_corr + $len_1l * $nu1]
	set plv	[expr $V1_corr + $len_1l * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " plu = $plu und plv = $plv"}

	# Laenge von Schnittpunkt zum Lotpunkt
	set len	[expr sqrt([expr $rad_circ*$rad_circ-$len_ml*$len_ml])]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge Schnitt-Lot = $len"}

	set PschnittU	[expr $plu - $schnitt_dir * $len * $nu1]
	set PschnittV	[expr $plv - $schnitt_dir * $len * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "P-Schnitt: U:$PschnittU V:$PschnittV"}

	# TS 09.03.2005
	# Pruefen ob zusaetzliche Bewegung noetig ist.
	# Das geht mit Hilfe von:
	# len				: Laenge vom Lotpunkt zum Schnittpunkt
	# len_1l			: Laenge vom senkrecht korrigierten Punkt zum Lotpunkt
	# schnitt_dir	: Fallunterscheidung, ob die Gerade 'rein' oder 'raus' geht
	# Es ginge auch mit Schnitt_dir und der Unterscheidung, ob der korrigierte
	# Kreis kleiner oder groesser asl der programmierte ist.

	set len_1l [expr abs($len_1l)]
	set add_motion 0

	if {	($schnitt_dir ==  1 && $len < $len_1l) || \
			($schnitt_dir == -1 && $len > $len_1l) } \
				{ set add_motion 1 }

	# TS 10.03.2005 Hier koennte eine Sicherheitsabfrage gemacht werden,
	# um zu vermeiden, dass Vollkreise als Zusatzbewegung eingefuegt werden.
	# Das gibt es aber eigentlich eh nur beim Tangentialfall und der ist 
	# bereits abgefragt.

	if {$add_motion} \
	{
		# zusaetzliche Kreisbewegung. Programmierter Endpunkt (P0) ist der
		# Mittelpunkt der zusaetzlichen K-Bewegung. Startpunkt ist der Endpunkt
		# der Gerade senkrecht um den WKZG-Radius korrigert (P1corr).
		# Endpunkt ist der Schnittpunkt des korrigieren Kreises mit der Geraden
		# vom Mittelpunkt zum programmierten Startpunkt des Kreises (Pcorr_senk).

		set DATA(RCC,GK,ADD_MOVE) 1

		# Drehrichtung der zusaetzlichen Bewegung speichern
		# Wenn eine Uebergangbewegung bei groesserem korrigierten Kreisradius 
		# stattdindet, dann ist die zusaetzliche Kreisbewegung in der gleichen
		# Drehrichtung (G2/G3) wie der Kreis. Ansonsten immer umgekehrt
		if {$rad_circ > $rad_circ_org} \
			{ set DATA(RCC,ADD_MOVE,ROT) $ipmode } \
		else \
		{
			if {$ipmode == 2} \
				{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 2 }
		}

		# 1. korrigierter Punkt Fall GK:
		set DATA(RCC,U)  [expr $U1_corr - $U0]
		set DATA(RCC,V)  [expr $V1_corr - $V0]

		# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
		# Der Endpunkt fuer den Uebergangskreis
		set DATA(RCC,OLD_U)  $Uendcor
		set DATA(RCC,OLD_V)  $Vendcor

		# Programmierten Endpunkt der Geraden als Mittelpunkt merken
		set DATA(RCC,ADD_MOVE,CENTER,U) $U0
		set DATA(RCC,ADD_MOVE,CENTER,V) $V0
	} \
	else \
	{
		# Den Mittelpunkt anfahren (bzw. muesste er dort bereits stehen)
		# Keine zusaetzliche Bewegung

		set DATA(RCC,OLD_U)	$PschnittU
		set DATA(RCC,OLD_V)	$PschnittV

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]
	}
}


proc CalcRadiusCorrKG {ipmode radius U0 V0 U1 V1 OLD_U OLD_V A B} \
{
	global DEBUG_CUTCOM_NX DATA

	set du21 [expr $U0 - $U1]
	set dv21 [expr $V0 - $V1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " du21 = $du21 und dv21 = $dv21"}

	# Mittelpunkt ist P0 + delta (IJK), da incrementale KB
	set pmu	[expr $OLD_U + $A]
	set pmv	[expr $OLD_V + $B]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " pmu = $pmu und pmv = $pmv"}

	# Radius vom Kreis
	set rad_circ	[expr sqrt([expr $A*$A+$B*$B])]
	set rad_circ_org $rad_circ
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius = $rad_circ"}

	# Korrigiert mit WKZRadius
	if {$ipmode == 2} {set ccw -1} else {set ccw 1}
	set rad_circ	[expr $rad_circ + $DATA(RCC,MODE) * $ccw * $radius]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius Korrigiert = $rad_circ"}

	# Schnittpunkt vom korrigerten Kreis mit der Gerade U0/V0 -> MP
	set nu [expr $pmu - $U0]
	set nv [expr $pmv - $V0]

	set nlen	[expr sqrt($nu*$nu + $nv*$nv)]
	set nu	[expr $nu / $nlen]
	set nv	[expr $nv / $nlen]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Normale U0/V0 -> M1: U: $nu V: $nv"}

	# Unterscheiden, ob der korrigierte Kreis kleiner oder groesser ist.
	if { $rad_circ < $rad_circ_org} {set fact -1} {set fact 1}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fact is: $fact"}
	
	# Schnittpunkt vom korrigerten Kreis mit der Gerade P0 -> PM
	set Uendcor [expr $U0 - $fact * $radius * $nu]
	set Vendcor [expr $V0 - $fact * $radius * $nv]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "kor. Punkt senk: U: $Uendcor V: $Vendcor"}

	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Werkzeugradius ist: $radius"}

	# TS 08.03.05 
	# Bei der Abwahl im standard Modus nur die aktuelle Bewegung
	# Analysieren (0-1) und den programmierten Endpunkt rechtwicklig 
	# dazu um den Radius korrigieren. Also den programmierten
	# Endpunktrechtwinklig in Richtung des Mittelpunktes korrigieren

	if {	([expr abs($du21)] < 0.01 && [expr abs($dv21)] < 0.01) || \
			$DATA(RCC,ABWAHL) } \
	{
		# Quasi keine linear Bewegung -> Fahren auf den Schnittpunkt der
		# Geraden U/V0 - Mittelpunkt mit dem corrigierten Kreis
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kein Delta von 0 nach 1"}

		set DATA(RCC,OLD_U)	$Uendcor
		set DATA(RCC,OLD_V)	$Vendcor

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	set l1   [expr sqrt ($du21*$du21 + $dv21*$dv21)]
	set nu1  [expr $du21 / $l1]
	set nv1  [expr $dv21 / $l1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 " nu1 = $nu1 und nv1 = $nv1"}

	# TS 10.03.2005 Zur Sicherheit den Nullfall abfangen!
	# z.B: rad_circ ist -0.008
	if {[expr abs($rad_circ)] > 0.01 && $rad_circ < 0.01} \
	{
		# Negativer Radius des korrigierten Kreises!
		# -> programmierter Kreis mit gegebenen WKZK-Radius nicht fraesbar
		# Das sollte aber schon bei der Vorgaengerbewegung aufgefallen sein!

		Message 1 "ERROR: RCC Motion circle-line: programed circle not machinable"
		Message 1 "       Corrected circle lower zero -> Tool to big"

		set DATA(RCC,U) 0.0
		set DATA(RCC,V) 0.0

		# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
		set DATA(RCC,OLD_U)	$U0
		set DATA(RCC,OLD_V)	$V0

		return
	}

	# Korrigierten Punkt am Start der Geraden ermitteln. Senkrecht zu n
	set U1_corr  [expr $U0 - $DATA(RCC,MODE) * $radius * $nv1]
	set V1_corr  [expr $V0 + $DATA(RCC,MODE) * $radius * $nu1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "U1_corr = $U1_corr und V1_corr = $V1_corr"}

	# Ohne viele Laengen zu errechnen, kann hier schon getestet werden, ob der
	# Tangentialfall vorliegt. Das ist der Fall, wenn P-CORR-Senkrecht und
	# P1-Corr identisch sind. Bei der weiterfuehrenden Laengenrechnung werden
	# Toleranzbreiche zu gross.

	# TS 22-Feb-2006 selbst diese Toleranzbereiche sind schon zu groß, wenn die 
	# Gerade sehr kurz ist und der Normalvektor errechnet wird 
	# Aendern von 0.01 auf 0.1 -> Keine Endgültige Lösung!

	if {	[expr abs($U1_corr - $Uendcor)] < 0.1 && \
			[expr abs($V1_corr - $Vendcor)] < 0.1 } \
	{
		# Tangentialfall -> ein Schnittpunkt
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 " Tangentialschnittpunkt"}

		# 22.03.2005 TS Sonderfall Vollkreis:
		# Um Rechenungenauigkeiten zu vermeiden den Fall extra behandeln.
		# Eingabewerte sind identisch!
		if {	[expr abs($U0-$OLD_U)] < 0.000001 && \
				[expr abs($V0-$OLD_V)] < 0.000001} \
		{
			# set DATA(RCC,OLD_U)  Bleibt
			# set DATA(RCC,OLD_V)  Bleibt

			set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
			set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

			return
		}

		set DATA(RCC,OLD_U)	$U1_corr
		set DATA(RCC,OLD_V)	$V1_corr

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]

		return
	}

	# Sowohl den Schnittpunkt zw. korrigierten Kreis und korrigierter Gerade
	# ermitteln als auch den senkrecht zur Gerade korrigierten Startpunkt
	# ermitteln. Danach muss entschieden werden, welcher der zu nehmende ist.
	# Mit Hilfe des korrigerten Kreisradius feststellen, ob eine 
	# Uebergangsbewegung noetig ist.

	# Ermittlung der Schnittpunkte
	#-----------------------------

	# Vektor von P1 korrigiert zum Mittelpunkt
	set Vmu	[expr $pmu - $U1_corr]
	set Vmv	[expr $pmv - $V1_corr]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Vmu = $Vmu und Vmv = $Vmv"}

	# die Laenge von Vm
	set len_vm	[expr sqrt([expr $Vmu*$Vmu+$Vmv*$Vmv])]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge 1-M = $len_vm"}

	# Laenge vom Vektor P1 korrigiert zum Lotpunkt mit Skalarprodukt
	set len_1l	[expr $Vmu * $nu1 + $Vmv * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge 1-Lot = $len_1l"}

	# Laenge vom Mittelpunkt zum Lotpunkt
	set len_ml	[expr sqrt([expr $len_vm*$len_vm-$len_1l*$len_1l])]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge M-Lot = $len_ml"}

	# Anhand des Betrages von len_1l kann unterschieden werden, ob die
	# Gerade in den Kreis rein oder raus geht.
	# Ist len_1l positiv, dann geht die Folgegerade 'raus' aus dem Kreis
	if {$len_1l > 0.01 } \
		{ set schnitt_dir 1 } \
	else \
		{ set schnitt_dir -1 }
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Richtung ist = $schnitt_dir (raus = 1 rein = -1)"}

	if {[expr abs($rad_circ)] < 0.01} \
	{
		# Korrigierter Kreis ist quais keiner mehr -> Mittelpunkt anfahren
		# Pruefen, ob eine Zusatzbewegung noetig ist. Das ist nur der Fall, wenn
		# der korrigierte Kreis kleiner ist und die Gerade 'raus' aus dem
		# Kreis geht.

		if {$schnitt_dir == 1} \
		{
			# zusaetzliche Kreisbewegung. Programmierter Endpunkt ist der
			# Mittelpunkt der zusaetzlichen K-Bewegung. Startpunkt ist der 
			# Schnittpunkt des korrigieren Kreises mit der Geraden vom Mittelpunkt
			# zum programmierten Startpunkt des Kreises. In diesem Fall der
			# Mittelpunkt. Endpunkt ist der Endpunkt der Gerade senkrecht um 
			# den WKZG-Radius korrigert.

			set DATA(RCC,KG,ADD_MOVE) 1

			# Drehrichtung der zusaetzlichen Bewegung speichern
			# Wenn eine Uebergangbewegung bei groesserem korrigierten Kreisradius 
			# stattdindet, dann ist die zusaetzliche Kreisbewegung in der gleichen
			# Drehrichtung (G2/G3) wie der Kreis. Ansonsten immer umgekehrt
			# TS 10.03.2005 Da dieser Fall nur fuer kleinere Korrigierte Kreise
			# (eigentlich keine Kreise mehr) gilt ist die Drehrichtung hier immer
			# entgegengesetzt der des programmierten Kreises
			if {$ipmode == 2} \
				{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 2 }

			# 1. korrigierter Punkt Fall KG
			set DATA(RCC,U)  [expr $pmu - $U0]
			set DATA(RCC,V)  [expr $pmv - $V0]

			# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
			set DATA(RCC,OLD_U)  $U1_corr
			set DATA(RCC,OLD_V)  $V1_corr

			# Programmierten Endpunkt der Geraden als Mittelpunkt merken
			set DATA(RCC,ADD_MOVE,CENTER,U) $U0
			set DATA(RCC,ADD_MOVE,CENTER,V) $V0
		} \
		else \
		{
			# Den Mittelpunkt anfahren (bzw. muesste er dort bereits stehen)
			# Keine zusaetzliche Bewegung

			set DATA(RCC,OLD_U)	$pmu
			set DATA(RCC,OLD_V)	$pmv

			set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
			set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]
		}

		return
	}

	if {$len_ml > $rad_circ} \
	{
		# Kein Schnittpunkt - das darf nur sein, wenn korrigierter Kreis kleiner 
		# ist als programmierter und die Gerade 'raus' geht.

		if {$rad_circ > $rad_circ_org || $schnitt_dir == -1} \
		{
			Message 1 "ERROR: RCC Motion circle-line: Not possible"
			Message 1 "       No intersection between corrected circle and line,"
			Message 1 "       althought corrected circle is bigger than programmed"
			Message 1 "       or althought line goes in dircetion 'in' of circle"

			set DATA(RCC,U) 0.0
			set DATA(RCC,V) 0.0

			# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
			set DATA(RCC,OLD_U)	$U0
			set DATA(RCC,OLD_V)	$V0

			return
		}

		# Zusaetzliche Kreisuebergangsbewegung:

		set DATA(RCC,KG,ADD_MOVE) 1

		# Drehrichtung der zusaetzlichen Bewegung speichern
		# Drehrichtung ist umgekehrt zum programmierten Kreis, da der korrigierte
		# Kreis hier immer kleiner ist.
		if {$ipmode == 2} \
			{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
		else \
			{ set DATA(RCC,ADD_MOVE,ROT) 2 }

		# 1. korrigierter Punkt:
		set DATA(RCC,U)  [expr $Uendcor - $U0]
		set DATA(RCC,V)  [expr $Vendcor - $V0]

		# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
		set DATA(RCC,OLD_U)  $U1_corr
		set DATA(RCC,OLD_V)  $V1_corr

		# Programmierten Endpunkt der Geraden als Mittelpunkt merken
		set DATA(RCC,ADD_MOVE,CENTER,U) $U0
		set DATA(RCC,ADD_MOVE,CENTER,V) $V0
	
		return
	}
	
	# Zwei Schnittpunkte
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Zwei Schnittpunkte"}

	# Lotpunkt ermitteln
	# Hier ist es von Bedeutung, ob len_1l negativ ist!
	set plu	[expr $U1_corr + $len_1l * $nu1]
	set plv	[expr $V1_corr + $len_1l * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "plu = $plu und plv = $plv"}

	# Laenge von Lotpunkt zum Schnittpunkt
	set len	[expr sqrt([expr $rad_circ*$rad_circ-$len_ml*$len_ml])]

	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laenge Schnitt-Lot = $len"}

	set PschnittU	[expr $plu - $schnitt_dir * $len * $nu1]
	set PschnittV	[expr $plv - $schnitt_dir * $len * $nv1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "P-Schnitt: U:$PschnittU V:$PschnittV"}
	
	# TS 09.03.2005
	# Pruefen ob zusaetzliche Bewegung noetig ist.
	# Das geht mit Hilfe von:
	# len				: Laenge vom Lotpunkt zum Schnittpunkt
	# len_1l			: Laenge vom senkrecht korrigierten Punkt zum Lotpunkt
	# schnitt_dir	: Fallunterscheidung, ob die Gerade 'rein' oder 'raus' geht
	# Es ginge auch mit Schnitt_dir und der Unterscheidung, ob der korrigierte
	# Kreis kleiner oder groesser asl der programmierte ist.

	set len_1l [expr abs($len_1l)]
	set add_motion 0

	if {	($schnitt_dir ==  1 && $len < $len_1l) || \
			($schnitt_dir == -1 && $len > $len_1l) } \
				{ set add_motion 1 }

	# TS 10.03.2005 Hier koennte eine Sicherheitsabfrage gemacht werden,
	# um zu vermeiden, dass Vollkreise als Zusatzbewegung eingefuegt werden.
	# Das gibt es aber eigentlich eh nur beim Tangentialfall und der ist 
	# bereits abgefragt.

	if {$add_motion} \
	{
		# zusaetzliche Kreisbewegung. Programmierter Endpunkt ist der
		# Mittelpunkt der zusaetzlichen K-Bewegung (P0). Startpunkt ist der 
		# Schnittpunkt des korrigieren Kreises mit der Geraden vom Mittelpunkt
		# zum programmierten Startpunkt des Kreises (Pcorr_senk). Endpunkt ist 
		# der Endpunkt der Gerade senkrecht um den WKZG-Radius korrigert (P1corr).

		set DATA(RCC,KG,ADD_MOVE) 1

		# Drehrichtung der zusaetzlichen Bewegung speichern
		# Wenn eine Uebergangbewegung bei groesserem korrigierten Kreisradius 
		# stattdindet, dann ist die zusaetzliche Kreisbewegung in der gleichen
		# Drehrichtung (G2/G3) wie der Kreis. Ansonsten immer umgekehrt
		if {$rad_circ > $rad_circ_org} \
			{ set DATA(RCC,ADD_MOVE,ROT) $ipmode } \
		else \
		{
			if {$ipmode == 2} \
				{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 2 }
		}

		# 1. korrigierter Punkt:
		set DATA(RCC,U)  [expr $Uendcor - $U0]
		set DATA(RCC,V)  [expr $Vendcor - $V0]

		# den korrigierten Endpunkt merken, fuer Uebergangsbewegung
		set DATA(RCC,OLD_U)  $U1_corr
		set DATA(RCC,OLD_V)  $V1_corr

		# Programmierten Endpunkt der Geraden als Mittelpunkt merken
		set DATA(RCC,ADD_MOVE,CENTER,U) $U0
		set DATA(RCC,ADD_MOVE,CENTER,V) $V0
	} \
	else \
	{
		# Den Schnittpunkt vom korrigierten Kreis mit Gerade anfahren. 
		# Keine zusaetzliche Bewegung

		set DATA(RCC,OLD_U)	$PschnittU
		set DATA(RCC,OLD_V)	$PschnittV

		set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U0]
		set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V0]
	}
}

proc CalcRadiusCorrKK {	radius ipmode_akt ipmode U0 V0 U1 V1 A0 B0 A1 B1 } \
{
	global DEBUG_CUTCOM_NX DATA

	set DATA(RCC,KK) 1

	# ------------------------------------------------------------------------
	# Schnittpunkterrechnung der zwei korrigierten Kreise
	#
	# Kresigleichung fuer den ersten Kreis
	# (X - Xm1)2 + (Y - Ym1)2 = R12
	#
	# Kresigleichung fuer den zweiten Kreis
	# (X - Xm2)2 + (Y - Ym2)2 = R22
	#
	# 1. ausmultiplizieren und subtrahieren -> lineare Beziehung zw X und Y
	#    Sekantenbeschreibung, auf der die Schnittpunkte liegen
	# 2. nach X aufloesen und in die erste Kreisgleichung einsetzen
	# 3. Die quadratische Gleichung liefert dann zwei Werte fuer Y
	#
	# ------------------------------------------------------------------------
	
	# Mittelpunkt ist P0 + delta (IJK), da incrementale KB
	set Um1	[expr $U0 + $A0]
	set Vm1	[expr $V0 + $B0]
	set Um2	[expr $U1 + $A1]
	set Vm2	[expr $V1 + $B1]
	set R1	[expr sqrt($A0*$A0 + $B0*$B0)]
	set R2	[expr sqrt($A1*$A1 + $B1*$B1)]

	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius R1: $R1 R2: $R2"}

	# Korrigiert mit WKZRadius
	if {$ipmode_akt == 2} {set ccw -1} else {set ccw 1}
	set R1cor	[expr $R1 + $DATA(RCC,MODE) * $ccw * $radius]
	if {$ipmode == 2} {set ccw -1} else {set ccw 1}
	set R2cor	[expr $R2 + $DATA(RCC,MODE) * $ccw * $radius]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreisradius Korrigiert R1: $R1cor R2: $R2cor"}

	set dUmn	[expr $Um2 - $Um1]
	set dUmp	[expr $Um2 + $Um1]
	set dVmn	[expr $Vm2 - $Vm1]
	set dVmp	[expr $Vm2 + $Vm1]

	if {$DEBUG_CUTCOM_NX(2)} \
	{
		Message 3 "Mittelpunkt 1: $Um1  /  $Vm1"
		Message 3 "Mittelpunkt 2: $Um2  /  $Vm2"
		Message 3 "deltaUm : $dUmn"
		Message 3 "deltaVm : $dVmn"
		Message 3 "Um1: $Um1 Vm1: $Vm1 Um2: $Um2 Vm2: $Vm2"
	}

	# Sonderfaelle abfangen!
	#----------------------

	if {[expr abs($dUmn)] < 0.01  && [expr abs($dVmn)] < 0.01 } \
	{
		# Kreise haben identischen Mittelpunkt
		# -> Radius muss auch identisch sein

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreise haben identischen Mittelpunkt"}

		set nemu [expr $U1 - $Um1]
		set nemv [expr $V1 - $Vm1]

		set nlen	[expr sqrt($nemu*$nemu + $nemv*$nemv)]
		set nemu	[expr $nemu / $nlen]
		set nemv	[expr $nemv / $nlen]

		# Korrigierter Endpunkt ist gleich Endpunkt +/- WKZGRadius in
		# Richtung Mittelpunkt - Endpunkt

		if {$R1 > $R1cor} \
		{
			set Uendcor [expr $U1 - $radius * $nemu]
			set Vendcor [expr $V1 - $radius * $nemv]
		} \
		else \
		{
			set Uendcor [expr $U1 + $radius * $nemu]
			set Vendcor [expr $V1 + $radius * $nemv]
		}

		set DATA(RCC,U) [expr $Uendcor - $U1]
		set DATA(RCC,V) [expr $Vendcor - $V1]

		# den aktuellen korrigierten Startpunkt merken, fuer KBI
		set DATA(RCC,OLD_U)	$Uendcor
		set DATA(RCC,OLD_V)	$Vendcor

		return
	}

	# TS 17.03.2005 Zur Sicherheit den Nullfall abfangen!
	# z.B: rad_circ ist -0.008
	if {	([expr abs($R1cor)] > 0.01 && $R1cor < 0.01) || \
			([expr abs($R2cor)] > 0.01 && $R2cor < 0.01)} \
	{
		# Aktuelle Bewegung nicht fraesbar. Das sollte schon beim
		# vorraustesten der vorgaenger-Bewegung aufgefallen sein,
		# es sei denn, das hier ist die Anfahrtbewegung
		# oder Folgebewegung nicht fraesbar.

		Message 1 "ERROR: RCC Motion circle-circle: programed circle not"
		Message 1 "machinable - Corrected circle lower zero -> Tool to big"

		set DATA(RCC,U) 0.0
		set DATA(RCC,V) 0.0

		# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
		set DATA(RCC,OLD_U)	$U1
		set DATA(RCC,OLD_V)	$V1
		
		return
	}

	# Vektor vom programmierten Schnittpunkt zum Mittepunkt vom 1. Kreis
	set U0M1 [expr $Um1 - $U1]
	set V0M1 [expr $Vm1 - $V1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Vektor P0 -> M1: U $U0M1 V $V0M1"}

	# Vektor vom programmierten Schnittpunkt zum Mittepunkt vom 2. Kreis
	set U0M2 [expr $Um2 - $U1]
	set V0M2 [expr $Vm2 - $V1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Vektor P0 -> M2: U $U0M2 V $V0M2"}

	# Normalvektor von P0->M1
	set nlen	[expr sqrt($U0M1*$U0M1 + $V0M1*$V0M1)]
	set n1u	[expr $U0M1 / $nlen]
	set n1v	[expr $V0M1 / $nlen]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Normale P0 -> M1: U: $n1u V: $n1v"}

	# Normalvektor von P0->M2
	set nlen	[expr sqrt($U0M2*$U0M2 + $V0M2*$V0M2)]
	set n2u	[expr $U0M2 / $nlen]
	set n2v	[expr $V0M2 / $nlen]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Normale P0 -> M2: U: $n2u V: $n2v"}

	set skalar_vm1_vm2 [expr $U0M1 * $U0M2 + $V0M1 * $V0M2 ]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Skalar-Produkt der Vm-Vektoren:$skalar_vm1_vm2"}

	set Bedingung4 0
	set checkit YES

	# Tangentialer Uebergang - beide Mittelpunkte liegen auf einer Gerade
	# Bestimmung mit Hilfe der Normalvektoren P0->M1 und P0->M2
	if {	([expr abs(abs($n1u)-abs($n2u))]) < 0.01  && \
			([expr abs(abs($n1v)-abs($n2v))]) < 0.01 } \
	{
		# 18.03.2005 TS So einfach ist das nicht:
		# Im tangential fall gibt es Faelle, bei denen einen Uebergangsbewegung
		# notwendig ist und Faelle, bei denen der Schnittpunkt der korrigierten
		# Kreise errechnet werden muss.
		# 
		# Fall 1	Beide korrigierten Kreise sind groesser und das Skalarprodukt
		#      	von P0-M1 * P0-M2 ist negativ.
		#			-> Schnittpunkt der korrigierten Kreise rechnen.
		# Fall 2	Beide korrigierten Kreise sind kleiner und das Skalarproduktes
		#			von P0-M1 * P0-M2 ist negativ 
		#			ODER
		#			Einer der korrigierten Kreise ist kleiner und das Skalarproduktes
		#			von P0-M1 * P0-M2 ist positiv.
		#			-> Zusaetzliche Uebergangsbewegung notwendig
		# Fall 3	In allen anderen Faellen kann senkrecht zum P0 korrigiert werden.

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Tangentialer Uebergang"}

		# Hilfszahlen zum Rechnen: Groesser ist 1 kleiner ist 0
		if { $R1cor > $R1} {set Kreis1_KG 1} {set Kreis1_KG 0}
		if { $R2cor > $R2} {set Kreis2_KG 1} {set Kreis2_KG 0}

		if { $Kreis1_KG && $Kreis2_KG && $skalar_vm1_vm2 < 0.0} \
		{
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "   spezial Fall - Schnittpunkt errechnen"}
			# Schnittpunkt der korrigierten Kreise errechnen
			# Keinen Test mehr zur Entscheidung einer Uebergangsbewegung machen!
			set checkit NO
		} \
		elseif {	(!$Kreis1_KG && !$Kreis2_KG && $skalar_vm1_vm2 < 0.0) || \
					(((!$Kreis1_KG && $Kreis2_KG)||(!$Kreis2_KG && $Kreis1_KG)) && \
					$skalar_vm1_vm2 > 0.0) } \
		{
			# TS 18.01.2007 obige Abfrage korrigiert, damit diese dem Text
			# "einer der korrigierten Kreise ist kleiner"
			# entspricht

			# Zusaetzliche Bewegung
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "   mit Uebergangsbewegung"}
			set Bedingung4 1
		} \
		else \
		{
			# 22.03.2005 TS Sonderfall Vollkreis:
			# Um Rechenungenauigkeiten zu vermeiden den Fall extra behandeln.
			# Eingabewerte sind identisch!
			if {[expr abs($U0-$U1)] < 0.000001 && [expr abs($V0-$V1)] < 0.000001} \
			{
				# set DATA(RCC,OLD_U)  Bleibt
				# set DATA(RCC,OLD_V)  Bleibt

				set DATA(RCC,U)  [expr $DATA(RCC,OLD_U) - $U1]
				set DATA(RCC,V)  [expr $DATA(RCC,OLD_V) - $V1]

				return
			}
		
			# Unterscheiden, ob der korrigierte Kreis kleiner oder groesser ist.
			if { $R1cor < $R1} {set fact -1} {set fact 1}
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fact is: $fact"}
		
			# Schnittpunkt vom korrigerten Kreis mit der Gerade P0 -> PM1
			set Uendcor [expr $U1 - $fact * $radius * $n1u]
			set Vendcor [expr $V1 - $fact * $radius * $n1v]

			set DATA(RCC,OLD_U)  $Uendcor
			set DATA(RCC,OLD_V)  $Vendcor

			set DATA(RCC,U)  [expr $Uendcor - $U1]
			set DATA(RCC,V)  [expr $Vendcor - $V1]

			return
		}
	}

	# TS 16.03.2005 
	# Pruefen, ob Uebergangsbewegung notwendig ist:
	#
	# Zusaetzliche Bewegung mit Hilfe der Informationen:
	# - zweiter korrigierten Kreis ist kleiner/groesser
	#   Groesser ->  1
	#   Kleiner  -> -1
	# - Drehrichtung des ersten Kreises CCW/CW
	#   CCW ->  1
	#   CW  -> -1
	# - Betrag des Skalarproduktes Tangentvektor mir P0->M2
	#   -> Drehrichtung des Anfangskreises (G2/G3) , damit mit dem Vektor
	#   produkt ein tangentialer Vektor am P0 errechnet werden kann, der 
	#   richtungsbehaftet ist. Mit Hilfe des Tangetenvektors kann man nun 
	#   feststellen, wo M2 liegt 'vor' oder 'hinter' der Gerade P0-M1
	#   Betrag Positiv ->  1
	#   Betrag Negativ -> -1
	# 
	# Eine zusaetzliche Bewegung gibt es immer dann wenn das Produkt aus den
	# drei obigen Informationen Negativ ist.
		
	if {$R2cor > $R2} {set Bedingung1 1 } {set Bedingung1 -1}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "1. Bedingung R2corr G/K: $Bedingung1" }

	if {$ipmode_akt == 3} {set Bedingung2 1 } {set Bedingung2 -1}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "2. Bedingung 1. Kreis CWW/CW: $Bedingung2" }

	# Tangente am Kreis 1 am Punkt P0 mit Vektorprodukt (richtungsbehaftet)
	set UTang              $V0M1
	set VTang [expr -1.0 * $U0M1]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Tangente am P0 ist U: $UTang V: $VTang"}
	
	# Das Vorzeichen des Skalarproduktes von Tangentenvektor und P0->M2
	# gibt an, ob der Mittelpunkt M2 'vor' oder 'hinter' der Geraden P0-M1
	# liegt (Aus Richtung entlang Kreis 1 kommend)
	set skalar_vTan_vm2 [expr $UTang * $U0M2 + $VTang * $V0M2]
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Skalar-Produkt V-Tan und VM2: $skalar_vTan_vm2"}
	
	if {$skalar_vTan_vm2 > 0.0} {set Bedingung3 1 } {set Bedingung3 -1}
	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "3. Bedingung Betrag Vt * Vm2: $Bedingung3" }

	if {	($checkit == "YES") && \
			([expr $Bedingung1*$Bedingung2*$Bedingung3] == -1 || $Bedingung4)} \
	{
		# Zusaetliche Kreisbewegung durchfuehren. Der Mittelpunkt
		# des zusaetzlichen Kreises ist der original programmierte
		# Schnittpunkt der beiden Kreise. Die Korrigierten Punkte sind
		# die Schnittpunkte der korrigerten Kreise mit den Geraden von den
		# Mittelpunkten zu dem programmierten Schnittpunkt beider Kreise
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Additional Motion on Circle-Circle"}

		set DATA(RCC,KK,ADD_MOVE) 1

		if {$R2cor > $R2} \
			{ set DATA(RCC,ADD_MOVE,ROT) $ipmode } \
		else \
		{
			if {$ipmode == 2} \
				{ set DATA(RCC,ADD_MOVE,ROT) 3 } \
			else \
				{ set DATA(RCC,ADD_MOVE,ROT) 2 }
		}

		# Den programmierten Schnittpunkt als Mittelpunkt merken
		set DATA(RCC,ADD_MOVE,CENTER,U) $U1
		set DATA(RCC,ADD_MOVE,CENTER,V) $V1

		# Unterscheiden, ob der korrigierte Kreis kleiner oder groesser ist.
		if { $R1cor < $R1} {set fact -1} {set fact 1}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fact is: $fact"}
	
		# 1. korrigierter Punkt:
		# Schnittpunkt vom korrigerten Kreis mit der Gerade P0 -> PM1
		set Uendcor [expr $U1 - $fact * $radius * $n1u]
		set Vendcor [expr $V1 - $fact * $radius * $n1v]
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "1. kor. Punkt: U: $Uendcor V: $Vendcor"}

		set DATA(RCC,U)  [expr $Uendcor - $U1]
		set DATA(RCC,V)  [expr $Vendcor - $V1]

		# Unterscheiden, ob der korrigierte Kreis kleiner oder groesser ist.
		if { $R2cor < $R2} {set fact -1} {set fact 1}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Fact is: $fact"}
	
		# 2. korrigierter Punkt
		# Schnittpunkt vom korrigerten Kreis mit der Gerade P0 -> PM1
		set Uendcor [expr $U1 - $fact * $radius * $n2u]
		set Vendcor [expr $V1 - $fact * $radius * $n2v]
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "2. kor. Punkt: U: $Uendcor V: $Vendcor"}

		# den korrigierten Startpunkt merken, fuer KBI
		set DATA(RCC,OLD_U)  $Uendcor
		set DATA(RCC,OLD_V)  $Vendcor

		return
	}

	if {0} \
	{
	 # Testen, ob diese Sonderfaelle unten richtig beruecksichtigt werden.

	# Testen, ob einer der beiden korrigierten Radien Null ist.
	# d.h. Kein Kreis mehr -> auf dem Mittelpunkt bleiben/fahren.
	if {[expr abs($R1cor)] < 0.01 } \
	{
		# Den Mittelpunkt nehmen
		set DATA(RCC,U) [expr $Um1 - $U0]
		set DATA(RCC,V) [expr $Vm1 - $V0]

		# Den korrigierten Startpunkt fuer folgebewegugn merken
		set DATA(RCC,OLD_U)	$Um1
		set DATA(RCC,OLD_V)	$Vm1
		
		# Nicht raus, damit eventuelle zusaetzliche Bewegung ermittelt werden kann
		# TS 29.04.03
		# return
	} \
	elseif {[expr abs($R2cor)] < 0.01 } \
	{
		# Den Mittelpunkt nehmen
		set DATA(RCC,U) [expr $Um2 - $U0]
		set DATA(RCC,V) [expr $Vm2 - $V0]

		# Den korrigierten Startpunkt fuer folgebewegugn merken
		set DATA(RCC,OLD_U)	$Um2
		set DATA(RCC,OLD_V)	$Vm2
		
		# Nicht raus, damit eventuelle zusaetzliche Bewegung ermittelt werden kann
		# TS 29.04.03
		# return
	}
	}
	
	if {[expr abs($dUmn)] < 0.01} \
	{
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreise liegen uebereinander"}

		# Die Sekante der beiden Schnittpunkte ist parallel zur U-Achs

		# Call die Subroutine: mit S ist V - T ist U - s ist v - t ist u
		KK_sub1	$R1cor $R2cor $dVmn $dVmp $V1 $U1 $Vm1 $Um1 \
					$DATA(RCC,OLD_V) $DATA(RCC,OLD_U) $ipmode

		# Umschreiben der errechneten Werte
		set DATA(RCC,U)		$DATA(RCC,T)
		set DATA(RCC,V)		$DATA(RCC,S)
		set DATA(RCC,OLD_U)	$DATA(RCC,OLD_T)
		set DATA(RCC,OLD_V)	$DATA(RCC,OLD_S)
	} \
	elseif {[expr abs($dVmn)] < 0.01} \
	{
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Kreise liegen nebeneinander"}

		# Die Sekante der beiden Schnittpunkte ist parallel zur V-Achse

		# Call die Subroutine: mit S ist U - T ist V - s ist u - t ist v
		KK_sub1	$R1cor $R2cor $dUmn $dUmp $U1 $V1 $Um1 $Vm1 \
					$DATA(RCC,OLD_U) $DATA(RCC,OLD_V) $ipmode

		# Umschreiben der errechneten Werte
		set DATA(RCC,U)		$DATA(RCC,S)
		set DATA(RCC,V)		$DATA(RCC,T)
		set DATA(RCC,OLD_U)	$DATA(RCC,OLD_S)
		set DATA(RCC,OLD_V)	$DATA(RCC,OLD_T)
	} \
	else \
	{
		# Einer der beiden korrigierten Kreise ist groesser als der
		# programmierte. Ermmittlung der Schnittpunkte der korrigierten Kreise.

		set C1	[expr ( ($R1cor-$R2cor)*($R1cor+$R2cor) + $dVmn*$dVmp \
						+ $dUmn*$dUmp) / (2*$dUmn)]
		set C2	[expr $dVmn / $dUmn]

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "C1 $C1 C2 $C2"}

		set p		[expr (2*$C2*$Um1 - 2*$C1*$C2 - 2*$Vm1) / ($C2*$C2 + 1)]
		set q		[expr ($C1*$C1 - 2*$C1*$Um1 + $Um1*$Um1 + $Vm1*$Vm1 -  \
							$R1cor*$R1cor) / ($C2*$C2 + 1)]

		set wurz	[expr ($p/2)*($p/2) - $q]

		if {$DEBUG_CUTCOM_NX(2)} { Message 3 "p: $p q: $q wurzel: $wurz"}

		if {[expr abs($wurz)] < 0.01 } \
		{
			# Korrigerten Kreise haben Tangentialschnittpunkt
			set Vs [expr -$p/2]
			set Us [expr $C1 - $C2 * $Vs]

			set DATA(RCC,U)  [expr $Us - $U1]
			set DATA(RCC,V)  [expr $Vs - $V1]

			# den aktuellen korrigierten Startpunkt merken, fuer KBI
			set DATA(RCC,OLD_U)	$Us
			set DATA(RCC,OLD_V)	$Vs
		} \
		elseif {$wurz < 0.0} \
		{
			# Hier duerfte man nicht mehr hinkommen! Wenn wurz kleiner Null,
			# dann haben korrigerte Kreise keinen Schnittpunkt, obwohl einer
			# von ihnen groesser als der programmierte ist!
			# 23.03.05 TS Doch das geht schon, sollte aber schon abgerfangen sein,
			# da in diesem Fall eine Uebergangsbewegung noetig ist!

			Message 1 "ERROR: Corrected circles have no intersection point"
			Message 1 "       although one of them is bigger than org. Circle"

			set DATA(RCC,U) 0.0
			set DATA(RCC,V) 0.0

			# Bei Fehler als korrigierten Startpunkt,
			# den unkorrigierten merken
			set DATA(RCC,OLD_U)	$U1
			set DATA(RCC,OLD_V)	$V1
		} \
		else \
		{
			# Die korrigierten Kreise haben zwei Schnittpunkte:
			set Vs1 [expr -$p/2 + sqrt($wurz)]
			set Vs2 [expr -$p/2 - sqrt($wurz)]

			set Us1 [expr $C1 - $C2 * $Vs1]
			set Us2 [expr $C1 - $C2 * $Vs2]

			if {$DEBUG_CUTCOM_NX(2)} { Message 3 "U1 V1: $Us1 --- $Vs1"}
			if {$DEBUG_CUTCOM_NX(2)} { Message 3 "U2 V2: $Us2 --- $Vs2"}

			# Den Richtigen Schnittpunkt ermitteln:
			# Es ist immer der, der dichter am Endpunkt von der ersten
			# Kreisbewegung liegt

			set len1 [expr sqrt(($Us1-$U1)*($Us1-$U1)+($Vs1-$V1)*($Vs1-$V1))]
			set len2 [expr sqrt(($Us2-$U1)*($Us2-$U1)+($Vs2-$V1)*($Vs2-$V1))]

			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laengen: len1 $len1 len2 $len2"}

			if { [expr abs($len1 - $len2)] < 0.01 } \
			{
				# Liegen beide Schnittpunkte etwa gleich weit entfernt,
				# den nehmen, der auf der Kresibahn als erster erreicht wird
				# Drehrichtung und ueberstrichene Kreissegmente betrachten.

				if {$DEBUG_CUTCOM_NX(2)} \
					{Message 3 "Beide Schnittpunkte in etwa gleich weit weg"}

				set smu [expr $DATA(RCC,OLD_U) - $Um1]
				set smv [expr $DATA(RCC,OLD_U) - $Vm1]

				set e1mu [expr $Us1 - $Um1]
				set e1mv [expr $Vs1 - $Vm1]

				set e2mu [expr $Us2 - $Um1]
				set e2mv [expr $Vs2 - $Vm1]

				# Anfangs- und Endwinkel berechnen
				# Winkel zwischen 180 und 360 sin  -0.001 -179,9999
				#--------------------------------------------------
				set sang		[expr atan2($smv,$smu)]
				set e1ang	[expr atan2($e1mv,$e1mu)]
				set e2ang	[expr atan2($e2mv,$e2mu)]

				set 2PI [expr 2 * $DATA(PI)]

				set 2PI [expr 2 * $DATA(PI)]

				if {$DEBUG_CUTCOM_NX(2)} {Message 3 "sang = $sang"}
				if {$DEBUG_CUTCOM_NX(2)} {Message 3 "e1ang = $e1ang"}
				if {$DEBUG_CUTCOM_NX(2)} {Message 3 "e2ang = $e2ang"}
	
				set circleseg1 [expr $e1ang - $sang]
				set circleseg2 [expr $e2ang - $sang]
	
				if { $circleseg1 < 0.0 } { set circleseg1 [expr $2PI+$circleseg1] }
				if { $circleseg2 < 0.0 } { set circleseg2 [expr $2PI+$circleseg2] }

				if {$DEBUG_CUTCOM_NX(2)} \
					{Message 3 "circleseg1 = $circleseg1 circleseg2 = $circleseg2"}

				# Nun haben wir die Winkel von SANG nach S1 und S2 als positiven
				# Winkel im mathematisch positiven Drehsinn. Wenn CCW (G3) ist der
				# erste der kleinere ansonsten der groessere.^

				if { $ipmode == 3 } \
					{ if {$circleseg1 < $circleseg2} {set pkt 1} {set pkt 2}} \
				else \
					{ if {$circleseg1 < $circleseg2} {set pkt 2} {set pkt 1}}

				set DATA(RCC,U)  [expr [set Us$pkt] - $U1]
				set DATA(RCC,V)  [expr [set Vs$pkt] - $V1]

				# den aktuellen korrigierten Startpunkt merken, fuer KBI
				set DATA(RCC,OLD_U)	$Us1
				set DATA(RCC,OLD_V)	$Vs1
			} \
			else \
			{
				if { $len1 > $len2 } \
				{
					set DATA(RCC,U)  [expr $Us2 - $U1]
					set DATA(RCC,V)  [expr $Vs2 - $V1]

					# den aktuellen korrigierten Startpunkt merken, fuer KBI
					set DATA(RCC,OLD_U)	$Us2
					set DATA(RCC,OLD_V)	$Vs2
				} \
				else \
				{
					set DATA(RCC,U)  [expr $Us1 - $U1]
					set DATA(RCC,V)  [expr $Vs1 - $V1]

					# den aktuellen korrigierten Startpunkt merken, fuer KBI
					set DATA(RCC,OLD_U)	$Us1
					set DATA(RCC,OLD_V)	$Vs1
				}
			}
		}
	}
}

proc KK_sub1 {R1cor R2cor dSmn dSmp S1 T1 Sm1 Tm1 Sold_circ Told_circ ipmode} \
{
	global DATA DEBUG_CUTCOM_NX

	# Einer der beiden korrigierten Kreise ist groesser als der programmierte.
	# Ermmittlung der Schnittpunkte der korrigierten Kreise.

	set Ssek [expr (($R1cor-$R2cor) * ($R1cor+$R2cor) + $dSmn * $dSmp) \
				/ (2.0 * $dSmn)]

	if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Sekante liegt auf S = $Ssek"}

	if {[expr abs(abs($Ssek - $Sm1) - $R1cor)] < 0.01 } \
	{
		# Tangentialer Schnittpunkt

		set r1r2 [expr $R1cor + $R2cor]

		if {$dSmn > 0.0 } \
			{set nms 1} \
		else \
		{
			if {[expr abs($r1r2 + $dSmn)]  > 0.05 } \
				{set nms 1} \
			else \
				{set nms -1}
		}

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "dSmn = $dSmn und r1r2 = $r1r2"}
		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Richtung ist nms = $nms"}

		set Ss [expr $Sm1 + $R1cor * $nms]
		set Ts $Tm1

		set DATA(RCC,S)  [expr $Ss - $S1]
		set DATA(RCC,T)  [expr $Ts - $T1]

		# den aktuellen korrigierten Startpunkt merken, fuer KBI
		set DATA(RCC,OLD_S)	$Ss
		set DATA(RCC,OLD_T)	$Ts
	} \
	else \
	{
	# Zwei Schnittpunkte --- {[expr abs($Ssek - $Sm1)] < $R1cor }

		set p	[expr -2*$Tm1]
		set q	[expr ($Ssek-$Sm1)*($Ssek-$Sm1) + $Tm1*$Tm1 - $R1cor*$R1cor]

		set wurz	[expr ($p/2)*($p/2) - $q]

		if {$DEBUG_CUTCOM_NX(2)} { Message 3 "p: $p q: $q wurzel: $wurz"}

		if {[expr abs($wurz)] < 0.01 } \
		{
			# Der Tangentialfall ist zuvor behandelt

			if {$DEBUG_CUTCOM_NX(2)} \
				{Message 3 "Tangentialfall sollte vorher beahndelt worden sein"}

			# Wurzel auf Null setzten. Dadurch zwei identische Punkte.
			# Das koennte die Methode beim auffinden des richtigen beeinflussen

			set wurz 0.0
		} \
		elseif {$wurz < 0.0} \
		{
			# Hier duerfte man nicht mehr hinkommen! Wenn wurz kleiner Null,
			# dann haben korrigerte Kreise keinen Schnittpunkt, obwohl einer
			# von ihnen groesser als der programmierte ist!

			Message 1 "ERROR: Corrected circles have no intersection point"
			Message 1 "       although one of them is bigger than org. Circle"

			set DATA(RCC,S) 0.0
			set DATA(RCC,T) 0.0

			# Bei Fehler als korrigierten Startpunkt, den unkorrigierten merken
			set DATA(RCC,OLD_S)	$S1
			set DATA(RCC,OLD_T)	$T1

			return
		}

		set Ts1 [expr -$p/2 + sqrt($wurz)]
		set Ts2 [expr -$p/2 - sqrt($wurz)]

		# Den Schnittpunkt suchen, der dichter am Endpunkt liegt.

		set len1 [expr sqrt(($Ssek-$S1)*($Ssek-$S1)+($Ts1-$T1)*($Ts1-$T1))]
		set len2 [expr sqrt(($Ssek-$S1)*($Ssek-$S1)+($Ts2-$T1)*($Ts2-$T1))]

		if {$DEBUG_CUTCOM_NX(2)} {Message 3 "Laengen: len1 $len1 len2 $len2"}

		if { [expr abs($len1 - $len2)] < 0.01 } \
		{
			# Liegen beide Schnittpunkte etwa gleich weit entfernt,
			# den nehmen, der auf der Kresibahn als erster erreicht wird
			# Drehrichtung und ueberstrichene Kreissegmente betrachten.

			if {$DEBUG_CUTCOM_NX(2)} \
				{Message 3 "Beide Schnittpunkte in etwa gleich weit weg"}

			set sms [expr $Sold_circ - $Sm1]
			set smt [expr $Told_circ - $Tm1]

			set ems [expr $Ssek - $Sm1]
			set e1mt [expr $Ts1 - $Tm1]
			set e2mt [expr $Ts2 - $Tm1]

			# Anfangs- und Endwinkel berechnen
			# Winkel zwischen 180 und 360 sin  -0.001 -179,9999
			#--------------------------------------------------
			set sang		[expr atan2($smt,$sms)]
			set e1ang	[expr atan2($e1mt,$ems)]
			set e2ang	[expr atan2($e2mt,$ems)]

			set 2PI [expr 2 * $DATA(PI)]

			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "sang = $sang"}
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "e1ang = $e1ang"}
			if {$DEBUG_CUTCOM_NX(2)} {Message 3 "e2ang = $e2ang"}

			set circleseg1 [expr $e1ang - $sang]
			set circleseg2 [expr $e2ang - $sang]

			if { $circleseg1 < 0.0 } { set circleseg1 [expr $2PI + $circleseg1] }
			if { $circleseg2 < 0.0 } { set circleseg2 [expr $2PI + $circleseg2] }

			if {$DEBUG_CUTCOM_NX(2)} \
				{Message 3 "circleseg1 = $circleseg1 circleseg2 = $circleseg2"}

			# Nun haben wir die Winkel von SANG nach S1 und S2 als positiven Winkel
			# im mathematisch positiven Drehsinn. Wenn CCW (G3) ist der erste der
			# kleinere ansonsten der groessere.

			if { $ipmode == 3 } \
				{ if {$circleseg1 < $circleseg2} {set pkt 1} {set pkt 2}} \
			else \
				{ if {$circleseg1 < $circleseg2} {set pkt 2} {set pkt 1}}

			set DATA(RCC,T)				[expr [set Ts$pkt] - $T1]
			set DATA(RCC,OLD_T)	$Ts1
		} \
		else \
		{
			if { $len1 > $len2 } \
			{
				set DATA(RCC,T)				[expr $Ts2 - $T1]
				set DATA(RCC,OLD_T)	$Ts2
			} \
			else \
			{
				set DATA(RCC,T)				[expr $Ts1 - $T1]
				set DATA(RCC,OLD_T)	$Ts1
			}
		}

		set DATA(RCC,S)				[expr $Ssek - $S1]
		set DATA(RCC,OLD_S)	$Ssek
	}
}
