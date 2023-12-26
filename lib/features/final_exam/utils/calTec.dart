// import 'dart:io';
// import 'dart:convert';
// import 'package:albiruni/albiruni.dart';
// import 'package:ical/serializer.dart';

// void main(List<String> args) async {
//   print("hello world");
//   var arr = ['AERO1121', 'AERO1322', 'AERO2128'];
//   Albiruni albiruni = Albiruni(semester: 2, session: "2022/2023");
//   var mappedArr = arr
//       .map((e) => albiruni.fetch("ENGIN", course: e.toAlbiruniFormat()))
//       .toList();
//   var result = await Future.wait(mappedArr);
//   result.map((e) => print(e)).toList();
//   if(result.isNotEmpty){
//     var class_appointments = result.map((e) => GenerateCalData(e)).toList();
//     var serialized_calendar_data = class_appointments.map((e) => e.serialize()).toList();
//     var file = new File('test.ics');
//     var _ = serialized_calendar_data.map((e) => file.writeAsStringSync(e, mode: FileMode.append)).toList();
//   }
 
// }

// ICalendar GenerateCalData(List<Subject> item) {
//   ICalendar cal = ICalendar();
//   //IF SUBJECT HAS MORE THAN TWO DATES
//   if (item.single.dayTime.length > 1) {
//     for (var element in item.single.dayTime) {
//       cal.addElement(
//         IEvent(
//           uid: 'test@example.com',
//           start: DateTime(2023,3,6,),
//           url: 'https://pub.dartlang.org/packages/srt_parser',
//           status: IEventStatus.CONFIRMED,
//           location: 'IIUM',
//           description:
//               'COURSE TITLE:${item.single.title}\nCREDIT HOUR:${item.single.chr}\nVENUE:${item.single.venue}\nLECTURERS:\n${item.single.lect.map((e) => print(e+"\n"))}',
//           summary: item.single.code,
//           //FOR RECURRENCE UNTIL DATE, ASK INPUT FROM USER
//           rrule: IRecurrenceRule(
//               frequency: IRecurrenceFrequency.WEEKLY,
//               untilDate: DateTime(2023, 6, 6)),
//         ),
//       );
//     }
//     return cal;}
    
//   cal.addElement(
//     IEvent(
//       uid: 'test@example.com',
//       start: DateTime(
//         2023,
//         3,
//         6,
//       ),
//       url: 'https://pub.dartlang.org/packages/srt_parser',
//       status: IEventStatus.CONFIRMED,
//       location: 'IIUM',
//       description:
//           'COURSE TITLE:${item.single.title}\nCREDIT HOUR:${item.single.chr}\nVENUE:${item.single.venue}',
//       summary: item.single.code,
//       rrule: IRecurrenceRule(
//           frequency: IRecurrenceFrequency.WEEKLY,
//           untilDate: DateTime(2023, 6, 6)),
//     ),
//   );
//   return cal;
// }
