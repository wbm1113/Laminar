onMessage(0x6, "onActivate")
eventMgr.add("wm_activate")
onActivate(wParam, lParam, msg, hwnd) {
    eventMgr.events["wm_activate"].invoke(wParam, lParam)
}

onMessage(0x200, "onMouseMove")
eventMgr.add("mouseMove")
eventMgr.events["mouseMove"].throttle := 10
onMouseMove(wParam, lParam, msg, hwnd) {
    eventMgr.events["mouseMove"].invoke()
}

onMessage(0x00A0, "onNCmouseMove")
eventMgr.add("NCmouseMove")
eventMgr.events["NCmouseMove"].throttle := 10
onNCmouseMove(wParam, lParam, msg, hwnd) {
    eventMgr.events["NCmouseMove"].invoke()
}

onMessage(0x02A2, "onNCmouseLeave")
eventManager.add("NCmouseLeave")
onNCmouseLeave(wParam, lParam, msg, hwnd) {
    eventMgr.events["NCmouseLeave"].invoke()
}

onMessage(0x0201, "onLeftClick")
eventMgr.add("leftClick")
global weird_leftClick_behavior_workaround_lParam := -1
onLeftClick(wParam, lParam, msg, hwnd) {
    critical, on
    (lParam != weird_leftClick_behavior_workaround_lParam) ? eventMgr.events["leftClick"].invoke()
    weird_leftClick_behavior_workaround_lParam := lParam
    critical, off
}

onMessage(0x0202, "onLeftClickRelease")
eventMgr.add("leftClickRelease")
onLeftClickRelease(wParam, lParam, msg, hwnd) {
    critical, on
    eventMgr.events["leftClickRelease"].invoke()
    weird_leftClick_behavior_workaround_lParam := -1
    critical, off
}

onMessage(0x0203, "onDoubleLeftClick")
eventMgr.add("doubleLeftClick")
onDoubleLeftClick(wParam, lParam, msg, hwnd) {
    critical, on
    eventMgr.events["doubleLeftClick"].invoke()
    critical, off
}

onMessage(0x204, "onRightClick")
eventMgr.add("rightClick")
onRightClick(wParam, lParam, msg, hwnd) {
    critical, on
    eventMgr.events["rightClick"].invoke()
    critical, off
}