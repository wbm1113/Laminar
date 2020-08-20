#noEnv
#singleInstance, Force
#keyHistory 0
#maxHotkeysPerInterval 500
#maxThreadsPerHotkey 1
sendMode input
setWorkingDir %a_scriptDir%
setTitleMatchMode, 2
detectHiddenWindows, on
detectHiddenText, on
setBatchLines, -1
listLines, off
process, priority, , H
setKeyDelay, -1
setMouseDelay, -1
setDefaultMouseSpeed, 0
setWinDelay, -1
setControlDelay, -1
coordMode, mouse, screen
coordMode, pixel, screen
coordMode, menu, screen
coordMode, toolTip, screen

;@Ahk2Exe-SetMainIcon img\icon.ico
;//Ahk2Exe-Bin Unicode 32*
#NoTrayIcon

#include lib\ahk_stdlib\events\class_eventMgr.ahk
#include lib\ahk_stdlib\events\onMessage.ahk
#include lib\ahk_stdlib\fn\fn_getFullFilePath.ahk
#include lib\ahk_stdlib\fn\fn_guid.ahk
#include lib\ahk_stdlib\fn\fn_randBetween.ahk
#include lib\ahk_stdlib\fn\fn_setFormat.ahk
#include lib\ahk_stdlib\fn\fn_sleep.ahk
#include lib\ahk_stdlib\gdi\class_bitmapString.ahk
#include lib\ahk_stdlib\gdi\class_colorMath.ahk
#include lib\ahk_stdlib\gdi\class_exBitmap.ahk
#include lib\ahk_stdlib\gdi\fn_saveBitmapToFile.ahk
#include lib\ahk_stdlib\gdi\layeredWindow\class_layeredWindow.ahk
#include lib\ahk_stdlib\gdi\layeredWindow\class_layeredWindow_canvas.ahk
#include lib\ahk_stdlib\gdi\layeredWindow\class_layeredWindow_colors.ahk
#include lib\ahk_stdlib\gdi\layeredWindow\class_layeredWindow_drawing.ahk
#include lib\ahk_stdlib\gdi\layeredWindow\class_layeredWindow_utensils.ahk
#include lib\ahk_stdlib\gdi\stencils\class_arrow.ahk
#include lib\ahk_stdlib\gdi\stencils\class_circle.ahk
#include lib\ahk_stdlib\gdi\stencils\class_diamond.ahk
#include lib\ahk_stdlib\gdi\stencils\class_roundRect.ahk
#include lib\ahk_stdlib\gdi\stencils\class_stencil.ahk
#include lib\ahk_stdlib\gdi\stencils\class_triangle.ahk
#include lib\ahk_stdlib\geometry\class_path.ahk
#include lib\ahk_stdlib\geometry\class_rect.ahk
#include lib\ahk_stdlib\geometry\class_trig.ahk
#include lib\ahk_stdlib\gui\class_guiMenu.ahk
#include lib\ahk_stdlib\gui\ctrl\class_ctlColors.ahk
#include lib\ahk_stdlib\gui\ctrl\class_ctrlMgr.ahk
#include lib\ahk_stdlib\gui\ctrl\ctrl\class_ctrl.ahk
#include lib\ahk_stdlib\gui\ctrl\ctrl\class_ctrl_actions.ahk
#include lib\ahk_stdlib\gui\ctrl\ctrl\class_ctrl_options.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_buttonCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_checkBoxCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_dropDownListCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_editCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_lvCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_radioCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_textCtrl.ahk
#include lib\ahk_stdlib\gui\ctrl\types\class_tvCtrl.ahk
#include lib\ahk_stdlib\gui\events\guiSpecLabel.ahk
#include lib\ahk_stdlib\gui\events\onScroll.ahk
#include lib\ahk_stdlib\gui\gui\class_gui.ahk
#include lib\ahk_stdlib\gui\gui\class_gui_childWindow.ahk
#include lib\ahk_stdlib\gui\gui\class_gui_options.ahk
#include lib\ahk_stdlib\gui\gui\class_gui_resize.ahk
#include lib\ahk_stdlib\ini\class_iniFile.ahk
#include lib\ahk_stdlib\proto\class_protoClass.ahk
#include lib\ahk_stdlib\proto\proto_prop.ahk
#include lib\ahk_stdlib\struct\class_struct.ahk
#include lib\ahk_stdlib\timer\class_timer.ahk
#include lib\ahk_stdlib\ui\class_cursor.ahk
#include lib\ahk_stdlib\ui\class_desktop.ahk
#include lib\ahk_stdlib\ui\class_mouse.ahk
#include lib\ahk_stdlib\ui\class_mouseHook.ahk
#include lib\ahk_stdlib\ui\class_window.ahk

