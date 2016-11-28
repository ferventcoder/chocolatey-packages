if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

SetTitleMatchMode, 2

WinWait, Dropbox Setup ahk_class Qt5QWindowIcon, , 60
Sleep, 1000
WinActivate
IfWinActive
Send, !{F4}