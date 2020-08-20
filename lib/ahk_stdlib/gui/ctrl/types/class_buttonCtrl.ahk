class buttonCtrl extends ctrl
{
    static type := "button"

    eventListener() {
        for i, e in this.events
            e.call()
    }
}