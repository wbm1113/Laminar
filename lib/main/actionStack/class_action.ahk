class stackAction
{
    undoMethods := []
    redoMethods := []

    __new(alias) {
        this.alias := alias
    }

    addUndoAction(objCriteria, method) {
        m := new boundMethod(objCriteria, method)
        this.undoMethods.push(m)
        return m
    }

    addRedoAction(objCriteria, method) {
        m := new boundMethod(objCriteria, method)
        this.redoMethods.push(m)
        return m
    }

    undo() {
        for i, m in this.undoMethods
            m.bind().call()
    }

    redo() {
        for i, m in this.redoMethods
            m.bind().call()
    }
}

class boundMethod
{
    params := 0

    __new(objCriteria, method) {
        this.objCriteria := objCriteria
        this.alias := grid.extractAlias(objCriteria)
        this.method := method
    }

    setParams(params*) {
        this.params := params
    }

    bind() {
        o := isObject(this.objCriteria) ? this.objCriteria : grid.updateReference(this.objCriteria)

        if ! isObject(o)
            throw exception("Invalid object passed to class_boundMethod", -2, "`r`nalias: " this.alias "`r`nmethod: " this.method "`r`no: " o "`r`n" "o.alias: " o.alias "`r`n" "o.alias.string: " o.alias.string)
        
        return this.params ? objBindMethod(o, this.method, this.params*) : objBindMethod(o, this.method)
    }
}