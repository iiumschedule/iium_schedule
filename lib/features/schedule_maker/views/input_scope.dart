import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart' as constants;
import '../../../shared/providers/schedule_maker_provider.dart';
import '../../../shared/utils/academic_session.dart';
import '../../../shared/utils/kulliyyahs.dart';
import 'schedule_steps.dart';

class InputScope extends StatefulWidget {
  const InputScope({super.key});

  @override
  State<InputScope> createState() => _InputScopeState();
}

class _InputScopeState extends State<InputScope>
    with AutomaticKeepAliveClientMixin<InputScope> {
  final GlobalKey dropdownKey = GlobalKey();
  late String _selectedSession;
  int _selectedSemester = constants.kDefaultSemester;
  String? _selectedKulliyah;
  StudyGrad _selectedStudyGrad = StudyGrad.ug;

  @override
  void initState() {
    super.initState();

    // check if [constants.kDefaultSession] is in the list of sessions
    // if not, set the first session in the list as the default session
    if (!AcademicSession.session.contains(constants.kDefaultSession)) {
      _selectedSession = AcademicSession.session.first;
    } else {
      _selectedSession = constants.kDefaultSession;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                        borderRadius: BorderRadius.circular(15.0),
                        items: Kuliyyahs.all
                            .map((e) => DropdownMenuItem(
                                  value: e.code,
                                  child: Text(e.fullName),
                                ))
                            .toList(),
                        key: dropdownKey,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)))),
                        value: _selectedKulliyah,
                        selectedItemBuilder: (_) => Kuliyyahs.all
                            .map((e) => Text(e.shortName))
                            .toList(),
                        hint: const Text('Select main kulliyyah'),
                        onChanged: (String? value) {
                          setState(() => _selectedKulliyah = value);
                        },
                      )),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        unselectedColor:
                            Theme.of(context).colorScheme.background,
                        borderColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        groupValue: _selectedSession,
                        children: {
                          for (var session in AcademicSession.session)
                            session: Text(session)
                        },
                        onValueChanged: (String value) {
                          setState(() => _selectedSession = value);
                        }),
                  ),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        unselectedColor:
                            Theme.of(context).colorScheme.background,
                        borderColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        groupValue: _selectedSemester - 1,
                        children: List.generate(
                          3,
                          (index) => Text("Sem ${index + 1}"),
                        ).asMap(),
                        onValueChanged: (int value) {
                          setState(() => _selectedSemester = value + 1);
                        }),
                  ),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                      unselectedColor: Theme.of(context).colorScheme.background,
                      borderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      groupValue: _selectedStudyGrad,
                      children: const {
                        StudyGrad.ug: Text('Undergraduate'),
                        StudyGrad.pg: Text('Postgraduate'),
                      },
                      onValueChanged: (StudyGrad value) {
                        setState(() => _selectedStudyGrad = value);
                      },
                    ),
                    // child: CupertinoSlidingSegmentedControl<StudyGrad>(
                    //   backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    //   thumbColor: Theme.of(context).colorScheme.primary,
                    //   groupValue: _selectedStudyGrad,
                    //   children: {
                    //     StudyGrad.ug: Text('Undergraduate', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),),
                    //     StudyGrad.pg: Text('Postgraduate', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),),
                    //   },
                    //   onValueChanged: (value) {
                    //     setState(() => _selectedStudyGrad = value!);
                    //   },
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: MouseRegion(
                      cursor: _selectedKulliyah == null
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
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
                                    semester: _selectedSemester,
                                    session: _selectedSession,
                                    studyGrade: _selectedStudyGrad);

                                Provider.of<ScheduleMakerProvider>(context,
                                        listen: false)
                                    .albiruni = albiruni;
                                Provider.of<ScheduleMakerProvider>(context,
                                        listen: false)
                                    .kulliyah = _selectedKulliyah!;
                              },
                        child: const Text('Next'),
                      ),
                      // child: CupertinoButton.filled(
                      //   onPressed: _selectedKulliyah == null
                      //       ? null
                      //       : () {
                      //           // Redo the same thing as in onEditingComplete above. Just in case.
                      //           FocusScope.of(context).unfocus();

                      //           ScheduleSteps.of(context)
                      //               .pageController
                      //               .nextPage(
                      //                   duration:
                      //                       const Duration(milliseconds: 200),
                      //                   curve: Curves.bounceInOut);

                      //           Albiruni albiruni = Albiruni(
                      //               semester: _semester,
                      //               session: _session,
                      //               studyGrade: _selectedStudyGrad);

                      //           ScheduleMakerData.albiruni = albiruni;
                      //           ScheduleMakerData.kulliyah = _selectedKulliyah!;
                      //         },
                      //   child: const Text('Next'),
                      // ),
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
