import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/extensions/string_extension.dart';
import '../../shared/services/isar_service.dart';
import 'components/day_time_table_widget.dart';
import 'components/subject_info_chip.dart';

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
    return GestureDetector(
      onTap: () {
        // to dismiss text selection when tapped outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                StringBuffer sb = StringBuffer(
                    '${widget.subject.title} (${widget.subject.code})');
                sb.writeln();
                sb.writeln();
                sb.writeln('Section: ${widget.subject.sect}');
                sb.writeln('Credit hour: ${widget.subject.chr}');
                sb.writeln('Lecturer(s): ${widget.subject.lect.join(', ')}');
                sb.writeln('Venue: ${widget.subject.venue ?? '-'}');

                final shareParams = ShareParams(text: sb.toString());
                SharePlus.instance.share(shareParams);
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
                    SubjectInfoChip(
                      text: widget.subject.code,
                      icon: Icons.label_outline,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    SubjectInfoChip(
                      text:
                          'Chr ${widget.subject.chr.toString().removeTrailingDotZero()}',
                      icon: Icons.class_outlined,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    SubjectInfoChip(
                      text: 'Section ${widget.subject.sect}',
                      icon: Icons.group_outlined,
                      foregroundColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ],
                ),
                const Text(
                  '\nSession(s)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                DayTimeTableWidget(dayTimes: widget.subject.dayTime),
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
      ),
    );
  }
}
