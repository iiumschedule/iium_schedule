import 'dart:io';

import 'package:admonitions/admonitions.dart';
import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/isar_service.dart';
import '../../util/extensions.dart';
import '../../util/my_ftoast.dart';

IsarService isarService = IsarService();

/// Subject detail viewer
class SubjectScreen extends StatefulWidget {
  const SubjectScreen(this.subject,
      {Key? key, this.isCached = false, this.albiruni, this.kulliyyah})
      : super(key: key);

  /// Subject information from albiruni
  final Subject subject;

  /// Marked the subject is fresh or cached
  ///
  /// eg: it is live when loaded from course browser page
  /// and it is cached when loaded from saved schedule page
  final bool isCached;

  /// Pass this from Course Browser, as a context to save to Favourites
  final Albiruni? albiruni;

  /// Pass this from Course Browser, as a context to save to Favourites
  final String? kulliyyah;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Subject details'),
        // shadowColor: Colors.transparent,
        actions: [
          // only shows favourite button when the subject is loaded from course browser
          if (widget.albiruni != null && widget.kulliyyah != null)
            FutureBuilder<int?>(
                future: isarService.checkFavourite(
                    widget.albiruni!, widget.kulliyyah!, widget.subject),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return const SizedBox.shrink();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data != null) {
                    return IconButton(
                      onPressed: () async {
                        await isarService
                            .removeFavouritesSubject(snapshot.data!);
                        setState(() {});
                      },
                      icon: const Icon(Icons.favorite),
                      tooltip: "Remove this subject from favourite",
                    );
                  }
                  return IconButton(
                    onPressed: () async {
                      await isarService.addFavouritesSubject(
                          widget.albiruni!, widget.kulliyyah!, widget.subject);

                      setState(() {});
                    },
                    icon: const Icon(Icons.favorite_outline),
                    tooltip: "Add this subject to favourite",
                  );
                }),
          IconButton(
            onPressed: () {
              String text = '${widget.subject.title} (${widget.subject.code})';
              text += '\n';
              text += '\nSection: ${widget.subject.sect}';
              text += '\nCredit hour: ${widget.subject.chr}';
              text += '\nLecturer(s): ${widget.subject.lect.join(', ')}';
              text += '\nVenue: ${widget.subject.venue ?? '-'}';
              Share.share(text);
            },
            icon: const Icon(Icons.share_outlined),
            tooltip: "Share this subject",
          )
        ],
      ),
      // TODO: Maybe boleh letak SelectionArea widget to the whole child
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isCached)
                PastelAdmonition.info(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  text:
                      'This is cached version as of the creation of the schedule',
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SelectableText(
                  widget.subject.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                children: [
                  TextBubble(
                    text: widget.subject.code,
                    icon: Icons.label_outline,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextBubble(
                    text:
                        'Chr ${widget.subject.chr.toString().removeTrailingDotZero()}',
                    icon: Icons.class_outlined,
                    backgroundColor: Colors.deepPurple,
                  ),
                  TextBubble(
                    text: 'Section ${widget.subject.sect}',
                    icon: Icons.group_outlined,
                    backgroundColor: Colors.deepOrange,
                  ),
                ],
              ),
              const Text(
                '\nSession(s)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              _DayTimeTable(widget.subject.dayTime),
              const Text(
                '\nLecturer(s)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...List.generate(
                widget.subject.lect.length,
                (index) => SelectableText(
                    '${index + 1}. ${ReCase(widget.subject.lect[index]).titleCase}'),
              ),
              const Text(
                '\nVenue',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(widget.subject.venue ?? '-')
            ],
          ),
        ),
      ),
    );
  }
}

class _DayTimeTable extends StatelessWidget {
  const _DayTimeTable(
    this.dayTimes, {
    Key? key,
  }) : super(key: key);

  final List<DayTime?> dayTimes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowHeight: 32,
      showBottomBorder: true,
      columns: const ["Day", "Time"]
          .map(
            (e) => DataColumn(
                label: Expanded(
              child: Text(
                e,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )),
          )
          .toList(),
      headingRowHeight: 32,
      rows: dayTimes
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  SelectableText(ReCase(e!.day.englishDay()).titleCase),
                ),
                DataCell(
                  SelectableText('${e.startTime} - ${e.endTime}'),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}

class TextBubble extends StatelessWidget {
  const TextBubble({
    Key? key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // for Android, long press to copy
        if (!kIsWeb || Platform.isAndroid) {
          Clipboard.setData(ClipboardData(text: text)).then((_) {
            Fluttertoast.showToast(msg: 'Copied');
            HapticFeedback.lightImpact();
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ActionChip(
          onPressed: () {
            // on Windows or Web, tap to copy
            if (kIsWeb || Platform.isWindows) {
              Clipboard.setData(ClipboardData(text: text)).then((_) {
                HapticFeedback.lightImpact();

                // handle toast based on platform
                if (kIsWeb) {
                  Fluttertoast.showToast(msg: 'Copied');
                } else {
                  MyFtoast.show(context, 'Copied');
                }
              });
            }
          },
          pressElevation: 2,
          avatar: Icon(icon, size: 18),
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          backgroundColor: backgroundColor.withAlpha(40),
          label: Text(text),
        ),
      ),
    );
  }
}
