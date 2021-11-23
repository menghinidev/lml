import 'package:lml/src/logger/logger.dart';
import 'package:lml/src/network/crud_network_delegate.dart';
import 'package:lml/src/network/headers/request_header.dart';
import 'package:lml/src/network/headers/token_refresher.dart';
import 'package:lml/src/response/error/error_details.dart';
import 'network_request.dart';
import 'network_response.dart';

class NetworkCommunicator with CrudNetworkDelegate {
  final ITokenRefresher tokenRefresher;
  final IRequestHeaderFactory headerFactory;
  final Logger? logger;

  NetworkCommunicator({required this.headerFactory, required this.tokenRefresher, this.logger});

  Future<NetworkResponse<T>> httpPost<T, X extends INetworkRequest>(
    String url,
    X body,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    if (logger != null) logger!.logRequest(url: url, body: body.body);
    return await _makeRequest<T>(
      (headers) => postRequest<T, X>(
        url,
        headers,
        parser,
        body,
      ),
      isAuthorized,
    );
  }

  Future<NetworkResponse<T>> httpGet<T>(
    String url,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    if (logger != null) logger!.logRequest(url: url, headers: headers);
    return await _makeRequest<T>(
      (headers) => getRequest(url, headers, parser),
      isAuthorized,
    );
  }

  Future<NetworkResponse<T>> httpPut<T, X extends INetworkRequest>(
    String url,
    X body,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    if (logger != null) logger!.logRequest(url: url, headers: headers, body: body.body);
    return await _makeRequest<T>(
      (headers) => putRequest<T, X>(url, headers, parser, body),
      isAuthorized,
    );
  }

  Future<NetworkResponse<T>> httpDelete<T>(
    String url,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    if (logger != null) logger!.logRequest(url: url, headers: headers);
    return await _makeRequest<T>(
      (headers) => deleteRequest<T>(url, headers, parser),
      isAuthorized,
    );
  }

  Future _makeRequest<T>(Future<NetworkResponse<T>> Function(Map<String, String>) request, bool isAuthorized) async {
    if (isAuthorized) {
      if (await tokenRefresher.areExpired()) {
        var refreshResponse = await tokenRefresher.refresh();
        if (refreshResponse.isError) {
          return NetworkResponse.errorResponse(refreshResponse.errors);
        }
      }
    }
    var headers = await headerFactory.createHeaders();
    return await request(headers).timeout(
      Duration(seconds: 30),
      onTimeout: () => NetworkResponse.errorResponse([
        ErrorDetails(
          id: 500,
          message: 'No internet connection',
        )
      ]),
    );
  }
}
