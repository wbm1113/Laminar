#NoEnv
#SingleInstance, Force
#KeyHistory 0
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
DetectHiddenWindows, Off
DetectHiddenText, Off
SetBatchLines, -1
ListLines Off
Process, Priority, , A
SetKeyDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, Menu, Screen
CoordMode, ToolTip, Screen

global prepend := "lib\ahk_stdlib\"

copyFullIncludeListToClipboard() {
    c := ""
    loop, files, *.ahk, r
    {
        if (a_loopFileName = "index.ahk" 
            or a_loopFileName = "hotkeys.ahk" 
                or inStr(a_loopFilePath, "test\") 
                    or inStr(a_loopFilePath, "worker_"))
                        continue
        str := "#include " prepend a_loopfilepath
        c := c str "`r`n"
    }
    clipboard := c
}

copyFullIncludeListToClipboard()

exitApp