import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          // colors: <Color>[Colors.red, Colors.black],
          colors: <Color>[buttonColor, backgroundColor],
          // colors: <Color>[getColor(Side.t), getColor(Side.br)],
        ),
      ),
    );
  }
}
