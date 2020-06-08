set rcsId {$Id: pb_stooop.tcl,v 1.2 1999/04/27 18:35:22 dasn INTEGRATED=^BY=dasn^ON=Tue_Apr_27_11_35_20_PDT_1999^GROUP=/cam/v160^GROUPBR=1_1_1_1^FROMM=ugv160^ $}

package provide stooop 3.6

catch {rename proc _proc}            ;# rename proc before it is overloaded, ignore error in case of multiple inclusion of this file

namespace eval ::stooop {
    variable checkCode
    variable traceProcedureChannel
    variable traceProcedureFormat
    variable traceDataChannel
    variable traceDataFormat
    variable traceDataOperations

    set checkCode {}                                ;# no checking by default: use an empty instruction to avoid any performance hit
    if {[info exists ::env(STOOOPCHECKALL)]} {
        array set ::env {STOOOPCHECKPROCEDURES {} STOOOPCHECKDATA {}}
    }
    if {[info exists ::env(STOOOPCHECKPROCEDURES)]} {
        append checkCode {::stooop::checkProcedure;}
    }
    if {[info exists ::env(STOOOPTRACEALL)]} {                                                   ;# use same channel for both traces
        set ::env(STOOOPTRACEPROCEDURES) $::env(STOOOPTRACEALL)
        set ::env(STOOOPTRACEDATA) $::env(STOOOPTRACEALL)
    }
    if {[info exists ::env(STOOOPTRACEPROCEDURES)]} {
        set traceProcedureChannel $::env(STOOOPTRACEPROCEDURES)
        if {![regexp {^stdout|stderr$} $traceProcedureChannel]} {
            set traceProcedureChannel [open $::env(STOOOPTRACEPROCEDURES) w+]        ;# eventually truncate output file if it exists
        }
        set traceProcedureFormat {class: %C, procedure: %p, object: %O, arguments: %a}                             ;# default format
        catch {set traceProcedureFormat $::env(STOOOPTRACEPROCEDURESFORMAT)}         ;# eventually override with user defined format
        append checkCode {::stooop::traceProcedure;}
    }
    if {[info exists ::env(STOOOPTRACEDATA)]} {
        set traceDataChannel $::env(STOOOPTRACEDATA)
        if {![regexp {^stdout|stderr$} $traceDataChannel]} {
            set traceDataChannel [open $::env(STOOOPTRACEDATA) w+]                   ;# eventually truncate output file if it exists
        }
        # default format
        set traceDataFormat {class: %C, procedure: %p, array: %A, object: %O, member: %m, operation: %o, value: %v}
        catch {set traceDataFormat $::env(STOOOPTRACEDATAFORMAT)}                    ;# eventually override with user defined format
        set traceDataOperations rwu                                                               ;# trace all operations by default
        catch {set traceDataOperations $::env(STOOOPTRACEDATAOPERATIONS)}        ;# eventually override with user defined operations
    }

    namespace export class virtual new delete classof                                                      ;# export public commands

    if {![info exists newId]} {
        variable newId 0                        ;# initialize object id counter only once even if this file is sourced several times
    }

    _proc new {classOrId args} {                                   ;# create an object of specified class or copy an existing object
        variable newId
        variable fullClass

        # use local variable for identifier because new can be invoked recursively
        if {[scan $classOrId %u dummy]==0} {                                                            ;# first argument is a class
            set constructor ${classOrId}::[namespace tail $classOrId]                                   ;# generate constructor name
            # we could detect here whether class was ever declared but that would prevent stooop packages to load properly, because
            # constructor would not be invoked and thus class source file never sourced
            # invoke the constructor for the class with optional arguments in caller's variable context so that object creation is
            # transparent and that array names as constructor parameters work with a simple upvar
            # note: if class is in a package, the class namespace code is loaded here, as the first object of the class is created
            uplevel $constructor [set id [incr newId]] $args
            # generate fully qualified class namespace name now that we are sure that class namespace code has been invoked
            set fullClass($id) [namespace qualifiers [uplevel namespace which -command $constructor]]
        } else {   ;# first argument is an object identifier (unsigned integer), copy source object to new object of identical class
            if {[catch {set fullClass([set id [incr newId]]) $fullClass($classOrId)}]} {
                error "invalid object identifier $classOrId"
            }
            # invoke the copy constructor for the class in caller's variable context so that object copy is transparent (see above)
            uplevel $fullClass($classOrId)::_copy $id $classOrId
        }
        return $id                                                                              ;# return a unique object identifier
    }

