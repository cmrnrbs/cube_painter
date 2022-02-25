import 'dart:convert';

import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  const testPosition = Position(1, 2);
  const testSlice = Slice.dl;

  const testCube = CubeInfo(center: testPosition, slice: testSlice);

  //TOOO values.byName('
  group('json', () {
    const testJson = '{"center":{"x":1,"y":2},"sliceIndex":5}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);

      final newCube = CubeInfo.fromJson(map);
      expect(testCube, equals(newCube));
    });

    test('save', () {
      String newJson = jsonEncode(testCube);
      expect(testJson, equals(newJson));
    });
  });
}
