import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'body.dart';
import 'constants.dart';
import 'providers/saved_schedule_provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(kHiveSavedSchedule);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'IIUM Schedule (Preview)',
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