    _proc delete {args} {                                                                              ;# delete one or more objects
        variable fullClass

        foreach id $args {                           ;# destruct in caller's variable context so that object deletion is transparent
            uplevel ::stooop::deleteObject $fullClass($id) $id
            unset fullClass($id)
        }
    }

    # delete object data starting at specified class layer and going up the base class hierarchy if any
    # invoke the destructor for the object class and unset all the object data members for the class
    # the destructor will in turn delete the base classes layers
    _proc deleteObject {fullClass id} {
        # invoke the destructor for the class in caller's variable context so that object deletion is transparent
        uplevel ${fullClass}::~[namespace tail $fullClass] $id
        # delete all this object data members if any (assume that they were stored as ${class}::($id,memberName))
        foreach name [array names ${fullClass}:: $id,*] {
            unset ${fullClass}::($name)
        }
        # data member arrays deletion is left to the user
    }

    _proc classof {id} {
        variable fullClass

        return $fullClass($id)                                                                             ;# return class of object
    }

    _proc copy {fullClass from to} {                                          ;# copy object data members from one object to another
        set index [string length $from]
        foreach name [array names ${fullClass}:: $from,*] {                                             ;# copy regular data members
            set ${fullClass}::($to[string range $name $index end]) [set ${fullClass}::($name)]
        }
        # if any, array data members copy is left to the class programmer through the then mandatory copy constructor
    }
}

_proc ::stooop::class {args} {
    variable declared

    set class [lindex $args 0]
    set declared([uplevel namespace eval $class {namespace current}]) {}            ;# register class using its fully qualified name
    # create the empty name array used to hold all class objects so that static members can be directly initialized within the class
    # declaration but outside member procedures
    uplevel namespace eval $class [list "::variable {}\n[lindex $args end]"]
}

# if procedure is a member of a known class, class and procedure names are set and true is returned, otherwise false is returned
_proc ::stooop::parseProcedureName {namespace name fullClassVariable procedureVariable messageVariable} {
    # namespace argument is the current namespace (fully qualified) in which the procedure is defined
    variable declared
    upvar $fullClassVariable fullClass $procedureVariable procedure $messageVariable message

    if {[info exists declared($namespace)]&&([string length [namespace qualifiers $name]]==0)} {
        # a member procedure is being defined inside a class namespace
        set fullClass $namespace
        set procedure $name                                                                    ;# member procedure name is full name
        return 1
    } else {                                                 ;# procedure is either a member of a known class or a regular procedure
        if {![string match ::* $name]} {                                                  ;# eventually fully qualify procedure name
            if {[string compare $namespace ::]==0} {                                                ;# global namespace special case
                set name ::$name
            } else {
                set name ${namespace}::$name
            }
        }
        set fullClass [namespace qualifiers $name]                                            ;# eventual class name is leading part
        if {[info exists declared($fullClass)]} {                                                               ;# if class is known
            set procedure [namespace tail $name]                                                     ;# procedure always is the tail
            return 1
        } else {                                                                                           ;# not a member procedure
            if {[string length $fullClass]==0} {
                set message "procedure $name class name is empty"
            } else {
                set message "procedure $name class $fullClass is unknown"
            }
            return 0
        }
    }
}

