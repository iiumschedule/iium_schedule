import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/basic_subject_model.dart';
import '../../util/extensions.dart';
import 'imaluum_webview.dart';
import 'json_import_dialog.dart';
import 'schedule_maker_data.dart';
import 'schedule_steps.dart';

enum ImportMethod { json, imaluum }

class InputCourse extends StatefulWidget {
  const InputCourse({Key? key}) : super(key: key);

  @override
  State<InputCourse> createState() => _InputCourseState();
}

class _InputCourseState extends State<InputCourse>
    with AutomaticKeepAliveClientMixin<InputCourse> {
  final _courseCodeInputController = TextEditingController();
  final _sectionInputController = TextEditingController();

  final List<BasicSubjectModel> _inputCourses = [];

  int? _editingIndex;
  ImportMethod? _importMethod;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ListTile(
                title: const Text("Enter your course code and section number."),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  // style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: _inputCourses.isEmpty
                      ? null
                      : () {
                          // Redo the same thing as in onEditingComplete above. Just in case.
                          FocusScope.of(context).unfocus();

                          ScheduleSteps.of(context).pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.bounceInOut);

                          ScheduleMakerData.subjects = _inputCourses;
                        },
                  child: const Text("Next"),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DataTable(
                      columnSpacing:
                          MediaQuery.of(context).size.width < 410 ? 23 : null,
                      showBottomBorder: true,
                      columns: ['No.', 'Course Code', 'Section', 'Action']
                          .map((e) => DataColumn(
                                  label: Expanded(
                                child: Text(
                                  e,
                                  textAlign: TextAlign.center,
                                ),
                              )))
                          .toList(),
                      rows: List.generate(
                        _inputCourses.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text('${index + 1}.'),
                            ),
                            DataCell(Text(_inputCourses[index].courseCode!)),
                            DataCell(Text(
                              _inputCourses[index].section != null
                                  ? _inputCourses[index].section.toString()
                                  : '-',
                            )),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                      tooltip: 'Edit',
                                      onPressed: () {
                                        setState(
                                          () {
                                            _editingIndex = index;
                                            _courseCodeInputController.text =
                                                _inputCourses[index]
                                                    .courseCode!;
                                            _sectionInputController.text =
                                                _inputCourses[index].section !=
                                                        null
                                                    ? _inputCourses[index]
                                                        .section
                                                        .toString()
                                                    : '';
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined)),
                                  IconButton(
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      setState(() {
                                        _inputCourses.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .removeCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Deleted successfully'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.purple,
                                      ));
                                    },
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ).toList(),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _courseCodeInputController,
                              // Initially 8, increased to give some space for whitespace
                              // character etc, so that text will not be truncated
                              maxLength: 10,
                              decoration: InputDecoration(
                                labelText: 'Course Code',
                                counterText: '', // disable counter text
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onEditingComplete: () {
                                context
                                    .nextEditableTextFocus(); // focus the json input
                                context
                                    .nextEditableTextFocus(); // focus ke section input
                                if (_courseCodeInputController.text.isEmpty) {
                                  return;
                                }
                                _courseCodeInputController.text =
                                    _courseCodeInputController.text
                                        .toAlbiruniFormat();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: _sectionInputController,
                              decoration: InputDecoration(
                                labelText: 'Section',
                                filled: true,
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              // https://stackoverflow.com/a/54343828
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              var courseCode = _courseCodeInputController.text;
                              var section =
                                  int.tryParse(_sectionInputController.text);

                              if (courseCode.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Can\'t add. Course code is empty'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                ));
                                return;
                              }

                              // to make sure the format is <string><space><number>
                              courseCode = courseCode.toAlbiruniFormat();

                              // Check if the code already exist in table
                              bool subjectExist = _inputCourses.every(
                                  (element) =>
                                      element.courseCode != courseCode);

                              if (!subjectExist && _editingIndex == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Course already added'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                ));
                                // cancel the operation if it does
                                return;
                              }

                              var inputedCourse = BasicSubjectModel(
                                  courseCode: courseCode, section: section);
                              setState(() {
                                if (_editingIndex != null) {
                                  _inputCourses[_editingIndex!] = inputedCourse;
                                  _editingIndex = null;
                                } else {
                                  _inputCourses.add(inputedCourse);
                                }
                              });

                              _courseCodeInputController.clear();
                              _sectionInputController.clear();
                            },
                            child: _editingIndex == null
                                ? const Text('Add')
                                : const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                      child: Text(
                        'Note: You could also add subject that are not from your main kuliyyah eg COCU etc.',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 5),
                    PopupMenuButton<ImportMethod>(
                      initialValue: _importMethod,
                      onSelected: (ImportMethod item) async {
                        switch (item) {
                          case ImportMethod.imaluum:
                            // Inappwebview is supported on Android only
                            // so, show unsupported message on other platforms
                            if (kIsWeb || !Platform.isAndroid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Unsupported on this platform. Available on Android only'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.purpleAccent,
                                ),
                              );
                              return;
                            }

                            var res = await Navigator.push<List<dynamic>?>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ImaluumWebView()),
                            );
                            if (res != null) {
                              importSubjects(res);
                            }
                            break;
                          case ImportMethod.json:
                            var res = await showDialog<List<dynamic>?>(
                                context: context,
                                builder: ((_) => const JsonImportDialog()));
                            if (res != null) {
                              importSubjects(res);
                            }
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => const [
                        PopupMenuItem(
                          value: ImportMethod.imaluum,
                          child: Text("I-ma'luum"),
                        ),
                        PopupMenuItem(
                          value: ImportMethod.json,
                          child: Text('JSON'),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Import from..'),
                            SizedBox(width: 5),
                            Icon(Icons.add)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void importSubjects(List<dynamic> decodedJson) {
    var jsonSubjects =
        decodedJson.map((item) => BasicSubjectModel.fromJson(item));

    int itemCountAdded = 0;

    if (_inputCourses.isEmpty) {
      // if the list was still empty, just add it
      itemCountAdded = jsonSubjects.length;
      setState(() {
        _inputCourses.addAll(jsonSubjects);
      });
    } else {
      // check the subject by its course code,
      // if it already exist, don't add it
      // I maybe can use set here, but I want to track how
      // many items added/removed, and provide visual
      // feedback to users
      var newSubjects = jsonSubjects.where(
        (element) => !_inputCourses
            .any((subject) => subject.courseCode == element.courseCode),
      );
      itemCountAdded = newSubjects.length;
      setState(() {
        _inputCourses.addAll(newSubjects);
      });
    }

    String itemSkippkedMessage = '';
    if (itemCountAdded < jsonSubjects.length) {
      itemSkippkedMessage =
          ' (${jsonSubjects.length - itemCountAdded} subject(s) already exists)';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $itemCountAdded subjects. $itemSkippkedMessage'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.purple,
      ),
    );
  }
}
