import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:and/and.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../util/extensions.dart';
import 'subject_screen.dart';

class BrowserView extends StatefulWidget {
  const BrowserView(
      {Key? key,
      required this.albiruni,
      required this.kulliyah,
      this.courseCode})
      : super(key: key);

  final Albiruni albiruni;
  final String kulliyah;
  final String? courseCode;

  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  int _page = 1;

  @override
  void initState() {
    super.initState();
    if (widget.kulliyah == "CCAC") showInfoBanner();
  }

  /// Inform user that they maybe be looking for usrah in action courses
  /// at wrong place.
  void showInfoBanner() async {
    await Future.delayed(const Duration(milliseconds: 500));
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "If you're looking for"),
              TextSpan(
                  text: " Usrah in Action ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "courses, they are located under the"),
              TextSpan(
                  text: " SEJAHTERA ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "department.")
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BrowserView(
                            albiruni: widget.albiruni, kulliyah: "SC4SH")));
              },
              child: const Text('Go to Sejahtera')),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              },
              child: const Text('Dismiss')),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "${widget.kulliyah} Sem ${widget.albiruni.semester} (${widget.albiruni.sesShort})",
            overflow: TextOverflow.fade,
          ),
          actions: [
            IconButton(
                tooltip: "Previous page",
                onPressed: _page <= 1
                    ? null
                    : () {
                        setState(() => _page--);
                      },
                icon: const Icon(Icons.navigate_before_outlined)),
            Center(child: Text(_page.toString())),
            IconButton(
                tooltip: "Next page",
                onPressed: () {
                  setState(() => _page++);
                },
                icon: const Icon(Icons.navigate_next_outlined))
          ],
        ),
        body: FutureBuilder(
          future: widget.albiruni.fetch(widget.kulliyah,
              course: widget.courseCode, page: _page, useProxy: kIsWeb),
          builder:
              (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              {
                return const Center(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('Please wait...'),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    )
                  ]),
                );
              }
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Builder(builder: (_) {
                    if (snapshot.error is NoSubjectsException) {
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          'assets/icons/explorer-dynamic-colorx.png',
                        ),
                        const Text(
                          "Oops, you may want to go back.",
                          textAlign: TextAlign.center,
                        )
                      ]);
                    } else if (snapshot.error is EmptyBodyException) {
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          'assets/icons/file-dynamic-clay.png',
                        ),
                        const Text(
                          "Oops. Subject you're looking for is nowhere to be found. Maybe the course is not offered. Please check for typo just in case.",
                          textAlign: TextAlign.center,
                        )
                      ]);
                    } else if (snapshot.error is SocketException) {
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          'assets/icons/wifi-dynamic-color.png',
                        ),
                        const Text(
                          '* Insert apes meme * "Where Internet"',
                          textAlign: TextAlign.center,
                        )
                      ]);
                    } else {
                      return Text(snapshot.error.toString());
                    }
                  }),
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(
                      ReCase(snapshot.data![index].title).titleCase,
                    ),
                    subtitle: Text(
                      "Section ${snapshot.data![index].sect}",
                    ),
                    leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data![index].code
                              .toString()
                              .replaceAll(" ", "\n"))
                        ]),
                    childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    // backgroundColor: Colors.grey.shade100,
                    children: [
                      InkWell(
                        // splashColor: Colors.purple.shade100,
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => SubjectScreen(
                                snapshot.data![index],
                                albiruni: widget.albiruni,
                                kulliyyah: widget.kulliyah,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.date_range_outlined,
                                ),
                                const SizedBox(width: 5),
                                // Whoaa a lot going on here
                                // First, from the snapshot data,
                                // convert to Day String, then,
                                // Change to title case
                                // Then, render the list properly
                                // Minus 1 on the day because list start with 0,
                                // meanwhile in datetime, first day start with 1
                                Builder(builder: (_) {
                                  if (snapshot.data![index].dayTime.isEmpty) {
                                    return const Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                          'No day and time specified',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ));
                                  } else {
                                    return Text(
                                      and(
                                        snapshot.data![index].dayTime
                                            .map((e) => ReCase(
                                                  e!.day.englishDay(),
                                                ).titleCase)
                                            .toSet()
                                            .toList(),
                                      ),
                                    );
                                  }
                                }),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline_outlined,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Builder(builder: (_) {
                                    if (snapshot.data![index].lect.length > 1) {
                                      return Text(
                                        'Multiple lecturers (${snapshot.data![index].lect.length})',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        ReCase(snapshot.data![index].lect.first)
                                            .titleCase,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }
                                  }),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.meeting_room_outlined,
                                ),
                                const SizedBox(width: 5),
                                Builder(builder: (_) {
                                  if (snapshot.data![index].venue == null) {
                                    return const Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                          'Venue not specified',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ));
                                  } else {
                                    return Text(snapshot.data![index].venue!);
                                  }
                                })
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.class_outlined,
                                ),
                                const SizedBox(width: 5),
                                // https://stackoverflow.com/a/55173692
                                Text(
                                  snapshot.data![index].chr
                                      .toString()
                                      .removeTrailingDotZero(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
