/// Join arrays with commas and a separator before the last item.
///
/// Usage:
///   and(['1', '2', '3']); // '1, 2 & 3'
///   and(['1', '2', '3'], oxfordComma: true); // '1, 2, & 3'
///   and(['1', '2', '3'], separator: 'and'); // '1, 2 and 3'
///
/// Parameters:
///   - [list]: List of Strings (required)
///   - [separator]: String for last separator (default: '&')
///   - [oxfordComma]: bool for Oxford comma (default: false)
///
/// Original code: https://github.com/Sayegh7/and
String and(List<String> list,
    {String separator = '&', bool oxfordComma = false}) {
  int items = list.length;
  String lastItem = list.removeLast();
  if (list.isNotEmpty) {
    return "${list.join(', ')}${oxfordComma && items > 2 ? ',' : ''} $separator $lastItem"
        .trim();
  }
  return lastItem;
}
