import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../util/colour_palletes.dart';

class ColourPickerSheet extends StatefulWidget {
  const ColourPickerSheet({super.key, required this.color});

  final Color color;

  @override
  State<ColourPickerSheet> createState() => _ColourPickerSheetState();
}

class _ColourPickerSheetState extends State<ColourPickerSheet> {
  late Color _choosenColor;
  @override
  void initState() {
    super.initState();
    _choosenColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _choosenColor);
        return false;
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlockPicker(
            pickerColor: _choosenColor,
            availableColors: const [
              ...ColourPalletes.pallete1,
              ...ColourPalletes.pallete2,
              ...ColourPalletes.pallete3
            ],
            onColorChanged: (color) {
              setState(() => _choosenColor = color);
            },
            layoutBuilder: (context, colors, child) {
              return GridView(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 70,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 70,
                  mainAxisSpacing: 10,
                ),
                children: [for (Color color in colors) child(color)],
              );
            },
          ),
        ),
      ),
    );
  }
}
