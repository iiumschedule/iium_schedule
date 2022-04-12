import 'dart:convert';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'constants.dart';
import 'views/scheduler/schedule_layout.dart';

class SavedScheduleSelector extends StatefulWidget {
  const SavedScheduleSelector({Key? key}) : super(key: key);

  @override
  State<SavedScheduleSelector> createState() => _SavedScheduleSelectorState();
}

class _SavedScheduleSelectorState extends State<SavedScheduleSelector> {
  final box = Hive.box(kHiveSavedSchedule);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved schedule",
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: box.length,
        itemBuilder: (context, index) {
          var name = box.keyAt(index);
          var data = box.getAt(index);
          return Card(
            child: ListTile(
              title: Text(name),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Confirm delete"),
                      actions: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => box.deleteAt(index));
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onTap: () async {
                List<dynamic> parsedListJson = jsonDecode(data);
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ScheduleLayout(
                      initialName: name,
                      subjects: List<Subject>.from(
                        parsedListJson.map((e) => Subject.fromJson(e)),
                      ),
                    ),
                  ),
                );

                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

                // refresh page when come back to thus screen
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
