import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../isar_models/saved_schedule.dart';
import '../../services/isar_service.dart';
import '../../util/kulliyyahs.dart';

final IsarService isarService = IsarService();

/// Show info about the save schedule
class MetadataSheet extends StatelessWidget {
  const MetadataSheet({super.key, required this.savedScheduleId});

  final int savedScheduleId;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return StreamBuilder(
            stream: isarService.listenToSavedSchedule(id: savedScheduleId),
            builder: (context, AsyncSnapshot<SavedSchedule?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              DateTime lastModifiedDate = snapshot.data!.lastModified;
              DateTime createdDate = snapshot.data!.dateCreated;
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const _LeadingTextWidget('Acedemic Year:'),
                      title: Text(snapshot.data!.session),
                    ),
                    ListTile(
                      leading: const _LeadingTextWidget('Kuliyyah:'),
                      title: snapshot.data!.kuliyyah != null
                          ? Text(
                              '${Kuliyyahs.kuliyyahFromCode(snapshot.data!.kuliyyah!)}')
                          : Row(
                              children: [
                                const Text('Not set'),
                                const SizedBox(width: 8),
                                ActionChip(
                                  label: const Text('Set now'),
                                  onPressed: () async {
                                    var newKull = await showDialog(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                        title: const Text(
                                            "Set your main kuliyyah"),
                                        children: Kuliyyahs.all
                                            .map((e) => SimpleDialogOption(
                                                  child: Text(e.fullName),
                                                  onPressed: () =>
                                                      Navigator.pop(context, e),
                                                ))
                                            .toList(),
                                      ),
                                    );

                                    if (newKull == null) return;

                                    var res = await showDialog(
                                        context: context,
                                        builder: ((context) => AlertDialog(
                                              content: Text(
                                                  'This will set the main kuliyyah for this schedule to ${newKull.fullName}.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            )));

                                    if (res ?? false) {
                                      snapshot.data!.kuliyyah = newKull.code;
                                      await isarService
                                          .updateSchedule(snapshot.data!);
                                    }
                                  },
                                )
                              ],
                            ),
                    ),
                    ListTile(
                      leading: const _LeadingTextWidget('Semester:'),
                      title: Text('Sem ${snapshot.data!.semester}'),
                    ),
                    ListTile(
                      leading: const _LeadingTextWidget('Subject count:'),
                      title: Text(snapshot.data!.subjects.length.toString()),
                    ),
                    ListTile(
                      leading: const _LeadingTextWidget('Last modified:'),
                      title:
                          Text(DateFormat('d/M/yy').format(lastModifiedDate)),
                      subtitle: Text(
                          '${DateFormat('hh:mm:ss').format(lastModifiedDate)} (${DateFormat('EEEE').format(lastModifiedDate)})'),
                    ),
                    ListTile(
                      leading: const _LeadingTextWidget('Created on:'),
                      title: Text(DateFormat('d/M/yy').format(createdDate)),
                      subtitle: Text(
                          '${DateFormat('hh:mm:ss').format(createdDate)} (${DateFormat('EEEE').format(createdDate)})'),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

class _LeadingTextWidget extends StatelessWidget {
  const _LeadingTextWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(text)],
    );
  }
}
