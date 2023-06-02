/// Sessions (2-3 entries, I think 3 is enough)
/// Eg: current semester & upcoming semester
/// or: previous semester & current semester
/// https://albiruni.iium.edu.my/myapps/StudentOnline/schedule1.php
const List<String> kSessions = ['2022/2023', '2023/2024'];

/// default session & semester (current academic seesion)
/// Values must exist in [sessions]
const String kDefaultSession = '2022/2023';

/// Values must be between 1 and 3 (inclusive)
const int kDefaultSemester = 3;
