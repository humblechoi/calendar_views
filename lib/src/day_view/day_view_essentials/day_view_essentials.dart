import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'day_view_properties.dart';
import 'day_view_widths.dart';
import 'horizontal_positioner.dart';

/// Widget that propagates essential information for other day-view widgets.
class DayViewEssentials extends StatefulWidget {
  DayViewEssentials({
    @required this.properties,
    this.widths = const DayViewWidths(),
    @required this.child,
  });

  /// Properties to propagate to other day-view widgets.
  final DayViewProperties properties;

  /// Information about widths to propagate to other day-view widgets.
  final DayViewWidths widths;

  final Widget child;

  @override
  State createState() => new DayViewEssentialsState();

  static DayViewEssentialsState of(BuildContext context) {
    _DayViewEssentialsInherited inherited =
        _DayViewEssentialsInherited.of(context);

    return inherited?.dayViewEssentialsState;
  }
}

class DayViewEssentialsState extends State<DayViewEssentials> {
  HorizontalPositioner _horizontalPositioner;

  /// Properties for day-view widgets.
  DayViewProperties get properties => widget.properties;

  /// Width information for day-view widgets.
  DayViewWidths get widths => widget.widths;

  /// Positioner for day-view widgets.
  HorizontalPositioner get horizontalPositioner => _horizontalPositioner;

  final double borderWidth = 1.0;

  void _throwExceptionIfInvalidBoxConstraints(BoxConstraints constraints) {
    if (constraints.maxWidth.isInfinite) {
      throw new FlutterError("""
DayViewEssentials must have a bounded width.

This error probably happened because DayViewEssentials is child of an widget with unbounded width (eg. a Row).
      """);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _throwExceptionIfInvalidBoxConstraints(constraints);

        _horizontalPositioner = new HorizontalPositioner(
          properties: properties,
          widths: widths,
          totalWidth: constraints.maxWidth,
        );

        return new _DayViewEssentialsInherited(
          dayViewEssentialsState: this,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: Color(0xffB7B7B7),
                      width: borderWidth,
                      style: BorderStyle.solid),
                  right: BorderSide(
                      color: Color(0xffB7B7B7),
                      width: borderWidth,
                      style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: Color(0xffB7B7B7),
                      width: borderWidth,
                      style: BorderStyle.solid)),
            ),
            margin: EdgeInsets.only(
                left: _horizontalPositioner.outerPadding / 2 - borderWidth * 2,
                right: _horizontalPositioner.outerPadding / 2 - borderWidth * 2,
                top: 20),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _DayViewEssentialsInherited extends InheritedWidget {
  _DayViewEssentialsInherited({
    @required this.dayViewEssentialsState,
    @required Widget child,
  })  : assert(dayViewEssentialsState != null),
        super(child: child);

  final DayViewEssentialsState dayViewEssentialsState;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static _DayViewEssentialsInherited of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_DayViewEssentialsInherited);
  }
}
