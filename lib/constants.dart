/// Sessions (2-3 entries, I think 3 is enough)
/// Eg: current semester & upcoming semester
/// or: previous semester & current semester
const List<String> kSessions = ['2022/2023', '2023/2024'];

/// default session & semester (current academic seesion)
/// Values must exist in [sessions]
const String kDefaultSession = '2023/2024';

/// Values must be between 1 and 3 (inclusive)
const int kDefaultSemester = 1;

// Hive boxes name (do not change)
const kHiveSavedSchedule = "savedSchedule";
const kHiveGhResponse = "ghResponse";
