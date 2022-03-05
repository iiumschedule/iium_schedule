import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'util/launcher_url.dart';
import 'views/course browser/browser.dart';
import 'views/scheduler/schedule_maker.dart';

class MyBody extends StatelessWidget {
  const MyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Colors.white,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                  LauncherUrl.open("https://iiumschedule.vercel.app/");
                  break;
                default:
              }
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.black87,
            ),
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text("Website"),
                value: "website",
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
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => ScheduleMaker()));
              },
            ),
          ),
          const SizedBox(height: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              child: Text(
                'Course Browser',
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => const Browser()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
