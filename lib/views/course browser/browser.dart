import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/services.dart';

import '../../util/kulliyyahs.dart';
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
                                child: Text(e.fullName), value: e.code))
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
                      // https://github.com/flutter/flutter/issues/48438#issuecomment-621262652
                      style: CupertinoTheme.of(context).textTheme.textStyle,
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
                        child: const Text('Search'),
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
