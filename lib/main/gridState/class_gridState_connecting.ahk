class gridState_connecting
{
    lastActiveOriginArrow := 0
    lastActiveDestArrow := 0

    resetProperties() {
        this.lastActiveOriginArrow := 0
        this.lastActiveDestArrow := 0
        this.origShape := 0
        this.destShape := 0
        this.lastCollision := 0
    }

    getOrigShape() {
        if grid.activeState != "selecting"
            return

        eventMgr.enabled := 0
        eventMgr.resetToDefault()

        this.resetProperties()

        scratchPad.clear().update()

        grid.lastActiveState := grid.activeState
        grid.activeState := "connecting"

        eventMgr.events["mouseMove"].swap(2, "gridState_connecting_targetCollision")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(2, 0)
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].enabled := 1
    
        this.origShape := gridState_selecting.selectedShape
        for i, s in grid.shapes
            s.render(scratchPad2,, s.alias = this.origShape.alias ? "black" : "solidGreen")

        critical, on
        eventMgr.suspended := 1
        loop 10
            scratchPad2.update(a_index), sleep.call(1)
        eventMgr.suspended := 0
        critical, off

        this.targetCollision()
    }

    getDestShape() {
        if ! this.lastCollision {
            gridState_default.activate()
            return
        }

        eventMgr.enabled := 0
        eventMgr.resetToDefault()

        this.destShape := this.lastCollision

        eventMgr.events["mouseMove"].swap(2, "gridState_connecting_arrowCollision")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(2, "gridState_connecting_arrowSelection")
        eventMgr.events["leftClick"].enabled := 1
        
        eventMgr.events["rightClick"].enabled := 1

        this.attachArrows()
    }

    targetCollision() {
        s := grid.detectProximity_shapes(coordComm.gridCoords[1], coordComm.gridCoords[2], grid.padding)

        if (! s or s.alias = this.origShape.alias) {
            eventMgr.events["leftClick"].swap(2, 0)
            this.lastCollision := 0
            scratchPad.clear().update()
            cursor.reset()
            return
        }
        
        eventMgr.events["leftClick"].swap(2, "gridState_connecting_getDestShape")

        if (this.lastCollision.alias = s.alias) {
            cursor.set("fingerPoint")
            return
        }
        
        scratchPad.clear()
        , cursor.set("fingerPoint")
        , s.outline("offGreen", 1)
        , this.lastCollision := s
        , scratchPad.update()
    }

    attachArrows(origShape = 0, destShape = 0) {
        critical, on
        eventMgr.suspended := 1
        loop 5
            scratchPad2.update(10 - a_index * 2), sleep.call(1)
        eventMgr.suspended := 0
        critical, off

        scratchPad.clear().update()
        cursor.reset()

        if (origShape) and (destShape) {
            this.origShape := origShape
            this.destShape := destShape
            this.lastCollision := destShape
        }

        this.originArrows := []
        this.destArrows := []
        w := 20
        h := 24

        if this.origShape.isLineAnchor {
            oxLeft := -20
            oyTop := -20
            oxRight := 20
            oyBot := 20
        } else {
            oxLeft := 0
            oyTop := 0
            oxRight := 0
            oyBot := 0
        }

        o := this.origShape.midLeft
        origLeft := new arrow().updateCoords(o[1] + oxLeft + 1, o[2] - w // 2, h, w, "left")

        o := this.origShape.midTop
        origTop := new arrow().updateCoords(o[1] - w // 2, o[2] + 1 + oyTop, w, h, "top")

        o := this.origShape.midRight
        origRight := new arrow().updateCoords(o[1] - h - 1 + oxRight, o[2] - w // 2, h, w, "right")

        o := this.origShape.midBottom
        origBottom := new arrow().updateCoords(o[1] - w // 2 - 1, o[2] - h - 1 + oyBot, w, h, "bottom")

        this.originArrows.push(origLeft, origTop, origRight, origBottom)

        if this.destShape.isLineAnchor {
            oxLeft := -20
            oyTop := -20
            oxRight := 20
            oyBot := 20
        } else {
            oxLeft := 0
            oyTop := 0
            oxRight := 0
            oyBot := 0
        }

        o := this.destShape.midLeft
            destLeft := new arrow().updateCoords(o[1] + oxLeft + 1, o[2] - w // 2, h, w, "left")

        o := this.destShape.midTop
            destTop := new arrow().updateCoords(o[1] - w // 2, o[2] + 1 + oyTop, w, h, "top")

        o := this.destShape.midRight
            destRight := new arrow().updateCoords(o[1] - h - 1 + oxRight, o[2] - w // 2, h, w, "right")

        o := this.destShape.midBottom
            destBottom := new arrow().updateCoords(o[1] - w // 2 - 1, o[2] - h - 1 + oyBot, w, h, "bottom")
                
        this.destArrows.push(destLeft, destTop, destRight, destBottom)

        if (this.origShape.form = "arrow") {
            pT := this.origShape.pointsToward
            if (pT = "up" or pT = "down") {
                this.originArrows[1] := 0
                this.originArrows[3] := 0
            }
            if (pT = "left" or pT = "right") {
                this.originArrows[2] := 0
                this.originArrows[4] := 0
            }
        }

        if (this.destShape.form = "arrow") {
            pT := this.destShape.pointsToward
            if (pT = "up" or pT = "down") {
                this.destArrows[1] := 0
                this.destArrows[3] := 0
            }
            if (pT = "left" or pT = "right") {
                this.destArrows[2] := 0
                this.destArrows[4] := 0
            }
        }

        for i, a in this.originArrows
            a.fill(scratchPad, "eggShellWhite").draw(scratchPad, "black", 1)
        for i, a in this.destArrows
            a.fill(scratchPad, "eggShellWhite").draw(scratchPad, "black", 1)

        scratchPad.update()
        this.enableOriginArrowCollision := 1
        this.enableDestArrowCollision := 1
        this.lastActiveOriginArrow := 0
        this.lastActiveDestArrow := 0
    }

    arrowCollision() {
        if this.enableOriginArrowCollision {
            lastActiveOriginArrow := 0

            for i, a in this.originArrows
                if a.boundingBox.contains(coordComm.gridcoords[1], coordComm.gridCoords[2])
                    lastActiveOriginArrow := a_index ;// feeds into the loop below
                    
            if (lastActiveOriginArrow)
                cursor.set("fingerPoint")

            if this.lastActiveOriginArrow = lastActiveOriginArrow {
                ;// do nothing, can't return because need to check enableDestArrowCollision below
            } else {
                o := this.origShape
                , scratchPad.clip(o.x - 20, o.y - 20, o.w + 40, o.h + 40).clear().unClip() ;// prevents clipping the shape's border
                for i, a in this.originArrows {
                    if (lastActiveOriginArrow = a_index) {
                        this.originArrows[a_index].fill(scratchPad, "black")
                                                  .draw(scratchPad, "eggShellWhite", 1)
                    } else {
                        this.originArrows[a_index].fill(scratchPad, "eggShellWhite")
                                                  .draw(scratchPad, "black", 1)
                    }
                }
                scratchPad.update()
                , this.lastActiveOriginArrow := lastActiveOriginArrow
            }
        }

        if this.enableDestArrowCollision {
            lastActiveDestArrow := 0
            for i, a in this.destArrows
                if a.boundingBox.contains(coordComm.gridcoords[1], coordComm.gridCoords[2])
                    lastActiveDestArrow := a_index ;// feeds into the loop below
            
            if (lastActiveDestArrow)
                cursor.set("fingerPoint")
            else if (! lastActiveOriginArrow)
                cursor.reset()

            if this.lastActiveDestArrow = lastActiveDestArrow {
                return ;// can return as this is the last if block in the function
            } else {
                d := this.destShape
                , scratchPad.clip(d.x - 20, d.y - 20, d.w + 40, d.h + 40).clear().unClip() ;// prevents clipping the shape's border
                for i, a in this.destArrows {
                    if (lastActiveDestArrow = a_index) {
                        this.destArrows[a_index].fill(scratchPad, "black")
                                                .draw(scratchPad, "eggShellWhite", 1)
                    } else {
                        this.destArrows[a_index].fill(scratchPad, "eggShellWhite")
                                                .draw(scratchPad, "black", 1)
                    }
                }
                scratchPad.update()
                , this.lastActiveDestArrow := lastActiveDestArrow
            }
        }

        if (this.enableOriginArrowCollision and lastActiveOriginArrow)
            cursor.set("fingerPoint")
        else if (this.enableDestArrowCollision and lastActiveDestArrow)
            cursor.set("fingerPoint")
        else cursor.reset()
    }

    arrowSelection() {
        if this.enableOriginArrowCollision {
            for i, a in this.originArrows {
                if a.boundingBox.contains(coordComm.gridCoords[1], coordComm.gridCoords[2]) {
                    o := this.origShape
                    , scratchPad.clip(o.x - 20, o.y - 20, o.w + 40, o.h + 40).clear().unClip() ;// prevents clipping the shape's border
                    , a.fill(scratchPad, "highlightYellow")
                    , a.draw(scratchPad, "black", 1)
                    , scratchPad.update()
                    , this.enableOriginArrowCollision := 0
                    , this.lastActiveOriginArrow := a_index
                    break
                }
            }
        }

        if this.enableDestArrowCollision {
            for i, a in this.destArrows {
                if a.boundingBox.contains(coordComm.gridcoords[1], coordComm.gridCoords[2]) {
                    d := this.destShape
                    , scratchPad.clip(d.x - 20, d.y - 20, d.w + 40, d.h + 40).clear().unClip() ;// prevents clipping the shape's border
                    , a.fill(scratchPad, "highlightYellow")
                    , a.draw(scratchPad, "black", 1)
                    , scratchPad.update()
                    , this.enableDestArrowCollision := 0
                    , this.lastActiveDestArrow := a_index
                    break
                }
            }
        }

        if ! this.enableOriginArrowCollision and ! this.enableDestArrowCollision
            this.drawConnectingLine(), gridState_default.activate()
    }

    static facingDirection := ["midLeft", "midTop", "midRight", "midBottom"]

    drawConnectingLine() {
        eventMgr.enabled := 0
        
        origDirection := this.facingDirection[this.lastActiveOriginArrow]
        destDirection := this.facingDirection[this.lastActiveDestArrow]
        l := grid.addLine(this.origShape, origDirection, this.destShape, destDirection)
        l.draw(lineLayer)
        lineLayer.update()

        a := actionStack.add(l.alias.string)
        a.addUndoAction(l.alias.string, "remove")
        a.addUndoAction(grid, "redrawLines").setParams(0)
        a.addRedoAction(grid, "importLine").setParams(l.alias.string)
        a.addRedoAction(grid, "redrawOneLine").setParams(l.alias.string)

        gridState_default.activate()
    }
}