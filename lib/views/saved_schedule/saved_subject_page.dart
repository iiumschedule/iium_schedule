import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../isar_models/saved_subject.dart';
import '../../providers/schedule_notifier_provider.dart';
import '../../services/isar_service.dart';
import '../../util/extensions.dart';
import 'colour_picker_sheet.dart';

class SavedSubjectPage extends StatefulWidget {
  const SavedSubjectPage(
      {super.key,
      required this.title,
      required this.subjectId,
      required this.dayTimesId,
      required this.subjectColor});

  final String title;
  final int subjectId;
  final int dayTimesId;
  final Color subjectColor;

  @override
  State<SavedSubjectPage> createState() => _SavedSubjectPageState();
}

class _SavedSubjectPageState extends State<SavedSubjectPage> {
  final IsarService isarService = IsarService();

  Color? newColor; // track selected new colour from colour picker

  Offset _tapPosition = Offset.zero;

  /// https://protocoderspoint.com/flutter-long-press-on-widget-show-context-popup-menu-item/
  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
    // no setState needed, [StreamBuilder] taking care of it
  }

  void _copyToClipboard(String text) {
    final data = ClipboardData(text: text);
    Clipboard.setData(data);
  }

  void _shareText(String text) => Share.share(text);

  /// Show menu to copy or share texts
  void _showCopyShareMenu(String textToCopy) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            value: "copy",
            child: Text('Copy'),
          ),
          const PopupMenuItem(
            value: "share",
            child: Text('Share'),
          )
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'copy':
        _copyToClipboard(textToCopy);
        break;
      case 'share':
        _shareText(textToCopy);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<SavedSubject?>(
          stream: isarService.listenToSavedSubject(id: widget.subjectId),
          builder: (context, snapshot) {
            String subjectTitle = snapshot.data?.subjectName ?? widget.title;
            String courseCode = snapshot.data?.code ?? '';
            int section = snapshot.data?.sect ?? 0;
            String? venue = snapshot.data?.venue;
            List<String> lecturers = snapshot.data?.lect ?? [];
            TimeOfDay startTime = TimeOfDay(
                hour: snapshot.data != null
                    ? int.parse(snapshot.data!.dayTimes.first.startTime
                        .split(":")
                        .first)
                    : 0,
                minute: snapshot.data != null
                    ? int.parse(
                        snapshot.data!.dayTimes.first.startTime.split(":").last)
                    : 0);
            TimeOfDay endTime = TimeOfDay(
                hour: snapshot.data != null
                    ? int.parse(
                        snapshot.data!.dayTimes.first.endTime.split(":").first)
                    : 0,
                minute: snapshot.data != null
                    ? int.parse(
                        snapshot.data!.dayTimes.first.endTime.split(":").last)
                    : 0);
            // generate custom color scheme based on subject color
            ColorScheme subjectCustomScheme = ColorScheme.fromSeed(
                seedColor: newColor ?? widget.subjectColor,
                brightness: Theme.of(context).brightness);

            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: MySliverPersistentHeaderDelegate(
                    tag: '${widget.subjectId}-${widget.dayTimesId}',
                    // subjectCustomScheme.primary,
                    bgColor: newColor ?? widget.subjectColor,
                    title: subjectTitle,
                    onDeleteCallback: () async {
                      // show alert dialog
                      var res = await showDialog(
                          context: context,
                          builder: (_) => const _DeleteSubjectDialog());

                      if (res == null) return;

                      await isarService.deleteSingleSubject(
                          subjectId: widget.subjectId,
                          dayTimesId: widget.dayTimesId);
                      if (!mounted) return;
                      Navigator.pop(context);
                      Provider.of<ScheduleNotifierProvider>(context,
                              listen: false)
                          .notify();
                    },
                    onColourPickerCallback: () async {
                      Color? selectedColour = await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => ColourPickerSheet(
                              color: newColor ?? widget.subjectColor));

                      if (selectedColour == null) return;

                      snapshot.data!.hexColor = selectedColour.value;
                      newColor = selectedColour;

                      isarService.updateSubject(snapshot.data!);
                      // notify the schedule behind the dialog to reflect the
                      // new information
                      Provider.of<ScheduleNotifierProvider>(context,
                              listen: false)
                          .notify();
                    },
                  ),
                  pinned: true,
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (details) => _getTapPosition(details),
                              child: _MiniInfoCard(
                                colourScheme: subjectCustomScheme,
                                title: courseCode,
                                subtitle: 'Course Code',
                                onLongPressCallback: () {
                                  _showCopyShareMenu(courseCode);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (details) => _getTapPosition(details),
                              child: _MiniInfoCard(
                                colourScheme: subjectCustomScheme,
                                title: section.toString(),
                                subtitle: 'Section',
                                onLongPressCallback: () {
                                  _showCopyShareMenu('Section $section');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTapDown: (details) => _getTapPosition(details),
                        child: _MiniEditCard(
                          colourScheme: subjectCustomScheme,
                          title: venue ?? 'No venue',
                          subtitle: 'Venue',
                          onEditPressed: () async {
                            // show dialog with textfield

                            String? res = await showDialog(
                                context: context,
                                builder: (_) {
                                  return _EditDialog(
                                    colourScheme: subjectCustomScheme,
                                    currentVenue: venue ?? '',
                                  );
                                });

                            if (res == null) return;

                            // update venue in db
                            snapshot.data!.venue = res;
                            isarService.updateSubject(snapshot.data!);
                            // Provider.of<ScheduleNotifierProvider>(context,
                            //         listen: false)
                            //     .notify();
                          },
                          onLongPressCallback: () {
                            _showCopyShareMenu(venue ?? 'No venue');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _MiniInfoTimeCard(
                        colourScheme: subjectCustomScheme,
                        startTime: startTime,
                        endTime: endTime,
                        onLongPressCallback: () {
                          _showCopyShareMenu(
                              '${startTime.format(context)} - ${endTime.format(context)}');
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _MiniInfoListCard(
                        colourScheme: subjectCustomScheme,
                        items: lecturers,
                        subtitle:
                            lecturers.length > 1 ? 'Lecturers' : 'Lecturer',
                        onLongPressCallback: () {
                          _showCopyShareMenu(lecturers.join(', '));
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ))
              ],
            );
          }),
    );
  }
}

/// Dialog for editing value
class _EditDialog extends StatefulWidget {
  const _EditDialog({
    Key? key,
    required this.colourScheme,
    required this.currentVenue,
  }) : super(key: key);

  final ColorScheme colourScheme;
  final String currentVenue;

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final TextEditingController _venueTextController;

  @override
  void initState() {
    super.initState();
    _venueTextController = TextEditingController(text: widget.currentVenue);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Make dialog theme follow subject theme
      data: Theme.of(context).copyWith(
          colorScheme: widget.colourScheme,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: widget.colourScheme.primary,
            selectionColor: widget.colourScheme.primaryContainer,
            // There is currently an issue where the teardrop selection
            // is not respecting the property below
            // https://github.com/flutter/flutter/issues/74890
            selectionHandleColor: widget.colourScheme.primary,
          )),
      child: AlertDialog(
        // backgroundColor: subjectCustomScheme.background,
        title: const Text('Edit Venue'),
        content: TextField(
          controller: _venueTextController,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                print(_venueTextController.text);
                Navigator.pop(context, _venueTextController.text);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }
}

/// Static mini card to display course code, section etc.
class _MiniInfoCard extends StatelessWidget {
  const _MiniInfoCard({
    Key? key,
    required this.colourScheme,
    required this.title,
    required this.subtitle,
    required this.onLongPressCallback,
  }) : super(key: key);

  final ColorScheme colourScheme;
  final String title;
  final String subtitle;
  final VoidCallback? onLongPressCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colourScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: onLongPressCallback,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same as [_MiniInfoCard], but have editing callback
class _MiniEditCard extends StatelessWidget {
  const _MiniEditCard({
    Key? key,
    required this.colourScheme,
    required this.title,
    required this.subtitle,
    required this.onEditPressed,
    required this.onLongPressCallback,
  }) : super(key: key);

  final ColorScheme colourScheme;
  final String title;
  final String subtitle;
  final VoidCallback onEditPressed;
  final VoidCallback? onLongPressCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colourScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: onLongPressCallback,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // empty space
              const IconButton(onPressed: null, icon: SizedBox.shrink()),
              Column(
                children: [
                  SelectableText(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              IconButton(onPressed: onEditPressed, icon: const Icon(Icons.edit))
            ],
          ),
        ),
      ),
    );
  }
}

/// Same as [_MiniInfoCard], but accepting lists of string
/// If one item, will not show numbering
class _MiniInfoListCard extends StatelessWidget {
  const _MiniInfoListCard({
    Key? key,
    required this.colourScheme,
    required this.items,
    required this.subtitle,
    required this.onLongPressCallback,
  }) : super(key: key);

  final ColorScheme colourScheme;
  final List<String> items;
  final String subtitle;
  final VoidCallback onLongPressCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colourScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: onLongPressCallback,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (items.length == 1)
                AutoSizeText(
                  items.first,
                  minFontSize: 12,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

              /// If map to an individual [AutoSizeText], the font size may be
              ///  different from each other
              if (items.length > 1)
                AutoSizeText(
                  items
                      .asMap()
                      .map((i, name) => MapEntry(i, "${i + 1}. $name"))
                      .values
                      .join("\n"),
                  minFontSize: 12,
                  maxLines: items.length,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same as [_MiniInfoCard], but accepting lists of string
/// If one item, will not show numbering
class _MiniInfoTimeCard extends StatelessWidget {
  const _MiniInfoTimeCard({
    Key? key,
    required this.colourScheme,
    required this.startTime,
    required this.endTime,
    required this.onLongPressCallback,
  }) : super(key: key);

  final ColorScheme colourScheme;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback onLongPressCallback;

  @override
  Widget build(BuildContext context) {
    // TimeOfDay duration = endTime.difference(startTime);
    return Card(
      elevation: 0,
      color: colourScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: onLongPressCallback,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                      flex: 2,
                      child: Text(
                        startTime.toRealString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Expanded(child: Divider(color: colourScheme.secondary)),
                  Expanded(
                      flex: 2,
                      child: Text(
                        endTime.toRealString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  const Spacer(),
                ],
              ),
              const Text(
                'Time',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Similar to _DeleteDialog in [body.dart]
class _DeleteSubjectDialog extends StatelessWidget {
  const _DeleteSubjectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Delete this subject?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              elevation: 0),
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: Text(
            "Delete",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      ],
    );
  }
}

/// https://stackoverflow.com/a/75434707/13617136
/// https://github.com/iqfareez/flutter_hero_sliver/pull/1
class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String tag;
  final Color bgColor;
  final String title;
  final VoidCallback onDeleteCallback;
  final VoidCallback onColourPickerCallback;

  MySliverPersistentHeaderDelegate({
    required this.tag,
    required this.bgColor,
    required this.title,
    required this.onDeleteCallback,
    required this.onColourPickerCallback,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Color foregroundAppbarColor =
        bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Hero(
      tag: tag,
      child: Material(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          color: bgColor,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onColourPickerCallback,
                        icon: Icon(
                          Icons.color_lens,
                          color: foregroundAppbarColor,
                        ),
                      ),
                      IconButton(
                        onPressed: onDeleteCallback,
                        icon: Icon(
                          Icons.delete,
                          color: foregroundAppbarColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        12, kToolbarHeight - 20, 12, 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        title,
                        minFontSize: 14,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: foregroundAppbarColor,
                            fontSize: 30,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600),
                        maxLines: 4,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: foregroundAppbarColor,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => kToolbarHeight + 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
