import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'body.dart';
import 'constants.dart';
import 'model/saved_daytime.dart';
import 'model/saved_schedule.dart';
import 'model/saved_subject.dart';
import 'providers/schedule_layout_setting_provider.dart';

void main() async {
  await Hive.initFlutter('IIUM Schedule Data');
  Hive.registerAdapter(SavedScheduleAdapter());
  Hive.registerAdapter(SavedSubjectAdapter());
  Hive.registerAdapter(SavedDaytimeAdapter());
  await Hive.openBox<SavedSchedule>(kHiveSavedSchedule);

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleLayoutSettingProvider()),
      ],
      child: MaterialApp(
        title: 'IIUM JAJJAJJA (Preview)',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        darkTheme: ThemeData.dark().copyWith(
          cupertinoOverrideTheme:
              const CupertinoThemeData(primaryColor: Colors.purple),
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
