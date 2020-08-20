class eventMgr
{
    static events := object()
    static suspended := 0

    add(alias) {
        e := new event(this, alias)
        this.events[alias] := e
        return e
    }

    enabled[] {
        set {
            for a, e in this.events
                e.enabled := value ? 1 : 0
        }
    }

    resetToDefault() {
        this.enabled := 0
        for a, e in this.events
            e.resetToDefault()
    }
}

class event
{
    _actions := object()
    _enabled := 1
    ignoreBlanketDisable := 0
    lParamCondition := ""
    defaultsDefined := 0

    __new(parent, alias) {
        this.parent := parent
        this.alias := alias
        this.throttle := 0
    }

    actions[action] {
        get {
            a := this._actions[action]
            return this._actions[action]
        }
        set {
            this._actions[action] := value
        }
    }

    enabled[] {
        get {
            return this._enabled
        }
        set {
            if (this.ignoreBlanketDisable) {
                if (value = 0) {
                    return
                } else if (value = -1) {
                    value := 0
                }
            }
            this._enabled := value
        }
    }

    addAction(alias, action) {
        this.actions[alias] := action
        return this
    }

    setDefault(defaults*) {
        this.defaults := []
        for i, d in defaults
            this.defaults.push(d)
        this.defaultsDefined := 1
        return this
    }

    invoke(wParam = "", lParam = "", msg = "", hwnd = "") {
        for i, a in this.sequence {
            if ! this.enabled or ! a or eventMgr.suspended
                return

            if (this.lParamCondition = "")
                returnCode := a.call()
            else if (this.lParamCondition = lParam)
                returnCode := a.call()
            else returnCode := 0

            if (returnCode = "")
                continue
            else if (returnCode = 0)
                return
        }

        if this.throttle
            sleep % this.throttle
    }

    swap(actionIndex, actionAlias = 0) { ;// replaces action at actionIndex with actionAlias
        if (actionAlias = 0)
            this.sequence.removeAt(actionIndex), this.sequenceNames.removeAt(actionIndex)
        else this.sequence[actionIndex] := this.actions[actionAlias], this.sequenceNames[actionIndex] := actionAlias
        return this
    }

    resetToDefault() {
        this.sequenceNames := []
        this.sequence := []
        for i, d in this.defaults
            this.sequence.push(this.actions[d]), this.sequenceNames.push(d)
        return this
    }
}