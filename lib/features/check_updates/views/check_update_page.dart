
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../../shared/services/isar_service.dart';
import '../../../shared/utils/launcher_url.dart';
import '../service/update_service.dart';

/// Check for update for Android & Windows
/// Currently the is an known issue for Windows
/// version is not tally with pubspec.yaml
class CheckUpdatePage extends StatefulWidget {
  const CheckUpdatePage({super.key});

  @override
  State<CheckUpdatePage> createState() => _CheckUpdatePageState();
}

class _CheckUpdatePageState extends State<CheckUpdatePage> {
  late Version currentVersion;
  late UpdateService updateService;

  /// Since this method is importing dart:io, it cannot be used on the web
  /// Also, the web seems like unsuitable to have a check for updates feature
  /// Despite that there have bene multiple issuew with web pwa caching


  @override
  void initState() {
    super.initState();
    //construct service and inject isar service
    updateService = UpdateService( isarService: IsarService());

    // determine current version
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      currentVersion = Version.parse(packageInfo.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: FutureBuilder(
              future: updateService.checkLatestVersion(),
              builder: (context, AsyncSnapshot<Version> snapshot) {
                if (snapshot.hasData) {
                  if (currentVersion.compareTo(snapshot.data) < 0) {
                    var version = snapshot.data!.toString().split('+').first;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'New version available!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // add glow effect when in dark mode
                              if (Theme.of(context).brightness ==
                                  Brightness.dark)
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 90.0,
                                        spreadRadius: 70.0,
                                      ),
                                    ],
                                  ),
                                ),

                              Image.asset(
                                  'assets/icons/rocket-front-color.png'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'v$version',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Current: v${currentVersion.toString().split('+').first}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(height: 30),
                          MarkdownBody(
                            data:
                                'Upgrade the app the same way you installed it. [Learn more...](https://iiumschedule.iqfareez.com/downloads)',
                            onTapLink: (_, href, __) {
                              LauncherUrl.open(href!);
                            },
                          ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                LauncherUrl.open(
                                    'https://iiumschedule.iqfareez.com/changelog');
                              },
                              child: const Text('What\'s new?')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Update Later'))
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'This app is up to date!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Current version: v${currentVersion.toString().split('+').first}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(
                    'Sorry. Check update requets has failed.\n${snapshot.error}',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                } else {
                  return const Text('Checking update...');
                }
              }),
        ),
      ),
    );
  }
}
