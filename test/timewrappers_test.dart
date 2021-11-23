import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lml/lml.dart';
import 'package:test/test.dart';

void main() {
  group('Time Tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('TimeInDay', () async {
      initializeDateFormatting();
      var firstTime = TimeInDay(hour: 16, minute: 00, local: true);
      var secondTime = TimeInDay(hour: 18, minute: 00, local: true);
      var diff = secondTime.difference(firstTime);
      expect(diff.inHours, 2);
    });

    test('Date', () async {
      initializeDateFormatting();
      var firstDate = Date(day: 1, month: 12, year: 2021);
      var secondDate = Date(day: 1, month: 1, year: 2022);
      var diff = secondDate.difference(firstDate);
      var firstAdd = firstDate.increase(Duration(days: 1));
      expect(firstAdd.difference(firstDate).inDays, 1);
      expect(diff.inDays, 31);
    });
  });
}
