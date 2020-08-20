cleanup() {
    grid.reset()

    layeredWindow.releaseUtensils()
    screenMask.release()
    bgLayer.release()
    shapeLayer.release()
    lineLayer.release()
    cursorBox.release()
    smartGuideLayer_h.release()
    smartGuideLayer_v.release()
    smartGuideLayer_g.release()
    scratchPad.release()
    scratchPad2.release()

    cursor.reset()

    layeredWindow.shutdown()
}

guiOnClose() {
    this.cleanup()
    exitApp
    return 1
}