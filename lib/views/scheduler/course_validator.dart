import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recase/recase.dart';

import '../../model/basic_subject_model.dart';
import '../../util/course_validator_pass.dart';
import '../../util/kulliyyah_suggestions.dart';
import '../../util/kulliyyahs.dart';
import '../../util/subject_fetcher.dart';
import '../course%20browser/subject_screen.dart';
import 'schedule_view/schedule_layout.dart';
import 'schedule_maker_data.dart';

CourseValidatorPass? _validatorPass;

class CourseValidator extends StatefulWidget {
  const CourseValidator({Key? key}) : super(key: key);

  @override
  State<CourseValidator> createState() => _CourseValidatorState();
}

class _CourseValidatorState extends State<CourseValidator>
    with AutomaticKeepAliveClientMixin<CourseValidator> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    _validatorPass = CourseValidatorPass(ScheduleMakerData.subjects!.length);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ListView(
          children: [
            ListTile(
              title:
                  const Text("Please ensure all the subject data is available"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setState(() {}),
                    tooltip: "Refresh All",
                    icon: const Icon(Icons.restart_alt),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (!_validatorPass!.isClearToProceed()) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text(
                                "${_validatorPass!.countFailedToFetch()} subject failed to fetch. Please solve the error first"),
                          ),
                        );
                        return;
                      }

                      await Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (_) {
                        var title =
                            '${ScheduleMakerData.kulliyah} ${ScheduleMakerData.albiruni!.semester} ${ScheduleMakerData.albiruni!.session}';
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
              itemCount: ScheduleMakerData.subjects!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return SubjectCard(
                    albiruni: ScheduleMakerData.albiruni!,
                    kulliyah: ScheduleMakerData.kulliyah!,
                    subject: ScheduleMakerData.subjects![index],
                    index: index);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SubjectCard extends StatefulWidget {
  const SubjectCard({
    Key? key,
    required this.albiruni,
    required this.kulliyah,
    required this.subject,
    required this.index,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _selectedKulliyah = Kuliyyahs.kuliyyahFromCode(widget.kulliyah);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Center(
      child: FutureBuilder(
        // try to find the kulliyyah for the course code
        // if cannot find, use the main kulliyyah
        future: SubjectFetcher.fetchSubjectData(
            albiruni: ScheduleMakerData.albiruni!,
            kulliyyah:
                KulliyyahSugestions.suggest(widget.subject.courseCode!) ??
                    _selectedKulliyah.code,
            courseCode: widget.subject.courseCode!,
            section: widget.subject.section!),
        builder: (context, AsyncSnapshot<Subject> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              leading: MiniSubjectInfo(widget.subject),
              title: const Text(
                'Waiting...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: const Padding(
                padding: EdgeInsets.all(6.0), // to match refresh icon button
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
                                    onPressed: () => Navigator.pop(context, e),
                                  ))
                              .toList(),
                        ),
                      );

                      if (newKull != null) {
                        setState(() {
                          _selectedKulliyah = newKull;
                        });
                      }
                    },
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  onPressed: () => setState(() {}),
                  color: Colors.yellow.shade700,
                ));
          }

          // Check if every subjects is exist of the server
          _validatorPass!.subjectSuccess(widget.index, snapshot.data!);

          return ListTile(
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

class MiniSubjectInfo extends StatelessWidget {
  const MiniSubjectInfo(
    this.subject, {
    Key? key,
  }) : super(key: key);

  final BasicSubjectModel subject;

  final widgetTextStyle = const TextStyle(fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subject.courseCode!,
            style: widgetTextStyle,
          ),
          if (subject.section != null)
            Text(
              "Section ${subject.section}",
              style: widgetTextStyle,
            )
          else
            Text(
              "No section",
              style: widgetTextStyle,
            )
        ],
      ),
    );
  }
}
