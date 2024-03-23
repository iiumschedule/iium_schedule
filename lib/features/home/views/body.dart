import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../../isar_models/saved_schedule.dart';
import '../../../shared/services/isar_service.dart';
import '../../../shared/utils/launcher_url.dart';
import '../../../shared/utils/my_ftoast.dart';
import '../../check_updates/views/check_update_page.dart';
import '../../course browser/browser.dart';

import '../../final_exam/views/final_exam_page.dart';
import '../../schedule_maker/views/schedule_maker_entry.dart';
import '../../schedule_viewer/saved/views/saved_schedule_layout.dart';
import '../../settings/view/settings_page.dart';
import '../services/home_service.dart';

class MyBody extends StatefulWidget {
  const MyBody({super.key});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  final IsarService _isarService = IsarService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // page index (wether it is scheduke of course browser)
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    configureQuickAction(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.grey.withAlpha(90),
          systemNavigationBarColor:
              Theme.of(context).colorScheme.surfaceVariant,
        ),
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
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    foregroundColor:
                        Theme.of(context).colorScheme.onBackground),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _SimpleAboutDialog(),
                  );
                },
                child: Text(
                  'v${snapshot.data?.version}',
                ),
              );
            }),
        actions: [
          PopupMenuButton<String>(
            elevation: 1.0,
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
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
                case "settings":
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()));
                  break;
                default:
              }
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "settings",
                child: Text("Settings"),
              ),
              PopupMenuDivider(),
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
                onDestinationSelected: (value) {
                  setState(() => selectedIndex = value);
                },
                extended: MediaQuery.of(context).size.width > 800,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: Text('Schedule'),
                  ),
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.book_rounded),
                    icon: Icon(Icons.book_outlined),
                    label: Text('Course Browser'),
                  ),
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.history_edu_rounded),
                    icon: Icon(Icons.history_edu_outlined),
                    label: Text('Final Exam'),
                  )
                ],
                selectedIndex: selectedIndex),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'IIUM Schedule',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          StreamBuilder(
                            stream: _isarService.listenToAllSchedulesChanges(),
                            builder: (_,
                                AsyncSnapshot<List<SavedSchedule>> snapshot) {
                              var data = snapshot.data ?? [];
                              // check the current size of AnimatedList
                              // if different that data.length, rebuild the list
                              if (_listKey.currentState != null &&
                                  _listKey.currentState!.widget
                                          .initialItemCount <
                                      data.length) {
                                _listKey.currentState!
                                    .insertItem(data.length - 1);
                              }

                              if (data.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    "Your saved schedule will appear here",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                );
                              }

                              return AnimatedList(
                                key: _listKey,
                                initialItemCount: data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index, animation) {
                                  var item = data[index];
                                  return _CardItem(
                                    item: item,
                                    animation: animation,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) => SavedScheduleLayout(
                                            id: item.id!,
                                          ),
                                        ),
                                      );

                                      SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.edgeToEdge);
                                    },
                                    onDeleteAction: () async {
                                      var res = await showDialog(
                                        context: context,
                                        builder: (_) => const _DeleteDialog(),
                                      );

                                      if (res ?? false) {
                                        // ignore: use_build_context_synchronously
                                        AnimatedList.of(context).removeItem(
                                            index,
                                            (context, animation) => _CardItem(
                                                  item: item,
                                                  animation: animation,
                                                ));
                                        await _isarService
                                            .deleteSchedule(item.id!);
                                        setState(() {}); // refresh list
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Browser(),
                    const FinalExamPage(),
                  ][selectedIndex]),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => ScheduleMakerEntry()));
              },
              icon: const Icon(Icons.add),
              label: const Text('Create'),
            )
          : null,

      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? NavigationBar(
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectedIndex: selectedIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Schedule',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.book_rounded),
                  icon: Icon(Icons.book_outlined),
                  label: 'Course Browser',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.history_edu_rounded),
                  icon: Icon(Icons.history_edu_outlined),
                  label: 'Final Exam',
                )
              ],
            )
          : null,
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem(
      {required this.item,
      required this.animation,
      this.onTap,
      this.onDeleteAction});

  final SavedSchedule item;
  final Animation<double> animation;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteAction;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(item.lastModified);
    return ScaleTransition(
      scale: animation,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondaryContainer,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            item.title!,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          )),
                          if (kDebugMode) Text('Item ID: ${item.id}* '),
                          Text(
                            'Modified on $formattedDate',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: onDeleteAction,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        icon: const Icon(Icons.delete))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class _SimpleAboutDialog extends StatelessWidget {
  final HomeService homeService = HomeService();
  _SimpleAboutDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          const SimpleDialogOption(
            child: Text(
                'This app enables students to make & check their schedules, specially tailoired for IIUM Students.'),
          ),
          SimpleDialogOption(
            child: const Text(
              '\u00a9 2024 Muhammad Fareez',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () => LauncherUrl.open('https://iqfareez.com'),
          ),
          SimpleDialogOption(
            child: const Text('Thanks to awesome contributors!'),
            onPressed: () => LauncherUrl.open(
                'https://github.com/iqfareez/iium_schedule/#contributors'),
          ),
          const Divider(),
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
              var deviceInfoData = await homeService.getDeviceInfo();
              var packageInfo = await PackageInfo.fromPlatform();

              final data = {
                'device': deviceInfoData,
                'version': packageInfo.version,
              };

              await Clipboard.setData(
                  ClipboardData(text: data.values.join('; ')));
              MyFtoast.show(context, 'Copied to clipboard');
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

/// Configure the quick action if running on Android only
/// TODO: Add recent schedules https://github.com/iqfareez/iium_schedule/issues/43
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
    ],
  );
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Are you sure?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Deleted schedule will be gone forever!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              elevation: 0),
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: Text(
            "Delete",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      ],
    );
  }
}
