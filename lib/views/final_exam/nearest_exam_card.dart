import 'package:flutter/material.dart';

import '../../model/imaluum_exam.dart';
import '../../util/relative_date.dart';

class NearestExamCard extends StatelessWidget {
  const NearestExamCard({super.key, required this.exam});

  final ImaluumExam exam;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      // color: Colors.black,
      color: Theme.of(context).colorScheme.primaryContainer,
      clipBehavior: Clip.hardEdge,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming exam (${RelativeDate.fromDate(exam.date)})',
                      style: const TextStyle(fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exam.title,
                      maxLines: 2,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text(exam.venue, maxLines: 2),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chair_alt),
                      const SizedBox(width: 2),
                      Text(
                        'Seat ${exam.seat}',
                        style: const TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.wb_twilight),
                      const SizedBox(width: 2),
                      Text(
                        exam.time.name.toUpperCase(),
                        // style: TextStyle(fontWeight: FontWeight.w100),
                        style: const TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
