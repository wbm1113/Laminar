class gridShape_image extends gridShape_dataTransfer
{
    bitmapObject := 0

    attachBitmap(bitmap) {
        this.bitmapObject := new exBitmap().import(bitmap)
        this.bitmap := bitmap
        return this
    }

    renderImage(canvas = 0, update = 1) {
        canvas := canvas ? canvas : shapeLayer

        (this.path) ? canvas.clipPath(this.path.gdiPath)

        canvas.drawBitmap(this.bitmap, this.x + 1, this.y + 1, this.w, this.h)
        canvas.unclip()
        (update) ? canvas.update()
    }

    cropImage(x, y, w, h) {
        this.bitmapObject := new exBitmap().import(this.bitmap)
        this.bitmap := this.bitmapObject.crop(x, y, w, h)
    }

    detachBitmap() {
        this.bitmapObject := 0
        this.bitmap := 0
    }

    deleteBitmap() {
        this.bitmapObject.remove()
    }
}