extension TextBeautify on String {
  /// Remove dot zero. Ezample: `3.0` become `3`
  /// Not supprted for more than one trailing zero. For eg: `3.00` will become `3.0`.
  String removeTrailingDotZero() => replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
}
