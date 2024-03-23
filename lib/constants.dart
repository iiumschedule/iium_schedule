import 'dart:io';

/// default session/current academic seesion
const String kDefaultSession = '2023/2024';

/// Values must be between 1 and 3 (inclusive)
const int kDefaultSemester = 2;

/// Check if app is running on macos or iphones/ipads
final kIsApple = Platform.isMacOS || Platform.isIOS;
