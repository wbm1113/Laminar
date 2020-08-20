class editCtrl extends ctrl
{
    static type := "edit"
    lastRows := 0
    
    eventListener() {
        for i, e in this.events
            e.call()
    }

    GetTextExtentPoint(sString, sFaceName, nHeight = 9, bBold = False, bItalic = False, bUnderline = False, bStrikeOut = False, nCharSet = 0)
    {   ;// thanks Sean
        hDC := DllCall("GetDC", "Uint", 0)
        nHeight := -DllCall("MulDiv", "int", nHeight, "int", DllCall("GetDeviceCaps", "Uint", hDC, "int", 90), "int", 72)

        hFont := DllCall("CreateFont", "int", nHeight, "int", 0, "int", 0, "int", 0, "int", 400 + 300 * bBold, "Uint", bItalic, "Uint", bUnderline, "Uint", bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", sFaceName)
        hFold := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

        DllCall("GetTextExtentPoint32", "Uint", hDC, "str", sString, "int", StrLen(sString), "int64P", nSize)

        DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
        DllCall("DeleteObject", "Uint", hFont)
        DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

        nWidth  := nSize & 0xFFFFFFFF
        nHeight := nSize >> 32 & 0xFFFFFFFF

        Return [nWidth, nHeight]
    }

    getLineCount() {
        controlGet, numberOfLines, lineCount,,, % this.a_hwnd
        this.numberOfLines := numberOfLines
        return numberOfLines
    }

    selectAll() {
        sendMessage, 0xB1, 0, -1,, % this.a_hwnd
    }

    moveCaretToEnd() {
        sendMessage, 0xB1, -2, -1,, % this.a_hwnd
        sendMessage, 0xB7,,,, % this.a_hwnd
    }
}