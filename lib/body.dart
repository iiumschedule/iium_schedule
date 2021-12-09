import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'util/launcher_url.dart';
import 'views/course browser/browser.dart';
import 'views/scheduler/input_course.dart';

class MyBody extends StatelessWidget {
  const MyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  );
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
              child: const Text('Schedule Maker'),
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const InputCourse()));
              },
            ),
          ),
          const SizedBox(height: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              child: const Text('Browser'),
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