global screenMask := new layeredWindow("screenMask")
    screenMask.create()
    screenMask.setDimensions(desktop.topLeftX, desktop.topLeftY, desktop.w, desktop.h)
    screenMask.getCanvas()
    screenMask.update()
    screenMask.hide()

global gui := new gui("Laminar")
    gui.create()
    gui.makeResizable()
    gui.setColor("696969")
    gui.setDimensions("", "", 783, 800)
    gui.ctrls.add("button", "focusDumpster").setDimensions(0, 0, 1, 1).draw().hide()

global menu := new guiMenu(gui)
    setupMenu()

global bgLayer := gui.addChild_layered("bgLayer", 10, 10, 761, 1001) ;// extra 1 on the width/height for the border
    bgLayer.applyStyles("clickThrough")
    bgLayer.show()
    bgLayer.getCanvas("white")
    drawGridVertical()
    drawGridHorizontal()

global backerPad := gui.addChild_layered("backerPad", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h)
    backerPad.applyStyles("clickThrough")
    backerPad.show()
    backerPad.getCanvas()
    backerPad.update()

global lineLayer := gui.addChild_layered("lineLayer", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h)
    lineLayer.applyStyles("clickThrough")
    lineLayer.show()
    lineLayer.getCanvas()
    lineLayer.update()

global shapeLayer := gui.addChild_layered("shapeLayer", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h)
    shapeLayer.applyStyles("clickThrough")
    shapeLayer.show()
    shapeLayer.getCanvas()
    shapeLayer.update()

global textLayer := gui.addChild("textLayer", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h)
    textLayer.applyStyles("noCaption", "alwaysOnTop")
    textLayer.setColor("white")
    textLayer.setFont()
    textLayer.show()
    winSet, transColor, white, % textLayer.a_hwnd
    textLayer.hide()

global cursorBox := gui.addChild_layered("cursorBox", bgLayer.window.x, bgLayer.window.y, 11, 11)
    cursorBox.applyStyles("clickThrough")
    cursorBox.show()
    cursorBox.getCanvas()
    cursorBox.drawRect("black", 1, 0, 0, 10, 10)
    cursorBox.update()

global smartGuideLayer_h := gui.addChild_layered("smartGuide_h", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h, 0, 1)
    smartGuideLayer_h.applyStyles("clickThrough")
    smartGuideLayer_h.show()
    smartGuideLayer_h.getCanvas()
    smartGuideLayer_h.update()
    
global smartGuideLayer_v := gui.addChild_layered("smartGuide_v", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h, 0, 1)
    smartGuideLayer_v.applyStyles("clickThrough")
    smartGuideLayer_v.show()
    smartGuideLayer_v.getCanvas()
    smartGuideLayer_v.update()

global smartGuideLayer_g := gui.addChild_layered("smartGuide_d", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h, 0, 1)
    smartGuideLayer_g.applyStyles("clickThrough")
    smartGuideLayer_g.show()
    smartGuideLayer_g.getCanvas()
    smartGuideLayer_g.update()
global scratchPad := gui.addChild_layered("scratchPad", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h, 0, 1)
    scratchPad.applyStyles("clickThrough")
    scratchPad.show()
    scratchPad.getCanvas()
    scratchPad.update()

global scratchPad2 := gui.addChild_layered("scratchPad2", bgLayer.window.x, bgLayer.window.y, bgLayer.window.w, bgLayer.window.h, 0, 1)
    scratchPad2.applyStyles("clickThrough")
    scratchPad2.show()
    scratchPad2.getCanvas()
    scratchPad2.update()

bgLayer.drawLine("faintBlue", 1, gridAlign.1Q, 1, gridAlign.1Q, grid.yLimit - 1)
bgLayer.drawLine("faintBlue", 1, gridAlign.M, 1, gridAlign.M, grid.yLimit - 1) 
bgLayer.drawLine("faintBlue", 1, gridAlign.3Q, 1, gridAlign.3Q, grid.yLimit - 1)  
bgLayer.setBorder("borderPen")
bgLayer.update()
eventSetup()

global gui_scroll_list := [bgLayer, backerPad, shapeLayer, textLayer, lineLayer, smartGuideLayer_h, smartGuideLayer_v, smartGuideLayer_g, scratchPad, scratchPad2]
gui.vScrollUpdate()
gui.show()
gui.applyStyles("noMaximize")
gui.setMaxSize(783, 1000)
textLayer.show() ;// showing it, hiding it, then showing it again here, after calling gui.show(), prevents weird rendering issues
onExit(func("cleanup"))
gridState_default.activate()
return

