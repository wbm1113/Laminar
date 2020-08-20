class bitmapString
{
    toString(bitmap) {
        critical, on

        bitmap := new exBitmap().import(bitmap)
        w := bitmap.w
        h := bitmap.h

        pixels := w * h
        bytesPerChar := a_isUnicode ? 2 : 1
        bytes := pixels * bytesPerChar + bytesPerChar
        bmpData := 0
        stride := 0
        scan0 := 0
        bmpDataOut := 0
        r := 0
        varSetCapacity(bmpData, bytes, 0)

        varSetCapacity(r, 16)
        numPut(0, r, 0, "int")
        numPut(0, r, 4, "int")
        numPut(w, r, 8, "int")
        numPut(h, r, 12, "int")
        varSetCapacity(bmpDataOut, 32, 0)
        dllCall("gdiplus\GdipBitmapLockBits"
              , "ptr", bitmap.handle
              , "ptr", &r
              , "uint", 3
              , "int", 0x26200a
              , "ptr", &bmpDataOut)
        stride := numGet(bmpDataOut, 8, "int")
        scan0 := numGet(bmpDataOut, 16, "ptr")

        setFormat.hex()
        z := 0
        loop % h {
            b_index := a_index
            loop % w {
                colorValue := numGet(scan0 + 0, ((a_index - 1) * 4) + ((b_index - 1) * stride), "uint")
                if (colorValue = lastColorValue) {
                    z++
                    continue
                }
                if (z > 0)
                    setFormat.decimal()
                    , bmpData .= ",z" z 
                    , setFormat.hex()
                    , bmpData .= "," colorValue
                else bmpData .= "," colorValue
                z := 0
                lastColorValue := colorValue
            }
        }

        if (z > 0)
            setFormat.decimal()
            , bmpData .= ",z" z 
            , setFormat.hex()
            , bmpData .= "," colorValue

        bmpData := strReplace(bmpData, "0xff")
        bmpData := subStr(bmpData, 2)

        dllCall("gdiplus\GdipBitmapUnlockBits"
              , "ptr", bitmap.handle
              , "ptr", &bmpDataOut)

        critical, off                
        setFormat.decimal()
        return bmpData
    }

    splitIndex(i, w) {
        x := mod(i, w)
        return [x, (i - x) // w]
    }

    toBitmap(string, w, h) {
        critical, on

        area := w * h

        bitmap := new exBitmap().create(w, h)

        varSetCapacity(r, 16)
        numPut(0, r, 0, "int")
        numPut(0, r, 4, "int")
        numPut(w, r, 8, "int")
        numPut(h, r, 12, "int")
        varSetCapacity(bmpDataOut, 32, 0)
        dllCall("gdiplus\GdipBitmapLockBits"
              , "ptr", bitmap.handle
              , "ptr", &r
              , "uint", 3
              , "int", 0x26200a
              , "ptr", &bmpDataOut)
        stride := numGet(bmpDataOut, 8, "int")
        scan0 := numGet(bmpDataOut, 16, "ptr")
        
        i := 0
        loop, parse, string, `, 
        {   
            if (i >= area)
                break

            colorID := a_loopField

            if inStr(colorID, "z") {
                loop % strReplace(colorID, "z") {
                    xy := this.splitIndex(i, w)
                    numPut(lastColorID, scan0 + 0, (xy[1] * 4) + (xy[2] * stride), "uint")
                    i++
                    if (i >= area)
                        break
                }
                continue
            }

            colorID := "0xff" a_loopField
            , xy := this.splitIndex(i, w)
            , numPut(colorID, scan0 + 0, (xy[1] * 4) + (xy[2] * stride), "uint")
            , i++
            , lastColorID := colorID
        }

        dllCall("gdiplus\GdipBitmapUnlockBits"
              , "ptr", bitmap.handle
              , "ptr", &bmpDataOut)

        critical, off
        return bitmap.handle
    }
}