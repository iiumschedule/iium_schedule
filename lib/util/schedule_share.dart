import 'dart:convert';
import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ScheduleShare {
  /// Share schedule image to external apps. Currently support for Android & ios
  ///
  /// Even the plugin already support sharing files on Windows, I've tested but there is not
  /// image shown. My share target is Mail app. Anyway, looks like the target app in sharesheet
  /// is limited.
  static void share(String savedPath, String scheduleTitle) async {
    XFile xFilePath = XFile(savedPath);

    // To make the schedule title as caption, set either [subject] or [text]
    // On Android, set [text]
    // On Ios, set [subject] (when set text, the share sheet display two files)
    Share.shareXFiles(
      [xFilePath],
      subject: !Platform.isAndroid ? scheduleTitle : null,
      text: !Platform.isIOS ? scheduleTitle : null,
    );
  }

  /// TODO: Test with Firebase functions and use it (Not fully implemented yet)
  static void email(String savedPath, String scheduleTitle) async {
    Map<String, String> data = {"schedule_title": scheduleTitle};
    var request =
        http.MultipartRequest('POST', Uri.parse('https://file.io/?expires=1d'));
    request.fields.addAll(data);
    var multipartFile = await http.MultipartFile.fromPath(
      'schedule',
      savedPath,
      filename: 'schedule.png',
    );

    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();
    var jsonData = jsonDecode(respStr);
    print(jsonData);
    if (response.statusCode == 200) {
      // success
      print('Success');
    } else {
      // error
      print('Error');
    }
  }
}
