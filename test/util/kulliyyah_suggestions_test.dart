import 'package:flutter_test/flutter_test.dart';
import 'package:iium_schedule/util/kulliyyah_suggestions.dart';

void main() {
  test('Return correct kulliyyah suggestion', () {
    // tests correct codes
    var codes = ["CCUB 1062", "CCUB 1061"];
    for (var code in codes) {
      expect(KulliyyahSugestions.suggest(code), "CCAC");
    }

    codes = ["CCUB 2163", "CCUB 3164", "SCSH 2163"];
    for (var code in codes) {
      expect(KulliyyahSugestions.suggest(code), "SC4SH");
    }

    codes = [
      "LC 1014",
      "LE 1234",
      "LEED 1234",
      "LQAD 1234",
      "LM 2023",
      "TQ 3001",
      "TQTD 0004"
    ];
    for (var code in codes) {
      expect(KulliyyahSugestions.suggest(code), "CFL");
    }

    codes = ["UNGS 1234", "MPU 3122"];
    for (var code in codes) {
      expect(KulliyyahSugestions.suggest(code), "IRKHS");
    }
  });
}
