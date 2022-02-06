import 'package:cube_painter/shared/brush_maths.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Brush extends StatefulWidget {
  final _cubes = <Cube>[];

  final void Function() onStartPan;
  final void Function(List<Cube> takenCubes) onEndPan;

  final void Function(List<Cube> takenCubes) onTapUp;
  final Crop crop;

  final bool erase;

  Brush(
      {Key? key,
      required this.onStartPan,
      required this.onEndPan,
      required this.onTapUp,
      required this.crop,
      required this.erase})
      : super(key: key);

  List<Cube> _takeCubes() {
    final listCopy = _cubes.toList();

    _cubes.clear();
    return listCopy;
  }

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> {
  final brushMaths = BrushMaths();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          // HACK without this container,
          // onPanStart etc doesn't get called after cubes are added.
          Container(),
          Transformed(
            child: Stack(children: widget._cubes),
          ),
        ],
      ),
      onPanStart: (details) {
        widget.onStartPan();
        brushMaths.startFrom(
          screenToBrush(details.localPosition, context),
        );
      },
      onPanUpdate: (details) {
        brushMaths.extrudeTo(
          widget._cubes,
          screenToBrush(details.localPosition, context),
        );
        setState(() {});
      },
      onPanEnd: (details) {
        widget.onEndPan(widget._takeCubes());
      },
      onTapUp: (details) {
        brushMaths.setCroppedCube(
          widget._cubes,
          screenToBrush(details.localPosition, context),
          widget.crop,
        );

        setState(() {});
        widget.onTapUp(widget._takeCubes());
      },
    );
  }
}
