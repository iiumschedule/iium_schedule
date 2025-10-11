import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

const String undergraduateLabel = 'Undergraduate';
const String postgraduateLabel = 'Postgraduate';

/// A widget to select the study level (undergraduate or postgraduate)
class StudyGradSelectorWidget extends StatelessWidget {
  const StudyGradSelectorWidget(
      {super.key, required this.selectedStudyGrad, required this.onChanged});

  final StudyGrad selectedStudyGrad;
  final ValueChanged<StudyGrad> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<StudyGrad>(
      tooltip: 'Select Study Level',
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: StudyGrad.ug,
          child: Text(
            undergraduateLabel,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
        ),
        PopupMenuItem(
          value: StudyGrad.pg,
          child: Text(
            postgraduateLabel,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedStudyGrad == StudyGrad.ug
                  ? undergraduateLabel
                  : postgraduateLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}
