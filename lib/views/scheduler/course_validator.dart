import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../util/course_validator_pass.dart';
import '../course%20browser/subject_screen.dart';
import 'schedule_layout.dart';
import 'package:recase/recase.dart';
import '../../model/basic_subject_model.dart';

late CourseValidatorPass _validatorPass;

class CourseValidator extends StatefulWidget {
  const CourseValidator(
      {Key? key,
      required this.albiruni,
      required this.kulliyah,
      required this.subjects})
      : super(key: key);

  final List<BasicSubjectModel> subjects;
  final Albiruni albiruni;
  final String kulliyah;

  @override
  _CourseValidatorState createState() => _CourseValidatorState();
}

class _CourseValidatorState extends State<CourseValidator> {
  @override
  void initState() {
    super.initState();
    _validatorPass = CourseValidatorPass(widget.subjects.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Validator'),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                if (!_validatorPass.clearToProceed()) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                          "${_validatorPass.countFailedToFetch()} subject failed to fetch. Please solve the error first"),
                    ),
                  );
                  return;
                }

                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) =>
                        ScheduleLayout(_validatorPass.fetchedSubjects())));
              },
              child: const Icon(Icons.send_outlined))
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.builder(
              itemCount: widget.subjects.length,
              itemBuilder: (_, index) {
                return SubjectCard(
                    albiruni: widget.albiruni,
                    kulliyah: widget.kulliyah,
                    subject: widget.subjects[index],
                    index: index);
              }),
        ),
      ),
    );
  }
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

  final Albiruni albirui = Albiruni(semester: 1, session: "2021/2022");

  Future<Subject> fetchSubjectData(
      String kulliyah, String courseCode, int? section) async {
    var fetchedSubjects = await albirui.fetch(_selectedKulliyah,
        course: courseCode, useProxy: kIsWeb);
    return fetchedSubjects.firstWhere((element) => element.sect == section);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    child: DropdownButton(
                      items: _kulliyahs
                          .map(
                            (e) => DropdownMenuItem(child: Text(e), value: e),
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
                ],
              ),
              trailing: Icon(
                Icons.error_outline,
                color: Colors.yellow.shade700,
              ));
        }

        // Check if every subjects is exist of the server
        _validatorPass.subjectSuccess(widget.index, snapshot.data!);

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
              CupertinoPageRoute(builder: (_) => SubjectScreen(snapshot.data!)),
            );
          },
        );
      },
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
