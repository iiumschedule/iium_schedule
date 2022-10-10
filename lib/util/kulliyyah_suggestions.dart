/// Set kuliyyah based on the common subject course code. [courseCode] must be
/// albiruni formatted already.
///
/// Eg: CCUB course will return SC4SH
///
/// Uses in course course validator
class KulliyyahSugesstions {
  static String? suggest(String courseCode) {
    if (courseCode.contains(RegExp(r'CCUB [2-3]1'))) return 'SC4SH';
    if (courseCode.contains(RegExp(r'SCSH \d{4}$'))) return 'SC4SH';
    if (courseCode.contains(RegExp(r'CCUB 106[1-2]'))) return 'CCAC';
    if (courseCode.startsWith('CC')) return 'CCAC';
    if (courseCode.contains(RegExp(r'LC \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'LE \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'LEED \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'LQAD \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'LM \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'TQ \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'TQTD \d{4}$'))) return 'CFL';
    if (courseCode.contains(RegExp(r'UNGS \d{4}$'))) return 'IRKHS';
    if (courseCode.contains(RegExp(r'MPU \d{4}$'))) return 'IRKHS';
    return null;
  }
}
