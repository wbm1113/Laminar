class export
{
    createBlankCanvas() {
        if ! isObject(this.canvas) {
            this.canvas := new layeredWindow("export")
            this.canvas.create()
            r := bgLayer.window
            this.canvas.window.setDimensions(r.x, r.y, r.w, r.h)
            this.canvas.getCanvas()
        }
        this.canvas.clear()
        this.canvas.setBackground("white")
    }

    renderLines() {
        for i, s in grid.shapes
            for j, l in s.linesOriginatingFrom
                l.draw(this.canvas)
    }

    renderShapes() {
        for i, s in grid.shapes {
            if (s.isLineAnchor)
                continue
            s.render(this.canvas)
            (s.bitmap) ? s.renderImage(this.canvas)
        }
    }

    renderText() {
        tlBmp := new exBitmap()
        tlHandle := tlBmp.createFromHwnd(textLayer.hwnd)
        tlBmp.handle := tlHandle

        for i, s in grid.shapes {
            if (s.text = "")
                continue
            if (s.container.visible = 0)
                continue
            t := textLayer.ctrls[s.alias "text"]
            this.canvas.drawBitmap(tlBmp.handle
                                 , t.x, t.y, t.w, t.h
                                 , t.x, t.y, t.w, t.h)
        }

        tlBmp.remove()
    }

    call() {
        errorLevel := 0
        fileSelectFile, outPath, s, % a_desktop, Export Chart as Image, *.jpg
        if (errorLevel)
            return

        this.createBlankCanvas()
        this.renderLines()
        this.renderShapes()
        this.renderText()

        b := new exBitmap()
        b.handle := b.createFromDib(this.canvas.bitmap)
        b.save(outPath ".jpg")
    }
}