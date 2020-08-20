class textLayerEffects
{
    static fading := 0

    fadeIn() {
        critical, on
        eventMgr.suspended := 1
        this.fading := 1
        loop 5 {
            winSet, transColor, % "white " . 51 * a_index, % textLayer.window.a_hwnd
            sleep.call(3)
        }
        this.fading := 0
        eventMgr.suspended := 0
        critical, off
    }

    fadeOut() {
        critical, on
        eventMgr.suspended := 1
        this.fading := 1
        loop 5 {
            winSet, transColor, % "white " . 255 - 51 * a_index, % textLayer.window.a_hwnd
            sleep.call(3)
        }
        this.fading := 0
        eventMgr.suspended := 0
        critical, off
    }
}