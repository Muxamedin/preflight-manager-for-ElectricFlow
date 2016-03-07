set            fp [open [file join [lindex $argv 0]]]
fconfigure     $fp -encoding utf-8
set xml [read  $fp]
close          $fp
package require tdom
# parcer for xml - create DOM on doc 
dom parse  $xml doc

# get root element for doc
$doc documentElement root

# create data structure 
array set xmlArr [ list doc $doc root $root ]


proc getSCM {root xmlArr } {

}
proc getServer {root xmlArr } {

}

proc getProcedure {root xmlArr } {

}

if { [ $root hasChildNodes ] } {
	foreach item [ $root childNodes ] {
		set xmlArr($item) [ $item nodeName ]
	}
} else {
	puts "Empty document"
}

set childList [$root childNodes]

