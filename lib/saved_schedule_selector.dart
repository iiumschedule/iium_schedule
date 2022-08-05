import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'constants.dart';
import 'model/saved_schedule.dart';
import 'views/saved_schedule/saved_schedule_layout.dart';

class SavedScheduleSelector extends StatefulWidget {
  const SavedScheduleSelector({Key? key}) : super(key: key);

  @override
  State<SavedScheduleSelector> createState() => _SavedScheduleSelectorState();
}

class _SavedScheduleSelectorState extends State<SavedScheduleSelector> {
  final box = Hive.box<SavedSchedule>(kHiveSavedSchedule);

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
      // TODO: Letak animated listview
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: box.length,
        itemBuilder: (context, index) {
          var item = box.getAt(index);
          return Card(
            child: ListTile(
              title: Text(item!.title!),
              subtitle: Text('Last modified: ${item.lastModified}'),
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
                          onPressed: () async {
                            Navigator.pop(context);
                            await box.deleteAt(index);
                            setState(() {});
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SavedScheduleLayout(
                      savedSchedule: item,
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
