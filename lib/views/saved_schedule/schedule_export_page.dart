import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../util/lane_events_util.dart';
import '../../util/my_ftoast.dart';
import '../../util/schedule_share.dart';
import '../../util/screenshot_widget.dart';
import '../scheduler/schedule_view/timetable_view_widget.dart';

class ScheduleExportPage extends StatefulWidget {
  const ScheduleExportPage(
      {super.key,
      required this.laneEventsResponse,
      required this.scheduleTitle,
      required this.itemHeight});
  final LaneEventsResponse laneEventsResponse;
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ClipRect(
                        // cliprect to remove schedule 'leaking' out of the container
                        child: TimetableViewWidget(
                          startHour: widget.laneEventsResponse.startHour,
                          endHour: widget.laneEventsResponse.endHour,
                          laneEventsList:
                              widget.laneEventsResponse.laneEventsList,
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
                  TextButton.icon(
                      onPressed: () async {
                        String? path = await ScreenshotWidget.screenshotAndSave(
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
                  if (!kIsWeb && Platform.isAndroid)
                    TextButton.icon(
                      onPressed: () async {
                        String? path = await ScreenshotWidget.screenshotAndSave(
                            _globalKey, widget.scheduleTitle,
                            tempPath: true);
                        ScheduleShare.share(path!, widget.scheduleTitle);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
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
