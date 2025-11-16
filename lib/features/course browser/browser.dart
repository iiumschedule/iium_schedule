import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../../constants.dart' as constants;
import '../../shared/utils/academic_session.dart';
import '../../shared/widgets/kulliyyah_selection_widget.dart';
import '../favourites/views/favourites_page.dart';
import 'browser_view.dart';

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  late String _selectedSession;
  int _selectedSemester = constants.kDefaultSemester;
  String? _selectedKulliyah;
  StudyGrad _selectedStudyGrad = StudyGrad.ug;

  @override
  void initState() {
    super.initState();
    // check if [constants.kDefaultSession] is in the list of sessions
    // if not, set the first session in the list as the default session
    if (!AcademicSession.session.contains(constants.kDefaultSession)) {
      _selectedSession = AcademicSession.session.first;
    } else {
      _selectedSession = constants.kDefaultSession;
    }
  }

  /// Callback when the kulliyah is changed
  void onKulliyyahChanged(String? value) {
    setState(() => _selectedKulliyah = value);
  }

  /// Callback when the session is changed
  void onSessionChanged(String value) {
    setState(() => _selectedSession = value);
  }

  /// Callback when the study grade is changed
  void onStudyGradChanged(StudyGrad value) {
    // reset kulliyah selection and dropdown state
    setState(() {
      _selectedKulliyah = null;
      _selectedStudyGrad = value;
    });
    dropdownKey.currentState?.setState(() {});
  }

  /// Callback when the semester is changed
  void onSemesterChanged(int value) {
    setState(() => _selectedSemester = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KulliyyahSelectionWidget(
                  kulliyyahDropdownKey: dropdownKey,
                  onKulliyyahChanged: onKulliyyahChanged,
                  onSessionChanged: onSessionChanged,
                  onSemesterChanged: onSemesterChanged,
                  onStudyGradChanged: onStudyGradChanged,
                  selectedStudyGrad: _selectedStudyGrad,
                  selectedKulliyah: _selectedKulliyah,
                  selectedSession: _selectedSession,
                  selectedSemester: _selectedSemester,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    maxLength: 9,
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      labelText: 'Search',
                      // TODO: Buat dia tukar2 course code suggestion
                      hintText: 'Eg: MCTE 3100',
                      isDense: true,
                      helperText: 'Leave empty to load all',
                      counter: const SizedBox.shrink(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.clear_outlined),
                      ),
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      // format to Albiruni format
                      _searchController.text =
                          _searchController.text.toAlbiruniFormat();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: MouseRegion(
                    cursor: _selectedKulliyah == null
                        ? SystemMouseCursors.forbidden
                        : SystemMouseCursors.click,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: _selectedKulliyah == null
                          ? null
                          : () {
                              // Redo the same thing as in onEditingComplete above. Just in case.
                              FocusScope.of(context).unfocus();
                              String? courseCode;
                              if (_searchController.text.isNotEmpty) {
                                _searchController.text = courseCode =
                                    _searchController.text.toAlbiruniFormat();
                              } else {
                                courseCode = null;
                              }

                              Albiruni albiruni = Albiruni(
                                  semester: _selectedSemester,
                                  session: _selectedSession,
                                  studyGrade: _selectedStudyGrad);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BrowserView(
                                      kulliyah: _selectedKulliyah!,
                                      albiruni: albiruni,
                                      courseCode: courseCode),
                                ),
                              );
                            },
                      child: const Text('Go'),
                    ),
                  ),
                ),
                // I'm still thinking the best place to place this favourites button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavouritesPage(),
                          ),
                        );
                      },
                      child: const Text('Open Favourites'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