setupMenu() {
    menu.add("File").add("Save`tCtrl+S", objBindMethod(laminarData, "save", 0))
                    .add("Save As...", objBindMethod(laminarData, "save", 1))
                    .add("Open`tCtrl+O", objBindMethod(laminarData, "open"))
                    .add("separator")
                    .add("Export", objBindMethod(export, "call"))
    
    menu.add("Edit").add("Undo`tCtrl+Z", objBindMethod(actionStack, "undo"))
                    .add("Redo`tCtrl+Y", objBindMethod(actionStack, "redo"))
                    .add("separator")
                    .add("Select", objBindMethod(menuActions, "multiSelect"))

    menu.add("Shape").add("Copy`tCtrl+C", objBindMethod(gridState_copying, "activate"))
                     .add("Connect to another shape`tx", objBindMethod(gridState_connecting, "getOrigShape"))
                     .add("separator")
                     .add("Form", "submenu")
                        .add("Rectangle", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Rounded Rectangle", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Circle", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Diamond", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Up Arrow", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Down Arrow", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Left Arrow", objBindMethod(menuActions, "changeShapeForm"))
                        .add("Right Arrow", objBindMethod(menuActions, "changeShapeForm"), returnParent := 1)
                     .add("Color", "subMenu")
                        .add("Gray", objBindMethod(menuActions, "setBgColor"))
                        .add("Red", objBindMethod(menuActions, "setBgColor"))
                        .add("Blue", objBindMethod(menuActions, "setBgColor"))
                        .add("Green", objBindMethod(menuActions, "setBgColor"))
                        .add("Purple", objBindMethod(menuActions, "setBgColor"))
                        .add("Yellow", objBindMethod(menuActions, "setBgColor"))
                        .add("Orange", objBindMethod(menuActions, "setBgColor"), returnParent := 1)
                     .add("Adjust Position", "submenu")
                        .add("Up`tUp Arrow", objBindMethod(menuActions, "adjustShapePosition"))
                        .add("Down`tDown Arrow", objBindMethod(menuActions, "adjustShapePosition"))
                        .add("Left`tLeft Arrow", objBindMethod(menuActions, "adjustShapePosition"))
                        .add("Right`tRight Arrow", objBindMethod(menuActions, "adjustShapePosition"), returnParent := 1)
                     .add("separator")
                     .add("Add screenshot to shape", objBindMethod(screenshotToShape, "beginCapture"))
                     .add("Crop", objBindMethod(menuActions, "crop"))
                     .add("separator")
                     .add("Add/edit shape text", objBindMethod(menuActions, "editText"))
                     .add("Text properties", "subMenu")
                        .add("Normal", objBindMethod(menuActions, "updateTextProperty"))
                        .add("Bold", objBindMethod(menuActions, "updateTextProperty"))
                        .add("separator")
                        .add("Small", objBindMethod(menuActions, "updateTextProperty"))
                        .add("Large", objBindMethod(menuActions, "updateTextProperty"))
                        .add("Huge", objBindMethod(menuActions, "updateTextProperty"), returnParent := 1)
                     .add("separator")                     
                     .add("Delete", objBindMethod(menuActions, "delete"))
    
    menu.add("Line").add("Add line anchor", objBindMethod(menuActions, "addLineAnchor"))
                    .add("Delete", objBindMethod(menuActions, "delete"))

    menu.attach()
}

drawGridVertical() {
    loop % bgLayer.window.w - 1
        bgLayer.drawLine("lightGray", 1, a_Index * grid.gridSize, 0, a_Index * grid.gridSize, bgLayer.window.h - 1)
}

drawGridHorizontal() {
    loop % bgLayer.window.h - 1
        bgLayer.drawLine("lightGray", 1, 0, a_index * grid.gridSize, bgLayer.window.w - 1, a_index * grid.gridSize)
}

