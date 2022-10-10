/// Set kuliyyah based on the common subject course code. [courseCode] must be
/// albiruni formatted already.
///
/// Eg: CCUB course will return SC4SH
///
/// Uses in course course validator
class KulliyyahSugestions {
  static String? suggest(String courseCode) {
    if (courseCode.contains(RegExp(r'CCUB [2-3]1'))) return 'SC4SH';
    if (courseCode.contains(RegExp(r'SCSH \d{4}$'))) return 'SC4SH';
    if (courseCode.contains(RegExp(r'CCUB 106[1-2]'))) return 'CCAC';
    if (courseCode.startsWith('CC')) return 'CCAC';
    if (courseCode.startsWith('LC')) return 'CFL';
    if (courseCode.startsWith('LE')) return 'CFL';
    if (courseCode.startsWith('LEED')) return 'CFL';
    if (courseCode.startsWith('LQAD')) return 'CFL';
    if (courseCode.startsWith('LM')) return 'CFL';
    if (courseCode.startsWith('TQ')) return 'CFL';
    if (courseCode.startsWith('TQTD')) return 'CFL';
    if (courseCode.startsWith('UNGS')) return 'IRKHS';
    if (courseCode.startsWith('MPU')) return 'IRKHS';

    return null;
  }
}
