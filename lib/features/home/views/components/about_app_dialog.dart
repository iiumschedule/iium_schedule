import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/utils/launcher_url.dart';
import '../../../../shared/utils/my_ftoast.dart';
import '../../../check_updates/views/check_update_page.dart';
import '../../services/home_service.dart';

/// The app about dialog
class AboutAppDialog extends StatefulWidget {
  const AboutAppDialog({super.key});

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  final HomeService homeService = HomeService();

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
              'This app enables students to create and check their schedules, specifically tailored for IIUM students.'),
        ),
        SimpleDialogOption(
          child: const Text(
            '\u00a9 2026 Muhammad Fareez',
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
          child: const Text('Available on Android/Windows/MacOS'),
          onPressed: () =>
              LauncherUrl.open('https://iiumschedule.iqfareez.com/downloads'),
        ),
        const Divider(),
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
            var packageInfo = await homeService.getPackageInfo();
            var flutterVersion = FlutterVersion.version;

            final stringBuffer = StringBuffer();
            stringBuffer.writeln('Device: $deviceInfoData');
            stringBuffer.writeln('App Version: $packageInfo');
            stringBuffer.writeln('Flutter Version: $flutterVersion');
            var debugInfo = stringBuffer.toString();

            await Clipboard.setData(ClipboardData(text: debugInfo));
            if (!context.mounted) return;
            MyFtoast.show(context, 'Copied to clipboard');
          },
          child: const Text('Copy debug info'),
        ),
        SimpleDialogOption(
          child: const Text('View licenses'),
          onPressed: () => showLicensePage(
              context: context,
              applicationLegalese: '\u{a9} 2022-2026 Muhammad Fareez',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/logo/app-logo.png',
                  width: 68,
                  height: 68,
                ),
              )),
        ),
      ],
    );
  }
}
