import 'package:albiruni/albiruni.dart';
import 'package:material_ui/material_ui.dart';
import 'package:like_button/like_button.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/extensions/string_extension.dart';
import '../../shared/services/isar_service.dart';
import '../../shared/extensions/int_extension.dart';
import 'components/detail_card.dart';
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
    final sessions = widget.subject.dayTime.whereType<DayTime>().toList();
    final lecturers =
        widget.subject.lect.where((name) => name.trim().isNotEmpty).toList();
    final venue = widget.subject.venue?.trim();

    return GestureDetector(
      onTap: () {
        // to dismiss text selection when tapped outside
        FocusScope.of(context).unfocus();
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
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            widget.subject.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4.0,
                            children: [
                              SubjectInfoChip(text: widget.subject.code),
                              SubjectInfoChip(
                                text:
                                    '${widget.subject.chr.toString().removeTrailingDotZero()} CH',
                              ),
                              SubjectInfoChip(
                                text: 'Section ${widget.subject.sect}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    DetailCard(
                      title: 'Sessions',
                      icon: Icons.calendar_today_outlined,
                      children: [
                        if (sessions.isEmpty)
                          const Text('No sessions available'),
                        for (var index = 0;
                            index < sessions.length;
                            index++) ...[
                          if (index > 0) const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SelectableText(
                                  ReCase(sessions[index].day.englishDay())
                                      .titleCase,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SelectableText(
                                  '${sessions[index].startTime} - ${sessions[index].endTime}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    DetailCard(
                      title: lecturers.length == 1 ? 'Lecturer' : 'Lecturers',
                      icon: Icons.person_outline,
                      children: [
                        if (lecturers.isEmpty)
                          const Text('No lecturer information available'),
                        for (var index = 0;
                            index < lecturers.length;
                            index++) ...[
                          if (index > 0) const SizedBox(height: 12),
                          SelectableText(
                            ReCase(lecturers[index]).titleCase,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    DetailCard(
                      title: 'Venue',
                      icon: Icons.location_on_outlined,
                      children: [
                        SelectableText(
                          venue == null || venue.isEmpty
                              ? 'No venue information available'
                              : venue,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
