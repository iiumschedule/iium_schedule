import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

import 'package:flutter_timetable_view_demo/main.dart';

void main() {
  testWidgets('Timetable View displays', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app title is displayed
    expect(find.text('Flutter Timetable View Demo'), findsWidgets);

    // Verify track names are displayed
    expect(find.text('Track A'), findsOneWidget);
    expect(find.text('Track B'), findsOneWidget);
    expect(find.text('Track C'), findsOneWidget);

    // Verify TimetableView widget exists
    expect(find.byType(TimetableView), findsOneWidget);
  });
}
