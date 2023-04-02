import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/exam_date_time.dart';

class HttpFetcher {
  /// Fetch the final exam date and time. It is sorted already I think due to how it
  /// fetched by the API server
  static Future<ExamDateTime> fetchExam(
      String courseCode, String session, int semester) async {
    var response = await http.get(Uri.parse(
        'https://albiruni.up.railway.app/exams/$courseCode?sesssion=$session&semester=$semester'));
    if (response.statusCode == 200) {
      return ExamDateTime.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
