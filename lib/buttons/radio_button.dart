import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// A raised hexagon shaped button
/// It can act as a radio or a push button.
/// It can have an [Icon] too e.g. the plus sign for adding cubes.
/// The cube might be a whole cube or a slice of a cube.
class RadioButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String tip;
  final bool isRadioOn;

  final Widget child;

  const RadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.isRadioOn,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      isRadioOn: isRadioOn,
      child: child,
      onPressed: onPressed,
      tip: tip,
    );
  }
}

/// A raised hexagon shaped button with a cube on it.
/// It can act as a radio or a push button.
/// It can have an [Icon] too e.g. the plus sign for adding cubes.
/// The cube might be a whole cube or a slice of a cube.
class CubeRadioButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String tip;
  final bool isRadioOn;

  final IconData icon;
  final Slice slice;

  const CubeRadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.icon,
    required this.isRadioOn,
    required this.slice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioButton(
      isRadioOn: isRadioOn,
      child: _CubeAndIcon(slice: slice, icon: icon),
      onPressed: onPressed,
      tip: tip,
    );
  }
}

class _CubeAndIcon extends StatelessWidget {
  const _CubeAndIcon({
    Key? key,
    required this.slice,
    required this.icon,
  }) : super(key: key);

  final Slice slice;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(1, 1) * 12,
          child: Transform.scale(
            scale: 21,
            child: slice == Slice.whole
                ? const WholeUnitCube()
                : SliceUnitCube(slice: slice),
          ),
        ),
        Transform.translate(
          offset: -const Offset(1, 1) * assetIconSize / 2,
          child: Icon(icon, color: enabledIconColor),
        ),
      ],
    );
  }
}
