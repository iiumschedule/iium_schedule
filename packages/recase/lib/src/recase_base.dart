/// An instance of text to be re-cased.
///
/// Provides various case transformations for strings.
class ReCase {
  /// Creates a ReCase instance from the given [text].
  ReCase(String text) {
    originalText = text;
    _words = _groupIntoWords(text);
  }

  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');

  static const Set<String> _symbolSet = {' ', '.', '/', '_', '\\', '-'};

  /// The original text that was passed to the constructor.
  late final String originalText;

  late final List<String> _words;

  List<String> _groupIntoWords(String text) {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = text.toUpperCase() == text;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final nextChar = i + 1 == text.length ? null : text[i + 1];

      if (_symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      final isEndOfWord =
          nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  /// Returns the text in camelCase format.
  String get camelCase => _getCamelCase();

  /// Returns the text in CONSTANT_CASE format.
  String get constantCase => _getConstantCase();

  /// Returns the text in Sentence case format.
  String get sentenceCase => _getSentenceCase();

  /// Returns the text in snake_case format.
  String get snakeCase => _getSnakeCase();

  /// Returns the text in dot.case format.
  String get dotCase => _getSnakeCase(separator: '.');

  /// Returns the text in param-case format.
  String get paramCase => _getSnakeCase(separator: '-');

  /// Returns the text in path/case format.
  String get pathCase => _getSnakeCase(separator: '/');

  /// Returns the text in PascalCase format.
  String get pascalCase => _getPascalCase();

  /// Returns the text in Header-Case format.
  String get headerCase => _getPascalCase(separator: '-');

  /// Returns the text in Title Case format.
  String get titleCase => _getPascalCase(separator: ' ');

  String _getCamelCase({String separator = ''}) {
    final words = _words.map(_upperCaseFirstLetter).toList();
    if (words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }

    return words.join(separator);
  }

  String _getConstantCase({String separator = '_'}) {
    final words = _words.map((word) => word.toUpperCase()).toList();
    return words.join(separator);
  }

  String _getPascalCase({String separator = ''}) {
    var words = _words.map(_upperCaseFirstLetter).toList();
    words = words.map(_uppercaseRomanCharacter).toList();
    words = words.map(_reservedWords).toList();

    // Apply English special terms to all words except the first
    if (words.isNotEmpty) {
      final wordsSublist = words.sublist(1);
      words = [words[0], ...wordsSublist.map(_englishSpecialTerm)];
    }

    return words.join(separator);
  }

  String _getSentenceCase({String separator = ' '}) {
    final words = _words.map((word) => word.toLowerCase()).toList();
    if (words.isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }

    return words.join(separator);
  }

  String _getSnakeCase({String separator = '_'}) {
    final words = _words.map((word) => word.toLowerCase()).toList();
    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    if (word.isEmpty) {
      return word;
    }

    final firstLetter = word[0].toUpperCase();

    // Handle special case for opening brackets
    // See: https://github.com/iqfareez/iium_schedule/issues/76
    if (word.length > 1) {
      if (firstLetter == '(' || firstLetter == '[' || firstLetter == '{') {
        if (word.length > 2) {
          return '$firstLetter${word[1].toUpperCase()}${word.substring(2).toLowerCase()}';
        } else {
          return '$firstLetter${word[1].toUpperCase()}';
        }
      }
    }

    return '$firstLetter${word.substring(1).toLowerCase()}';
  }

  /// Uppercase word if it's a Roman numeral.
  String _uppercaseRomanCharacter(String word) {
    const romanNumerals = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII'];

    if (romanNumerals.contains(word.toUpperCase())) {
      return word.toUpperCase();
    }
    return word;
  }

  /// Uppercase reserved terms that should always be in CAPS.
  String _reservedWords(String word) {
    const terms = ['ENM', 'IT', 'ELT', 'ESL'];

    if (terms.contains(word.toUpperCase())) {
      return word.toUpperCase();
    }
    return word;
  }

  /// Lowercase English articles and conjunctions that don't need capitalization.
  String _englishSpecialTerm(String word) {
    const englishTerms = [
      'a',
      'an',
      'and',
      'as',
      'at',
      'but',
      'of',
      'for',
      'to',
      'in',
      'the',
    ];

    if (englishTerms.contains(word.toLowerCase())) {
      return word.toLowerCase();
    }
    return word;
  }
}

/// Extension methods for String to provide easy access to case transformations.
extension StringReCase on String {
  /// Returns this string in camelCase format.
  String get camelCase => ReCase(this).camelCase;

  /// Returns this string in CONSTANT_CASE format.
  String get constantCase => ReCase(this).constantCase;

  /// Returns this string in Sentence case format.
  String get sentenceCase => ReCase(this).sentenceCase;

  /// Returns this string in snake_case format.
  String get snakeCase => ReCase(this).snakeCase;

  /// Returns this string in dot.case format.
  String get dotCase => ReCase(this).dotCase;

  /// Returns this string in param-case format.
  String get paramCase => ReCase(this).paramCase;

  /// Returns this string in path/case format.
  String get pathCase => ReCase(this).pathCase;

  /// Returns this string in PascalCase format.
  String get pascalCase => ReCase(this).pascalCase;

  /// Returns this string in Header-Case format.
  String get headerCase => ReCase(this).headerCase;

  /// Returns this string in Title Case format.
  String get titleCase => ReCase(this).titleCase;
}
