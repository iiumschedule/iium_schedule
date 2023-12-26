import 'package:url_launcher/url_launcher.dart';

class LauncherUrl {
  LauncherUrl._();
  static void open(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
