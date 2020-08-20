#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#singleInstance, force

setSystemCursor("iBeam")

return

SetSystemCursor(cursor)
{

    static cursorDescriptions := { "helpArrow"         : 32512
                                 , "iBeam"             : 32513
                                 , "wait"              : 32514 
                                 , "cross"             : 32515 
                                 , "upArrow"           : 32516
                                 , "resizeUpLeft"      : 32642 
                                 , "resizeUpRight"     : 32643
                                 , "resizeSideToSide"  : 32644 
                                 , "resizeUpDown"      : 32645
                                 , "pan"               : 32646 
                                 , "no"                : 32648
                                 , "fingerPoint"       : 32649
                                 , "mouseWait"         : 32650 }	
    cursorID := cursorDescriptions[cursor]
    cursorHandle := dllCall("LoadCursor", "uint", 0, "int", cursorDescriptions[cursor])

    for a, h in cursorDescriptions
    {
        CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )
        a := DllCall( "CopyImage", Uint,CursorHandle, Uint,0x2, Int,0, Int,0, Uint,0 )		
        CursorHandle := DllCall( "CopyImage", Uint, a, Uint,0x2, Int,0, Int,0, Int,0 )
        DllCall( "SetSystemCursor", Uint,CursorHandle, Int,h )
    }
	
}