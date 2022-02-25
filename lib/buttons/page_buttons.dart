import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/buttons/open_file_menu_button.dart';
import 'package:cube_painter/buttons/open_slice_menu_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// all the button on the PainterPage
class PageButtons extends StatelessWidget {
  final Undoer undoer;

  const PageButtons({
    Key? key,
    required this.undoer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);
    // final double width = getScreenWidth(context);

    final bool canUndo = undoer.canUndo;
    final bool canRedo = undoer.canRedo;

    return Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OpenFileMenuButton(),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 72,
                  child: CubeButton(
                    radioOn: GestureMode.addWhole == gestureMode,
                    icon: DownloadedIcons.plusOutline,
                    iconSize: downloadedIconSize,
                    onPressed: () =>
                        setGestureMode(GestureMode.addWhole, context),
                    tip:
                        'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
                  ),
                ),
                CubeButton(
                  radioOn: GestureMode.erase == gestureMode,
                  icon: DownloadedIcons.cancelOutline,
                  iconSize: downloadedIconSize,
                  onPressed: () {
                    setGestureMode(GestureMode.erase, context);
                  },
                  tip:
                      'Tap on a cube to delete it.  You can change the position while you have your finger down.',
                ),
                HexagonElevatedButton(
                  height: 68,
                  radioOn: GestureMode.panZoom == gestureMode,
                  child: Icon(
                    Icons.zoom_in_sharp,
                    size: iconSize * 1.2,
                    color: enabledIconColor,
                  ),
                  onPressed: () => setGestureMode(GestureMode.panZoom, context),
                  tip: 'Pinch to zoom, drag to move around.',
                ),
                const OpenSliceMenuButton(),
              ]),
            ]),
        Column(children: [
          if (canUndo || canRedo)
            HexagonElevatedButton(
              child: Icon(
                Icons.undo_sharp,
                size: iconSize,
                color: canUndo ? enabledIconColor : disabledIconColor,
              ),
              onPressed: canUndo ? undoer.undo : null,
              tip: 'Undo the last add or delete operation.',
            ),
          if (canRedo)
            HexagonElevatedButton(
              tip: 'Redo the last add or delete operation that was undone.',
              child: Icon(
                Icons.redo_sharp,
                color: canRedo ? enabledIconColor : disabledIconColor,
                size: iconSize,
              ),
              onPressed: canRedo ? undoer.redo : null,
            ),
          // HACK without this container, the buttons don't work
          Container(),
        ]),
      ],
    );
  }
}
