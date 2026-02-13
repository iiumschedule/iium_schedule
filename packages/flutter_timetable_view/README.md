# Flutter Timetable View

<img width="384" height="854" alt="Screenshot_1770987626 (Small)" src="https://github.com/user-attachments/assets/b2cef9ca-f2de-4573-b49c-b818f3286cf5" />

Timetable Widget Package for Flutter

# iqfareez's changes specifically for iium schedule app

- Add optional parameter `showMinutes` in `Utils.hourFormatter` function.
- Using widget class instead of a function returning widget in `lib/src/views/timetable_view.dart`.
- Top row width is following the lane width. dbe733fe3fbdd5d6f3a7f7d47a72b23a098bb953
- Added `heroTag` to `TableEvent`, and `EventView` now has a `Hero`.
- Added `subtitle` property that can replace the default time in `EventView`.

_Contents below are from the [original package](https://github.com/yamarkz/flutter_timetable_view) author_

# Features

## Image

<img src="https://user-images.githubusercontent.com/12509392/75619419-dc877480-5bbe-11ea-88a3-330e0a03154e.png" width="200" />

## Video Recording

<img src="https://user-images.githubusercontent.com/12509392/75619433-f0cb7180-5bbe-11ea-8644-11d7277b2e29.gif" height="440" /> <img src="https://user-images.githubusercontent.com/12509392/75619441-0476d800-5bbf-11ea-854b-4e9ec653f551.gif" height="440" />

# Install

https://pub.dev/packages/flutter_timetable_view#-installing-tab-

# Usage

## Basic

```
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TimetableView(
        laneEventsList: [
          LaneEvents(
            lane: Lane(
              name: 'Track A',
            ),
            events: [
              TableEvent(
                title: 'An event 1',
                start: TableEventTime(hour: 10, minute: 0),
                end: TableEventTime(hour: 11, minute: 20),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
```

## Customized

```
todo
```

# Info

Use case is [here](https://github.com/yamarkz/unofficial_conference_app_2020)

# Contributing

1. Fork it
2. Create your feature branch (git checkout -b new_feature_branch)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin new_feature_branch)
5. Create new Pull Request

# License

```
MIT License

Copyright (c) 2020 Kazuki Yamaguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
