abstract class INetworkRequest {
  Map<String, String> get queryParameters => {};
  List<String> get pathParameters => [];
  String get body => '';
}
