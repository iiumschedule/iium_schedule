import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../util/colour_palletes.dart';

class SubjectColourDialog extends StatefulWidget {
  const SubjectColourDialog(
      {super.key, required this.subjectName, required this.color});

  final String subjectName;
  final Color color;

  @override
  State<SubjectColourDialog> createState() => _SubjectColourDialogState();
}

class _SubjectColourDialogState extends State<SubjectColourDialog> {
  late Color _choosenColor;
  @override
  void initState() {
    super.initState();
    _choosenColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    bool isNotSameColor = _choosenColor != widget.color;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background colour'),
        actions: [
          if (isNotSameColor)
            TextButton(
              onPressed: () => Navigator.pop(context, _choosenColor),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(children: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    color: widget.color,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.subjectName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (widget.color.computeLuminance() > .5)
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  if (isNotSameColor) const Icon(Icons.arrow_forward_rounded),
                  if (isNotSameColor)
                    AnimatedContainer(
                      width: 100,
                      height: 120,
                      duration: const Duration(milliseconds: 350),
                      color: _choosenColor,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.subjectName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (_choosenColor.computeLuminance() > .5)
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),
          Material(
            color: Colors.grey.withOpacity(.1),
            child: const TabBar(
              labelColor: Colors.purple,
              tabs: [Tab(text: 'Pallets'), Tab(text: 'Custom')],
            ),
          ),
          Flexible(
            flex: 2,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ColorPicker(
                    pickerColor: _choosenColor,
                    displayColorIndicator: false,
                    displayThumbColor: true,
                    pickerAreaHeightPercent: .7,
                    enableAlpha: false,
                    hexInputBar: true,
                    onColorChanged: (value) {
                      setState(
                        () => _choosenColor = value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
