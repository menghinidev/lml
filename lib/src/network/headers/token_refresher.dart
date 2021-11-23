import 'dart:async';
import 'dart:convert';
import 'package:lml/src/network/crud_network_delegate.dart';
import 'package:lml/src/network/headers/request_header.dart';
import 'package:lml/src/network/network_request.dart';
import 'package:lml/src/network/network_response.dart';
import 'package:lml/src/response/error/error_details.dart';
import 'package:lml/src/response/response.dart';
import 'package:lml/src/timewrappers/timestamp.dart';

const String tokenExpirationKey = 'expiration';
const String accessTokenKey = 'accessToken';
const String refreshTokenKey = 'refreshToken';

abstract class ITokenRefresher<T> {
  Future<bool> areExpired();
  Future<NetworkResponse<T>> refresh();
}

class BearerTokenRefresher with CrudNetworkDelegate implements ITokenRefresher<RefreshTokenResponse> {
  final String Function() refreshEndpoint;
  final Future Function(RefreshTokenResponse) accessInfoUpdater;
  final Future<Response<Map<String, String>>> Function() accessInfoRetriever;

  BearerTokenRefresher({
    required this.accessInfoRetriever,
    required this.accessInfoUpdater,
    required this.refreshEndpoint,
  });

  @override
  Future<bool> areExpired() async {
    var accessInfo = await accessInfoRetriever();
    if (accessInfo.isError) return true;
    var expirationValue = accessInfo.payload![tokenExpirationKey];
    if (expirationValue == null) return true;
    var timeToExpire = TimeStamp.fromString(expirationValue).difference(TimeStamp.now().increase(Duration(minutes: 1)));
    return timeToExpire.inMinutes < 1;
  }

  @override
  Future<NetworkResponse<RefreshTokenResponse>> refresh() async {
    var accessInfo = await accessInfoRetriever();
    var refreshResponse = await TokenRefreshLocker.instance.refresh(
      execute: () async {
        if (accessInfo.isError) NetworkResponse.errorResponse([ErrorDetails(id: 1, message: 'Refresh Token invalid')]);
        var request = RefreshTokenRequestDto(
          accessToken: accessInfo.payload![accessTokenKey] ?? '',
          refreshToken: accessInfo.payload![refreshTokenKey] ?? '',
        );
        return postRequest<RefreshTokenResponse, RefreshTokenRequestDto>(
          refreshEndpoint(),
          IRequestHeaderFactory.generateApplicationJson(),
          (json) => RefreshTokenResponse.fromJson(json),
          request,
        );
      },
      onSuccess: (dto) => accessInfoUpdater(dto),
    );
    if (refreshResponse.isError) return NetworkResponse.errorResponse(refreshResponse.errors);
    return refreshResponse;
  }
}

class RefreshTokenRequestDto extends INetworkRequest {
  final String accessToken;
  final String refreshToken;

  RefreshTokenRequestDto({required this.accessToken, required this.refreshToken});

  @override
  String get body => json.encode({accessTokenKey: accessToken, refreshTokenKey: refreshToken});
}

class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String expiration;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  factory RefreshTokenResponse.fromJson(dynamic json) {
    if (!json is Map) return RefreshTokenResponse(accessToken: '', refreshToken: '', expiration: '');
    return RefreshTokenResponse(
      accessToken: json[accessTokenKey],
      refreshToken: json[refreshTokenKey],
      expiration: json[tokenExpirationKey],
    );
  }
}

class TokenRefreshLocker {
  static TokenRefreshLocker get instance => _singleton;
  static final TokenRefreshLocker _singleton = TokenRefreshLocker._();
  TokenRefreshLocker._();

  Completer<NetworkResponse<RefreshTokenResponse>>? _completer;
  bool get _isRefreshing => _computation != null;
  Future<NetworkResponse<RefreshTokenResponse>>? _computation;

  Future<NetworkResponse<RefreshTokenResponse>> refresh({
    required Future<NetworkResponse<RefreshTokenResponse>> Function() execute,
    required Future Function(RefreshTokenResponse) onSuccess,
  }) async {
    if (_isRefreshing) {
      return await _computation!;
    }
    _completer = Completer();
    _computation = _completer!.future;
    var response = await execute();
    if (!response.isError) await onSuccess(response.payload!);
    _completer!.complete(response);
    _computation = null;
    return response;
  }
}
