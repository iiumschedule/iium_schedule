// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:albiruni/albiruni.dart';

// 🌎 Project imports:
import 'package:flutter_iium_schedule/browser_view.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  String session = "2020/2021";
  int semester = 1;
  String? selectedKulliyah;
  List<String> kulliyahs = [
    "AED",
    "BRIDG",
    "CFL",
    "CCAC",
    "EDUC",
    "ENGIN",
    "ECONS",
    "KICT",
    "IRKHS",
    "KLM",
    "LAWS"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Browser'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: selectedKulliyah,
                hint: const Text('Select kulliyyah'),
                items: kulliyahs
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedKulliyah = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            CupertinoSegmentedControl(
                groupValue: session,
                children: const {
                  "2020/2021": Text("2020/2021"),
                  "2021/2022": Text("2021/2022")
                },
                onValueChanged: (String value) {
                  setState(() {
                    session = value;
                  });
                }),
            const SizedBox(height: 10),
            CupertinoSegmentedControl(
                groupValue: semester - 1,
                children: List.generate(
                  3,
                  (index) => Text("Sem ${index + 1}"),
                ).asMap(),
                onValueChanged: (int value) {
                  setState(() {
                    semester = value + 1;
                  });
                  print(semester);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: CupertinoButton.filled(
                child: const Text('Get'),
                onPressed: selectedKulliyah == null
                    ? null
                    : () {
                        Albiruni albiruni = Albiruni(
                            kulliyah: selectedKulliyah!,
                            semester: semester,
                            session: session);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrowserView(albiruni: albiruni),
                          ),
                        );
                      },
              ),
            )
          ],
        ),
      ),
    );
  }
}
