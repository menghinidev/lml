import 'dart:convert';
import 'package:lml/src/logger/logger.dart';
import 'package:lml/src/network/crud_network_delegate.dart';
import 'package:lml/src/network/headers/request_header.dart';
import 'package:lml/src/network/headers/token_refresher.dart';
import 'package:lml/src/network/pagination.dart';
import '../response/error/error_details.dart';
import 'package:http/http.dart' as http;
import 'network_request.dart';
import 'network_response.dart';
import 'dart:io';

class NetworkCommunicator with Logger, CrudNetworkDelegate {
  final ITokenRefresher tokenRefresher;
  final IRequestHeaderFactory headerFactory;

  NetworkCommunicator({required this.headerFactory, required this.tokenRefresher});

  Future<NetworkResponse<T>> httpPost<T, X extends INetworkRequest>(
    String url,
    X body,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    logRequest(url: url, body: body.body);
    return await __makeRequest<T>(
      (headers) => postRequest<T, X>(
        url,
        headers,
        parser,
        body,
      ),
      isAuthorized,
    );
    return await _makeRequest<T>(
      (headers) async => await http.post(Uri.parse(url), headers: headers, body: body.body),
      isAuthorized,
      parser: parser,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () => NetworkResponse.errorResponse([ErrorDetails('No internet connection')]),
    );
  }

  Future __makeRequest<T>(
    Future<NetworkResponse<T>> Function(Map<String, String>) request,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    if (isAuthorized) {
      if (await tokenRefresher.areExpired()) {
        var refreshResponse = await tokenRefresher.refresh();
        if (refreshResponse.isError) {
          return NetworkResponse.errorResponse(refreshResponse.errors);
        }
      }
    }
    var headers = await headerFactory.createHeaders();
    return request(headers);
  }

  Future<NetworkResponse<T>> httpGet<T>(
    String url,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    logRequest(url: url, headers: headers);
    return await _makeRequest<T>(
      (headers) async => await http.get(Uri.parse(url), headers: headers),
      isAuthorized,
      parser: parser,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () => NetworkResponse.errorResponse([ErrorDetails('No internet connection')]),
    );
  }

  Future<NetworkResponse<T>> httpPut<T, X extends INetworkRequest>(
    String url,
    X body,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    logRequest(url: url, body: body.body, headers: headers);
    return await _makeRequest<T>(
      (headers) async => await http.put(Uri.parse(url), headers: headers, body: body.body),
      isAuthorized,
      parser: parser,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () => NetworkResponse.errorResponse([ErrorDetails('No internet connection')]),
    );
  }

  Future<NetworkResponse<T>> httpDelete<T>(
    String url,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    var headers = await headerFactory.createHeaders();
    logRequest(url: url, headers: headers);
    return await _makeRequest<T>(
      (headers) async => await http.delete(Uri.parse(url), headers: headers),
      isAuthorized,
      parser: parser,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () => NetworkResponse.errorResponse([ErrorDetails('No internet connection')]),
    );
  }

  Future<NetworkResponse<T>> _makeRequest<T>(
    Future<http.Response> Function(Map<String, String>) request,
    bool isAuthorized, {
    T Function(dynamic)? parser,
  }) async {
    if (isAuthorized) {
      if (await tokenRefresher.areExpired()) {
        var refreshResponse = await tokenRefresher.refresh();
        if (refreshResponse.isError) {
          return NetworkResponse.errorResponse(refreshResponse.errors);
        }
      }
    }
    return _makeRequestImpl<T>(request, parser: parser);
  }

  Future<NetworkResponse<T>> _makeRequestImpl<T>(
    Future<http.Response> Function(Map<String, String>) request, {
    T Function(dynamic)? parser,
  }) async {
    try {
      var headers = await headerFactory.createHeaders();
      var response = await request(headers);
      logNetworkRepsonse(response: response);
      Map parsedJson;
      if (response.body.isEmpty) {
        parsedJson = {'NetworkError': 'ops'};
      } else {
        parsedJson = json.decode(response.body);
      }
      if (!_isEngineResponse(response, parsedJson)) {
        return NetworkResponse<T>.errorResponse([_parseHttpError(response)]);
      }
      if (parsedJson.containsKey(CrudNetworkDelegate.errors) && parsedJson[CrudNetworkDelegate.errors].isNotEmpty) {
        return NetworkResponse<T>.errorResponse(_parseEasyDeskErrors(parsedJson[CrudNetworkDelegate.errors]));
      }
      return NetworkResponse<T>.successfulResponse(
        payload: parsedJson.containsKey(CrudNetworkDelegate.data) && parser != null
            ? parser(parsedJson[CrudNetworkDelegate.data])
            : null,
        pagination: _parsePagination(parsedJson),
      );
    } on SocketException catch (e, s) {
      logException(e, s);
      return NetworkResponse<T>.errorResponse([ErrorDetails("Couldn't connect to internet")]);
    } on http.ClientException catch (e, s) {
      logException(e, s);
      return NetworkResponse<T>.errorResponse([ErrorDetails("Couldn't connect to internet")]);
    } catch (e, s) {
      logException(e, s);
      return NetworkResponse<T>.errorResponse([ErrorDetails('Exception occurred during network request')]);
    }
  }

  bool _isEngineResponse(http.Response response, dynamic json) {
    var mappedJson = json as Map<Object, dynamic>;
    return mappedJson.keys.every((element) =>
        element == CrudNetworkDelegate.data ||
        element == CrudNetworkDelegate.meta ||
        element == CrudNetworkDelegate.errors);
  }

  PaginationResponse _parsePagination(json) {
    var hasMeta = json.containsKey(CrudNetworkDelegate.meta);
    if (!hasMeta) {
      return PaginationResponse(
        pageSize: PaginationRequest.max_page_size,
        pageIndex: PaginationRequest.max_page_size,
        rowCount: PaginationRequest.max_page_size,
        pageCount: PaginationRequest.max_page_size,
      );
    }
    var metaPayload = json[CrudNetworkDelegate.meta];
    return PaginationResponse(
      pageSize: metaPayload['pageSize'] as int,
      pageIndex: metaPayload['pageIndex'] as int,
      rowCount: metaPayload['rowCount'] as int,
      pageCount: metaPayload['pageCount'] as int,
    );
  }

  List<ErrorDetails> _parseEasyDeskErrors(List<dynamic> json) {
    return json.map<ErrorDetails>((e) => ErrorDetails.fromJSON(e)).toList();
  }

  ErrorDetails _parseHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return ErrorDetails('Bad Request');
      case 401:
        return ErrorDetails('The user needs to authenticate');
      case 403:
        return ErrorDetails('The user is not allow to do this');
      case 404:
        return ErrorDetails('The given URL is not valid');
      default:
        return ErrorDetails('Unexpected Error');
    }
  }
}
