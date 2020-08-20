    ;rotate(angle, rotateAbout = "tip") {
    ;    b := this.boundingBox
;
    ;    this.rotationAngle := angle
;
    ;    if (rotateAbout = "tip") {
    ;        rotationPoint := this.path.points[1] ;// rotates the arrow's points relative to the tip of the arrow
    ;    } else if (rotateAbout = "center") {
    ;        rotationPoint := [round(b.center[1]), round(b.center[2])]
    ;    }
;
    ;    loop 8
    ;        this.path.points[a_index] := trig.rotate(this.path.points[a_index], angle, rotationPoint)
;
    ;    xy := trig.rotate([b.x, b.y], angle, rotationPoint)
    ;    , xy2 := trig.rotate([b.x2, b.y2], angle, rotationPoint)
    ;    , b.x := xy[1] ;// collision detection methods work off x, y, w, h, so some extra steps are needed to convert to that from x, y, x2, y2
    ;    , b.y := xy[2]
    ;    , b.x2 := xy2[1]
    ;    , b.y2 := xy2[2]
    ;    , w := b.x - b.x2
    ;    , h := b.y - b.y2
    ;    , b.w := abs(w)
    ;    , b.h := abs(h)
    ;    , b.x -= w > 0 ? w : 0
    ;    , b.y -= h > 0 ? h : 0
    ;    , b.x2 := b.x + b.w
    ;    , b.y2 := b.y + b.h
    ;    
    ;    return this
    ;}