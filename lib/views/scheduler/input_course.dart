import 'dart:convert';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../../model/basic_subject_model.dart';
import '../../util/extensions.dart';
import 'schedule_maker_data.dart';
import 'schedule_steps.dart';

class InputCourse extends StatefulWidget {
  const InputCourse({Key? key}) : super(key: key);

  @override
  State<InputCourse> createState() => _InputCourseState();
}

class _InputCourseState extends State<InputCourse>
    with AutomaticKeepAliveClientMixin<InputCourse> {
  final _courseCodeInputController = TextEditingController();
  final _jsonInputController = TextEditingController();
  final _sectionInputController = TextEditingController();

  final List<BasicSubjectModel> _inputCourses = [];

  int? _editingIndex;
  int _inputIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ListTile(
                title: const Text("Enter your course code and section number"),
                trailing: ElevatedButton(
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
                                            _inputIndex =
                                                0; // move to manual option
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
                      child: IndexedStack(index: _inputIndex, children: [
                        // Manual TextField
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _courseCodeInputController,
                                maxLength: 8,
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
                                var courseCode =
                                    _courseCodeInputController.text;
                                var section =
                                    int.tryParse(_sectionInputController.text);

                                if (courseCode.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Can\'t add. Course code is empty'),
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
                                    _inputCourses[_editingIndex!] =
                                        inputedCourse;
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
                        // JSON Textfield
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _jsonInputController,
                                decoration: InputDecoration(
                                  labelText: 'JSON',
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 5,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_jsonInputController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Can\'t add. Data is empty'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ));
                                  return;
                                }

                                List<dynamic> decodedJson;

                                try {
                                  decodedJson =
                                      jsonDecode(_jsonInputController.text);
                                } on FormatException catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Failed to decode JSON (${e.message})'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                  return;
                                }

                                var jsonSubjects = decodedJson.map(
                                    (item) => BasicSubjectModel.fromJson(item));

                                setState(() {
                                  _inputCourses.addAll(jsonSubjects);
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Added ${jsonSubjects.length} subjects'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                ));
                                _jsonInputController.clear();
                              },
                              child: const Text('Add all'),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Input method: '),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: CupertinoSlidingSegmentedControl<int>(
                              groupValue: _inputIndex,
                              children: const {
                                0: Text('Manual'),
                                1: Text('JSON')
                              },
                              onValueChanged: (res) {
                                setState(() => _inputIndex = res!);
                              }),
                        ),
                      ],
                    ),
                    if (_inputIndex == 1)
                      Link(
                        uri: Uri.parse(
                            "https://iiumschedule.iqfareez.com/docs/extract"),
                        target: LinkTarget.blank,
                        builder: (_, followLink) => TextButton(
                          onPressed: followLink,
                          child: const Text('How can I get the JSON?'),
                        ),
                      ),
                    const SizedBox(height: 30),
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
}
