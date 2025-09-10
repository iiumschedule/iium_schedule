import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/extensions/int_extension.dart';
import '../../shared/extensions/string_extension.dart';
import '../../shared/services/isar_service.dart';
import '../../shared/utils/my_ftoast.dart';

IsarService isarService = IsarService();

/// Subject detail viewer
class SubjectScreen extends StatefulWidget {
  const SubjectScreen(this.subject, {super.key, this.albiruni, this.kulliyyah});

  /// Subject information from albiruni
  final Subject subject;

  /// Pass this from Course Browser, as a context to save to Favourites
  final Albiruni? albiruni;

  /// Pass this from Course Browser, as a context to save to Favourites
  final String? kulliyyah;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  /// Set when the subject is/already added to favourites
  int? favouriteId;

  @override
  void initState() {
    super.initState();

    // check subject if it is already added to favourites. If from schedule maker, I think we dont need
    // to have the favourite subject yet
    if (widget.albiruni != null && widget.kulliyyah != null) {
      isarService
          .checkFavourite(widget.albiruni!, widget.kulliyyah!, widget.subject)
          .then((value) => setState(() => favouriteId = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Subject details'),
        actions: [
          // only shows favourite button when the subject is loaded from course browser
          if (widget.albiruni != null && widget.kulliyyah != null)
            LikeButton(
              isLiked: favouriteId != null,
              likeBuilder: (isLiked) {
                if (isLiked) {
                  return const Icon(Icons.favorite, color: Colors.redAccent);
                } else {
                  return const Icon(Icons.favorite_outline);
                }
              },
              onTap: (isLiked) async {
                if (isLiked) {
                  isarService.removeFavouritesSubject(favouriteId!);
                } else {
                  int savedId = await isarService.addFavouritesSubject(
                      widget.albiruni!, widget.kulliyyah!, widget.subject);
                  setState(() => favouriteId = savedId);
                }
                return Future.value(!isLiked);
              },
            ),
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

      // Tak letak `SelectionArea` wrap the whole widget sbb taknak label (eg 'Time',
      // 'Lecturer') to be included in the selection
      //
      // tak pakai `showMenu` sbb entah, mcm tak kena
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  '${index + 1}. ${ReCase(widget.subject.lect[index]).titleCase}',
                  textAlign: TextAlign.center,
                ),
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
  const _DayTimeTable(this.dayTimes);

  final List<DayTime?> dayTimes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
  });

  final String text;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // for Android, long press to copy
        if (Platform.isAndroid) {
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
            if (Platform.isWindows) {
              Clipboard.setData(ClipboardData(text: text)).then((_) {
                HapticFeedback.lightImpact();

                MyFtoast.show(context, 'Copied');
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
