import 'package:flutter_test/flutter_test.dart';
import 'package:iium_schedule/shared/extensions/string_extension.dart';

void main() {
  test("Remove trailing zeros test", () {
    var testValue = '3.0';
    expect(testValue.removeTrailingDotZero(), '3');

    // current implementation did not supports more that one traiiling zero
    expect(testValue, isNot('3'));
  });
}
