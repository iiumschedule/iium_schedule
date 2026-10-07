import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/utils/my_ftoast.dart';

/// The chip to display text in subject screen page.
class SubjectInfoChip extends StatelessWidget {
  const SubjectInfoChip({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text)).then((_) {
          HapticFeedback.lightImpact();
          if (!context.mounted) return;
          MyFtoast.show(context, 'Copied');
        });
      },
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Barlow'),
      label: Text(text),
    );
  }
}
