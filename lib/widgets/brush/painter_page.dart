import 'package:cube_painter/model/assets.dart';
import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/widgets/brush/brush.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/scafolding/grid.dart';
import 'package:cube_painter/widgets/scafolding/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Screen];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<AnimCube> _animCubes = [];
  final List<SimpleCube> _simpleCubes = [];

  // TODO allow change
  final crop = Crop.dl;

  final _cubeGroups = <CubeGroup>[];

  @override
  void initState() {
    _loadAllCubeGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO instead of clip, use maths to not draw widgets outside screen

    return Stack(
      children: [
        Transformed(
          child: Stack(
            children: [
              const Grid(),
              ..._simpleCubes,
              ..._animCubes,
            ],
          ),
        ),
        Brush(
          onStartPan: () {},
          onEndPan: _takeCubes,
          onTapUp: _takeCubes,
          erase: false,
          crop: crop,
        ),
      ],
    );
  }

  void _takeCubes(List<AnimCube> takenCubes) {
    if (takenCubes.isNotEmpty) {
      // _takeEditBlock();

      final int n = takenCubes.length;

      for (int i = 0; i < n; ++i) {
        //TODO maybe set anim speed
        _animCubes.add(AnimCube(
          key: UniqueKey(),
          info: takenCubes[i].info,
          start: takenCubes[i].scale,
          end: 1.0,
          whenComplete: _convertToSimpleCube,
        ));
      }

      setState(() {});
      // _save();
    }
  }

  dynamic _convertToSimpleCube(AnimCube old) {
    _simpleCubes.add(SimpleCube(info: old.info));
    _animCubes.remove(old);
    return () => 'whatever';
  }

  void _loadAllCubeGroups() async {
    await for (final json in Assets.loadAll()) {
      _cubeGroups.add(CubeGroup.fromJson(await json));
      if (_cubeGroups.length == 1) {
        _loadCubeGroup(0);
        setState(() {});
      }
    }
  }

  void _loadCubeGroup(int i) {
    for (CubeInfo cubeInfo in _cubeGroups[i].list) {
      _animCubes.add(AnimCube(
        key: UniqueKey(),
        info: cubeInfo,
        start: 0,
        end: 1.0,
        whenComplete: _convertToSimpleCube,
      ));
    }
  }
}