eventSetup() {
    eventMgr.events["wm_activate"]
        .addAction("init", objBindMethod(cursor, "reset", 1))
        .addAction("init2", objBindMethod(gridState_default, "activate"))
            .setDefault("init", "init2").resetToDefault()
        eventMgr.events["wm_activate"].lParamCondition := 0
        eventMgr.events["wm_activate"].ignoreBlanketDisable := 1

    eventMgr.events["NCmouseMove"]
        .addAction("init", objBindMethod(cursor, "reset"))
            .setDefault("init").resetToDefault()
        eventMgr.events["NCmouseMove"].ignoreBlanketDisable := 1

    eventMgr.events["NCmouseLeave"]
        .addAction("init", objBindMethod(cursor, "reset"))
            .setDefault("init").resetToDefault()
        eventMgr.events["NCmouseLeave"].ignoreBlanketDisable := 1

    eventMgr.events["mouseMove"]
        .addAction("init", objBindMethod(coordComm, "updateCoords"))
        .addAction("init_STRICTMODE", objBindMethod(coordComm, "updateCoords", 1))
        .addAction("gridState_default_track", objBindMethod(gridState_default, "track"))
        .addAction("gridState_drawing_track", objBindMethod(gridState_drawing, "track"))
        .addAction("gridState_selecting_track", objBindMethod(gridState_selecting, "track"))
        .addAction("gridState_moving_track", objBindMethod(gridState_moving, "track"))
        .addAction("gridState_resizing_track", objBindMethod(gridState_resizing, "track"))
        .addAction("gridState_copying_track", objBindMethod(gridState_copying, "track"))
        .addAction("gridState_cropping_track", objBindMethod(gridState_cropping, "track"))
        .addAction("gridState_cropping_adjust", objBindMethod(gridState_cropping, "adjust"))
        .addAction("gridState_addingLineAnchor_track", objBindMethod(gridState_addingLineAnchor, "track"))
        .addAction("gridState_multiSelecting_track", objBindMethod(gridState_multiSelecting, "track"))
        .addAction("gridState_connecting_targetCollision", objBindMethod(gridState_connecting, "targetCollision"))
        .addAction("gridState_connecting_arrowCollision", objBindMethod(gridState_connecting, "arrowCollision"))
        .addAction("screenshotToShape_drawing", objBindMethod(screenshotToShape, "drawing"))
        .addAction("gridState_multiSelecting_multiMove_track", objBindMethod(gridState_multiSelecting, "multiMove_track"))
            .setDefault("init", "gridState_default_track").resetToDefault()

    eventMgr.events["leftClick"]
        .addAction("init", objBindMethod(coordComm, "updateCoords"))
        .addAction("init_STRICTMODE", objBindMethod(coordComm, "updateCoords", 1))
        .addAction("gridState_default_activate", objBindMethod(gridState_default, "activate"))
        .addAction("gridState_drawing_activate", objBindMethod(gridState_drawing, "activate"))
        .addAction("gridState_drawing_addShape", objBindMethod(gridState_drawing, "addShape"))
        .addAction("gridState_selecting_activate", objBindMethod(gridState_selecting, "activate"))
        .addAction("gridState_selecting_selectShape", objBindMethod(gridState_selecting, "selectShape"))
        .addAction("gridState_resizing_activate", objBindMethod(gridState_resizing, "activate"))
        .addAction("gridState_moving_activate", objBindMethod(gridState_moving, "activate"))
        .addAction("gridState_moving_move", objBindMethod(gridState_moving, "move"))
        .addAction("gridState_cropping_trackToAdjust", objBindMethod(gridState_cropping, "trackToAdjust"))
        .addAction("gridState_connecting_getDestShape", objBindMethod(gridState_connecting, "getDestShape"))
        .addAction("gridState_connecting_arrowSelection", objBindMethod(gridState_connecting, "arrowSelection"))
        .addAction("gridState_textEntry_confirm", objBindMethod(gridState_textEntry, "confirm"))
        .addAction("gridState_copying_paste", objBindMethod(gridState_copying, "paste"))
        .addAction("gridState_cropping_adjust", objBindMethod(gridState_cropping, "adjust"))
        .addAction("screenshotToShape_select", objBindMethod(screenshotToShape, "select"))
        .addAction("screenshotToShape_endCapture", objBindMethod(screenshotToShape, "endCapture"))
        .addAction("gridState_multiSelecting_enableTracking", objBindMethod(gridState_multiSelecting, "enableTracking"))
        .addAction("gridState_addingLineAnchor_add", objBindMethod(gridState_addingLineAnchor, "add"))
        .addAction("gridState_multiSelecting_confirm", objBindMethod(gridState_multiSelecting, "confirm"))
        .addAction("gridState_selecting_swapSelection", objBindMethod(gridState_selecting, "swapSelection"))
            .setDefault("init", "gridState_drawing_activate").resetToDefault()

    eventMgr.events["rightClick"]
        .addAction("init", objBindMethod(coordComm, "updateCoords"))
        .addAction("gridState_default_activate", objBindMethod(gridState_default, "activate"))
        .addAction("gridState_textEntry_confirm", objBindMethod(gridState_textEntry, "confirm"))
        .addAction("gridState_cropping_abort", objBindMethod(gridState_cropping, "abort"))
        .addAction("gridState_resizing_abort", objBindMethod(gridState_resizing, "abort"))
        .addAction("gridState_moving_abort", objBindMethod(gridState_moving, "abort"))
        .addAction("gridState_drawing_abort", objBindMethod(gridState_drawing, "abort"))
        .addAction("gridState_copying_abort", objBindMethod(gridState_copying, "abort"))
        .addAction("gridState_multiSelecting_abort", objBindMethod(gridState_multiSelecting, "abort"))
            .setDefault("init", "gridState_default_activate").resetToDefault()

    eventMgr.events["leftClickRelease"]
        .addAction("init", objBindMethod(coordComm, "updateCoords"))
        .addAction("gridState_default_activate", objBindMethod(gridState_default, "activate"))
        .addAction("gridState_moving_move", objBindMethod(gridState_moving, "move"))
        .addAction("gridState_resizing_resize", objBindMethod(gridState_resizing, "resize"))
        .addAction("gridState_cropping_crop", objBindMethod(gridState_cropping, "crop"))
        .addAction("gridState_cropping_adjustToTrack", objBindMethod(gridState_cropping, "adjustToTrack"))
        .addAction("gridState_multiSelecting_select", objBindMethod(gridState_multiSelecting, "select"))
        .addAction("gridState_cropping_abort", objBindMethod(gridState_cropping, "abort"))
        .addAction("gridState_resizing_abort", objBindMethod(gridState_resizing, "abort"))
        .addAction("gridState_moving_abort", objBindMethod(gridState_moving, "abort"))
        .addAction("gridState_drawing_abort", objBindMethod(gridState_drawing, "abort"))
        .addAction("gridState_copying_abort", objBindMethod(gridState_copying, "abort"))
        .addAction("gridState_multiSelecting_multiMove_move", objBindMethod(gridState_multiSelecting, "multiMove_move"))
            .setDefault("init").resetToDefault()

    eventMgr.events["doubleLeftClick"]
        .addAction("init", objBindMethod(coordComm, "updateCoords"))
        .addAction("gridState_textEntry_activate", objBindMethod(gridState_textEntry, "activate"))
            .setDefault("init").resetToDefault()
}

