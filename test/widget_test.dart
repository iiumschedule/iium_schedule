// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iium_schedule/constants.dart';
import 'package:iium_schedule/enums/subject_title_setting_enum.dart';
import 'package:iium_schedule/hive_model/saved_daytime.dart';
import 'package:iium_schedule/hive_model/saved_schedule.dart';
import 'package:iium_schedule/hive_model/saved_subject.dart';
import 'package:iium_schedule/main.dart';

void main() async {
  setUp(() async {
    await Hive.initFlutter('IIUM Schedule Data');
    Hive
      ..registerAdapter(SavedScheduleAdapter())
      ..registerAdapter(SavedSubjectAdapter())
      ..registerAdapter(SavedDaytimeAdapter())
      ..registerAdapter(SubjectTitleSettingAdapter());
    await Hive.openBox<SavedSchedule>(kHiveSavedSchedule);
  });

  testWidgets('Smoke test Homepage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the buttons are there
    expect(
        find.widgetWithText(CupertinoButton, 'Schedule Maker'), findsOneWidget);
    expect(
        find.widgetWithText(CupertinoButton, 'Course Browser'), findsOneWidget);
  });
}