# virtual operator, to be placed before proc
# virtualize a member procedure, determine whether it is a pure virtual, check for procedures that cannot be virtualized
_proc ::stooop::virtual {keyword name arguments args} {
    variable pureVirtual     ;# set a flag so that proc knows it is acting upon a virtual procedure, also serves as a pure indicator

    if {[string compare [uplevel namespace which -command $keyword] ::proc]!=0} {
        error "virtual operator works only on proc, not $keyword"
    }
    if {![parseProcedureName [uplevel namespace current] $name fullClass procedure message]} {
        error $message                                                                       ;# not in a member procedure definition
    }
    set class [namespace tail $fullClass]
    if {[string compare $class $procedure]==0} {
        error "cannot make class $fullClass constructor virtual"
    }
    if {[string compare ~$class $procedure]==0} {
        error "cannot make class $fullClass destructor virtual"
    }
    if {[string compare [lindex $arguments 0] this]!=0} {
        error "cannot make static procedure $procedure of class $fullClass virtual"
    }
    set pureVirtual [expr {[llength $args]==0}]                                              ;# no procedure body means pure virtual
    # process procedure declaration, body being empty for pure virtual procedure
    uplevel ::proc [list $name $arguments [lindex $args 0]]                             ;# make virtual transparent by using uplevel
    unset pureVirtual
}

_proc proc {name arguments args} {
    if {![::stooop::parseProcedureName [uplevel namespace current] $name fullClass procedure message]} {
        # not in a member procedure definition, fall back to normal procedure declaration
        # uplevel is required instead of eval here otherwise tcl seems to forget the procedure namespace if it exists
        uplevel _proc [list $name $arguments] $args
        return
    }
    if {[llength $args]==0} {                                                                   ;# check for procedure body presence
        error "missing body for ${fullClass}::$procedure"
    }
    set class [namespace tail $fullClass]
    if {[string compare $class $procedure]==0} {                                                     ;# class constructor definition
        if {[string compare [lindex $arguments 0] this]!=0} {
            error "class $fullClass constructor first argument must be this"
        }
        if {[string compare [lindex $arguments 1] copy]==0} {                            ;# user defined copy constructor definition
            if {[llength $arguments]!=2} {
                error "class $fullClass copy constructor must have 2 arguments exactly"
            }
            if {[catch {info body ::${fullClass}::$class}]} {                               ;# make sure of proper declaration order
                error "class $fullClass copy constructor defined before constructor"
            }
            eval ::stooop::constructorDeclaration $fullClass $class 1 \{$arguments\} $args
        } else {                                                                                                 ;# main constructor
            eval ::stooop::constructorDeclaration $fullClass $class 0 \{$arguments\} $args
            ::stooop::generateDefaultCopyConstructor $fullClass                          ;# always generate default copy constructor
        }
    } elseif {[string compare ~$class $procedure]==0} {                                              ;# class destructor declaration
        if {[llength $arguments]!=1} {
            error "class $fullClass destructor must have 1 argument exactly"
        }
        if {[string compare [lindex $arguments 0] this]!=0} {
            error "class $fullClass destructor argument must be this"
        }
        if {[catch {info body ::${fullClass}::$class}]} {                      ;# use fastest method for testing procedure existence
            error "class $fullClass destructor defined before constructor"                  ;# make sure of proper declaration order
        }
        ::stooop::destructorDeclaration $fullClass $class $arguments [lindex $args 0]
    } else {                                           ;# regular member procedure, may be static if there is no this first argument
        if {[catch {info body ::${fullClass}::$class}]} {                                   ;# make sure of proper declaration order
            error "class $fullClass member procedure $procedure defined before constructor"
        }
        ::stooop::memberProcedureDeclaration $fullClass $class $procedure $arguments [lindex $args 0]
    }
}