#include lib\main\grid\class_grid.ahk
#include lib\main\grid\class_grid_shapes.ahk
#include lib\main\grid\class_grid_lines.ahk
#include lib\main\grid\class_grid_collisionDetection.ahk
#include lib\main\grid\class_grid_query.ahk

#include lib\main\gridLine\class_gridLine.ahk
#include lib\main\gridLine\class_gridLine_pathCalculation.ahk
#include lib\main\gridLine\class_gridLine_arrowHead.ahk
#include lib\main\gridLine\class_gridLine_predictionPath.ahk
#include lib\main\gridLine\class_gridPoint.ahk

#include lib\main\gridShape\class_gridShape.ahk
#include lib\main\gridShape\class_gridShape_text.ahk
#include lib\main\gridShape\class_gridShape_image.ahk
#include lib\main\gridShape\class_gridShape_dataTransfer.ahk
#include lib\main\gridShape\class_gridShape_drawing.ahk

#include lib\main\gridState\class_gridState_default.ahk
#include lib\main\gridState\class_gridState_drawing.ahk
#include lib\main\gridState\class_gridState_connecting.ahk
#include lib\main\gridState\class_gridState_selecting.ahk
#include lib\main\gridState\class_gridState_moving.ahk
#include lib\main\gridState\class_gridState_textEntry.ahk
#include lib\main\gridState\class_gridState_resizing.ahk
#include lib\main\gridState\class_gridState_copying.ahk
#include lib\main\gridState\class_gridState_cropping.ahk
#include lib\main\gridState\class_gridState_multiSelecting.ahk
#include lib\main\gridState\class_gridState_addingLineAnchor.ahk

#include lib\main\guides\class_alignMgr.ahk
#include lib\main\guides\class_gridAlign.ahk
#include lib\main\guides\class_autoAlign.ahk

#include lib\main\file\class_laminarData.ahk
#include lib\main\file\class_export.ahk

#include lib\main\actionStack\class_actionStack.ahk
#include lib\main\actionStack\class_action.ahk

#include lib\main\fn\class_compositeBoundingBox.ahk
#include lib\main\fn\class_menuActions.ahk
#include lib\main\fn\class_coordComm.ahk
#include lib\main\fn\class_screenshotToShape.ahk
#include lib\main\fn\class_shapeNudge.ahk
#include lib\main\fn\class_textLayerEffects.ahk
#include lib\main\fn\exitRoutine.ahk

#include lib\main\debug\class_inspector.ahk

#include lib\main\hotkeys.ahk
#include lib\ahk_stdlib\hotkeys.ahk