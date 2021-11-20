// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:albiruni/albiruni.dart';
import 'package:and/and.dart';
import 'package:recase/recase.dart';

// 🌎 Project imports:
import 'util/enums.dart';

class BrowserView extends StatefulWidget {
  const BrowserView({Key? key, required this.albiruni}) : super(key: key);

  final Albiruni albiruni;

  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.albiruni.kulliyah} Sem ${widget.albiruni.semester} ${widget.albiruni.session}"),
        actions: [
          IconButton(
              onPressed: _page <= 1
                  ? null
                  : () {
                      setState(() {
                        _page--;
                      });
                    },
              icon: const Icon(Icons.navigate_before_outlined)),
          Center(child: Text(_page.toString())),
          IconButton(
              onPressed: () {
                setState(() {
                  setState(() {
                    _page++;
                  });
                });
              },
              icon: const Icon(Icons.navigate_next_outlined))
        ],
      ),
      body: FutureBuilder(
        future: widget.albiruni.fetch(page: _page, useProxy: kIsWeb),
        builder: (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: const [
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
            if (snapshot.error is NoSubjectsException) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    'assets/icons/explorer-dynamic-colorx.png',
                  ),
                  const Text("Oops, you may want to go back.")
                ]),
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
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
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.grey.shade100,
                  children: [
                    InkWell(
                      splashColor: Colors.purple.shade100,
                      onTap: () {
                        // TODO: Make another screen for details
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not implemented')));
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
                                                describeEnum(
                                                  (Day.values[e!.day - 1]),
                                                ),
                                              ).titleCase)
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
                              Builder(builder: (_) {
                                if (snapshot.data![index].lect.length > 1) {
                                  return Text(
                                    'Multiple lecturers (${snapshot.data![index].lect.length})',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  );
                                } else {
                                  return Text(
                                      ReCase(snapshot.data![index].lect.first)
                                          .titleCase);
                                }
                              })
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
                                Icons.class__outlined,
                              ),
                              const SizedBox(width: 5),
                              // https://stackoverflow.com/a/55173692
                              Text(snapshot.data![index].chr
                                  .toString()
                                  .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")),
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
    );
  }
}
