import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../isar_models/favourite_subject.dart';
import '../services/isar_service.dart';
import '../util/kulliyyahs.dart';
import '../util/subject_fetcher.dart';
import 'course browser/browser.dart';
import 'course browser/subject_screen.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final IsarService isarService = IsarService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<FavouriteSubject>>(
          future: isarService.getAllFavourites(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No favourites yet.'),
                    const SizedBox(height: 30),
                    const Text(
                        'Start adding favourites by tapping the ♡ icon on the subject details page.'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Browser()));
                      },
                      child: const Text('Go to course browser'),
                    )
                  ],
                ),
              );
            }
            return LayoutBuilder(builder: (context, constraints) {
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 750 ? 2 : 1,
                  mainAxisExtent: 130,
                ),
                children: snapshot.data!.map((e) => _FavouriteCard(e)).toList(),
              );
            });
          },
        ),
      ),
    );
  }
}

class _FavouriteCard extends StatefulWidget {
  const _FavouriteCard(this.favouriteSubject);

  final FavouriteSubject favouriteSubject;

  @override
  State<_FavouriteCard> createState() => __FavouriteCardState();
}

class __FavouriteCardState extends State<_FavouriteCard> {
  late Future<Subject> subject;

  @override
  void initState() {
    super.initState();
    subject = fetchSubject();
  }

  Future<Subject> fetchSubject() async {
    return SubjectFetcher.fetchSubjectData(
        albiruni: Albiruni(
            semester: widget.favouriteSubject.semester,
            session: widget.favouriteSubject.session),
        kulliyyah: widget.favouriteSubject.kulliyyahCode,
        courseCode: widget.favouriteSubject.courseCode,
        section: widget.favouriteSubject.section);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Subject>(
        future: subject,
        builder: (context, snapshot) {
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: snapshot.hasData
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubjectScreen(snapshot.data!),
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.favouriteSubject.courseCode,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          if (snapshot.hasData)
                            Text(
                              snapshot.data!.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          Text(
                              'Section ${widget.favouriteSubject.section.toString()}'),
                          Text(
                            Kuliyyahs.kuliyyahFromCode(
                                    widget.favouriteSubject.kulliyyahCode)
                                .fullName,
                            style: const TextStyle(fontWeight: FontWeight.w200),
                          ),

                          // Text(widget.favouriteSubject.favouritedDate.toString()),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.favouriteSubject.session),
                        Text('Semester ${widget.favouriteSubject.semester}'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
