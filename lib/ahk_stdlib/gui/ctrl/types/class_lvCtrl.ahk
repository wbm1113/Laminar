class lv extends ctrl
{
    __new(params*) {
        base.__new(params*)
        this.selectedRow := 0
        this.selectedIndex := 0
        this.clickEvents := []
    }

    __call(method, params*) { ;// points threads to the correct gui before executing each command
        gui, % this.p.hwnd ":default"
    }

    add(options, fields*) {
        lv_add(options, fields*)
        return this
    }

    setIndexCol(col) { 
        this.indexCol := col
        return this
    }

    setColWidth(col, w) { 
        lv_modifyCol(col, w)
        return this
    }

    setColAlign(col, alignment) { 
        lv_modifyCol(col, alignment)
        return this
    }

    select(row) { 
        lv_modify(row, "select")
        lv_modify(row, "focus")
        return this
    }

    getVal(row, col) { 
        lv_getText(retVal, row, col)
        return retVal
    }

    addClickEvent(clickEvent) {
        this.clickEvents.push(clickEvent)
        return this
    }
    
    onClick(selectedRow) {
        this.selectedRow := selectedRow
        this.selectedIndex := this.getVal(selectedRow, this.indexCol)
        for i, clickEvent in this.clickEvents
            clickEvent.call()
    }
}