import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/scheduler/input_scope.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'util/launcher_url.dart';
import 'views/course browser/browser.dart';

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
        actions: [
          PopupMenuButton(
            tooltip: "Menu",
            onSelected: (value) async {
              switch (value) {
                case "about":
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showAboutDialog(
                      context: context,
                      applicationVersion: packageInfo.version,
                      applicationLegalese: "2021 \u00a9 Fareez Iqmal");
                  break;
                case "github":
                  LauncherUrl.open("https://github.com/iqfareez/iium_schedule");
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
                child: Text("GitHub"),
                value: "github",
              ),
              PopupMenuItem(
                child: Text("About"),
                value: "about",
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
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const InputScope()));
              },
            ),
          ),
          const SizedBox(height: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              child: Text(
                'Browser',
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
