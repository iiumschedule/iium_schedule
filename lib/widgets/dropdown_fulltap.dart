import 'package:flutter/material.dart';

/// Dropdown with full target size
/// Impemented from https://github.com/flutter/flutter/issues/53634#issuecomment-988612213
/// https://github.com/flutter/flutter/issues/53634#issuecomment-889227826
/// After this issue is solved, we can refactor this code
class DropDownFullTap<T> extends StatelessWidget {
  // Key is needed to start the search from DropdownButtonFormField in the tree.
  final GlobalKey dropdownKey = GlobalKey();
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final InputDecoration? decoration;
  final Widget? hint;

  DropDownFullTap({
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
      child: GestureDetector(
        onTap: openItemsList,
        child: DropdownButtonFormField<T>(
          hint: hint,
          key: dropdownKey,
          decoration: decoration,
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void openItemsList() {
    if (dropdownKey.currentContext == null) return;
    GestureDetector? detector;

    // Go down the tree to find the first GestureDetector, which should be the one from DropdownButton.
    void search(BuildContext context) {
      context.visitChildElements((element) {
        if (detector != null) return;
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
        } else {
          search(element);
        }
      });
    }

    search(dropdownKey.currentContext!);
    if (detector != null && detector!.onTap != null) detector!.onTap!();
  }
}
