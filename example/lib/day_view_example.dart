import 'package:calendar_views/day_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'utils/all.dart';

@immutable
class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.duration,
    @required this.title,
  });

  final int startMinuteOfDay;
  final int duration;

  final String title;
}

List<Event> eventsOfDay0 = <Event>[
  new Event(startMinuteOfDay: 0, duration: 60, title: "Midnight Party"),
  new Event(
      startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
  new Event(
      startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
];

List<Event> eventsOfDay1 = <Event>[
  new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
  new Event(startMinuteOfDay: 8 * 60, duration: 20, title: "A"),
  new Event(startMinuteOfDay: 8 * 60, duration: 30, title: "B"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
  new Event(startMinuteOfDay: 8 * 60 + 10, duration: 20, title: "D"),
  new Event(startMinuteOfDay: 8 * 60 + 30, duration: 30, title: "E"),
  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
];

class DayViewExample extends StatefulWidget {
  @override
  State createState() => new _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  DateTime poopooBirthday;
  DateTime tuesday;
  DateTime wednesday;
  DateTime thursday;
  DateTime friday;
  double paddingTop = 30;

  @override
  void initState() {
    super.initState();

    poopooBirthday = new DateTime(
      2019,
      9,
      2,
    );
    tuesday = poopooBirthday.toUtc().add(new Duration(days: 1)).toLocal();
    wednesday = poopooBirthday.toUtc().add(new Duration(days: 2)).toLocal();
    thursday = poopooBirthday.toUtc().add(new Duration(days: 3)).toLocal();
    friday = poopooBirthday.toUtc().add(new Duration(days: 4)).toLocal();
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    List<Event> events;
    if (day.year == poopooBirthday.year &&
        day.month == poopooBirthday.month &&
        day.day == poopooBirthday.day) {
      events = eventsOfDay0;
    } else {
      events = eventsOfDay1;
    }

    return events
        .map(
          (event) => new StartDurationItem(
            startMinuteOfDay: event.startMinuteOfDay,
            duration: event.duration,
            builder: (context, itemPosition, itemSize) => _eventBuilder(
              context,
              itemPosition,
              itemSize,
              event,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DayView Example"),
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(
          days: <DateTime>[
            poopooBirthday,
            tuesday,
            wednesday,
            thursday,
            friday
          ],
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.grey[200],
              child: new DayViewDaysHeader(
                headerItemBuilder: _headerItemBuilder,
              ),
            ),
            new Expanded(
              child: new SingleChildScrollView(
                child: new DayViewSchedule(
                  heightPerMinute: 1.0,
                  components: <ScheduleComponent>[
                    new TimeIndicationComponent.intervalGenerated(
                      generatedTimeIndicatorBuilder:
                          _generatedTimeIndicatorBuilder,
                    ),
                    new SupportLineComponent.intervalGenerated(
                      generatedSupportLineBuilder: _generatedSupportLineBuilder,
                    ),
                    new DaySeparationComponent(
                      generatedDaySeparatorBuilder:
                          _generatedDaySeparatorBuilder,
                    ),
                    new EventViewComponent(
                      getEventsOfDay: _getEventsOfDay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///요일을 나타내는 부분
  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return new Container(
      color: Color.fromRGBO(166, 212, 229, 1),
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: Center(child: new Text(weekdayToAbbreviatedString(day.weekday))),
    );
  }

  ///시간을 나타내는 부분
  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top - paddingTop / 2,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        height: itemSize.height / 2,
        child: new Text(_minuteOfDayToHourMinuteString(minuteOfDay)),
      ),
    );
  }

  ///시간표 빨간색 라인
  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top - paddingTop,
      left: itemPosition.left,
      width: itemWidth,
      child: new Container(
        height: 1.5,
        color: Color(0xffEEEEEE),
      ),
    );
  }

  ///시간표 파란색 라인
  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top - paddingTop,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 1.5,
          color: Color(0xffEEEEEE),
        ),
      ),
    );
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Event event,
  ) {
    return new Positioned(
      top: itemPosition.top - paddingTop,
      left: itemPosition.left,
      width: itemSize.width + 1,
      height: itemSize.height + 1,
      child: new Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green), color: Colors.white),
        padding: new EdgeInsets.all(3.0),
        //color: Colors.white,
        child: new Text(
          "${event.title}",
          style: TextStyle(color: Color(0xff97E074)),
        ),
      ),
    );
  }
}
