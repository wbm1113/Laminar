#NoEnv
#SingleInstance, Force
SetBatchLines, -1
ListLines Off
Process, Priority, , A
#include C:\Users\Ward\Desktop\ahk_stdlib\ui\class_mouse.ahk

dllCall("QueryPerformanceFrequency", "int64*", speedCounterFrequency)
dllCall("QueryPerformanceCounter", "int64*", speedCounterBefore)

;// ======== TESTING ZONE ================================

loop 1000
stuff := getaa()
, stuff[1] += 1
, stuff[2] += 2



;// ======== TESTING ZONE ================================

dllCall("QueryPerformanceCounter", "int64*", speedCounterAfter)
timer := (speedCounterAfter - speedCounterBefore) / speedCounterFrequency * 1000
tooltip % timer
exitApp

