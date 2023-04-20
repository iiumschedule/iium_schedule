import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../isar_models/final_exam.dart';
import '../../services/isar_service.dart';
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
  final IsarService isar = IsarService();
  List<FinalExam>? finalExams;

  /// Sort and set the final exams from imported data
  /// Usually, it was already sorted from earliest to oldest from the Imaluum
  /// but, just in case
  void _setFinalExams(List<FinalExam> exams) {
    exams.sort((a, b) => a.date.compareTo(b.date));
    // filter to exams that are in the future
    exams =
        exams.where((element) => element.date.isAfter(DateTime.now())).toList();

    // The list is empty when the exams are in the past, so we can just set to the
    // empty list
    if (exams.isEmpty) {
      setState(() => finalExams = List.empty());
    }
    // clear existing and save new to db
    isar.clearAllExams();
    isar.saveFinalExams(exams);

    // refresh UI
    setState(() => finalExams = exams);
  }

  void _openImporter(Widget widget) async {
    var data = await showDialog(
        context: context,
        builder: (_) {
          return widget;
        });
    if (data == null) return;
    var dataParsed = FinalExam.fromList(data);
    _setFinalExams(dataParsed);
  }

  void loadSavedExams() async {
    var savedExams = await isar.getFinalExams();
    print('called');
    if (savedExams != null) {
      setState(() {
        finalExams = savedExams;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSavedExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Exam'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'delete-all') {
                isar.clearAllExams();
                setState(() => finalExams = null);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Clear all saved'),
                value: 'delete-all',
              )
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
                // latest upcoming final exams
                var upcomingExam = finalExams!.first;

                // if the upcoming exam is in less than 2 weeks, show it
                if (upcomingExam.date.difference(DateTime.now()).inDays > 14) {
                  return const SizedBox.shrink();
                }

                return NearestExamCard(exam: upcomingExam);
              }),
            const SizedBox(height: 5),
            // Show this notice when user add past final exams
            if (finalExams != null && finalExams!.isEmpty)
              const Text(
                  'No upcoming exams found. Please check back with the I-Ma\'luum portal'),
            // show when user didn't import any final exams yet
            if (finalExams == null)
              const Text(
                  'No final exams added yet. Please import your final exams from the I-Ma\'luum by tapping the + button'),
            if (finalExams != null)
              ListView.builder(
                itemCount: finalExams!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(finalExams![index].title),
                    subtitle: Text(
                        ReCase(RelativeDate.fromDate(finalExams![index].date))
                            .titleCase),
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
      floatingActionButton: finalExams == null
          ? FloatingActionButton(
              onPressed: () {
                // if run on windows, just use the json import dialog
                if (Theme.of(context).platform == TargetPlatform.windows) {
                  _openImporter(const JsonImportDialog());
                  return;
                }
                showDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        children: [
                          SimpleDialogOption(
                            onPressed: () async {
                              Navigator.pop(context);
                              _openImporter(const FeImaluumImporter());
                            },
                            child: const Text("Import from I-Ma'Luum"),
                          ),
                          SimpleDialogOption(
                            onPressed: () async {
                              Navigator.pop(context);

                              _openImporter(const JsonImportDialog());
                            },
                            child: const Text("Import from JSON"),
                          ),
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
