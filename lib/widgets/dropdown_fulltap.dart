import 'package:flutter/material.dart';

/// Update: I changed to using Pageview to navigate between screen
/// Previous implementation didnt work, I modified to code.
/// And hope https://github.com/flutter/flutter/pull/95906 will make its way to stable sooner
///
/// Dropdown with full target size
/// Impemented from https://github.com/flutter/flutter/issues/53634#issuecomment-988612213
/// https://github.com/flutter/flutter/issues/53634#issuecomment-889227826
/// After this issue is solved, we can refactor this code
class DropDownFullTap<T> extends StatelessWidget {
  // Key is needed to start the search from DropdownButtonFormField in the tree.
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final InputDecoration? decoration;
  final Widget? hint;

  const DropDownFullTap({
    this.value,
    this.items,
    this.onChanged,
    this.decoration,
    this.hint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DropdownButtonFormField<T>(
        hint: hint,
        decoration: decoration,
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
