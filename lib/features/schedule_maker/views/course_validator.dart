import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../../shared/providers/schedule_maker_provider.dart';
import '../../../shared/utils/kulliyyah_suggestions.dart';
import '../../../shared/utils/kulliyyahs.dart';
import '../../../shared/utils/subject_fetcher.dart';
import '../../course browser/subject_screen.dart';
import '../../schedule_viewer/not_saved/views/schedule_layout.dart';
import '../controllers/course_validator_pass.dart';
import '../models/basic_subject_model.dart';
import 'mini_subject_info.dart';

CourseValidatorPass? _validatorPass;

class CourseValidator extends StatefulWidget {
  const CourseValidator({super.key});

  @override
  State<CourseValidator> createState() => _CourseValidatorState();
}

class _CourseValidatorState extends State<CourseValidator>
    with AutomaticKeepAliveClientMixin<CourseValidator> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ScheduleMakerProvider>(
        builder: (context, scheduleMaker, _) {
      _validatorPass = CourseValidatorPass(scheduleMaker.subjects!.length);
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ListView(
            children: [
              ListTile(
                title: const Text("Collecting subject informations"),
                contentPadding: const EdgeInsets.only(left: 16, right: 12),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: () async {
                        if (!_validatorPass!.isClearToProceed()) {
                          final res = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: Text(
                                  "${_validatorPass!.countFailedToFetch()} subject(s) information failed to fetch. Would you like to proceed anyway without the failed subjects?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Proceed"),
                                ),
                              ],
                            ),
                          );
                          // return if user select cancel or dismiss the dialog
                          if (!(res ?? false)) return;
                        }

                        await Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (_) {
                          var title =
                              '${scheduleMaker.kulliyah} ${scheduleMaker.albiruni!.semester} ${scheduleMaker.albiruni!.session}';
                          return ScheduleLayout(
                            initialName: title,
                            subjects: _validatorPass!.fetchedSubjects(),
                          );
                        }));
                        // reset full screen when it come back
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge);
                      },
                      child: const Text("Proceed"),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: scheduleMaker.subjects!.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (_, index) {
                  return SubjectCard(
                      // we need key to removed failed subject to 'fail' the next subject
                      key: ValueKey(scheduleMaker.subjects![index]),
                      albiruni: scheduleMaker.albiruni!,
                      kulliyah: scheduleMaker.kulliyah!,
                      subject: scheduleMaker.subjects![index],
                      index: index);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class SubjectCard extends StatefulWidget {
  const SubjectCard({
    super.key,
    required this.albiruni,
    required this.kulliyah,
    required this.subject,
    required this.index,
  });

  final BasicSubjectModel subject;
  final int index;
  final String kulliyah;
  final Albiruni albiruni;

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  final GlobalKey dropdownKey = GlobalKey();

  late Kuliyyah _selectedKulliyah;
  late Future<Subject> _subjectFuture;

  @override
  void initState() {
    super.initState();
    _selectedKulliyah = Kuliyyahs.kuliyyahFromCode(widget.kulliyah);

    _subjectFuture = SubjectFetcher.fetchSubjectData(
        albiruni: widget.albiruni,
        kulliyyah: KulliyyahSugestions.suggest(widget.subject.courseCode!) ??
            _selectedKulliyah.code,
        courseCode: widget.subject.courseCode!,
        section: widget.subject.section!);
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<ScheduleMakerProvider>(context).albiruni?.semester);
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondaryContainer,
        clipBehavior: Clip.hardEdge,
        child: Center(
          child: FutureBuilder(
            // try to find the kulliyyah for the course code
            // if cannot find, use the main kulliyyah
            future: _subjectFuture,
            builder: (context, AsyncSnapshot<Subject> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: MiniSubjectInfo(widget.subject),
                  title: const Text(
                    'Waiting...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  trailing: const Padding(
                    padding:
                        EdgeInsets.all(6.0), // to match refresh icon button
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return ListTile(
                    leading: MiniSubjectInfo(widget.subject),
                    title: const Text(
                      'Can\'t get subject info',
                    ),
                    subtitle: Align(
                      alignment: Alignment.centerLeft,
                      child: ActionChip(
                        visualDensity:
                            const VisualDensity(horizontal: 0.0, vertical: -4),
                        avatar: const CircleAvatar(
                          radius: 10,
                          child: Icon(Icons.edit, size: 13),
                        ),
                        label: Text(_selectedKulliyah.shortName),
                        tooltip: "Change kuliyyah for this subject",
                        onPressed: () async {
                          var newKull = await showDialog(
                            context: context,
                            builder: (_) => SimpleDialog(
                              title: Text(
                                  "${widget.subject.courseCode} belongs to which kulliyyah?"),
                              children: Kuliyyahs.all
                                  .map((e) => SimpleDialogOption(
                                        child: Text(e.fullName),
                                        onPressed: () =>
                                            Navigator.pop(context, e),
                                      ))
                                  .toList(),
                            ),
                          );

                          if (newKull != null) {
                            setState(() {
                              _selectedKulliyah = newKull;
                              _subjectFuture = SubjectFetcher.fetchSubjectData(
                                  albiruni: widget.albiruni,
                                  kulliyyah: _selectedKulliyah.code,
                                  courseCode: widget.subject.courseCode!,
                                  section: widget.subject.section!);
                            });
                          }
                        },
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      onPressed: () => setState(() {
                        // somehow this is hacky solution because is we just
                        // use `setState` it will not refreshing
                        _subjectFuture = SubjectFetcher.fetchSubjectData(
                            albiruni: widget.albiruni,
                            kulliyyah: _selectedKulliyah.code,
                            courseCode: widget.subject.courseCode!,
                            section: widget.subject.section!);
                      }),
                      color: Colors.yellow.shade700,
                    ));
              }

              // TODO: Re-evalute this. Check by index, really?
              // Check if every subjects is exist of the server
              _validatorPass!.subjectSuccess(widget.index, snapshot.data!);

              return ListTile(
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                leading: MiniSubjectInfo(widget.subject),
                title: Text(snapshot.data!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                subtitle: Text(
                  ReCase(snapshot.data!.lect.join(', ')).titleCase,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Padding(
                  padding: EdgeInsets.all(6.0), // to match refresh icon button
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => SubjectScreen(snapshot.data!)),
                  );
                },
              );
            },
          ),
        ));
  }
}
