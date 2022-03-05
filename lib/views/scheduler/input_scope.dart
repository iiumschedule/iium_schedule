import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'schedule_maker_data.dart';
import 'schedule_steps.dart';

class InputScope extends StatefulWidget {
  const InputScope({Key? key}) : super(key: key);

  @override
  _InputScopeState createState() => _InputScopeState();
}

class _InputScopeState extends State<InputScope>
    with AutomaticKeepAliveClientMixin<InputScope> {
  final GlobalKey dropdownKey = GlobalKey();
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
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: MouseRegion(
                      cursor: _selectedKulliyah == null
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: CupertinoButton.filled(
                        child: const Text('Next'),
                        onPressed: _selectedKulliyah == null
                            ? null
                            : () {
                                // Redo the same thing as in onEditingComplete above. Just in case.
                                FocusScope.of(context).unfocus();

                                ScheduleSteps.of(context)
                                    .pageController
                                    .nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.bounceInOut);

                                Albiruni albiruni = Albiruni(
                                    semester: _semester, session: _session);

                                ScheduleMakerData.albiruni = albiruni;
                                ScheduleMakerData.kulliyah = _selectedKulliyah!;
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

  @override
  bool get wantKeepAlive => true;
}
