import 'package:material_ui/material_ui.dart';

class Lane {
  final String name;

  final double height;

  final Color backgroundColor;

  final TextStyle textStyle;

  Lane({
    required this.name,
    this.height = 70,
    this.backgroundColor = Colors.white,
    this.textStyle = const TextStyle(color: Colors.blue),
  });
}
