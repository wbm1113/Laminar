global lookupGuiByHwnd := {}
global guiEventRouter := {}

guiOnSize(hwnd, eventInfo, w, h) {
    guiEventRouter[hwnd].call(w, h)
}