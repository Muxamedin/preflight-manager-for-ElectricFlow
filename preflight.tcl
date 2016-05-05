# Copyright (c) 2016 BMikhail Solutions
# Package for ElectricFlow preflight 

# Parser for array to get information about devision. Can 
# Arguments:
# 			xmlArr - name of array with data from xml
# 			nName  - name of node : can be  Server, Scm or Procedures
# Return:
# 			no
# Result will be added to xmlArr(nName)			

proc getInformationByNodeName {xmlArr nName } {
	upvar #0 $xmlArr xmlarr 
    set obj_id [ $xmlarr(root) getElementsByTagName $nName ]
    set obj_child_list [$obj_id childNodes]
	set obj_pairs_list {}
	foreach item $obj_child_list {
		set nodeItem [$item childNodes] 
		if { [llength $nodeItem] == 1  &&  [ [lindex $nodeItem 0] nodeName] == "#text" } {
			lappend obj_pairs_list [$item nodeName] [ [lindex $nodeItem 0] nodeValue]
		} 
   }
	set xmlarr($nName) $obj_pairs_list
}

proc getScm    { name_gArr } { ::getInformationByNodeName $name_gArr scm   }
proc getServer { name_gArr } { ::getInformationByNodeName $name_gArr server}

# for a procedure we has enother structure 
proc getProcedure { name_gArr } {
	upvar #0 $name_gArr xmlarr 
	set obj_id [ $xmlarr(root) getElementsByTagName "procedure" ]
	set obj_child_list [$obj_id childNodes]
	set obj_procedure_list {}
	set obj_parametr_list {}
	# 
	foreach item $obj_child_list {
		set nodeItem [$item childNodes] 
		if { [llength $nodeItem] == 1  &&  [ [lindex $nodeItem 0] nodeName] == "#text" } {
			lappend obj_procedure_list [$item nodeName] [ [lindex $nodeItem 0] nodeValue]
		}
		if { [$item nodeName] == "parameter" } {
			set name  [ $item getElementsByTagName "name"  ]
			set value [ $item getElementsByTagName "value" ]
			lappend obj_parametr_list [ [$name childNodes] nodeValue ] [ [$value childNodes] nodeValue]
		}
   }
   set xmlarr(procedure) $obj_procedure_list 
   set xmlarr(procedure,parametr) $obj_parametr_list 
}

proc RunBuild {} {
	tk_messageBox -message "Here I going to run preflight"
}
proc SavePreflightFile {} {
	tk_messageBox -message "Save to file - if setting was changed"
	parray ::txtArr
}


# main procedure
# tk interactive pane
# View of xml document special format for preflight
# On View you can see or change fields - which can change setting for custom preflight

proc View {} {
	getPreflightStructure
	global xmlArr
	global txtArr
	package require Tk
	wm title . "Preflight"
	wm resizable . 0 0
	# frame container with white bg, for all frames
	set bottom_frame [frame  .bottom -bg  white ]
	pack $bottom_frame  -fill x -side top -expand 1
	set scm_layer [labelframe $bottom_frame.scm -bg white -text scm -pady 2 -fg blue ]
	grid $scm_layer  
	# add fields with info for scm
	foreach {name value} $xmlArr(scm) {
		set txtArr(scm$name) $value
		set label_a [label  $scm_layer.$name -text "$name" -bg white]
		#set $value $value
		set entry_a [entry  $scm_layer.$name$value -width 20 -relief sunken -textvariable txtArr(scm$name)  -width 60]
			grid $label_a $entry_a  
	}
	set server_layer [labelframe $bottom_frame.server -bg white -text server -pady 2 -fg blue ]
	grid $server_layer
	# add fields with info for server
	foreach {name value} $xmlArr(server) {
		set txtArr(server$name) $value
		set label_a [label  $server_layer.$name -text "$name" -bg white]
		#set $value $value
		set entry_a [entry  $server_layer.$name$value -width 20 -relief sunken -textvariable txtArr(server$name) -width 59]
		if {  [string match $name "password"] } { $entry_a config -show *}
		grid $label_a $entry_a  
	}
	set procedure_layer [labelframe $bottom_frame.procedure -bg white -text procedure   -pady 2 -fg blue ]
	grid $procedure_layer
	foreach {name value} $xmlArr(procedure) {
		set txtArr(procedure$name) $value
		set label_a [label  $procedure_layer.$name -text "$name" -bg white ]
		#set $value $value
		set entry_a [entry  $procedure_layer.$name$value -width 20 -relief sunken -textvariable txtArr(procedure$name) -width 45 ]
		grid $label_a $entry_a  
	}
	foreach {name value} $xmlArr(procedure,parametr) {
		if { ($value == 1 ) || ($value == 0)} {
			continue
		}
		set txtArr(procedure_parametr$name) $value
		set label_a [label  $procedure_layer.$name -text "$name"  -bg white]
		set entry_a [entry  $procedure_layer.$name$value -width 20 -relief sunken -textvariable txtArr(procedure_parametr$name) -width 45]	
		grid $label_a $entry_a
	}
	foreach {name value} $xmlArr(procedure,parametr) {
		if { ($value == 1 ) || ($value == 0)} {
			set txtArr(procedure_parametr$name) $value
			set label_a [label  $procedure_layer.$name -text "$name"  -bg white]
			set checkbox_a [checkbutton  $procedure_layer.$name$value -text "Choose for use option"  -variable txtArr(procedure_parametr$name) -bg white ]	
			grid $label_a $checkbox_a			
		} else {
			continue
		}
	}
	# buttons
	set buttons_layer [labelframe $bottom_frame.buttons -bg white -text "manage preflight"   -pady 2 -fg blue ]
	grid $buttons_layer -sticky ew
	set cancel_b [button  $buttons_layer.cancel_b -text "Cancel" -bg white -command { exit } ]
	set build_b  [button  $buttons_layer.build_b  -text "Build"  -bg white -command RunBuild ]
	set save_b   [button  $buttons_layer.save_b   -text "Save"   -bg white -command SavePreflightFile ]
	grid $cancel_b $build_b $save_b  -padx 2
}

# save to XML 
proc SaveXML { {path {} } } {
}

proc init {} {
	#work with file \
	reads it and return data
	
	set file_name [lindex $::argv 0]
	set  fp [open $file_name r ]
	fconfigure $fp -encoding utf-8
	set xml [read  $fp]
	close          $fp
	# puts $xml
	return $xml
}

# procedure for reading xml in dom model and then  get information about every of nodes
# Arguments:
# 			no
# Return:
# 			no
# 
proc getPreflightStructure {} {
	if  { [catch { package require tdom }] } { 
		puts "There are no package  tdom. Exit"
		exit 1
	}
	set xml [ init ]
	# parcer for xml - create DOM on doc 
	dom parse  $xml doc

	# get root element for doc
	$doc documentElement root
	
	# work with data structure 
	global xmlArr
	array set xmlArr [ list doc $doc root $root ]
	
	getScm xmlArr
	getServer xmlArr
	getProcedure xmlArr

}

View
