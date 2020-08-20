class cursor
{
    static cursorDescriptions := { "helpArrow"         : 32512
                                 , "iBeam"             : 32513
                                 , "wait"              : 32514 
                                 , "cross"             : 32515 
                                 , "upArrow"           : 32516
                                 , "resizeUpLeft"      : 32642 
                                 , "resizeUpRight"     : 32643
                                 , "resizeSideToSide"  : 32644 
                                 , "resizeUpDown"      : 32645
                                 , "pan"               : 32646 
                                 , "no"                : 32648
                                 , "fingerPoint"       : 32649
                                 , "mouseWait"         : 32650 }
    static isDefault := 1
    static lastSetCursor := ""
    static lastHc := 32512

    reset(override = 0) {
        if this.isDefault and ! override
            return
        this.lastSetCursor := ""
        , this.isDefault := 1
        , SPI_SETcs := 0x57
        dllCall("SystemParametersInfo"
              , "int", SPI_SETcs
              , "int", 0
              , "int", 0
              , "int", 0)
    }

    set(cursor)
    {
        if this.lastSetCursor = cursor
            return
        (this.isDefault = 0) ? this.reset()
        this.isDefault := 0
        c := this.cursorDescriptions[cursor]
        hc := dllCall("LoadCursor"
                     , "uint", 0
                     , "int", c)
        dllCall("SetSystemCursor"
                , "uint", hc ;// cursor that replaces
                , "int", 32512) ;// cursor that gets replaced
        this.lastSetCursor := cursor
        this.lastHc := hc
    }


    setAll(cursor)
    {
        this.isDefault := 0
        for a, h in this.cursorDescriptions ;// i should be shot dead in the street for this
            dllCall("SetSystemCursor"
                    , "uint", dllCall("CopyImage"
                                    , "uint", dllCall("CopyImage"
                                                    , "uint", dllCall("LoadCursor"
                                                                    , "uint", 0
                                                                    , "int", this.cursorDescriptions[cursor])
                                                    , "uint", 0x2
                                                    , "int", 0
                                                    , "int", 0
                                                    , "uint", 0)
                                    , "uint", 0x2
                                    , "int", 0
                                    , "int", 0
                                    , "int", 0)
                    , "int", h)
    }
}