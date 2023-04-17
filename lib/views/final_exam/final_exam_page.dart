import 'package:flutter/material.dart';

import '../../model/imaluum_exam.dart';
import '../../util/relative_date.dart';
import '../scheduler/json_import_dialog.dart';
import 'exam_detail_page.dart';
import 'fe_imaluum_importer.dart';
import 'nearest_exam_card.dart';

class FinalExamPage extends StatefulWidget {
  const FinalExamPage({super.key});

  @override
  State<FinalExamPage> createState() => _FinalExamPageState();
}

class _FinalExamPageState extends State<FinalExamPage> {
  // TODO: add banner please bring along matric card and exam slip
  List<ImaluumExam>? finalExams;

  /// Sort and set the final exams from imported data
  /// Usually, it was already sorted from earliest to oldest from the Imaluum
  /// but, just in case
  void setFinalExams(List<ImaluumExam> exams) {
    exams.sort((a, b) => a.date.compareTo(b.date));
    print(exams);
    setState(() => finalExams = exams);
  }

  @override
  Widget build(BuildContext context) {
    print(finalExams != null);
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
                        return SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              onPressed: () async {
                                var data = await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FeImaluumImporter(),
                                  ),
                                );
                                var dataParsed = ImaluumExam.fromList(data);
                                setFinalExams(dataParsed);
                              },
                              child: const Text("Import from I-Ma'Luum"),
                            ),
                            SimpleDialogOption(
                              onPressed: () async {
                                Navigator.pop(context);
                                var data = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const JsonImportDialog();
                                    });
                                var dataParsed = ImaluumExam.fromList(data);
                                setFinalExams(dataParsed);
                              },
                              child: const Text("Import from JSON"),
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
            if (finalExams != null && finalExams!.isNotEmpty)
              Builder(builder: (context) {
                // filter to exams that are in the future
                var finalExams = this
                    .finalExams!
                    .where((element) => element.date.isAfter(DateTime.now()))
                    .toList();

                // latest upcoming final exams
                var upcomingExam = finalExams.first;

                // if the upcoming exam is in less than 2 weeks, show it
                if (upcomingExam.date.difference(DateTime.now()).inDays > 14) {
                  return const SizedBox.shrink();
                }

                return NearestExamCard(exam: upcomingExam);
              }),
            const SizedBox(height: 5),
            if (finalExams != null)
              ListView.builder(
                itemCount: finalExams!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(finalExams![index].title),
                    subtitle:
                        Text(RelativeDate.fromDate(finalExams![index].date)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamDetailPage(
                            exam: finalExams![index],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
