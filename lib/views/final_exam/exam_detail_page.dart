import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/imaluum_exam.dart';
import 'seat_number_card.dart';

class ExamDetailPage extends StatelessWidget {
  const ExamDetailPage({super.key, required this.exam});

  final ImaluumExam exam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam ${exam.courseCode}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            ListTile(
              title: Text(exam.title, style: const TextStyle(fontSize: 24)),
              leading: Icon(
                Icons.book,
                size: 38,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              subtitle: const Text("Date & Time"),
              title: Row(
                children: [
                  Text(DateFormat('d MMM yy').format(exam.date),
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      exam.time.name.toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                ],
              ),
              leading: Icon(
                Icons.today_outlined,
                size: 38,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              subtitle: const Text("Venue"),
              title: Text(exam.venue, style: const TextStyle(fontSize: 24)),
              leading: Icon(
                Icons.meeting_room,
                size: 38,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
            const Spacer(),
            SeatNumberCard(exam.seat.toString()),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
