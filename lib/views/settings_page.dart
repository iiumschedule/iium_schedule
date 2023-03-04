import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../providers/settings_provider.dart';
import '../util/my_ftoast.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settings, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            _ThemeSelectDialog(
              currentTheme: settings.themeMode,
              onThemeToggle: (themeMode) => settings.setThemeMode(themeMode),
            ),
            // const Spacer(),
            // TODO: Add developer mode feature, such as
            // zooming in webview: https://www.danrodney.com/blog/force-webpages-to-zoom/
            // course json autofill
            // clear isar db
            if (settings.developerMode)
              _DeveloperModeButton(
                isDeveloperModeEnabled: settings.developerMode,
                onDevModeEnable: () => settings.setDeveloperMode(true),
              ),
          ],
        ),
      );
    });
  }
}

class _ThemeSelectDialog extends StatelessWidget {
  const _ThemeSelectDialog(
      {Key? key, required this.onThemeToggle, required this.currentTheme})
      : super(key: key);

  final Function(ThemeMode) onThemeToggle;
  final ThemeMode currentTheme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("App Theme"),
      trailing: Text(currentTheme.name.titleCase),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => SimpleDialog(
            children: ThemeMode.values
                .map(
                  (e) => SimpleDialogOption(
                    child: Text(e.name.titleCase),
                    onPressed: () => onThemeToggle(e),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _DeveloperModeButton extends StatefulWidget {
  const _DeveloperModeButton(
      {Key? key,
      required this.isDeveloperModeEnabled,
      required this.onDevModeEnable})
      : super(key: key);

  final bool isDeveloperModeEnabled;
  final VoidCallback onDevModeEnable;

  @override
  State<_DeveloperModeButton> createState() => _DeveloperModeButtonState();
}

class _DeveloperModeButtonState extends State<_DeveloperModeButton> {
  int tapCount = 0;
  DateTime? lastTap;

  // to allow user to tap the button once after developer mode is enabled
  bool _isDeveloperModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              foregroundColor:
                  Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.6),
            ),
            onPressed: _isDeveloperModeEnabled
                ? null
                : () async {
                    if (widget.isDeveloperModeEnabled) {
                      MyFtoast.show(
                          context, 'Developer mode is already enabled');
                      setState(() => _isDeveloperModeEnabled = true);
                    }

                    var diff =
                        (lastTap ??= DateTime.now()).difference(DateTime.now());

                    // reset counter if taps are too far apart
                    if (diff.abs().inSeconds > 2) tapCount = 0;

                    lastTap = DateTime.now();
                    tapCount++;

                    if (tapCount > 4 && tapCount < 8) {
                      MyFtoast.show(
                          context, 'Tap ${8 - tapCount} more times to enable');
                    }

                    if (tapCount == 8) {
                      MyFtoast.show(context, 'Developer mode enabled');
                      widget.onDevModeEnable();
                      setState(() => _isDeveloperModeEnabled = true);
                    }
                  },
            child: const Text('(✿◠‿◠)'),
          ),
        ],
      ),
    );
  }
}
