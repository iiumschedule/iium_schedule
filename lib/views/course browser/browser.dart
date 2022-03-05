import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:albiruni/albiruni.dart';

import 'browser_view.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  String _session = "2021/2022";
  int _semester = 2;
  String? _selectedKulliyah;
  final List<String> _kulliyahs = [
    "AED",
    "BRIDG",
    "CFL",
    "CCAC",
    "EDUC",
    "ENGIN",
    "ECONS",
    "KICT",
    "IRKHS",
    "KLM",
    "LAWS"
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
                        items: _kulliyahs
                            .map(
                              (e) => DropdownMenuItem(child: Text(e), value: e),
                            )
                            .toList(),
                        key: dropdownKey,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        value: _selectedKulliyah,
                        hint: const Text('Select kulliyyah'),
                        onChanged: (String? value) {
                          setState(() => _selectedKulliyah = value);
                        },
                      )),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        groupValue: _session,
                        children: const {
                          "2020/2021": Text("2020/2021"),
                          "2021/2022": Text("2021/2022")
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: CupertinoTextField(
                      maxLength: 9,
                      controller: _searchController,
                      placeholder: "Search subject",
                      clearButtonMode: OverlayVisibilityMode.editing,
                      selectionControls: MaterialTextSelectionControls(),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        _searchController.text =
                            _searchController.text.toAlbiruniFormat();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: MouseRegion(
                      cursor: _selectedKulliyah == null
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: CupertinoButton.filled(
                        child: const Text('Get'),
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
                                    semester: _semester, session: _session);
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