_proc ::stooop::constructorDeclaration {fullClass class copy arguments args} { ;# copy flag is set for user defined copy constructor
    variable checkCode
    variable fullBases
    variable variable

    set number [llength $args]
    if {($number%2)==0} {                                                    ;# check that each base class constructor has arguments
        error "bad class $fullClass constructor declaration, a base class, contructor arguments or body may be missing"
    }
    if {[string compare [lindex $arguments end] args]==0} {
        set variable($fullClass) {}                    ;# remember that there is a variable number of arguments in class constructor
    }
    if {!$copy} {
        # do not initialize (or reinitialize in case of multiple class file source statements) base classes for copy constructor
        set fullBases($fullClass) {}
    }
    foreach {base baseArguments} [lrange $args 0 [expr {$number-2}]] {         ;# check base classes and their constructor arguments
        # fully qualify base class namespace by looking up constructor, which must exist
        set constructor ${base}::[namespace tail $base]
        # in case base class is defined in a file that is part of a package, make sure that file is sourced through the tcl
        # package auto-loading mechanism by directly invoking the base class constructor while ignoring the resulting error
        catch {$constructor}
        # determine fully qualified base class name in user invocation level (up 2 levels from here since this procedure is invoked
        # exclusively by proc)
        set fullBase [namespace qualifiers [uplevel 2 namespace which -command $constructor]]
        if {[string length $fullBase]==0} {                                                       ;# base constructor is not defined
            if {[string match *$base $fullClass]} {
                # if the specified base class name is included last in the fully qualified class name, assume that it was meant to
                # be the same
                error "class $fullClass cannot be derived from itself"
            } else {
                error "class $fullClass constructor defined before base class $base constructor"
            }
        }
        if {!$copy} {                                     ;# check and save base classes only for main constructor that defines them
            if {[lsearch -exact $fullBases($fullClass) $fullBase]>=0} {
                error "class $fullClass directly inherits from class $fullBase more than once"
            }
            lappend fullBases($fullClass) $fullBase
        }
        # remove new lines in base arguments part in case user has formatted long declarations with new lines
        regsub -all \n $baseArguments {} constructorArguments($fullBase)
    }
    # setup access to class data (an empty named array)
    # fully qualify tcl variable command for it may have been redefined within the class namespace
    # since constructor is directly invoked by new, the object identifier must be valid, so debugging the procedure is pointless
    set constructorBody \
"::variable {}
$checkCode
"
    if {[llength $fullBases($fullClass)]>0} {                                                 ;# base class(es) derivation specified
        # invoke base class constructors before evaluating constructor body
        # then set base part hidden derived member so that virtual procedures are invoked at base class level as in C++
        if {[info exists variable($fullClass)]} {                       ;# variable number of arguments in derived class constructor
            foreach fullBase $fullBases($fullClass) {
                if {![info exists constructorArguments($fullBase)]} {
                    error "missing base class $fullBase constructor arguments from class $fullClass constructor"
                }
                set baseConstructor ${fullBase}::[namespace tail $fullBase]
                if {[info exists variable($fullBase)]&&([string first {$args} $constructorArguments($fullBase)]>=0)} {
                    # variable number of arguments in base class constructor and in derived class base class constructor arguments
                    # use eval so that base class constructor sees arguments instead of a list
                    # only the last argument of the base class constructor arguments is considered as a variable list
                    # (it usually is $args but could be a procedure invocation, such as [filter $args])
                    # fully qualify tcl commands such as set, for they may have been redefined within the class namespace
                    append constructorBody \
"::set _list \[::list $constructorArguments($fullBase)\]
::eval $baseConstructor \$this \[::lrange \$_list 0 \[::expr {\[::llength \$_list\]-2}\]\] \[::lindex \$_list end\]
::unset _list
::set ${fullBase}::(\$this,_derived) $fullClass
"
                } else {
                    # no special processing needed
                    # variable number of arguments in base class constructor or
                    # variable arguments list passed as is to base class constructor
                    append constructorBody \
"$baseConstructor \$this $constructorArguments($fullBase)
::set ${fullBase}::(\$this,_derived) $fullClass
"
                }
            }
        } else {                                                                                     ;# constant number of arguments
            foreach fullBase $fullBases($fullClass) {
                if {![info exists constructorArguments($fullBase)]} {
                    error "missing base class $fullBase constructor arguments from class $fullClass constructor"
                }
                set baseConstructor ${fullBase}::[namespace tail $fullBase]
                append constructorBody \
"$baseConstructor \$this $constructorArguments($fullBase)
::set ${fullBase}::(\$this,_derived) $fullClass
"
            }
        }
    }                                                                                     ;# else no base class derivation specified
    if {$copy} {                                        ;# for user defined copy constructor, copy derived class member if it exists
        append constructorBody \
"::catch {::set ${fullClass}::(\$this,_derived) \[::set ${fullClass}::(\$[::lindex $arguments 1],_derived)\]}
"
    }
    append constructorBody [lindex $args end]                                          ;# finally append user defined procedure body
    if {$copy} {
        _proc ${fullClass}::_copy $arguments $constructorBody
    } else {
        _proc ${fullClass}::$class $arguments $constructorBody
    }
}

