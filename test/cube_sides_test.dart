import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Testing calcHexagonOffsets()', () {
    const double x = root3over2;
    const double y = 0.5;

    const double delta = 0.00001;
    test('offset 0', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(x, -y) + unit;
      expect(offsets[0].dx, closeTo(offset.dx, delta));
      expect(offsets[0].dy, closeTo(offset.dy, delta));
    });
    test('offset 1', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(0.0, -1.0) + unit;
      expect(offsets[1].dx, closeTo(offset.dx, delta));
      expect(offsets[1].dy, closeTo(offset.dy, delta));
    });
    test('offset 2', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(-x, -y) + unit;
      expect(offsets[2].dx, closeTo(offset.dx, delta));
      expect(offsets[2].dy, closeTo(offset.dy, delta));
    });
    test('offset 3', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(-x, y) + unit;
      expect(offsets[3].dx, closeTo(offset.dx, delta));
      expect(offsets[3].dy, closeTo(offset.dy, delta));
    });
    test('offset 4', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(0.0, 1.0) + unit;
      expect(offsets[4].dx, closeTo(offset.dx, delta));
      expect(offsets[4].dy, closeTo(offset.dy, delta));
    });
    test('offset 5', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(x, y) + unit;
      expect(offsets[5].dx, closeTo(offset.dx, delta));
      expect(offsets[5].dy, closeTo(offset.dy, delta));
    });
  });

  group('Crop', () {
    test('c', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.c);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[2][0]));
      expect(
          equals5(sidesAndUnitOffsets[2][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('r', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.r);

      expect(Side.t, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);
    });

    test('ur', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ur);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('ul', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ul);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('l', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.l);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dl', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dl);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dr', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dr);

      // out(sidesAndUnitOffsets[0][1]);
      // out(sidesAndUnitOffsets[1][1]);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });
  });
}
