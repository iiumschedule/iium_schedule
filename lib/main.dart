import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'enums/subject_title_setting_enum.dart';
import 'hive_model/gh_responses.dart';
import 'hive_model/saved_daytime.dart';
import 'hive_model/saved_schedule.dart';
import 'hive_model/saved_subject.dart';
import 'providers/schedule_layout_setting_provider.dart';
import 'providers/schedule_notifier_provider.dart';
import 'util/migrate_hive_to_isar.dart';
import 'views/body.dart';

void main() async {
  await Hive.initFlutter('IIUM Schedule Data');
  Hive
    ..registerAdapter(SavedScheduleAdapter())
    ..registerAdapter(SavedSubjectAdapter())
    ..registerAdapter(SavedDaytimeAdapter())
    ..registerAdapter(GhResponsesAdapter())
    ..registerAdapter(SubjectTitleSettingAdapter());
  await Hive.openBox<SavedSchedule>(kHiveSavedSchedule);
  await Hive.openBox<GhResponses>(kHiveGhResponse);

  HttpOverrides.global = MyHttpOverrides();

  await MigrateHiveToIsar.migrate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleLayoutSettingProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleNotifierProvider()),
      ],
      child: MaterialApp(
        title: 'IIUM Schedule',
        theme: ThemeData(primarySwatch: Colors.purple),
        darkTheme: ThemeData.dark().copyWith(
          cupertinoOverrideTheme:
              const CupertinoThemeData(primaryColor: Colors.purple),
          textButtonTheme: TextButtonThemeData(
            style:
                TextButton.styleFrom(foregroundColor: Colors.purple.shade200),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple.shade200),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MyBody(),
      ),
    );
  }
}

/// To avoid invalid Cert Error
/// https://github.com/iqfareez/iium_schedule/issues/10
/// https://stackoverflow.com/a/61312927/13617136
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (_, String host, __) => host == 'albiruni.iium.edu.my';
  }
}
