class tvCtrl extends ctrl
{
    items := object()
    type := "treeView"

    __call(method, params*) {
        gui, % this.parent.hwnd ":default"
    }

    add(t) {
        this.items[t] := new tvItem(t)
        return this.items[t]
    }

    delete() {
        tv_delete()
    }
}

class tvItem
{
    items := object()
    type := "tvItem"

    __new(t, parent = 0) {
        this.t := t
        this.handle := parent ? tv_add(t, parent, "expand") : tv_add(t,, "expand")
    }

    add(t) {
        this.items[t] := new tvItem(t, this.handle)
        return this.items[t]
    }
}