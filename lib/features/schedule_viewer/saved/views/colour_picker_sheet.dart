import 'package:flutter/material.dart';

import '../../not_saved/utils/colour_palletes.dart';

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 34, 16, 16),
        child: _BlockPicker(
          selectedColor: _choosenColor,
          availableColors: const [
            ...ColourPalletes.pallete1,
            ...ColourPalletes.pallete2,
            ...ColourPalletes.pallete3
          ],
          onColorChanged: (color) {
            setState(() => _choosenColor = color);
          },
        ),
      ),
    );
  }
}

class _BlockPicker extends StatelessWidget {
  const _BlockPicker({
    required this.selectedColor,
    required this.availableColors,
    required this.onColorChanged,
  });
  final Color selectedColor;
  final List<Color> availableColors;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 70,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2,
        mainAxisExtent: 70,
        mainAxisSpacing: 2,
      ),
      children: [
        for (Color color in availableColors)
          GestureDetector(
            onTap: () => onColorChanged(color),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                ColoredBox(color: color),
                // if (color == selectedColor)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 270),
                      curve: Curves.easeInQuad,
                      width: color == selectedColor ? 30 : 0,
                      height: color == selectedColor ? 30 : 0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                    if (color == selectedColor)
                      const Icon(Icons.check, size: 20),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
