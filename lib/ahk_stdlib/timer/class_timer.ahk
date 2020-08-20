class timer
{
    freq := 0
    counterBefore := 0
    counterAfter := 0

    __new(objBinding = 0, period = 0, maxElapsedTime = -1) {
        this.internalRoutine := objBindMethod(this, "routineCapsule")
        this.externalRoutine := objBinding
        this.period := period
        this.maxElapsedTime := maxElapsedTime
    }

    start() {
        dllCall("QueryPerformanceFrequency", "int64*", freq)
        this.freq := freq
        dllCall("QueryPerformanceCounter", "int64*", counterBefore)
        this.counterBefore := counterBefore
        if ! this.externalRoutine
            return
        routine := this.internalRoutine
        setTimer % routine, % this.period
    }

    routineCapsule() {
        this.externalRoutine.call()
        if this.maxElapsedTime > 0
            if this.getElapsedTime() > this.maxElapsedTime
                this.stop()
    }

    stop() {
        if this.externalRoutine() {
            routine := this.internalRoutine
            setTimer % routine, off
        }
        return this.getElapsedTime()
    }

    getElapsedTime() { ;// return value = time in ms
        dllCall("QueryPerformanceCounter", "int64*", counterAfter)
        return (counterAfter - this.counterBefore) / this.freq * 1000
    }
}