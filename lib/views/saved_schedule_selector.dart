import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../isar_models/saved_schedule.dart';
import '../services/isar_service.dart';
import 'saved_schedule/saved_schedule_layout.dart';

class SavedScheduleSelector extends StatefulWidget {
  const SavedScheduleSelector({Key? key}) : super(key: key);

  @override
  State<SavedScheduleSelector> createState() => _SavedScheduleSelectorState();
}

class _SavedScheduleSelectorState extends State<SavedScheduleSelector> {
  final IsarService isar = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved schedule"),
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: StreamBuilder(
        stream: isar.listenToAllSchedulesChanges(),
        builder: (_, __) {
          var data = isar.getAllSchedule();
          return AnimatedList(
            padding: const EdgeInsets.all(8),
            initialItemCount: data.length,
            itemBuilder: (context, index, animation) {
              var item = data[index];
              return _CardItem(
                item: item,
                animation: animation,
                onTap: () async {
                  var res = await showDialog(
                    context: context,
                    builder: (_) => const _DeleteDialog(),
                  );

                  if (res ?? false) {
                    // ignore: use_build_context_synchronously
                    AnimatedList.of(context).removeItem(
                        index,
                        (context, animation) => _CardItem(
                              item: item,
                              animation: animation,
                            ));

                    // Note that index and id in this case
                    // are two different things
                    // index: to AnimatedList know where to move
                    // id: the isar id
                    await isar.deleteSchedule(item.id!);
                    setState(() {}); // refresh list
                  }
                },
              );
              // print(item);
              // return Text(item.toString());
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
          leading: kDebugMode ? Text('${item.id}*') : null,
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
                  id: item.id!,
                ),
              ),
            );

            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      content: const Text('Deleted schedule can\'t be recover'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
