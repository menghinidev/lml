import 'package:intl/intl.dart';
import 'time_wrapper.dart';
import 'timestamp.dart';

class TimeInDay with TimeWrapper {
  final int hour;
  final int minute;
  final int seconds;
  final bool _local;

  factory TimeInDay.fromDateTime(DateTime time, {bool keepLocal = false}) => TimeInDay(
        hour: time.hour,
        minute: time.minute,
        seconds: time.second,
        local: keepLocal,
      );

  factory TimeInDay.now() {
    var now = DateTime.now().toUtc();
    return TimeInDay(hour: now.hour, minute: now.minute);
  }

  factory TimeInDay.fromString(String time, {String divider = ':', bool local = true}) {
    var decomposed = time.split(divider);
    if (time.length < 2) return TimeInDay(hour: 0, minute: 0);
    return TimeInDay(
      hour: int.parse(decomposed[0]),
      minute: int.parse(decomposed[1]),
      seconds: time.length == 3 ? int.parse(decomposed[2]) : 0,
      local: local,
    );
  }

  TimeInDay({required this.hour, required this.minute, this.seconds = 0, bool local = false}) : _local = local;

  @override
  String format({DateFormat? formatter}) =>
      formatter != null ? formatter.format(toDateTime().toLocal()) : DateFormat.jm().format(toDateTime().toLocal());

  @override
  DateTime toDateTime({TimeStamp? filler, bool keepLocal = false}) {
    if (filler == null) {
      if (_local || keepLocal) return DateTime(2000, 7, 20, hour, minute, seconds);
      return DateTime.utc(2000, 7, 20, hour, minute, seconds);
    }
    if (_local || keepLocal) {
      return DateTime(
        filler.toDateTime().year,
        filler.toDateTime().month,
        filler.toDateTime().day,
        hour,
        minute,
        seconds,
      );
    }
    return DateTime.utc(
      filler.toDateTime().year,
      filler.toDateTime().month,
      filler.toDateTime().day,
      hour,
      minute,
      seconds,
    );
  }

  @override
  TimeWrapper increase(Duration value) => TimeInDay.fromDateTime(toDateTime().add(value), keepLocal: _local);

  @override
  TimeWrapper decrease(Duration value) => TimeInDay.fromDateTime(toDateTime().subtract(value), keepLocal: _local);
}
