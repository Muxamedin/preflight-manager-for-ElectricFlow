puts [pwd]
set curdir [pwd]
set scr [file join $curdir browser.tcl] 
set xml [file join $curdir xml.xml] 
set scrTree [file join $curdir browserTree.tcl] 
set scrTree2 [file join $curdir browserTree2.tcl] 
set scrTree3 [file join $curdir XMLTK.tcl] 
set app [file join $curdir preflight.tcl] 
exec wish $app $xml
exit