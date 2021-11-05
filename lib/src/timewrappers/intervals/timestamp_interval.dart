import 'package:lml/src/timewrappers/intervals/time_in_day_interval.dart';
import 'package:lml/src/timewrappers/intervals/time_interval_wrapper.dart';
import 'package:lml/src/timewrappers/time_in_day.dart';
import 'package:lml/src/timewrappers/time_wrapper.dart';
import 'package:lml/src/timewrappers/timestamp.dart';

class TimeStampInterval extends IntervalWrapper<TimeStamp> {
  @override
  final TimeStamp start;
  @override
  final TimeStamp end;

  TimeStampInterval({required this.start, required this.end});

  @override
  bool contains(TimeStamp wrapper) => start.compareTo(wrapper) <= 0 && end.compareTo(wrapper) >= 0;

  @override
  bool cross(IntervalWrapper<TimeWrapper> wrapper) {
    var crossStart = wrapper.contains(start);
    var crossEnd = wrapper.contains(end);
    var crossOtherStart = contains(wrapper.start as TimeStamp);
    var crossOtherEnd = contains(wrapper.end as TimeStamp);
    return crossStart || crossEnd || crossOtherStart || crossOtherEnd;
  }

  @override
  Duration difference() => end.difference(start);

  @override
  String format() => TimeInDayInterval(
        start: TimeInDay.fromDateTime(start.value),
        end: TimeInDay.fromDateTime(end.value),
      ).format();

  TimeStampInterval copyWith({TimeStamp? newStart, TimeStamp? newEnd}) => TimeStampInterval(
        start: newStart ?? start,
        end: newEnd ?? end,
      );
}
