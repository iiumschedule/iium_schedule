import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../util/extensions.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen(this.subject, {Key? key}) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject details'),
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline),
            tooltip: "Add this subject to favourite",
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            tooltip: "Share this subject",
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SelectableText(
                  subject.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextBubble(
                    text: subject.code,
                    icon: Icons.label_outline,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextBubble(
                    text:
                        'Chr ${subject.chr.toString().removeTrailingDotZero()}',
                    icon: Icons.class_outlined,
                    backgroundColor: Colors.deepPurple,
                  ),
                  TextBubble(
                    text: 'Section ${subject.sect}',
                    icon: Icons.group_outlined,
                    backgroundColor: Colors.deepOrange,
                  ),
                ],
              ),
              const Text(
                '\nSession(s)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              DayTimeTable(subject.dayTime),
              const Text(
                '\nLecturer(s)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...List.generate(
                subject.lect.length,
                (index) => Text(
                    '${index + 1}. ${ReCase(subject.lect[index]).titleCase}'),
              ),
              const Text(
                '\nVenue',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(subject.venue ?? '-')
            ],
          ),
        ),
      ),
    );
  }
}

class DayTimeTable extends StatelessWidget {
  const DayTimeTable(
    this.dayTimes, {
    Key? key,
  }) : super(key: key);

  final List<DayTime?> dayTimes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowHeight: 32,
      showBottomBorder: true,
      columns: const ["Day", "Time"]
          .map(
            (e) => DataColumn(
                label: Expanded(
                    child: Text(
              e,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ))),
          )
          .toList(),
      headingRowHeight: 32,
      rows: dayTimes
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  Text(ReCase(e!.englishDay()).titleCase),
                ),
                DataCell(
                  Text('${e.startTime} - ${e.endTime}'),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}

class TextBubble extends StatelessWidget {
  const TextBubble({
    Key? key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Chip(
        avatar: Icon(icon, size: 18),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        backgroundColor: backgroundColor.withAlpha(40),
        label: Text(
          text,
        ),
      ),
    );
  }
}
