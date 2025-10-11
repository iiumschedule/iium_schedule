import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../../shared/extensions/int_extension.dart';

/// Widget to tabulate the Day with time session for subjects
class DayTimeTableWidget extends StatelessWidget {
  const DayTimeTableWidget({super.key, required this.dayTimes});
  final List<DayTime?> dayTimes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showBottomBorder: true,
      columns: const ["Day", "Time"]
          .map(
            (e) => DataColumn(
                label: Expanded(
              child: Text(
                e,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )),
          )
          .toList(),
      headingRowHeight: 32,
      rows: dayTimes
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  SelectableText(ReCase(e!.day.englishDay()).titleCase),
                ),
                DataCell(
                  SelectableText('${e.startTime} - ${e.endTime}'),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}
