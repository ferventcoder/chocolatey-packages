Opt('WinDetectHiddenText', 1)
;Path and filename of the installer executable
$APPTOINSTALL="""" & $CmdLine[1] & """"

Run($APPTOINSTALL & " /SILENT", "", @SW_HIDE)
If @error <> 0  Then 
	MsgBox(0, "Run failed", "The ""Run"" command failed for " & $APPTOINSTALL & " /SILENT - exiting", 5)
	Exit
EndIf
 
;Wait for the installation to complete and the fluffyapp account entry dialog to appear, close the window
WinWait("FluffyApp","Email",45)
WinActivate("FluffyApp")
WinClose("FluffyApp")
 
;Installation complete
Exit