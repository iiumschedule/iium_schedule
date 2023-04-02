import 'package:recase/recase.dart';

class ExamDateTime {
  String? date;
  String? time;

  ExamDateTime({this.date, this.time});

  ExamDateTime.fromJson(Map<String, dynamic> json) {
    // Month need to be converted from 'JAN' to 'Jan'
    // otherwise it will throw format exception
    // ignore: no_leading_underscores_for_local_identifiers
    var _date = json["date"];
    var startIndex = _date.indexOf('-');
    var month =
        ReCase(_date.substring(startIndex + 1, startIndex + 4)).titleCase;
    // replace month to new month
    _date = _date.replaceAll(month.toUpperCase(), month);
    date = _date;
    time = json["time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["date"] = date;
    data["time"] = time;
    return data;
  }

  @override
  String toString() {
    return '$date $time';
  }
}
