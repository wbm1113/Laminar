class colorMath extends protoClass
{
    separateARGB(ARGB) {
        setFormat.hex()
        retVal := object()
        retVal.a := "0x" subStr(ARGB, 3, 2)
        retVal.r := "0x" subStr(ARGB, 5, 2)
        retVal.g := "0x" subStr(ARGB, 7, 2)
        retVal.b := "0x" subStr(ARGB, 9, 2)
        return retVal
    }

    reassembleARGB(colorObject) {
        return "0x"
             . strReplace(colorObject.a, "0x")
             . strReplace(colorObject.r, "0x")
             . strReplace(colorObject.g, "0x")
             . strReplace(colorObject.b, "0x")
    }

    darken(color, intensity) {
        color := this.separateARGB(color)
        setFormat.decimal()

        color.r -= intensity
        color.g -= intensity
        color.b -= intensity
        
        color.r := color.r < 0 ? 0 : color.r
        color.r := color.r > 255 ? 255 : color.r
        color.g := color.g < 0 ? 0 : color.g
        color.g := color.g > 255 ? 255 : color.g
        color.b := color.b < 0 ? 0 : color.b
        color.b := color.b > 255 ? 255 : color.b

        setFormat.hex()
        color.r += 0
        color.g += 0
        color.b += 0
        return this.reassembleARGB(color)
    }
}