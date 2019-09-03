import 'package:calendar_views/day_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget that builds a child in place of each day in a day view.
class DayViewDaysHeader extends StatefulWidget {
  DayViewDaysHeader({
    @required this.headerItemBuilder,
  }) : assert(headerItemBuilder != null);

  /// Function that builds a header item.
  final DayViewDaysHeaderItemBuilder headerItemBuilder;

  @override
  State createState() => new _DayViewDaysHeaderState();
}

class _DayViewDaysHeaderState extends State<DayViewDaysHeader> {
  DayViewEssentialsState _dayViewEssentials;

  HorizontalPositioner get _horizontalPositioner =>
      _dayViewEssentials.horizontalPositioner;

  SchedulePositioner _schedulePositioner;

  DayViewProperties get _dayViewProperties => _horizontalPositioner.properties;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dayViewEssentials = DayViewEssentials.of(context);
    if (_dayViewEssentials == null) {
      _throwNoDayViewEssentialsError();
    }
  }

  void _throwNoDayViewEssentialsError() {
    throw new FlutterError("""
Could not inherit DayViewEssentials.

This widget must be a decendant of DayViewEssentials.
""");
  }

  @override
  Widget build(BuildContext context) {
    _schedulePositioner = SchedulePositioner(
        horizontalPositioner: _horizontalPositioner, heightPerMinute: 1);

    List<Widget> rowChildren = <Widget>[];

    rowChildren.add(
      _buildStartingOffset(),
    );

    rowChildren.addAll(
      _buildDaysAndSeparations(),
    );

    rowChildren.add(
      _buildEndingOffset(),
    );

    return new Container(
      decoration: BoxDecoration(
        color: Color(0xff99CBDF),
        boxShadow: [
          BoxShadow(
            color: Color(0xffE3E3E3),
            blurRadius: 3.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              4.0, // vertical, move down 10
            ),
          )
        ],
      ),
      width: _horizontalPositioner.totalWidth,
      height: _schedulePositioner.topExtensionHeight,
      child: new IntrinsicHeight(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rowChildren,
        ),
      ),
    );
  }

  Widget _buildStartingOffset() {
    double width = _horizontalPositioner.eventAreaLeft;

    return new Container(
      width: width,
    );
  }

  List<Widget> _buildDaysAndSeparations() {
    List<Widget> daysAndSeparations = <Widget>[];

    List<DateTime> days = _dayViewProperties.days;

//    daysAndSeparations.add(
//      _buildDaySeparation(
//        daySeparationNumber: 1,
//      ),
//    );

    for (int dayNumber = 0; dayNumber < days.length; dayNumber++) {
      DateTime day = days[dayNumber];

      daysAndSeparations.add(
        _buildDay(
          dayNumber: dayNumber,
          day: day,
        ),
      );

//      if (_horizontalPositioner.isDaySeparationRightOfDay(dayNumber)) {
//        int daySeparationNumber =
//            _horizontalPositioner.daySeparationNumberRightOfDay(dayNumber);
//
//        daysAndSeparations.add(
//          _buildDaySeparation(
//            daySeparationNumber: daySeparationNumber,
//          ),
//        );
//      }
    }

    return daysAndSeparations;
  }

  Widget _buildDay({
    @required int dayNumber,
    @required DateTime day,
  }) {
    return new Container(
      width: _horizontalPositioner.dayAreaWidth(dayNumber) + 1,
      child: widget.headerItemBuilder(context, day),
    );
  }

  Widget _buildDaySeparation({
    @required int daySeparationNumber,
  }) {
    return new Container(
      color: Colors.black,
      width: _horizontalPositioner.daySeparationAreaWidth(daySeparationNumber),
    );
  }

  Widget _buildEndingOffset() {
    return new Container(
      color: Colors.white,
      width: _endingOffsetWidth,
    );
  }

  double get _endingOffsetWidth =>
      _horizontalPositioner.endMainAreaWidth +
      _horizontalPositioner.endTotalAreaWidth;
}
