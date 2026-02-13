import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TimeTable View Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Timetable View Demo')),
      body: TimetableView(
        laneEventsList: _buildLaneEvents(),
        timetableStyle: TimetableStyle(laneWidth: 100),
      ),
    );
  }

  List<LaneEvents> _buildLaneEvents() {
    return [
      LaneEvents(
        lane: Lane(name: 'Track A'),
        events: [
          TableEvent(
            title: 'An event 1',
            start: TableEventTime(hour: 8, minute: 0),
            end: TableEventTime(hour: 10, minute: 0),
            backgroundColor: Colors.blue,
          ),
          TableEvent(
            title: 'An event 2',
            subtitle: 'A subtitle',
            start: TableEventTime(hour: 12, minute: 0),
            end: TableEventTime(hour: 13, minute: 20),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Track B'),
        events: [
          TableEvent(
            title: 'An event 3',
            start: TableEventTime(hour: 10, minute: 10),
            end: TableEventTime(hour: 11, minute: 45),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Track C'),
        events: [
          TableEvent(
            title: 'Morning event',
            start: TableEventTime(hour: 8, minute: 0),
            end: TableEventTime(hour: 12, minute: 0),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    ];
  }
}
