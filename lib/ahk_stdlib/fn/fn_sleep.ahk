class globalSleep
{
    call(interval = 2) { 
        dllCall("Winmm\timeBeginPeriod", "uInt", 3)
        dllCall("Sleep", "uInt", Interval)
        dllCall("Winmm\timeEndPeriod", "uInt", 3)  
    }
}

class sleep
{
    call(interval = 10) {
        sleep % interval
    }
}