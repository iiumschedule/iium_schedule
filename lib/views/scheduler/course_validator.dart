import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../util/course_validator_pass.dart';
import 'schedule_maker_data.dart';
import '../course%20browser/subject_screen.dart';
import 'schedule_layout.dart';
import 'package:recase/recase.dart';
import '../../model/basic_subject_model.dart';

CourseValidatorPass? _validatorPass;

class CourseValidator extends StatefulWidget {
  const CourseValidator({Key? key}) : super(key: key);

  @override
  _CourseValidatorState createState() => _CourseValidatorState();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title:
                  const Text("Please ensure all the subject data is available"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setState(() {}),
                    tooltip: "Refresh",
                    icon: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: () {
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

                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => ScheduleLayout(
                              _validatorPass!.fetchedSubjects())));
                    },
                    child: const Text("Proceed"),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ScheduleMakerData.subjects!.length,
              itemBuilder: (_, index) {
                return SubjectCard(
                    albiruni: ScheduleMakerData.albiruni!,
                    kulliyah: ScheduleMakerData.kulliyah!,
                    subject: ScheduleMakerData.subjects![index],
                    index: index);
              },
            )
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
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  final GlobalKey dropdownKey = GlobalKey();

  late String _selectedKulliyah;
  final List<String> _kulliyahs = [
    "AED",
    "BRIDG",
    "CFL",
    "CCAC",
    "EDUC",
    "ENGIN",
    "ECONS",
    "KICT",
    "IRKHS",
    "KLM",
    "LAWS"
  ];

  @override
  void initState() {
    super.initState();
    _selectedKulliyah = widget.kulliyah;
  }

  Future<Subject> fetchSubjectData(
      String kulliyah, String courseCode, int? section) async {
    Albiruni albiruni = ScheduleMakerData.albiruni!;
    var fetchedSubjects = await albiruni.fetch(_selectedKulliyah,
        course: courseCode, useProxy: kIsWeb);
    return fetchedSubjects.firstWhere((element) => element.sect == section);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Center(
      child: FutureBuilder(
        future: fetchSubjectData(_selectedKulliyah, widget.subject.courseCode!,
            widget.subject.section),
        builder: (context, AsyncSnapshot<Subject> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              leading: MiniSubjectInfo(widget.subject),
              title: const Text(
                'Waiting...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return ListTile(
                leading: MiniSubjectInfo(widget.subject),
                title: const Text(
                  'Can\'t get subject info',
                ),
                subtitle: Row(
                  children: [
                    const Expanded(child: Text("Override kulliyyah:")),
                    Expanded(
                      child: Listener(
                        onPointerDown: (_) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: DropdownButton(
                          items: _kulliyahs
                              .map(
                                (e) =>
                                    DropdownMenuItem(child: Text(e), value: e),
                              )
                              .toList(),
                          isDense: true,
                          value: _selectedKulliyah,
                          icon: const SizedBox.shrink(),
                          onChanged: (String? value) {
                            setState(() => _selectedKulliyah = value!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.error_outline,
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
            trailing: const Icon(
              Icons.check,
              color: Colors.green,
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