_proc ::stooop::destructorDeclaration {fullClass class arguments body} {
    variable checkCode
    variable fullBases

    # setup access to class data
    # since the object identifier is always valid at this point, debugging the procedure is pointless
    set body \
"::variable {}
$checkCode
$body
"
    # if there are any, delete base classes parts in reverse order of construction
    for {set index [expr {[llength $fullBases($fullClass)]-1}]} {$index>=0} {incr index -1} {
        set fullBase [lindex $fullBases($fullClass) $index]
        append body \
"::stooop::deleteObject $fullBase \$this
"
    }
    _proc ${fullClass}::~$class $arguments $body
}

_proc ::stooop::memberProcedureDeclaration {fullClass class procedure arguments body} {
    variable checkCode
    variable pureVirtual

    if {[info exists pureVirtual]} {                                                                          ;# virtual declaration
        if {$pureVirtual} {                                                                              ;# pure virtual declaration
            # setup access to class data
            # evaluate derived procedure which must exists. derived procedure return value is automatically returned
            _proc ${fullClass}::$procedure $arguments \
"::variable {}
$checkCode
::uplevel \$${fullClass}::(\$this,_derived)::$procedure \[::lrange \[::info level 0\] 1 end\]
"
        } else {                                                                                      ;# regular virtual declaration
            # setup access to class data
            # evaluate derived procedure and return if it exists
            # else evaluate the base class procedure which can be invoked from derived class procedure by prepending _
            _proc ${fullClass}::_$procedure $arguments \
"::variable {}
$checkCode
$body
"
            _proc ${fullClass}::$procedure $arguments \
"::variable {}
$checkCode
if {!\[::catch {::info body \$${fullClass}::(\$this,_derived)::$procedure}\]} {
::return \[::uplevel \$${fullClass}::(\$this,_derived)::$procedure \[::lrange \[::info level 0\] 1 end\]\]
}
::uplevel ${fullClass}::_$procedure \[::lrange \[::info level 0\] 1 end\]
"
        }
    } else {                                                                                              ;# non virtual declaration
        # setup access to class data
        _proc ${fullClass}::$procedure $arguments \
"::variable {}
$checkCode
$body
"
    }
}

# generate default copy procedure which may be overriden by the user for any class layer
_proc ::stooop::generateDefaultCopyConstructor {fullClass} {
    variable fullBases

    foreach fullBase $fullBases($fullClass) {   ;# generate code for cloning base classes layers if there is at least one base class
        append body \
"${fullBase}::_copy \$this \$sibling
"
    }
    append body \
"::stooop::copy $fullClass \$sibling \$this
"
    _proc ${fullClass}::_copy {this sibling} $body
}


