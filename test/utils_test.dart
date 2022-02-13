import 'package:intl/date_symbol_data_local.dart';
import 'package:lml/src/utils/timewrappers/date.dart';
import 'package:lml/src/utils/timewrappers/time.dart';
import 'package:lml/src/utils/timewrappers/time_interval.dart';
import 'package:lml/src/utils/timewrappers/timestamp.dart';
import 'package:test/test.dart';

void main() {
  group('Time Tests', () {
    setUp(() {
      initializeDateFormatting();
    });

    test('TimeInDay', () async {
      var firstTime = Time(hour: 16, minute: 00, local: true);
      var secondTime = Time(hour: 18, minute: 00, local: true);
      var diff = secondTime.difference(firstTime);
      expect(diff.inHours, 2);

      firstTime = Time(hour: 16, minute: 00, local: false);
      secondTime = Time(hour: 18, minute: 00, local: false);
      diff = secondTime.difference(firstTime);
      expect(diff.inHours, 2);
    });

    test('Date', () async {
      var firstDate = Date(day: 1, month: 12, year: 2021);
      var secondDate = Date(day: 1, month: 1, year: 2022);
      var diff = secondDate.difference(firstDate);
      var firstAdd = firstDate.increase(Duration(days: 1));
      expect(firstAdd.difference(firstDate).inDays, 1);
      expect(diff.inDays, 31);
    });

    test('Timestamp', () async {
      var firstTimeStamp = TimeStamp(value: DateTime(2022, 1, 1));
      var secondTimeStamp = TimeStamp(value: DateTime(2022, 1, 2));
      var diff = secondTimeStamp.difference(firstTimeStamp);
      var secondAdd = secondTimeStamp.increase(Duration(days: 1));
      var addDiff = secondAdd.difference(firstTimeStamp);
      expect(diff.inDays, 1);
      expect(addDiff.inDays, 2);
    });

    test('TimeInDay Interval', () async {
      var firstTime = Time(hour: 16, minute: 00, local: true);
      var secondTime = Time(hour: 18, minute: 00, local: true);
      var interval = TimeInterval(start: firstTime, end: secondTime);
      var diff = interval.difference();
      expect(diff.inHours, 2);

      firstTime = Time(hour: 16, minute: 00, local: false);
      secondTime = Time(hour: 18, minute: 00, local: false);
      interval = TimeInterval(start: firstTime, end: secondTime);
      diff = interval.difference();
      expect(diff.inHours, 2);

      var secondInterval = TimeInterval(
        start: Time(hour: 17, minute: 00, local: false),
        end: Time(hour: 19, minute: 00, local: false),
      );

      var isCrossing = interval.cross(secondInterval);

      expect(isCrossing, true);
      expect(secondInterval.contains(firstTime), false);
      expect(secondInterval.contains(secondTime), true);
    });
  });
}
