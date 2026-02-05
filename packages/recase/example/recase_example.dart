import 'package:recase/recase.dart';

void main() {
  // Example 1: Using ReCase class
  const input = 'This is-Some_sampleText. YouDig?';
  final rc = ReCase(input);

  print('Original: $input');
  print('camelCase: ${rc.camelCase}');
  print('CONSTANT_CASE: ${rc.constantCase}');
  print('Sentence case: ${rc.sentenceCase}');
  print('snake_case: ${rc.snakeCase}');
  print('dot.case: ${rc.dotCase}');
  print('param-case: ${rc.paramCase}');
  print('path/case: ${rc.pathCase}');
  print('PascalCase: ${rc.pascalCase}');
  print('Header-Case: ${rc.headerCase}');
  print('Title Case: ${rc.titleCase}');

  print('\n---\n');

  // Example 2: Using String extension
  const text = 'hello_world';
  print('Original: $text');
  print('camelCase: ${text.camelCase}');
  print('PascalCase: ${text.pascalCase}');
  print('Title Case: ${text.titleCase}');
  print('param-case: ${text.paramCase}');

  print('\n---\n');

  // Example 3: All caps input
  const allCaps = 'FOO_BAR';
  print('Original: $allCaps');
  print('camelCase: ${allCaps.camelCase}');
  print('Sentence case: ${allCaps.sentenceCase}');
  print('Title Case: ${allCaps.titleCase}');
}
