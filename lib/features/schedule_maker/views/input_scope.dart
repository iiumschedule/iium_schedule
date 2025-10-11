import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart' as constants;
import '../../../shared/providers/schedule_maker_provider.dart';
import '../../../shared/utils/academic_session.dart';
import '../../../shared/widgets/kulliyyah_selection_widget.dart';
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

  /// Callback when the kulliyah is changed
  void onKulliyyahChanged(String? value) {
    setState(() => _selectedKulliyah = value);
  }

  /// Callback when the session is changed
  void onSessionChanged(String value) {
    setState(() => _selectedSession = value);
  }

  /// Callback when the study grade is changed
  void onStudyGradChanged(StudyGrad value) {
    // reset kulliyah selection and dropdown state
    setState(() {
      _selectedKulliyah = null;
      _selectedStudyGrad = value;
    });
    dropdownKey.currentState?.setState(() {});
  }

  /// Callback when the semester is changed
  void onSemesterChanged(int value) {
    setState(() => _selectedSemester = value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KulliyyahSelectionWidget(
                    kulliyyahDropdownKey: dropdownKey,
                    onKulliyyahChanged: onKulliyyahChanged,
                    onSessionChanged: onSessionChanged,
                    onSemesterChanged: onSemesterChanged,
                    onStudyGradChanged: onStudyGradChanged,
                    selectedStudyGrad: _selectedStudyGrad,
                    selectedKulliyah: _selectedKulliyah,
                    selectedSession: _selectedSession,
                    selectedSemester: _selectedSemester,
                  ),
                  const SizedBox(height: 10),
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
