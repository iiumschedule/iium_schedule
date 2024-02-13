class AcademicSession {
  /// Returns a list of academic sessions. Replace previous implementation
  /// using hardcoded constants [kSessions]
  ///
  /// Eg: ['2023/2024', '2024/2025']
  static List<String> get session {
    var yearNow = DateTime.now().year;

    return [
      '${yearNow - 1}/$yearNow',
      '$yearNow/${yearNow + 1}',
    ];
  }
}
