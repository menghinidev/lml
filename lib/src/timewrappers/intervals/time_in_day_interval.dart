import 'package:lml/src/timewrappers/time_in_day.dart';
import 'package:lml/src/timewrappers/time_wrapper.dart';

import 'time_interval_wrapper.dart';

class TimeInDayInterval with IntervalWrapper<TimeInDay> {
  @override
  final TimeInDay start;

  @override
  final TimeInDay end;

  TimeInDayInterval({required this.start, required this.end});

  factory TimeInDayInterval.fromJSON(dynamic json) {
    return TimeInDayInterval(
      start: TimeInDay.fromString(json['startTime']),
      end: TimeInDay.fromString(json['endTime']),
    );
  }

  @override
  bool contains(TimeInDay wrapper) => start.compareTo(wrapper) <= 0 && end.compareTo(wrapper) >= 0;

  @override
  Duration difference() => end.difference(start);

  @override
  bool cross(IntervalWrapper<TimeWrapper> wrapper) {
    var crossStart = wrapper.contains(start);
    var crossEnd = wrapper.contains(end);
    var crossOtherStart = contains(wrapper.start as TimeInDay);
    var crossOtherEnd = contains(wrapper.end as TimeInDay);
    return crossStart || crossEnd || crossOtherStart || crossOtherEnd;
  }

  @override
  String format() => start.format() + ' - ' + end.format();

  bool isValid() => start.isBefore(end);

  TimeInDayInterval copyWith({TimeInDay? newStart, TimeInDay? newEnd}) => TimeInDayInterval(
        start: newStart ?? start,
        end: newEnd ?? end,
      );
}
