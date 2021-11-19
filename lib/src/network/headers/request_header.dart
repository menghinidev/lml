import 'dart:io';

abstract class IRequestHeaderFactory {
  Future<Map<String, String>> createHeaders();

  static Map<String, String> generateApplicationJson() => {HttpHeaders.contentTypeHeader: 'application/json'};
}
