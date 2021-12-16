import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIUM Schedule (Preview)',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyBody(),
      darkTheme: ThemeData.dark().copyWith(
        cupertinoOverrideTheme:
            const CupertinoThemeData(primaryColor: Colors.purple),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
