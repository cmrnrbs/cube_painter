// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:flutter/material.dart';

/// the inverse of UnitToScreen
Offset screenToUnit(Offset point, BuildContext context) =>
    (point - getScreenCenter(context) - getPanOffset(context, listen: false)) /
        getZoomScale(context);

/// translate to screen, then zoom
class UnitToScreen extends StatelessWidget {
  const UnitToScreen({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: getPanOffset(context, listen: true) + getScreenCenter(context),
      child: Transform.scale(
        scale: getZoomScale(context),
        child: child,
      ),
    );
  }
}
