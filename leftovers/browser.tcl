 package require BWidget
 package require tdom

 proc recurseInsert {w node parent} {
    set name [$node nodeName]
    if {$name=="#text" || $name=="cdata"} {
        set text [$node nodeValue]
        set fill black
    } else {
        set text <$name
        foreach att [$node attributes] {
            catch {append text " $att=\"[$node getAttribute $att]\""}
        }
        append text >
        set fill blue
    }
    $w insert end $parent $node -text $text -fill $fill
    foreach child [$node childNodes] {recurseInsert $w $child $node}
 }
 set            fp [open [file join [lindex $argv 0]]]
 set xml [read $fp]
 close         $fp

 dom parse  $xml doc
 $doc documentElement root

 Tree .t -yscrollcommand ".y set"
 scrollbar .y -ori vert -command ".t yview"
 pack .y  -side right -fill y
 pack .t -side right -fill both -expand 1

 after 5 recurseInsert .t $root root