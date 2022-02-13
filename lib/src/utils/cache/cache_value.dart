import '../timewrappers/timestamp.dart';

class CachedValue<T> {
  static const Duration cacheLifetime = Duration(minutes: 5);
  T? _value;
  late TimeStamp _latestUpdate;

  CachedValue({T? initialValue}) {
    _value = initialValue;
    _latestUpdate = TimeStamp.now();
  }

  bool get isValid => !_isExpired && _value != null;
  TimeStamp get latestUpdate => _latestUpdate;
  T? get value => _value;
  void updateValue(T value) {
    _value = value;
    _latestUpdate = TimeStamp.now();
  }

  bool get _isExpired => TimeStamp.now().isAfter(_latestUpdate.increase(cacheLifetime));
}
