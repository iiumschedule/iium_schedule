import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../isar_models/final_exam.dart';
import '../../services/isar_service.dart';
import '../../util/calendar_ics.dart';
import '../../util/my_snackbar.dart';
import '../../util/relative_date.dart';
import '../../widgets/json_import_dialog.dart';
import 'exam_detail_page.dart';
import 'export_to_ics_prompt_dialog.dart';
import 'fe_imaluum_importer.dart';
import 'ics_generated_dialog.dart';
import 'nearest_exam_card.dart';

class _MyFinalExam {
  FinalExam finalExam;
  bool isPast;

  _MyFinalExam({required this.finalExam, required this.isPast});
}

class FinalExamPage extends StatefulWidget {
  const FinalExamPage({super.key});

  @override
  State<FinalExamPage> createState() => _FinalExamPageState();
}

class _FinalExamPageState extends State<FinalExamPage> {
  // TODO: add banner please bring along matric card and exam slip
  final IsarService isar = IsarService();
  List<_MyFinalExam>? finalExams;

  /// Sort and set the final exams from imported data
  /// Usually, it was already sorted from earliest to oldest from the Imaluum
  /// but, just in case
  void _setFinalExams(List<FinalExam> exams) async {
    exams.sort((a, b) => a.date.compareTo(b.date));

    /// Create a list of _MyFinalExam objects
    List<_MyFinalExam> myFinalExams = [];

    // Iterate through the exams and set the isPast property
    for (FinalExam exam in exams) {
      // the exam duration can be differs. Ie 2.5 hrs or 3 hrs. But, we set as 3 hours
      // in this case
      // https://github.com/iqfareez/iium_schedule/issues/93
      bool isPast =
          DateTime.now().isAfter(exam.date.add(const Duration(hours: 2)));
      myFinalExams.add(_MyFinalExam(finalExam: exam, isPast: isPast));
    }

    setState(() {
      finalExams = myFinalExams;
    });
    // clear existing and save new to db
    isar.clearAllExams();
    isar.saveFinalExams(exams);
  }

  void _processImport() async {
    bool isAllPast = finalExams!.every((element) => element.isPast);

    // The list is empty when the exams are in the past, so we can just set to the
    // empty list
    if (isAllPast) {
      MySnackbar.showWarn(context, 'No upcoming exams found');
      return;
    }

    // lastly, show prompt to add exams to calendar
    var res = await showDialog(
        context: context, builder: (_) => const ExportToIcsPromptDialog());
    if (res == null) return;
    if (res) _generateIcs();
  }

  void _openImporter(Widget widget) async {
    var data = await showDialog(context: context, builder: (_) => widget);
    if (data == null) return;
    var dataParsed = FinalExam.fromList(data);
    _setFinalExams(dataParsed);
    _processImport();
  }

  void _loadSavedExams() async {
    var savedExams = await isar.getFinalExams();
    if (savedExams != null) {
      _setFinalExams(savedExams);
    }
  }

  void _generateIcs() {
    if (finalExams == null) return;
    // On Windows, default to export as ICS
    if (!kIsWeb) {
      _showSaveIcsDialog();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedExams();
  }

  // after the ics file has been generated & saved, a dialog will be shown
  // that allow user to share (because finding the file in file explorer) is kinda hard
  void _showSaveIcsDialog() async {
    // TODO: Check web implementation
    if (kIsWeb) {
      CalendarIcs.downloadIcsFile(finalExams!.map((e) => e.finalExam).toList());
      // maybe show IcsGeneratedDialog but with download button instead
      return;
    }

    late File filePath;
    try {
      filePath = await CalendarIcs.generateIcsFile(
          finalExams!.map((e) => e.finalExam).toList());
    } catch (e) {
      MySnackbar.showError(context, 'Sorry. An error has occured. $e');
      return;
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (_) => IcsGeneratedDialog(icsSavedFile: filePath),
    );
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
          // only show the menu when there is no exams added
          if (finalExams != null && finalExams!.isNotEmpty)
            PopupMenuButton(
              onSelected: (value) async {
                if (value == 'delete-all') {
                  isar.clearAllExams();
                  setState(() => finalExams = null);
                }

                if (value == 'add-to-cal') {
                  _generateIcs();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add-to-cal',
                  child: Text('Export to calendar'),
                ),
                const PopupMenuItem(
                  value: 'delete-all',
                  child: Text('Clear all saved'),
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
                // latest upcoming final exams

                var upcomingExam =
                    finalExams!.where((element) => !element.isPast);
                if (upcomingExam.isEmpty) {
                  return const SizedBox.shrink();
                }

                // if the upcoming exam is in less than 2 weeks, show it
                if (upcomingExam.first.finalExam.date
                        .difference(DateTime.now())
                        .inDays >
                    5) {
                  return const SizedBox.shrink();
                }

                return NearestExamCard(exam: upcomingExam.first.finalExam);
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
                itemBuilder: (context, index) {
                  return ListTile(
                    enabled: !finalExams![index].isPast,
                    title: Text(
                      finalExams![index].finalExam.title,
                      style: finalExams![index].isPast
                          ? const TextStyle(
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.lineThrough)
                          : null,
                    ),
                    subtitle: Text(!finalExams![index].isPast
                        ? RelativeDate.fromDate(
                            finalExams![index].finalExam.date)
                        : 'Finished'),
                    trailing: !finalExams![index].isPast
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamDetailPage(
                            exam: finalExams![index].finalExam,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: finalExams == null
          ? FloatingActionButton(
              onPressed: () {
                // if run on windows, just use the json import dialog
                if (Theme.of(context).platform == TargetPlatform.windows) {
                  _openImporter(const JsonImportDialog(
                    helpLink:
                        "https://iiumschedule.iqfareez.com/docs/final-exams/",
                  ));
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

                              _openImporter(const JsonImportDialog(
                                helpLink:
                                    "https://iiumschedule.iqfareez.com/docs/final-exams/",
                              ));
                            },
                            child: const Text("Import from JSON"),
                          ),
                        ],
                      );
                    });
              },
              tooltip: 'Import/Add final exam',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
