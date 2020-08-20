/* 
    sample usage:

    guiMenu := new guiMenu(parentGuiObj)

    guiMenu.add("File").add("Save", objBindMethod(someClass, "save"))
                       .add("Open")

    guiMenu.add("Edit").add("Copy`tCtrl+C")
                       .add("Paste`tCtrl+P")
    
    guiMenu.attach()

    guiMenu.menus["file"].menus["save"].disable()
*/

class guiMenu extends menu_base
{
    menus_backend := []
    menus := object()

    __new(parent) { 
        this.parent := parent
        this.alias := this.parent.alias "menu"
    }
    
    add(menuName) {
        m := new headerMenu(this, menuName)
        this.menus_backend.push(m)
        this.menus[menuName] := m
        return m
    }

    attach() {
        for i, headerMenu in this.menus_backend {
            for j, menuItem in headerMenu.menus_backend {
                if menuItem.menus_backend[1] 
                    for k, subMenuItem in menuItem.menus_backend
                        subMenuItem.implement()
                menuItem.implement()
            }
            headerMenu.implement()
        }
        gui, % this.parent.cmd("menu"), % this.alias
        return this
    }
}

class headerMenu extends menu_base
{
    menus_backend := []
    menus := object()

    __new(parent, alias) {
        this.parent := parent
        this.alias := alias
    }

    add(menuName, boundMethod = 0) {
        if (menuName = "separator") {
            m := new menuItem(this, "separator", boundMethod)
            this.menus_backend.push(m)
            this.menus[menuName] := m
        } else {
            m := new menuItem(this, menuName, boundMethod)
            this.menus_backend.push(m)
            this.menus[menuName] := m
        }
        if (boundMethod = "subMenu") {
            return m
        }
            
        return this
    }
    
    implement() {
        menu, % this.parent.alias, add, % this.alias, % ":" this.alias
    }
}

class menuItem extends menu_base
{
    menus_backend := []
    menus := object()

    __new(parent, alias, boundMethod) {
        this.parent := parent
        this.alias := alias
        this.boundMethod := boundMethod
    }

    add(menuName, boundMethod = 0, returnParent = 0) {
        if (menuName = "separator") {
            m := new subMenuItem(this, "separator", boundMethod)
            this.menus_backend.push(m)
            this.menus[menuName] := m
        } else {
            m := new subMenuItem(this, menuName, boundMethod)
            this.menus_backend.push(m)
            this.menus[menuName] := m
        }

        if (returnParent)
            return this.parent
        return this
    }
    
    implement() {
        if this.alias = "separator" {
            menu, % this.parent.alias, add
            return
        }

        if ! isObject(this.boundMethod) {
            menu, % this.parent.alias, add, % this.alias, % ":" this.alias
            return
        }

        b := ! this.boundMethod ? func("tempMenuHandler").bind() : this.boundMethod
        menu, % this.parent.alias, add, % this.alias, % b
    }
}

class subMenuItem extends menu_base
{
    menus := object()

    __new(parent, alias, boundMethod) {
        this.parent := parent
        this.alias := alias
        this.boundMethod := boundMethod
    }
    
    implement() {
        if this.alias = "separator" {
            menu, % this.parent.alias, add
        } else {
            b := ! this.boundMethod ? func("tempMenuHandler").bind() : this.boundMethod
            menu, % this.parent.alias, add, % this.alias, % b
        }
    }
}

class menu_base
{
    enable() {
        menu, % this.parent.alias, enable, % this.alias
        return this.parent
    }

    disable() {
        menu, % this.parent.alias, disable, % this.alias
        return this.parent
    }

    check() {
        menu, % this.parent.alias, check, % this.alias
        return this.parent
    }

    uncheck() {
        menu, % this.parent.alias, uncheck, % this.alias
        return this.parent
    }

    setColor(colorID = "") {
        colorID := layeredWindow.lookupColorByAlias(colorID, 1)
        msgbox % this.alias
        menu, % this.alias, color, % colorID, Single
    }
}

tempMenuHandler(menuItem, pos, menuName) { ;// ahk throws an exception by default when you don't assign a label.  it's really annoying.
    MsgBox No function assigned to '%menuItem%' in '%menuName%.' ;// this lets you set up and test menus without having to make a ton of labels first
}