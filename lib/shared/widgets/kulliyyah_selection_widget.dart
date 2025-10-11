import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/academic_session.dart';
import '../utils/kulliyyahs.dart';
import 'study_grad_selector_widget.dart';

/// The widget that allows the kulliyyah, session & semester selection.
class KulliyyahSelectionWidget extends StatelessWidget {
  const KulliyyahSelectionWidget({
    super.key,
    required this.kulliyyahDropdownKey,
    required this.onKulliyyahChanged,
    required this.onSessionChanged,
    required this.onSemesterChanged,
    required this.onStudyGradChanged,
    required this.selectedStudyGrad,
    required this.selectedKulliyah,
    required this.selectedSession,
    required this.selectedSemester,
  });

  final GlobalKey kulliyyahDropdownKey;
  final StudyGrad selectedStudyGrad;
  final String? selectedKulliyah;
  final String selectedSession;
  final int selectedSemester;
  final ValueChanged<String?> onKulliyyahChanged;
  final ValueChanged<String> onSessionChanged;
  final ValueChanged<int> onSemesterChanged;
  final ValueChanged<StudyGrad> onStudyGradChanged;

  @override
  Widget build(BuildContext context) {
    final filteredKulliyyahs = Kuliyyahs.all
        .where((x) => x.scopes.contains(selectedStudyGrad))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: StudyGradSelectorWidget(
              selectedStudyGrad: selectedStudyGrad,
              onChanged: onStudyGradChanged,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField(
            isExpanded: true,
            items: filteredKulliyyahs
                .map((e) => DropdownMenuItem(
                      value: e.code,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          e.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          e.moniker,
                          style: const TextStyle(
                            fontFamily: 'Barlow_Condensed',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            key: kulliyyahDropdownKey,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            initialValue: selectedKulliyah,
            hint: const Text('Select kulliyyah'),
            selectedItemBuilder: (_) =>
                filteredKulliyyahs.map((e) => Text(e.moniker)).toList(),
            onChanged: onKulliyyahChanged,
          ),
        ),
        const SizedBox(height: 10),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: CupertinoSegmentedControl(
            unselectedColor: Theme.of(context).colorScheme.surface,
            borderColor: Theme.of(context).colorScheme.secondaryContainer,
            groupValue: selectedSession,
            children: {
              for (var session in AcademicSession.session)
                session: Text(session)
            },
            onValueChanged: onSessionChanged,
          ),
        ),
        const SizedBox(height: 10),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: CupertinoSegmentedControl(
            unselectedColor: Theme.of(context).colorScheme.surface,
            borderColor: Theme.of(context).colorScheme.secondaryContainer,
            groupValue: selectedSemester - 1,
            children: List.generate(
              3,
              (index) => Text("Sem ${index + 1}"),
            ).asMap(),
            onValueChanged: (value) => onSemesterChanged(value + 1),
          ),
        ),
      ],
    );
  }
}
