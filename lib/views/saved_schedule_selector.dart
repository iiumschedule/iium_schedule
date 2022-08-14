import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../hive_model/saved_schedule.dart';
import 'saved_schedule/saved_schedule_layout.dart';

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
        title: const Text("Saved schedule"),
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: AnimatedList(
        padding: const EdgeInsets.all(8),
        initialItemCount: box.length,
        itemBuilder: (context, index, animation) {
          var item = box.getAt(index);
          return _CardItem(
            item: item!,
            animation: animation,
            onTap: () async {
              var res = await showDialog(
                context: context,
                builder: (_) => const _DeleteDialog(),
              );

              if (res ?? false) {
                await box.deleteAt(index);
                // ignore: use_build_context_synchronously
                AnimatedList.of(context).removeItem(
                    index,
                    (context, animation) => _CardItem(
                          item: item,
                          animation: animation,
                        ));
              }
            },
          );
        },
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({
    Key? key,
    required this.item,
    required this.animation,
    this.onTap,
  }) : super(key: key);

  final SavedSchedule item;
  final VoidCallback? onTap;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('d/M/yy').format(DateTime.parse(item.lastModified));
    return ScaleTransition(
      scale: animation,
      child: Card(
        child: ListTile(
          title: Text(item.title!),
          subtitle: Text('Last modified: $formattedDate'),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
            onPressed: onTap,
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

            // refresh page when come back to this screen
            // setState(() {});
          },
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm delete"),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
