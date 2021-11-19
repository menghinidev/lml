import 'dart:convert';
import 'package:lml/src/network/network_request.dart';
import 'package:lml/src/network/network_response.dart';
import 'package:http/http.dart' as http;
import 'package:lml/src/network/pagination.dart';
import 'package:lml/src/response/error/error_details.dart';

mixin CrudNetworkDelegate {
  static final String errors = 'errors';
  static final String data = 'data';
  static final String meta = 'meta';

  Future<NetworkResponse<T>> getRequest<T>(
    String url,
    Map<String, String> headers,
    T Function(dynamic json)? parser,
  ) async {
    var response = await http.get(Uri.parse(url), headers: headers);
    return _parseResponse(response, parser);
  }

  Future<NetworkResponse<T>> postRequest<T, B extends INetworkRequest>(
    String url,
    Map<String, String> headers,
    T Function(dynamic json)? parser,
    B request,
  ) async {
    var response = await http.post(Uri.parse(url), headers: headers, body: request.body);
    return _parseResponse(response, parser);
  }

  NetworkResponse<T> _parseResponse<T>(http.Response response, T Function(dynamic json)? parser) {
    Map parsedJson;
    if (response.body.isEmpty) {
      parsedJson = {'NetworkError': 'ops'};
    } else {
      parsedJson = json.decode(response.body);
    }
    if (!_isEngineResponse(response, parsedJson)) {
      return NetworkResponse<T>.errorResponse(
        [_parseHttpError(response)],
      );
    }
    if (parsedJson.containsKey(errors) && parsedJson[errors].isNotEmpty) {
      return NetworkResponse<T>.errorResponse(
        _parseEasyDeskErrors(parsedJson[errors]),
      );
    }
    return NetworkResponse<T>.successfulResponse(
      payload: parsedJson.containsKey(data)
          ? parser != null
              ? parser(parsedJson[data])
              : null
          : null,
      pagination: PaginationResponse(
        pageSize: PaginationRequest.max_page_size,
        pageIndex: PaginationRequest.max_page_size,
        rowCount: PaginationRequest.max_page_size,
        pageCount: PaginationRequest.max_page_size,
      ),
    );
  }

  bool _isEngineResponse(http.Response response, dynamic json) {
    var mappedJson = json as Map<Object, dynamic>;
    return mappedJson.keys.every((element) => element == data || element == meta || element == errors);
  }

  List<ErrorDetails> _parseEasyDeskErrors(List<dynamic> json) =>
      json.map<ErrorDetails>((e) => ErrorDetails.fromJSON(e)).toList();

  ErrorDetails _parseHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return ErrorDetails(id: 400, message: 'Bad Request');
      case 401:
        return ErrorDetails(id: 401, message: 'The user needs to authenticate');
      case 403:
        return ErrorDetails(id: 403, message: 'The user is not allow to do this');
      case 404:
        return ErrorDetails(id: 404, message: 'The given URL is not valid');
      default:
        return ErrorDetails(id: 500, message: 'Unexpected Error');
    }
  }
}
