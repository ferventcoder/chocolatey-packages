;WinWait("Spotify", "Spotify", 120)
ProcessClose("spotify.exe")
;If ControlClick("Exit Dropbox", "Are you sure", "[CLASS:Button; INSTANCE:1]")=0 Then
;	MsgBox(0, "Autoit Dropbox install script", "Something's wrong: The ControlClick used to confirm the ;'are you sure' dialog returned failure - proceeding with file copy", 5)
;EndIf
 
;Installation complete
Exit