import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../util/colour_palletes.dart';

enum ColourChooserOptions { predefined, custom }

class ColourPickerFromPallets extends StatefulWidget {
  const ColourPickerFromPallets(this.color, {Key? key}) : super(key: key);

  final Color color;

  @override
  State<ColourPickerFromPallets> createState() =>
      _ColourPickerFromPalletsState();
}

class _ColourPickerFromPalletsState extends State<ColourPickerFromPallets> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pre-defined palletes'),
      content: BlockPicker(
        pickerColor: widget.color,
        availableColors: const [
          ...ColourPalletes.pallete1,
          ...ColourPalletes.pallete2,
          ...ColourPalletes.pallete3
        ],
        onColorChanged: (color) {
          setState(() => _color = color);
        },
      ),
      actions: [
        TextButton(
          child: const Text('Save'),
          onPressed: () => Navigator.pop(context, _color),
        )
      ],
    );
  }
}

class ColourPickerCustom extends StatefulWidget {
  const ColourPickerCustom(this.color, {Key? key}) : super(key: key);

  final Color color;

  @override
  State<ColourPickerCustom> createState() => _ColourPickerCustomState();
}

class _ColourPickerCustomState extends State<ColourPickerCustom> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Custom'),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context, _color);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            pickerColor: _color,
            pickerAreaHeightPercent: .5,
            enableAlpha: false,
            hexInputBar: true,
            onColorChanged: (value) {
              setState(() {
                _color = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
