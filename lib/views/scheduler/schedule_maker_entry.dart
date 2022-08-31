import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import 'appbar_title.dart';
import 'course_validator.dart';
import 'input_course.dart';
import 'input_scope.dart';
import 'schedule_steps.dart';

class ScheduleMakerEntry extends StatelessWidget {
  ScheduleMakerEntry({Key? key}) : super(key: key);

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final int _itemCount = 3;

  @override
  Widget build(BuildContext context) {
    return ScheduleSteps(
      pageController: _pageController,
      pageNotifier: _currentPageNotifier,
      child: WillPopScope(
        onWillPop: () async {
          if (_pageController.page! > 0) {
            var res = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: const Text("Back to main menu ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );

            return Future.value(res);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.transparent),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_pageController.page == 0) {
                  Navigator.pop(context);
                } else {
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                }
              },
            ),
            title: AppbarTitle(
              currentPageNotifier: _currentPageNotifier,
              itemCount: _itemCount,
            ),
            actions: [
              Center(
                child: StepPageIndicator(
                  stepColor: Colors.white,
                  size: 16,
                  currentPageNotifier: _currentPageNotifier,
                  itemCount: _itemCount,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: _itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return <Widget>[
                const InputScope(),
                const InputCourse(),
                const CourseValidator()
              ][index];
            },
            onPageChanged: (value) {
              _currentPageNotifier.value = value;
            },
          ),
        ),
      ),
    );
  }
}
