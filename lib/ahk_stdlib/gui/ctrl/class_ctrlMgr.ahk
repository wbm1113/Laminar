class ctrlMgr
{
    static reservedKeys := ["__new", "add", "draw"]
    aliases := []

    __new(parent) {
        this.parent := parent
    }

    isReservedKey(alias) {
        for i, k in this.reservedKeys
            if (k = alias)
                return 1
        if alias.isInteger()
            return 1
        return 0
    }

    add(ctrlType, alias) {
        (this.isReservedKey(alias)) ? throw exception("Invalid control name", -1, alias)

        if (ctrlType = "text")
            this[alias] := new textCtrl(this.parent, alias)
        else if (ctrlType = "edit")
            this[alias] := new editCtrl(this.parent, alias)
        else if (ctrlType = "dropDownList")
            this[alias] := new dropDownListCtrl(this.parent, alias)
        else if (ctrlType = "button")
            this[alias] := new buttonCtrl(this.parent, alias)
        else if (ctrlType = "checkBox")
            this[alias] := new checkBoxCtrl(this.parent, alias)
        else if (ctrlType = "radio")
            this[alias] := new radioCtrl(this.parent, alias)
        else if (ctrlType = "tv")
            this[alias] := new tvCtrl(this.parent, alias)

        if ! isObject(this[alias])
            throw exception("Failed to create control", -1, alias " [" ctrlType "]")
           
        this.aliases.push(alias)
        return this[alias]
    }

    getLowestCtrl() {
        l := 0
        for i, a in this.aliases
            c := this[a]
            , k := c.y + c.h
            , l := l > k ? l : k
        return l
    }
}