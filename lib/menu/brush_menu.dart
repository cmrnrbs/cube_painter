import 'package:cube_painter/app_icons.dart';
import 'package:cube_painter/buttons/brush_menu_button.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class BrushMenu extends StatelessWidget {
  final Cubes cubes;

  const BrushMenu({Key? key, required this.cubes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

    final bool canUndo = cubes.undoer.canUndo;
    final bool canRedo = cubes.undoer.canRedo;

    void undo() {
      if (canUndo) {
        cubes.undoer.undo();
        // Navigator.pop(context);
      }
    }

    void redo() {
      if (canRedo) {
        cubes.undoer.redo();
        // Navigator.pop(context);
      }
    }

    const pad = SizedBox(width: 14);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          Transform.translate(
            // offset:  Offset(constraints.maxWidth/2,0),
            offset: Offset.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HexagonButton(
                  child: Icon(
                    Icons.undo_sharp,
                    color: canUndo ? enabledIconColor : disabledIconColor,
                    size: iconSize,
                  ),
                  onPressed: canUndo ? undo : null,
                  tip: 'Undo the last add or delete operation.',
                ),
                pad,
                HexagonButton(
                  child: Icon(
                    Icons.redo_sharp,
                    color: canRedo ? enabledIconColor : disabledIconColor,
                    size: iconSize,
                  ),
                  onPressed: canRedo ? redo : null,
                  tip: 'Redo the last add or delete operation that was undone.',
                ),
              ],
            ),
          ),
          const Divider(),
          Center(child: Text('Brush...', style: TextStyle(color: textColor))),
          const SizedBox(height: 22),
          CubeButton(
            radioOn: GestureMode.erase == gestureMode,
            icon: cancelOutline,
            onPressed: () {
              setGestureMode(GestureMode.erase, context);
            },
            tip:
                'Tap on a cube to delete it.  You can change the position while you have your finger down.',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.dr),
              pad,
              BrushMenuButton(crop: Crop.dl),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.r),
              pad,
              BrushMenuButton(crop: Crop.c),
              pad,
              BrushMenuButton(crop: Crop.l),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.ur),
              pad,
              BrushMenuButton(crop: Crop.ul),
            ],
          ),
          HexagonButton(
            radioOn: GestureMode.panZoom == gestureMode,
            child: Icon(
              Icons.zoom_in_sharp,
              color: enabledIconColor,
              size: iconSize,
            ),
            onPressed: () => setGestureMode(GestureMode.panZoom, context),
            tip: 'Pinch to zoom, drag to move around.',
          ),
          const SizedBox(height: 3),
          Center(
              child:
              Text('...or Pan / Zoom', style: TextStyle(color: textColor))),
          const Divider(),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
