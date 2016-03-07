set            fp [open [file join [lindex $argv 0]]]
fconfigure     $fp -encoding utf-8
set xml [read  $fp]
close          $fp
package require tdom
# parcer for xml - create DOM on doc 
dom parse  $xml doc
#get root element for doc
$doc documentElement root

if { [ $root hasChildNodes ] } {
	foreach item [ $root childNodes ] {
		set xmlArr($item) [ $item nodeName ]
	}
} else {
	puts "Empty document"
}

set childList [$root childNodes]

