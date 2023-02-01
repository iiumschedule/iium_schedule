import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../../model/basic_subject_model.dart';
import '../../util/kulliyyah_suggestions.dart';
import '../../util/kulliyyahs.dart';
import '../../util/subject_fetcher.dart';
import '../scheduler/course_validator.dart';

// TODO: add default kulliyyah based on savedschedule killiyyah
// TODO: Prevent refetching when textfield unfocus (its quite hard, I need to track which value didn't change etc.)

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage(
      {super.key, required this.session, required this.semester});

  final String session;
  final int semester;

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _courseCodeController,
                      decoration: const InputDecoration(
                        labelText: "Subject Code",
                        hintText: "eg: UNGS 2080",
                        border: OutlineInputBorder(),
                      ),
                      onTapOutside: (event) {
                        if (_courseCodeController.text.isNotEmpty) {
                          _courseCodeController.text =
                              _courseCodeController.text.toAlbiruniFormat();
                        }
                      },
                      onChanged: (value) {
                        if (!hasManuallySelectedKulliyah) {
                          setState(() {
                            _selectedKulliyah = KulliyyahSugestions.suggest(
                                value.toAlbiruniFormat());
                          });
                        }
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
                        // format to albiruni in case havent already
                        _courseCodeController.text =
                            _courseCodeController.text.toAlbiruniFormat();
                      },
                    ),
                    const SizedBox(height: 30),
                    if ((_selectedKulliyah != null &&
                            _selectedKulliyah!.isNotEmpty) &&
                        _courseCodeController.text.isNotEmpty &&
                        _selectedSection != null)
                      FutureBuilder(
                        future: SubjectFetcher.fetchSubjectData(
                          albiruni: Albiruni(
                              session: widget.session,
                              semester: widget.semester),
                          kulliyyah: _selectedKulliyah!,
                          section: _selectedSection!,
                          courseCode:
                              _courseCodeController.text.toAlbiruniFormat(),
                        ),
                        builder: (context, AsyncSnapshot<Subject> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              title: Text('Loading'),
                              trailing: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator()),
                            );
                          }
                          if (snapshot.hasError) {
                            return ListTile(
                              title: const Text(
                                  'Error. Subject may not be available'),
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
                                  section:
                                      int.tryParse(_sectionController.text)),
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
