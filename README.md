# preflight-manager-for-ElectricFlow
Application should be able configure setup file before preflight on Electric Flow (by company Electric Cloud)
In few words it is simple editing file by GUI application
Application should be able remember story of preflights
Application should be able invokes preflights by just edited values  , and  to show state from Electric Flow - was preflight started , what is ID of build and so on.

# For creation UI used:
   tcl/Tk 8.6
# Required packages :
   tDom and Tk 

# Platforms:
Expected that should work on Linux and MacOs - but development continue on Windows 8
Last step to convert tcl file to executable for 3 platforms

# How to use :
Main file preflight.tcl
command line : wish /path_to/preflight.tcl /path_to/xml.xml
or invoke :    tclsh /path_to/exe.tcl
another files - files for creating tree from xml file - just in design