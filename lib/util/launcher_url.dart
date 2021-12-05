import 'package:url_launcher/url_launcher.dart';

class LauncherUrl {
  LauncherUrl._();
  static void open(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
