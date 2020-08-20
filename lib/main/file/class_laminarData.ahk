class laminarData
{
    path := ""
    working := 0
    _saveCommandEnabled := 1

    saveCommandEnabled[] {
        get {
            return this._saveCommandEnabled
        }
        set {
            if (this._saveCommandEnabled = value)
                return
            m := menu.menus["file"].menus["save`tctrl+s"]
            (value) ? m.enable() : m.disable()
            this._saveCommandEnabled := value
        }
    }

    reset() {
        actionStack.reset()
        grid.clear()
        shapeLayer.clear()
        lineLayer.clear()
    }

    setPath(outPath) {
        this.path := outPath ".ini"
        this.path := strReplace(this.path, ".ini.ini", ".ini")
        regExMatch(this.path, "(?<=\\)[^\\]+(?=\.ini)", fileName)
        this.fileName := strReplace(fileName, ".ini")
        gui.window.title := "Laminar - " this.fileName
    }

    save(saveAs = 0) {
        critical, on
        
        if (this.working)
            return
        
        if (! this.path or saveAs) {
            errorLevel := 0
            fileSelectFile, outPath, s, % a_desktop, Save Chart, *.ini
            if (errorLevel)
                return
            this.setPath(outPath)
        }

        this.working := 1
        eventMgr.enabled := 0
        cursor.setAll("wait")
        fileRecycle, % this.path
        file := fileOpen(this.path, "rw")
        
        for i, shape in grid.shapes {
            iniString := ""
            varSetCapacity(iniString, 20000, 0)
            iniString .= "[" shape.alias "]`r`n"  ;// f := file.addSection(shape.alias)
            shape := shape.export()
            for j, prop in gridShape.properties {
                if (prop = "bitmap") {
                    if shape.bitmap {
                        iniString .= "bitmap=1`r`n" ;//f.write("bitmap", 1)
                        bmpString := bitmapString.toString(shape.bitmap)
                        numberOfStringComponents := ceil(strLen(bmpString) / 5000)
                        stringPos := 1
                        loop % numberOfStringComponents {
                            setFormat.decimal()
                            iniString .= "bitmap" a_index "=" subStr(bmpString, stringPos, 5000) "`r`n" ;// f.writePseudoArray("bitmap", bmpString.toString(shape.bitmap))
                            stringPos += 5000
                        }
                    } else {
                        iniString .= "bitmap=0`r`n" ;// f.write("bitmap", 0)
                    }
                } else {
                    iniString .= prop "=" shape[prop] "`r`n" ;// f.write(prop, shape[prop])
                }
            } 
            file.write(iniString)
        }

        iniString := ""
        varSetCapacity(iniString, 20000, 0)
        for i, shape in grid.shapes {
            for j, prop in gridShape.properties {
                if (prop = "lines") {
                    for k, line in shape[prop] {
                        iniString .= "[" k "]`r`n"  ;// file.addSection(k)
                        iniString .= "alias=" k "`r`n" ;//file.sections[k].write("alias", k)
                    }
                }
            }
        }

        file.write(iniString)
        file.close()

        if regExMatch(this.path, "i)desktop\\([^\\]+)(.ini)$")
            desktop.refresh()

        cursor.reset()
        this.working := 0
        this.saveCommandEnabled := 0
        gridState_default.activate()
        cursor.reset()
        critical, off
    }

    open() {
        if (this.working)
            return
        
        errorLevel := 0
        fileSelectFile, outPath, 1, % a_desktop, Open Chart, *.ini
        if (errorLevel)
            return

        critical, on
        eventMgr.enabled := 0
        this.working := 1

        cursor.setAll("wait")

        actionStack.acceptingNewActions := 0
        this.reset()

        this.setPath(outPath)
        file := new iniFile("alias", this.path)
        file.getSections()

        textLayer.hide()

        for sectionName, section in file.sections {
            alias := section.read("alias")
            if alias.length < 12 {
                shape := object()
                for i, p in gridShape.properties {
                    if (p = "lines")
                        continue
                    shape[p] := section.read(p)
                }
                grid.importShape(shape.form, shape)
            }
        }

        for i, s in grid.shapes {
            s.render()
            (s.container) ? s.conformTextToShape()
            if (s.bitmap) {
                bmpData := file.sections[s.alias].readPseudoArray("bitmap")
                s.bitmap := bitmapString.toBitmap(bmpData, s.w, s.h)
                s.renderImage()
            }
            s.repos(,,,, 0)
        }

        textLayer.show()
        textLayer.applyStyles("clickThrough")
            
        for sectionName, section in file.sections {
            alias := sectionName
            if (alias.length > 12)
                grid.importLine(alias)
        }

        grid.redrawLines()
        shapeLayer.update()
        lineLayer.update()
        cursor.reset()
        actionStack.acceptingNewActions := 1
        this.working := 0
        gridState_default.activate()
        critical, off
    }
}