import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../../model/basic_subject_model.dart';
import '../../util/kulliyyah_suggestions.dart';
import '../../util/kulliyyahs.dart';
import '../../util/subject_fetcher.dart';
import '../scheduler/course_validator.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage(
      {super.key, required this.session, required this.semester});

  // TODO: add default kulliyyah. Currently not possible because
  // SavedSchedule object doesn't store main kulliyyah information
  final String session;
  final int semester;

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  String? _selectedKulliyah;
  int? _selectedSection;
  bool hasManuallySelectedKulliyah = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add new subject"),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _courseCodeController,
                      decoration: const InputDecoration(
                        labelText: "Subject Code",
                        hintText: "eg: UNGS 2080",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (!hasManuallySelectedKulliyah) {
                          setState(() {
                            _selectedKulliyah = KulliyyahSugestions.suggest(
                                value.toAlbiruniFormat());
                          });
                        }
                      },
                      onEditingComplete: () {
                        _courseCodeController.text =
                            _courseCodeController.text.toAlbiruniFormat();
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _sectionController,
                      decoration: const InputDecoration(
                        labelText: "Section",
                        hintText: "eg: 2",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {
                          _selectedSection =
                              int.tryParse(_sectionController.text);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField(
                      items: Kuliyyahs.all
                          .map((e) => DropdownMenuItem(
                                value: e.code,
                                child: Text(e.fullName),
                              ))
                          .toList(),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      value: _selectedKulliyah,
                      selectedItemBuilder: (_) =>
                          Kuliyyahs.all.map((e) => Text(e.shortName)).toList(),
                      hint: const Text('Select kulliyyah'),
                      onChanged: (String? value) {
                        hasManuallySelectedKulliyah = true;
                        setState(() => _selectedKulliyah = value);
                      },
                    ),
                    const SizedBox(height: 30),
                    if ((_selectedKulliyah != null &&
                            _selectedKulliyah!.isNotEmpty) &&
                        _courseCodeController.text.isNotEmpty &&
                        _selectedSection != null)
                      _SubjectAddCard(
                        key: ValueKey(
                            "${_courseCodeController.text.toAlbiruniFormat()}$_selectedSection"),
                        albiruni: Albiruni(
                            semester: widget.semester, session: widget.session),
                        kulliyyah: _selectedKulliyah!,
                        section: _selectedSection!,
                        courseCode:
                            _courseCodeController.text.toAlbiruniFormat(),
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

class _SubjectAddCard extends StatefulWidget {
  const _SubjectAddCard({
    Key? key,
    required this.albiruni,
    required this.kulliyyah,
    required this.courseCode,
    required this.section,
  }) : super(key: key);

  final Albiruni albiruni;
  final String kulliyyah;
  final String courseCode;
  final int section;

  @override
  State<_SubjectAddCard> createState() => __SubjectAddCardState();
}

class __SubjectAddCardState extends State<_SubjectAddCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SubjectFetcher.fetchSubjectData(
        albiruni: widget.albiruni,
        kulliyyah: widget.kulliyyah,
        section: widget.section,
        courseCode: widget.courseCode,
      ),
      builder: (context, AsyncSnapshot<Subject> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Loading'),
            trailing: SizedBox(
                height: 15, width: 15, child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return ListTile(
            title: const Text('Error. Subject may not be available'),
            trailing: const Icon(Icons.refresh_outlined),
            onTap: () {
              setState(() {});
            },
          );
        }

        // TODO: Add option check another section if error returned

        return ListTile(
          leading: MiniSubjectInfo(
            BasicSubjectModel(
              courseCode: snapshot.data!.code,
              section: widget.section,
            ),
          ),
          title: Text(snapshot.data!.title),
          trailing: IconButton(
            tooltip: "Add this subject",
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pop(snapshot.data);
            },
          ),
        );
      },
    );
  }
}
