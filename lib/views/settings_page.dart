import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settingsProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text("App Theme"),
              trailing: Text(settingsProvider.themeMode.name.titleCase),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => SimpleDialog(
                    children: ThemeMode.values
                        .map(
                          (e) => SimpleDialogOption(
                            child: Text(e.name.titleCase),
                            onPressed: () => settingsProvider.setThemeMode(e),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }
}

class ThemeSelectDialog extends StatelessWidget {
  const ThemeSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
