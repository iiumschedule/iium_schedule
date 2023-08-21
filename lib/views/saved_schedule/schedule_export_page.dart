import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../util/my_ftoast.dart';
import '../../util/schedule_share.dart';
import '../../util/screenshot_widget.dart';
import '../scheduler/schedule_view/timetable_view_widget.dart';

class ScheduleExportPage extends StatefulWidget {
  const ScheduleExportPage(
      {super.key,
      required this.scheduleTitle,
      required this.itemHeight,
      required this.laneEventsList,
      required this.startHour,
      required this.endHour});
  final List<LaneEvents> laneEventsList;
  final int startHour;
  final int endHour;
  final double itemHeight;
  final String scheduleTitle;

  @override
  State<ScheduleExportPage> createState() => _ScheduleExportPageState();
}

class _ScheduleExportPageState extends State<ScheduleExportPage> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Just show appbar on Windows & web since it doesn't have
      // back button like in Android.
      // In Android, the appbar is still needed to make sure the timetable
      // item is alligned to its time
      appBar: AppBar(
        toolbarHeight: (!kIsWeb && Platform.isAndroid) ? 0 : null,
        title: const Text('Export schedule'),
      ),
      body: Stack(
        children: [
          Transform.translate(
            offset: const Offset(0, -30),
            child: Transform.scale(
              scale: .8,
              child: Container(
                // container for decoration only
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 60,
                    spreadRadius: .1,
                  )
                ]),
                child: IgnorePointer(
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      // container to add bg colour & top padding
                      padding: const EdgeInsets.only(top: 18),
                      color: Theme.of(context).colorScheme.background,
                      child: ClipRect(
                        // cliprect to remove schedule 'leaking' out of the container
                        child: TimetableViewWidget(
                          startHour: widget.startHour,
                          endHour: widget.endHour,
                          laneEventsList: widget.laneEventsList,
                          itemHeight: widget.itemHeight + 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 10,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Show on all platforms except Apple devices
                  // There is an issue saving file to directory (permission issue)
                  // Fortunately, user still can save to system disk using share (button below)
                  if (kIsWeb || !kIsApple)
                    TextButton.icon(
                        onPressed: () async {
                          String? path =
                              await ScreenshotWidget.screenshotAndSave(
                                  _globalKey, widget.scheduleTitle);

                          if (kIsWeb) {
                            Fluttertoast.showToast(
                                msg: "Schedule will be downloaded shortly..",
                                webPosition: "left",
                                timeInSecForIosWeb: 3);
                            return;
                          }

                          // show toast for windows and android
                          if (mounted) {
                            MyFtoast.show(context, 'Saved to $path');
                          }
                        },
                        icon: const Icon(Icons.save_alt_outlined),
                        label: const Text(kIsWeb
                            ? 'Download (.png)'
                            : 'Save to device (.png)')),
                  // Show share button on Android, iOS & MacOS
                  if (!kIsWeb && !Platform.isWindows)
                    TextButton.icon(
                      onPressed: () async {
                        String? path = await ScreenshotWidget.screenshotAndSave(
                            _globalKey, widget.scheduleTitle,
                            tempPath: true);
                        ScheduleShare.share(path!, widget.scheduleTitle);
                      },
                      icon: Icon(kIsApple ? CupertinoIcons.share : Icons.share),
                      label: Text(kIsApple ? 'Share/Save' : 'Share'),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
