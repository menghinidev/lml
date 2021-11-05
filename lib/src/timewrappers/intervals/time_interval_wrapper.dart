import 'package:lml/src/timewrappers/time_wrapper.dart';

abstract class IntervalWrapper<T extends TimeWrapper> {
  bool contains(T wrapper);
  T get start;
  T get end;
  Duration difference();
  bool cross(IntervalWrapper wrapper);
  String format();
}
