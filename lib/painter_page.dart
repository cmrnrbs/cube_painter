import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cube_button.dart';
import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/menu.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  getScreen,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
  Tiles,
  HexagonButtonBar,
  getCubeInfos,
  StaticCubes,
  Crop.c,
  Provider,
];

class PainterPage extends StatefulWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final _cubes = Cubes();

  @override
  void initState() {
    _cubes.init(setState_: setState, context_: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubeInfos = getCubeInfos(context, listen: true);
    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;
    final gestureMode = getGestureMode(context, listen: true);

    const double barHeight = 87;
    // const double buttonHeight = barHeight + 22;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: barHeight,
        // leading: HexagonButton(
        //    child: const Icon(Icons.menu_sharp),
        //   onPressed: () {
        //     setGestureMode(GestureMode.panZoom, context);
        //   },
        //   tip: 'TODO',
        // ),
        backgroundColor: backgroundColor,
        // backgroundColor: Colors.transparent,
        actions: <Widget>[
          HexagonButton(
            child: Icon(Icons.undo_sharp,
                color: getColor(
                  _cubes.undoer.canUndo ? Side.br : Side.bl,
                )),
            onPressed: _cubes.undoer.undo,
            tip: 'Undo the last add or delete operation.',
          ),
          HexagonButton(
            child: Icon(Icons.redo_sharp,
                color: getColor(
                  _cubes.undoer.canRedo ? Side.br : Side.bl,
                )),
            onPressed: _cubes.undoer.redo,
            tip: 'Redo the last add or delete operation that was undone.',
          ),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 17,
            endIndent: 0,
            color: Colors.black,
          ),
          HexagonButton(
            radioOn: GestureMode.panZoom == gestureMode,
            child: const Icon(Icons.zoom_in_sharp),
            onPressed: () {
              setGestureMode(GestureMode.panZoom, context);
            },
            tip: 'TODO',
          ),
          CubeButton(
            radioOn: GestureMode.add == gestureMode,
            icon: Icons.add,
            onPressed: () {
              setGestureMode(GestureMode.add, context);
            },
            tip:
                'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
          ),
          CubeButton(
            radioOn: GestureMode.erase == gestureMode,
            icon: Icons.remove,
            onPressed: () {
              setGestureMode(GestureMode.erase, context);
            },
            tip:
                'Tap on a cube to delete it.  You can change the position while you have your finger down.',
          ),
        ],
      ),
      drawer: Menu(
        items: <MenuItem>[
          MenuItem(
            text: 'New',
            icon: Icons.star,
            callback: getCubeGroupNotifier(context).clear,
          ),
          MenuItem(
            text: 'Forward',
            icon: Icons.forward,
            callback: getCubeGroupNotifier(context).forward,
          ),
          MenuItem(
            text: 'Save to clipboard',
            icon: Icons.save_alt_sharp,
            callback: _cubes.saveToClipboard,
          ),
        ],
        brushs: [
          Transform.scale(
            scale: 21,
            child: CropUnitCube(crop: crop),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          UnitToScreen(
            child: Stack(
              children: [
                const Tiles(),
                StaticCubes(cubeInfos: cubeInfos),
                ..._cubes.animCubes,
              ],
            ),
          ),
          GestureMode.panZoom == getGestureMode(context, listen: true)
              ? const PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
        ]),
      ),
    );
  }
}
