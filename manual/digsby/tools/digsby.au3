Opt('WinDetectHiddenText', 1)
;Path and filename of the installer executable
$APPTOINSTALL="""" & $CmdLine[1] & """"

; Run installer
Run($APPTOINSTALL & " /S", "", @SW_HIDE)
If @error <> 0  Then 
	MsgBox(0, "Run failed", "The ""Run"" command failed for " & $APPTOINSTALL & " /S - exiting", 5)
	Exit
EndIf
 
;Wait for the installation to complete and the dialog to appear, close the window
$DEFAULTWAITTIME=180
; This will shut all of your default browser windows. 
; $WINDOWNAME="Digsby = IM + Email + Social Networks"
; WinWait($WINDOWNAME,"",$DEFAULTWAITTIME)
; WinActivate($WINDOWNAME)
; WinClose($WINDOWNAME)

$WINDOWNAME="Register a Digsby Account"
WinWait($WINDOWNAME,"",$DEFAULTWAITTIME)
WinActivate($WINDOWNAME)
WinClose($WINDOWNAME)

$WINDOWNAME="Digsby Login"
WinWait($WINDOWNAME,"",$DEFAULTWAITTIME)
WinActivate($WINDOWNAME)
WinClose($WINDOWNAME)
 
;Installation complete
Exit