import 'dart:io';

import 'package:flutter/foundation.dart';

/// default session/current academic seesion
const String kDefaultSession = '2023/2024';

/// Values must be between 1 and 3 (inclusive)
const int kDefaultSemester = 1;

/// Check if app is running on macos or iphones/ipads
final kIsApple = !kIsWeb && (Platform.isMacOS || Platform.isIOS);
