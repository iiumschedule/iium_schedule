// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:albiruni/albiruni.dart';

// 🌎 Project imports:

import 'browser_view.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  String _session = "2020/2021";
  int _semester = 1;
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

  void openItemsList() {
    GestureDetector? detector;
    void search(BuildContext context) {
      context.visitChildElements((element) {
        if (detector != null) return;
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
        } else {
          search(element);
        }
      });
    }

    search(dropdownKey.currentContext!);
    if (detector != null) detector?.onTap!();
  }

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
                    // https://github.com/flutter/flutter/issues/53634#issuecomment-889227826
                    // After this issue is solved, we can refactor this code
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: openItemsList,
                        child: DropdownButtonFormField(
                          key: dropdownKey,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          value: _selectedKulliyah,
                          hint: const Text('Select kulliyyah'),
                          items: _kulliyahs
                              .map(
                                (e) =>
                                    DropdownMenuItem(child: Text(e), value: e),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            setState(() => _selectedKulliyah = value);
                          },
                        ),
                      ),
                    ),
                  ),
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
                                    kulliyah: _selectedKulliyah!,
                                    semester: _semester,
                                    session: _session);
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => BrowserView(
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
