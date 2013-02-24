Opt('WinDetectHiddenText', 1)
;Path and filename of the installer executable
$DROPBOXINSTALLER="""" & $CmdLine[1] & """"

; Run Dropbox installer
Run($DROPBOXINSTALLER & " /S", "", @SW_HIDE)
If @error <> 0  Then 
	MsgBox(0, "Run failed", "The ""Run"" command failed for " & $DROPBOXINSTALLER & " /S - exiting", 5)
	Exit
EndIf
 
;Wait for the installation to complete and the Dropbox account entry dialog to appear, close the window
WinWait("Dropbox Setup", "I don't have a Dropbox account", 120)
WinActivate("Dropbox Setup", "I don't have a Dropbox account")
WinClose("Dropbox Setup", "I don't have a Dropbox account")
WinWait("Exit Dropbox", "Are you sure", 20)
If ControlClick("Exit Dropbox", "Are you sure", "[CLASS:Button; INSTANCE:1]")=0 Then
	MsgBox(0, "Autoit Dropbox install script", "Something's wrong: The ControlClick used to confirm the 'are you sure' dialog returned failure - proceeding with file copy", 5)
EndIf
 
;Installation complete
Exit