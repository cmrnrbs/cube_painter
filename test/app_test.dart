import 'package:cube_painter/background.dart';
import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/grid.dart';
import 'package:cube_painter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Run app', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());

    expect(find.byType(CubePainterApp), findsOneWidget);
    expect(find.byType(Background), findsOneWidget);

    expect(find.byType(Grid), findsOneWidget);
    expect(find.byType(Brush), findsOneWidget);


    // await tester.tap(find.byType(Checkbox));
    // await tester.pump();

//    find.descendant(of: find.text('Tab 1'), matching: find.byType(RichText));

//    tester.element(find.byType(MyChildWidget))
    //      .ancestorWidgetOfExactType(MyParentWidget);
  });
}
