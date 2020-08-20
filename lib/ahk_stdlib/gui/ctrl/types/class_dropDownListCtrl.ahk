class dropDownListCtrl extends ctrl
{
    static type := "dropDownList"

    eventListener() {
        for i, e in this.events
            e.call()
    }
}