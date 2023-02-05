import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'enums/subject_title_setting_enum.dart';
import 'hive_model/saved_daytime.dart';
import 'hive_model/saved_schedule.dart';
import 'hive_model/saved_subject.dart';
import 'providers/schedule_layout_setting_provider.dart';
import 'providers/schedule_maker_provider.dart';
import 'providers/schedule_notifier_provider.dart';
import 'providers/settings_provider.dart';
import 'util/migrate_hive_to_isar.dart';
import 'views/body.dart';

void main() async {
  await Hive.initFlutter('IIUM Schedule Data');
  Hive
    ..registerAdapter(SavedScheduleAdapter())
    ..registerAdapter(SavedSubjectAdapter())
    ..registerAdapter(SavedDaytimeAdapter())
    ..registerAdapter(SubjectTitleSettingAdapter());
  await Hive.openBox<SavedSchedule>(kHiveSavedSchedule);

  HttpOverrides.global = MyHttpOverrides();

  /**
   * For certain type of phones, the refresh rate is limited at 60fps. (i.e.: OnePlus phones)
   * This line of code instructs the OS to use the highest refresh rate available for this app.
   **/
  if (!kIsWeb && Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  await MigrateHiveToIsar.migrate();

  runApp(const MyApp());
}

/// Note: Some UI elements that are marked in asterisk (*) are only
/// appear in debug mode

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleLayoutSettingProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleNotifierProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleMakerProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: DynamicColorBuilder(builder:
          (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        // for platform that doesn't support dynamic color (eg. Android < 12)
        // use the colour generated from seed
        // avoid using ColorScheme.light() or ColorScheme.dark() directly
        return Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'IIUM Schedule',
            theme: ThemeData(
              colorScheme: lightColorScheme ??
                  ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true,
              fontFamily: 'Inter',
            ),
            darkTheme: ThemeData.dark().copyWith(
              // cupertinoOverrideTheme:
              //     const CupertinoThemeData(primaryColor: Color(0xFF23682B)),
              // textButtonTheme: TextButtonThemeData(
              //   style:
              //       TextButton.styleFrom(foregroundColor: Colors.purple.shade200),
              // ),
              // outlinedButtonTheme: OutlinedButtonThemeData(
              //   style: OutlinedButton.styleFrom(
              //       foregroundColor: Colors.purple.shade200),
              // ),
              useMaterial3: true,
              textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
              primaryTextTheme:
                  ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
              colorScheme: darkColorScheme ??
                  ColorScheme.fromSeed(
                      seedColor: Colors.orange, brightness: Brightness.dark),
            ),
            themeMode: settingsProvider.themeMode,
            home: const MyBody(),
          );
        });
      }),
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
