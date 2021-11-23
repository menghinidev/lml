import 'package:intl/intl.dart';
import 'time_in_day.dart';
import 'date.dart';
import 'time_wrapper.dart';

class TimeStamp with TimeWrapper {
  final DateTime value;

  TimeStamp({required this.value});

  factory TimeStamp.fromString(String datetime) => TimeStamp(value: DateTime.parse(datetime));

  static TimeStamp? tryParse(String? value) => value != null ? TimeStamp.fromString(value) : null;

  factory TimeStamp.fromDateAndTime(Date date, TimeInDay time) => TimeStamp(
        value: time.toDateTime(filler: TimeStamp(value: date.toDateTime())),
      );

  factory TimeStamp.now() => TimeStamp(value: DateTime.now().toUtc());

  @override
  String format({DateFormat? formatter}) {
    var form = formatter ?? DateFormat.yMd().add_jm();
    var utcTime = value.toUtc();
    var utcTimeString = form.format(utcTime);
    var localTimeString = form.parse(utcTimeString, true).toLocal().toString();
    return form.format(DateTime.parse(localTimeString));
  }

  @override
  DateTime toDateTime({TimeStamp? filler}) => DateTime.parse(format());

  @override
  TimeWrapper increase(Duration value) => TimeStamp(value: this.value.add(value));

  @override
  TimeWrapper decrease(Duration value) => TimeStamp(value: this.value.subtract(value));
}
