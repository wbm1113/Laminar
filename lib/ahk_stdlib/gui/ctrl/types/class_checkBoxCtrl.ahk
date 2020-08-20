class checkBoxCtrl extends ctrl
{
    static type := "checkBox"

    eventListener() {
        for i, e in this.events
            e.call()
    }
}