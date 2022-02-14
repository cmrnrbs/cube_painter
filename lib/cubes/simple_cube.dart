import 'package:cube_painter/cubes/simple_unit_cube.dart';
import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final CubeInfo info;

  const SimpleCube({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: info.crop == Crop.c
          ? const SimpleUnitCube()
          : UnitCube(
              crop: info.crop,
            ),
    );
  }
}
