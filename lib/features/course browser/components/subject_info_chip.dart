import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/utils/my_ftoast.dart';

/// The chip to display text and icon
class SubjectInfoChip extends StatelessWidget {
  const SubjectInfoChip({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.icon,
    required this.foregroundColor,
  });
  final String text;
  final Color backgroundColor;
  final IconData icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ActionChip(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text)).then((_) {
            HapticFeedback.lightImpact();

            MyFtoast.show(context, 'Copied');
          });
        },
        avatar: Icon(icon, size: 18, color: foregroundColor),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor,
          fontFamily: 'Barlow',
        ),
        backgroundColor: backgroundColor.withAlpha(40),
        label: Text(text),
      ),
    );
  }
}
