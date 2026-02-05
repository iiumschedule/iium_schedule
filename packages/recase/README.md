# ReCase

Change the case of text into common naming conventions with a simple API.

## Features

- Convert to 10+ case styles: camelCase, PascalCase, snake_case, CONSTANT_CASE,
  param-case, dot.case, path/case, Header-Case, Title Case, Sentence case.
- String extension helpers for terse one-liners.
- Title Case rules tuned for real text:
  - Roman numerals stay uppercase (I, II, III, IV, V, VI, VII, VIII).
  - Reserved terms stay uppercase (ENM, IT, ELT, ESL).
  - English prepositions and articles are lowercased (a, an, and, ...).
  - Handles capitalization after brackets.

## Usage

### ReCase class

```dart
import 'package:recase/recase.dart';

void main() {
	const input = 'Just_someSample-text';
	final rc = ReCase(input);

	print(rc.camelCase);     // justSomeSampleText
	print(rc.constantCase);  // JUST_SOME_SAMPLE_TEXT
	print(rc.titleCase);     // Just Some Sample Text
}
```

### String extensions

```dart
import 'package:recase/recase.dart';

void main() {
	const sample = 'Just_someSample-text';

	print(sample.camelCase);     // justSomeSampleText
	print(sample.constantCase);  // JUST_SOME_SAMPLE_TEXT
	print(sample.headerCase);    // Just-Some-Sample-Text
}
```

## Supported cases

- camelCase
- PascalCase
- snake_case
- CONSTANT_CASE
- param-case
- dot.case
- path/case
- Header-Case
- Title Case
- Sentence case

## Contributing

Ideas and PRs are welcome. If you want to improve Title Case rules:

1. Update the terms in `_englishSpecialTerm` or `_reservedWords`.
2. Adjust `romanNumerals` if needed.
3. Verify results with a Title Case reference.
4. (Update, if needed) and run the tests
