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
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(
      startMinuteOfDay: 8 * 60,
      duration: 75,
      title: "Computer Architecture and Organization(01)"),
  new Event(
      startMinuteOfDay: 10 * 60,
      duration: 60,
      title: "Computer Architecture and Organization(01)"),
  new Event(
      startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
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
  double paddingTop = 35;

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
    List<Event> events = eventsOfDay0;

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
      backgroundColor: Colors.white,
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
              child: new DayViewDaysHeader(
                headerItemBuilder: _headerItemBuilder,
                headerColor: Colors.blue,
              ),
            ),
            new Expanded(
              child: new SingleChildScrollView(
                physics: ClampingScrollPhysics(),
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
                    new EventViewComponent(
                      getEventsOfDay: _getEventsOfDay,
                    ),
                    new DaySeparationComponent(
                      generatedDaySeparatorBuilder:
                          _generatedDaySeparatorBuilder,
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
      child: Center(
          child: new Text(
        weekdayToAbbreviatedString(day.weekday),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      )),
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
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        alignment: Alignment.center,
        height: itemSize.height,
        child: new Text(
          _minuteOfDayToHourMinuteString(minuteOfDay),
          style: (TextStyle(color: Color(0xff3D3D3D), fontSize: 13)),
        ),
      ),
    );
  }

  ///시간표 가로 라인
  Positioned _generatedSupportLineBuilder(BuildContext context,
      ItemPosition itemPosition, double itemWidth, int minuteOfDay, int index) {
    return index == 16
        ? Positioned(
            child: Container(
              width: 0.0,
              height: 0.0,
              color: Colors.red,
            ),
          )
        : Positioned(
            top: itemPosition.top - paddingTop,
            left: itemPosition.left,
            width: itemWidth,
            height: index % 2 == 0 ? 1.5 : 1.0,
            child: Container(
              color: index % 2 == 0 ? Color(0xffC9C9C9) : Color(0xffE3E3E3),
            ),
          );
  }

  ///시간표 세로 라인
  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top - paddingTop,
      left: itemPosition.left,
      width: 1.5,
      height: itemSize.height + paddingTop * 2,
      child: new Center(
        child: new Container(
          decoration: BoxDecoration(
            color: Color(0xffC9C9C9),
          ),
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
      top: itemPosition.top - paddingTop + 1,
      left: itemPosition.left + 1,
      width: itemSize.width,
      height: itemSize.height - 2,
      child: new Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            color: Colors.transparent),
        //color: Colors.white,
        child: new Text(
          '${event.title}',
          style: TextStyle(color: Color(0xff97E074)),
        ),
      ),
    );
  }
}
