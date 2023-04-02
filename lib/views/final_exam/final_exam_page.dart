import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/exam_date_time.dart';
import '../../services/isar_service.dart';
import '../../util/http_fetcher.dart';

class FinalExamPage extends StatefulWidget {
  const FinalExamPage({super.key});

  @override
  State<FinalExamPage> createState() => _FinalExamPageState();
}

class _FinalExamPageState extends State<FinalExamPage> {
  // TODO: add banner please bring along matric card and exam slip
  List<String>? courseCodes;
  @override
  Widget build(BuildContext context) {
    print(courseCodes);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Exam'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'add-exam':
                  print('add exam');
                  break;
                case 'import-exams':
                  showDialog(
                      context: context,
                      builder: (_) {
                        final IsarService isarService = IsarService();
                        var schedules = isarService.getAllSchedule();
                        return SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              onPressed: () {},
                              child: const Text("Import from I-Ma'Luum"),
                            ),
                            const Divider(),
                            if (schedules.isEmpty)
                              const SimpleDialogOption(
                                child: Text('No saved schedule to import'),
                              ),
                            for (var schedule in schedules)
                              SimpleDialogOption(
                                onPressed: () async {
                                  schedule.subjects.loadSync();

                                  setState(() {
                                    courseCodes = schedule.subjects
                                        .map((e) => e.code)
                                        .toList();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Import from ${schedule.title!}'),
                              ),
                          ],
                        );
                      });
                  break;
                default:
              }
            },
            icon: const Icon(Icons.add),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add-exam',
                child: Text('Add exam'),
              ),
              const PopupMenuItem(
                value: 'import-exams',
                child: Text('Import exams'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Upcoming exam (In 1 day)',
                                style: TextStyle(fontWeight: FontWeight.w100),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "MANU 4313",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '9.00 am',
                                // style: TextStyle(fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),
                        // TODO: This banner is just mock as for now
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.chair_alt),
                                const Text('194'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const Text('Main Audi 3'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (courseCodes != null)
              for (var courseCode in courseCodes!)
                FutureBuilder<ExamDateTime>(
                    future: HttpFetcher.fetchExam(courseCode, '2022/2023', 1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          leading: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        courseCodes!.remove(courseCode);
                        return const SizedBox.shrink();
                      }

                      final format = DateFormat('dd-MMM-yy h.mm a');
                      final dateTime = format.parse(snapshot.data!.toString());

                      return ListTile(
                        title: Text(courseCode.toUpperCase()),
                        subtitle: Text(
                            DateFormat('EEE, d MMMM yyyy').format(dateTime)),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
