import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/brush_cubes.dart';
import 'package:cube_painter/cubes/growing_cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gestures/gesturer.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/paintings_menu.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/slices_menu.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

class PainterPage extends StatelessWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PaintingsMenu(),
      endDrawer: const SlicesMenu(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          left: false,
          child: Stack(children: const [
            Horizon(),
            DoneCubes(),
            _AnimatingCubes(),
            Gesturer(),
            PageButtons(),
          ]),
        ),
      ),
    );
  }
}

class _AnimatingCubes extends StatelessWidget {
  const _AnimatingCubes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    return Stack(
      children: [
        if (paintingBank.animCubeInfos.isNotEmpty)
          if (paintingBank.cubeState == CubeState.brushing)
            const BrushCubes()
          else
            const GrowingCubes(),
      ],
    );
  }
}
