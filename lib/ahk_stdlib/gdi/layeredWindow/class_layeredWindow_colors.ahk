class layeredWindow_colors extends gui
{
    static colors := {white:            0xffffffff
                    , eggShellWhite:    0xfff7f9f8
                    , transWhite:       0x96ffffff
                    , lighten:          0x15ffffff

                    , black:            0xff000000
                    , transBlack:       0x96000000
                    , darken:           0x12000000

                    , mutedGray:        0xfff5f5f5
                    , lightGray:        0xfff2f2f2
                    , lightMediumGray:  0xffd4d4d4
                    , mediumGray:       0xff919191
                    , darkGray:         0xff878787

                    , offRed:           0xffe31212
                    , mutedRed:         0xfff5dada
                    
                    , offOrange:        0xffe0a755
                    , mutedOrange:      0xfff5e3d5

                    , hazelnut:         0xff87520c

                    , highlightYellow:  0xfffff426
                    , mutedYellow:      0xfffafad9

                    , offGreen:         0xff12db22
                    , mutedGreen:       0xffdcf2d8
                    , lightGreen:       0xff2de388
                    , forestGreen:      0xff0f7d2c
                    , solidGreen:       0xff00b50e
                    , vibrantGreen:     0xff3fd84a
                    , lightGreen:       0xffebffe8
                    
                    , aqua:             0xff00bf96

                    , faintBlue:        0xffdae8f5
                    , lightBlue:        0xffb1d3f2
                    , blue:             0xff456dff
                    , mutedBlue:        0xffdadbf5
                    , vibrantBlue:      0xff4a4eff

                    , mutedPurple:      0xffead8f0
                    , vibrantPurple:    0xffff4aff

                    , invisible:        0x01ffffff
                    , clickThrough:     0x00ffffff}

    lookupColorByAlias(colorAlias, RGB = 0) {
        setFormat.hex()
        for ca, c in this.colors
            if (colorAlias = ca)
                return RGB ? strReplace(c, "0xff") : c
    }
}