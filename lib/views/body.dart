import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quick_actions/quick_actions.dart';

import '../constants.dart';
import '../hive_model/saved_schedule.dart';
import '../util/launcher_url.dart';
import '../util/my_ftoast.dart';
import 'check_update_page.dart';
import 'course browser/browser.dart';
import 'saved_schedule_selector.dart';
import 'scheduler/schedule_maker_entry.dart';

class MyBody extends StatelessWidget {
  const MyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    configureQuickAction(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show material banner notice about this web version
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: MarkdownBody(
            data:
                "This web version has **not been updated** for quite a while now. Consider using [Windows/Android/MacOS](https://iiumschedule.iqfareez.com/downloads) app instead to enjoy the latest & greatest features and improvements.",
            onTapLink: (_, href, __) => LauncherUrl.open(href!)),
        actions: [
          TextButton(
              onPressed: () {
                LauncherUrl.open(
                    'https://github.com/iqfareez/iium_schedule/issues/60');
              },
              child: const Text('Learn more')),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Understood')),
        ],
      ));
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
        // systemOverlayStyle: SystemUiOverlayStyle.light
        //     .copyWith(statusBarColor: Colors.transparent),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        titleSpacing: 0,
        centerTitle:
            false, // prevent the version render at the center of the screen for iphone/ipad
        titleTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        title: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
              return TextButton(
                // don't want to be as attractive like a button
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.caption,
                    foregroundColor:
                        Theme.of(context).textTheme.caption!.color),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const _SimpleAboutDialog(),
                  );
                },
                child: Text(
                  'v${snapshot.data?.version}',
                ),
              );
            }),
        actions: [
          PopupMenuButton(
            tooltip: "Menu",
            onSelected: (value) async {
              switch (value) {
                case "website":
                  LauncherUrl.open("https://iiumschedule.iqfareez.com/");
                  break;
                case "feedback":
                  LauncherUrl.open(
                      "https://iiumschedule.iqfareez.com/feedback");
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
              PopupMenuItem(
                value: "feedback",
                child: Text("Send feedback"),
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
            cursor:
                kIsWeb ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: CupertinoButton(
              child: Text(
                'Schedule Maker',
                style: textStyle,
              ),
              onPressed: () async {
                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                await Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => ScheduleMakerEntry()));

                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
              },
            ),
          ),
          const SizedBox(height: 5),
          MouseRegion(
            cursor:
                kIsWeb ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
          ValueListenableBuilder(
              valueListenable:
                  Hive.box<SavedSchedule>(kHiveSavedSchedule).listenable(),
              builder: (context, Box<SavedSchedule> box, _) {
                if (box.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Your saved schedule will appear here",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  );
                }
                return Column(
                  children: [
                    MouseRegion(
                      cursor: kIsWeb
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
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
              }),
        ],
      ),
    );
  }
}

class _SimpleAboutDialog extends StatelessWidget {
  const _SimpleAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const SimpleDialogOption(child: Text('About')),
        children: [
          const SimpleDialogOption(
            child: Text(
                'This app enables students to make & check their schedules, specially tailoired for IIUM Students.'),
          ),
          SimpleDialogOption(
            child: const Text('\u00a9 2022 Muhammad Fareez'),
            onPressed: () => LauncherUrl.open('https://iqfareez.com'),
          ),
          SimpleDialogOption(
            child: const Text('Available on Android/Windows/Web'),
            onPressed: () =>
                LauncherUrl.open('https://iiumschedule.iqfareez.com/downloads'),
          ),
          const Divider(),
          if (!kIsWeb) // don't show this option when on web
            SimpleDialogOption(
              child: const Text('Check for updates...'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const CheckUpdatePage(),
                  ),
                );
              },
            ),
          SimpleDialogOption(
            onPressed: () async {
              final BuildContext _context = context;
              var deviceInfo = await DeviceInfoPlugin().deviceInfo;
              var packageInfo = await PackageInfo.fromPlatform();

              String deviceInfoData;

              // check device info is android, windows or web
              if (deviceInfo is AndroidDeviceInfo) {
                var androidVersion = deviceInfo.version;
                // eg: Android 11 (30)
                deviceInfoData =
                    'Android ${androidVersion.release} (${androidVersion.sdkInt})';
              } else if (deviceInfo is WindowsDeviceInfo) {
                var windowsVersion = deviceInfo.displayVersion;
                // eg: Windows 22H2
                deviceInfoData = 'Windows $windowsVersion';
              } else {
                // on web
                var browserName = (deviceInfo as WebBrowserInfo).browserName;
                var platform = deviceInfo.platform;
                // eg: Web chrome Win32
                deviceInfoData = 'Web ${browserName.name} $platform';
              }

              final data = {
                'device': deviceInfoData,
                'version': packageInfo.version,
              };

              await Clipboard.setData(
                  ClipboardData(text: data.values.join('; ')));
              MyFtoast.show(_context, 'Copied to clipboard');
            },
            child: const Text('Copy debug info'),
          ),
          SimpleDialogOption(
            child: const Text('View licenses'),
            onPressed: () => showLicensePage(
                context: context,
                applicationLegalese: '\u{a9} 2022 Muhammad Fareez'),
          ),
        ]);
  }
}

/// COnfigure the quick action if running on Android only
void configureQuickAction(BuildContext context) {
  // check if running on Android only
  if (kIsWeb || !Platform.isAndroid) return;

  const QuickActions quickActions = QuickActions();

  // callback for quick actions
  quickActions.initialize((shortcutType) {
    if (shortcutType == 'action_browser') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Browser()));
    }
    if (shortcutType == 'action_create') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ScheduleMakerEntry()));
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
