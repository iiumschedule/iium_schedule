import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';

import 'shared/providers/schedule_layout_setting_provider.dart';
import 'shared/providers/schedule_maker_provider.dart';
import 'shared/providers/schedule_notifier_provider.dart';
import 'shared/providers/settings_provider.dart';
import 'shared/services/isar_service.dart';
import 'features/home/views/body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  /**
   * For certain type of phones, the refresh rate is limited at 60fps. (i.e.: OnePlus phones)
   * This line of code instructs the OS to use the highest refresh rate available for this app.
   **/
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  IsarService(); // initialize isar early when application starts

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
            // Replaced ThemeData.dark().copyWith(...) because the text is rendered
            // differently (i.e.: light mode will become slightly larger than dark mode)
            // so, to make it consistent, we do as below.
            // https://stackoverflow.com/a/68810576/13617136
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: darkColorScheme ??
                  ColorScheme.fromSeed(
                    seedColor: Colors.orange,
                    brightness: Brightness.dark,
                  ),
              useMaterial3: true,
              fontFamily: 'Inter',
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
/// https://github.com/iiumschedule/iium_schedule/issues/10
/// https://stackoverflow.com/a/61312927/13617136
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (_, String host, __) => host == 'albiruni.iium.edu.my';
  }
}
