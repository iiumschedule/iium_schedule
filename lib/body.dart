import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

import 'providers/saved_schedule_provider.dart';
import 'saved_schedule_selector.dart';
import 'util/launcher_url.dart';
import 'views/course browser/browser.dart';
import 'views/scheduler/input_scope.dart';
import 'views/scheduler/schedule_maker.dart';

class MyBody extends StatelessWidget {
  const MyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    configureQuickAction(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show material banner if app is launched from schedule.iium.online
      // TODO: Remember to just rmeove this implementation
      // after the domain expires
      if (Uri.base.host == 'schedule.iium.online') {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: const Text(
              "The domain 'schedule.iium.online' will expire soon in September. Please use 'iiumschedule.iqfareez.com/web' instead."),
          actions: [
            TextButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(
                          text: 'iiumschedule.iqfareez.com/web'))
                      .then((value) => Fluttertoast.showToast(msg: 'Copied'));
                },
                child: const Text('Copy new URL')),
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: const Text('OK')),
          ],
        ));
      }
    });
    var textStyle = TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Colors.white,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: Theme.of(context).brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.grey.withAlpha(90))
            : SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.grey.withAlpha(90)),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        title: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.version);
              } else {
                return const SizedBox.shrink();
              }
            }),
        actions: [
          PopupMenuButton(
            tooltip: "Menu",
            onSelected: (value) async {
              switch (value) {
                case "website":
                  LauncherUrl.open("https://iiumschedule.iqfareez.com/");
                  break;
                default:
              }
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Theme.of(context).iconTheme.color!,
            ),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "website",
                child: Text("Website"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              child: Text(
                'Schedule Maker',
                style: textStyle,
              ),
              onPressed: () async {
                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                await Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => ScheduleMaker()));

                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
              },
            ),
          ),
          const SizedBox(height: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              child: Text(
                'Course Browser',
                style: textStyle,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => const Browser()));
              },
            ),
          ),
          const Divider(),
          Consumer<SavedScheduleProvider>(
            builder: (_, value, __) {
              if (value.data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Your saved schedule will appear here",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                );
              }
              if (value.data.isNotEmpty) {
                return Column(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: CupertinoButton(
                        child: Text(
                          'Saved Schedule',
                          style: textStyle,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (_) => const SavedScheduleSelector()));
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

void configureQuickAction(BuildContext context) {
  const QuickActions quickActions = QuickActions();

  // callback for quick actions
  quickActions.initialize((shortcutType) {
    if (shortcutType == 'action_browser') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Browser()));
    }
    if (shortcutType == 'action_create') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const InputScope()));
    }

    if (shortcutType == 'action_view_saved') {
      print("hheehe");
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SavedScheduleSelector()));
    }
  });
  // setup quick actions
  quickActions.setShortcutItems(
    <ShortcutItem>[
      const ShortcutItem(
          type: 'action_browser',
          localizedTitle: 'Browse course',
          icon: 'ic_shortcut_search_outline'),
      const ShortcutItem(
          type: 'action_create',
          localizedTitle: 'Create new',
          icon: 'ic_shortcut_plus_square_outline'),
      const ShortcutItem(
          type: 'action_view_saved',
          localizedTitle: 'View saved schedule',
          icon: 'ic_shortcut_layout_outline')
    ],
  );
}
