import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart' as constants;
import '../../util/kulliyyahs.dart';
import 'browser_view.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  String _session = constants.kDefaultSession;
  int _semester = constants.kDefaultSemester;
  String? _selectedKulliyah;
  StudyGrad _selectedStudyGrad = StudyGrad.ug;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: Colors.transparent),
          title: const Text('Course Browser'),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonFormField(
                        items: Kuliyyahs.all
                            .map((e) => DropdownMenuItem(
                                  value: e.code,
                                  child: Text(e.fullName),
                                ))
                            .toList(),
                        key: dropdownKey,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        value: _selectedKulliyah,
                        hint: const Text('Select kulliyyah'),
                        selectedItemBuilder: (_) => Kuliyyahs.all
                            .map((e) => Text(e.shortName))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() => _selectedKulliyah = value);
                        },
                      )),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        groupValue: _session,
                        children: {
                          for (var session in constants.kSessions)
                            session: Text(session)
                        },
                        onValueChanged: (String value) {
                          setState(() => _session = value);
                        }),
                  ),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        groupValue: _semester - 1,
                        children: List.generate(
                          3,
                          (index) => Text("Sem ${index + 1}"),
                        ).asMap(),
                        onValueChanged: (int value) {
                          setState(() => _semester = value + 1);
                        }),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<StudyGrad>(
                            value: StudyGrad.ug,
                            groupValue: _selectedStudyGrad,
                            onChanged: ((value) => setState(
                                  () {
                                    _selectedStudyGrad = value!;
                                  },
                                )),
                            title: Text('Undergraduate'),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<StudyGrad>(
                            value: StudyGrad.pg,
                            groupValue: _selectedStudyGrad,
                            onChanged: ((value) => setState(
                                  () {
                                    _selectedStudyGrad = value!;
                                  },
                                )),
                            title: Text('Postgraduate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    // Removed [CupertinoTextField] to prevent the usage of
                    // [CupertinoIcons] as they are not tree shaken when publish
                    // to the web. https://github.com/flutter/flutter/issues/57181
                    child: TextField(
                      maxLength: 9,
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        // TODO: Buat dia tukar2 course code tu
                        labelText: 'Search',
                        hintText: 'Eg: MCTE 3100',
                        isDense: true,
                        helperText: 'Leave empty to load all',
                        counter: const SizedBox.shrink(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.clear_outlined),
                        ),
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        _searchController.text =
                            _searchController.text.toAlbiruniFormat();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: MouseRegion(
                      cursor: _selectedKulliyah == null
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: CupertinoButton.filled(
                        onPressed: _selectedKulliyah == null
                            ? null
                            : () {
                                // Redo the same thing as in onEditingComplete above. Just in case.
                                FocusScope.of(context).unfocus();
                                String? courseCode;
                                if (_searchController.text.isNotEmpty) {
                                  _searchController.text = courseCode =
                                      _searchController.text.toAlbiruniFormat();
                                } else {
                                  courseCode = null;
                                }

                                Albiruni albiruni = Albiruni(
                                    semester: _semester,
                                    session: _session,
                                    studyGrade: _selectedStudyGrad);
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => BrowserView(
                                        kulliyah: _selectedKulliyah!,
                                        albiruni: albiruni,
                                        courseCode: courseCode),
                                  ),
                                );
                              },
                        child: const Text('Go'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
