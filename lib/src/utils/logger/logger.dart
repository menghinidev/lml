import 'package:http/http.dart';

abstract class Logger {
  void logException(dynamic err, StackTrace stackTrace);

  void logRequest({required String url, String? body, Map<String, String> headers = const {}});

  void logNetworkRepsonse({required Response response});
}
