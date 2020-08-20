#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#singleInstance, force

;setSystemCursor("wait")
;setSystemCursor("IDC_WAIT")

                      reset()

return

reset() {
    SPI_SETcs := 0x57
    dllCall("SystemParametersInfo"
            , uInt, SPI_SETcs
            , uInt, 0
            , uInt, 0
            , uInt, 0)
}

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
    cHandles := []
    for d, h in cursorDescriptions { 

        CursorHandle := DllCall("LoadCursor"
                                , "uint", 0
                                , "int", cursorID)

        cHandles.push(DllCall("CopyImage"
                    , "uint", CursorHandle
                    , "uint", 0x2
                    , "int", 0
                    , "int", 0
                    , "uint", 0))

        msgbox % cHandles[a_index]

        CursorHandle := DllCall("CopyImage"
                                , "uint", cHandles[a_index]
                                , "uint", 0x2
                                , "int", 0
                                , "int", 0
                                , "int", 0)

        DllCall("SetSystemCursor"
                , "uint", CursorHandle
                , "int", h)
    }



}