if {[llength [array names ::env STOOOP*]]>0} {             ;# if one or more environment variables are set, we are in debugging mode

    catch {rename ::stooop::class ::stooop::_class}                              ;# gracefully handle multiple sourcing of this file
    _proc ::stooop::class {args} {                     ;# use a new class procedure instead of adding debugging code to existing one
        variable traceDataOperations

        set class [lindex $args 0]
        if {[info exists ::env(STOOOPCHECKDATA)]} {      ;# check write and unset operations on empty named array holding class data
            uplevel namespace eval $class [list {::trace variable {} wu ::stooop::checkData}]
        }
        if {[info exists ::env(STOOOPTRACEDATA)]} {      ;# trace write and unset operations on empty named array holding class data
            uplevel namespace eval $class [list "::trace variable {} $traceDataOperations ::stooop::traceData"]
        }
        uplevel ::stooop::_class $args
    }

    if {[info exists ::env(STOOOPCHECKPROCEDURES)]} {                ;# prevent the creation of any object of a pure interface class
        # use a new virtual procedure instead of adding debugging code to existing one
        catch {rename ::stooop::virtual ::stooop::_virtual}                      ;# gracefully handle multiple sourcing of this file
        _proc ::stooop::virtual {keyword name arguments args} {
            variable interface                     ;# keep track of interface classes (which have at least 1 pure virtual procedure)

            uplevel ::stooop::_virtual [list $keyword $name $arguments] $args
            parseProcedureName [uplevel namespace current] $name fullClass procedure message
            if {[llength $args]==0} {                                                        ;# no procedure body means pure virtual
                set interface($fullClass) {}
            }
        }

        catch {rename ::stooop::new ::stooop::_new}                              ;# gracefully handle multiple sourcing of this file
        _proc ::stooop::new {classOrId args} {           ;# use a new new procedure instead of adding debugging code to existing one
            variable fullClass
            variable interface

            if {[scan $classOrId %u dummy]==0} {                                                        ;# first argument is a class
                set constructor ${classOrId}::[namespace tail $classOrId]                               ;# generate constructor name
                catch {$constructor}              ;# force loading in case class is in a package so namespace commands work properly
                set fullName [namespace qualifiers [uplevel namespace which -command $constructor]]
            } else {                                                                       ;# first argument is an object identifier
                set fullName $fullClass($classOrId)                         ;# class code, if from a package, must already be loaded
            }
            if {[info exists interface($fullName)]} {
                error "class $fullName with pure virtual procedures should not be instanciated"
            }
            return [uplevel ::stooop::_new $classOrId $args]
        }
    }

    _proc ::stooop::ancestors {fullClass} {                              ;# return the unsorted list of ancestors in class hierarchy
        variable ancestors                                                                             ;# use a cache for efficiency
        variable fullBases

        if {[info exists ancestors($fullClass)]} {
            return $ancestors($fullClass)                                                                      ;# found in the cache
        }
        set list {}
        foreach class $fullBases($fullClass) {
            set list [concat $list [list $class] [ancestors $class]]
        }
        set ancestors($fullClass) $list                                                                             ;# save in cache
        return $list
    }

    # since this procedure is always invoked from a debug procedure, take the extra level in the stack frame into account
    # parameters (passed as references) that cannot be determined are not set
    _proc ::stooop::debugInformation {className fullClassName procedureName fullProcedureName thisParameterName} {
        upvar $className class $fullClassName fullClass $procedureName procedure $fullProcedureName fullProcedure\
            $thisParameterName thisParameter
        variable declared

        set namespace [uplevel 2 namespace current]
        if {[lsearch -exact [array names declared] $namespace]<0} return                                 ;# not in a class namespace
        set fullClass [string trimleft $namespace :]                                            ;# remove redundant global qualifier
        set class [namespace tail $fullClass]                                                                          ;# class name
        set list [info level -2]
        if {[llength $list]==0} return                                                     ;# not in a procedure, nothing else to do
        set procedure [lindex $list 0]
        set fullProcedure [uplevel 3 namespace which -command $procedure]            ;# procedure must be known at the invoker level
        set procedure [namespace tail $procedure]                                                            ;# strip procedure name
        if {[string compare $class $procedure]==0} {                                                                  ;# constructor
            set procedure constructor
        } elseif {[string compare ~$class $procedure]==0} {                                                            ;# destructor
            set procedure destructor
        }
        if {[string compare [lindex [info args $fullProcedure] 0] this]==0} {                                ;# non static procedure
            set thisParameter [lindex $list 1]                                                ;# object identifier is first argument
        }
    }

    _proc ::stooop::checkProcedure {} {                       ;# check that member procedure is valid for object passed as parameter
        variable fullClass

        debugInformation class qualifiedClass procedure qualifiedProcedure this
        if {![info exists this]} return                                                    ;# static procedure, no checking possible
        if {[string compare $procedure constructor]==0} return   ;# in constructor, checking useless since object is not yet created
        if {![info exists fullClass($this)]} {
            error "$this is not a valid object identifier"
        }
        set fullName [string trimleft $fullClass($this) :]
        if {[string compare $fullName $qualifiedClass]==0} return                              ;# procedure and object classes match
        # restore global qualifiers to compare with internal full class array data
        if {[lsearch -exact [ancestors ::$fullName] ::$qualifiedClass]<0} {
            error "class $qualifiedClass of $qualifiedProcedure procedure not an ancestor of object $this class $fullName"
        }
    }

    _proc ::stooop::traceProcedure {} {          ;# gather current procedure data, perform substitutions and output to trace channel
        variable traceProcedureChannel
        variable traceProcedureFormat

        debugInformation class qualifiedClass procedure qualifiedProcedure this
        # all debug data is available since we are for sure in a class procedure
        set text $traceProcedureFormat
        regsub -all %C $text $qualifiedClass text                                                      ;# fully qualified class name
        regsub -all %c $text $class text
        regsub -all %P $text $qualifiedProcedure text                                              ;# fully qualified procedure name
        regsub -all %p $text $procedure text
        if {[info exists this]} {                                                                            ;# non static procedure
            regsub -all %O $text $this text
            regsub -all %a $text [lrange [info level -1] 2 end] text                                          ;# remaining arguments
        } else {                                                                                                 ;# static procedure
            regsub -all %O $text {} text
            regsub -all %a $text [lrange [info level -1] 1 end] text                                          ;# remaining arguments
        }
        puts $traceProcedureChannel $text
    }

    # check that class data member is accessed within procedure of identical class
    # then if procedure is not static, check that only data belonging to the object passed as parameter is accessed
    _proc ::stooop::checkData {array name operation} {
        scan $name %u,%s identifier member
        if {[info exists member]&&([string compare $member _derived]==0)} return                ;# ignore internally defined members

        debugInformation class qualifiedClass procedure qualifiedProcedure this
        if {![info exists class]} return                                     ;# no checking can be done outside of a class namespace
        set array [uplevel [list namespace which -variable $array]]                                     ;# determine array full name
        if {![info exists procedure]} {                                                                  ;# inside a class namespace
            if {[string compare $array ::${qualifiedClass}::]!=0} {           ;# compare with empty named array fully qualified name
                # trace command error message is automatically prepended and indicates operation
                error "class access violation in class $qualifiedClass namespace"
            }
            return                                                                                                           ;# done
        }
        if {[string compare $qualifiedProcedure ::stooop::copy]==0} return                         ;# ignore internal copy procedure
        if {[string compare $array ::${qualifiedClass}::]!=0} {               ;# compare with empty named array fully qualified name
            # trace command error message is automatically prepended and indicates operation
            error "class access violation in procedure $qualifiedProcedure"
        }
        if {![info exists this]} return                                             ;# static procedure, all objects can be accessed
        if {![info exists identifier]} return                                                 ;# static data members can be accessed
        if {$this!=$identifier} {                                                 ;# check that accessed data belongs to this object
            error "object $identifier access violation in procedure $qualifiedProcedure acting on object $this"
        }
    }

    # gather accessed data member information, perform substitutions and output to trace channel
    _proc ::stooop::traceData {array name operation} {
        variable traceDataChannel
        variable traceDataFormat

        scan $name %u,%s identifier member
        if {[info exists member]&&([string compare $member _derived]==0)} return                ;# ignore internally defined members

        # ignore internal destruction
        if {![catch {lindex [info level -1] 0} procedure]&&([string compare ::stooop::deleteObject $procedure]==0)} return
        set class {}                                                                               ;# in case we are outside a class
        set qualifiedClass {}
        set procedure {}                                                                 ;# in case we are outside a class procedure
        set qualifiedProcedure {}

        debugInformation class qualifiedClass procedure qualifiedProcedure this
        set text $traceDataFormat
        regsub -all %C $text $qualifiedClass text                                                      ;# fully qualified class name
        regsub -all %c $text $class text
        if {[info exists member]} {
            regsub -all %m $text $member text
        } else {
            regsub -all %m $text $name text                                                                         ;# static member
        }
        regsub -all %P $text $qualifiedProcedure text                                              ;# fully qualified procedure name
        regsub -all %p $text $procedure text
        # fully qualified array name with global qualifiers stripped
        regsub -all %A $text [string trimleft [uplevel [list namespace which -variable $array]] :] text
        if {[info exists this]} {                                                                            ;# non static procedure
            regsub -all %O $text $this text
        } else {                                                                                                 ;# static procedure
            regsub -all %O $text {} text
        }
        array set string {r read w write u unset}
        regsub -all %o $text $string($operation) text
        if {[string compare $operation u]==0} {
            regsub -all %v $text {} text                                                                  ;# no value when unsetting
        } else {
            regsub -all %v $text [uplevel set ${array}($name)] text
        }
        puts $traceDataChannel $text
    }
}
