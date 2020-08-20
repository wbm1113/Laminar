#if gui.window.isActive() and grid.activeState = "default" or gui.window.isActive() and grid.activeState = "selecting" or gui.window.isActive() and grid.activeState = "multiSelecting"

^z::
    actionStack.undo()
    return

^y::
    actionStack.redo()
    return

^o::
    laminarData.open()
    return

^s::
    if (laminarData.saveCommandEnabled)
        laminarData.save()
    return

left::
up::
right::
down::
    menuActions.adjustShapePosition(a_thisLabel)
    return

x::
    gridState_connecting.getOrigShape()
    return

^c::
    gridState_copying.activate()
    return

delete::
    menuActions.delete()
    return

#if

#f1::
inspector.populate()
return

#f2::
inspector.init()
inspector.gui.show()
return