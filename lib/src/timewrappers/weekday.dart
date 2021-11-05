import 'package:intl/intl.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

extension WeekDayExtentions on WeekDay {
  String format() {
    var now = DateTime.now();
    var day = now;
    while (day.weekday != index + 1) {
      day = day.add(Duration(days: 1));
    }
    return DateFormat.EEEE().format(day);
  }
}

class WeekDayConverter {
  static final Map<WeekDay, String> _converter = {
    WeekDay.monday: 'Monday',
    WeekDay.tuesday: 'Tuesday',
    WeekDay.wednesday: 'Wednesday',
    WeekDay.thursday: 'Thursday',
    WeekDay.friday: 'Friday',
    WeekDay.saturday: 'Saturday',
    WeekDay.sunday: 'Sunday',
  };

  static WeekDay parse(String value) {
    return _converter.entries.firstWhere((element) => element.value == value).key;
  }

  static String convertToString(WeekDay day) => _converter[day] ?? '';
}
