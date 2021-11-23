import 'error/error_details.dart';

class Responses {
  static Response<T> success<T>(T? payload) => _Success(payload: payload);
  static Response<T> failure<T>(List<ErrorDetails> errors) => _Failure(errors: errors);

  static Response<T> create<T>({
    required T? Function() builder,
    required bool Function(T?) isError,
    ErrorDetails? error,
  }) {
    var payload = builder();
    if (isError(payload)) {
      return Responses.failure([error ?? ErrorDetails(id: 0, message: '')]);
    }
    return Responses.success<T>(payload!);
  }

  static Future<Response<T>> createAsync<T>({
    required Future<T> Function() builder,
    required bool Function(T) isError,
    ErrorDetails? error,
  }) async {
    var payload = await builder();
    if (isError(payload)) {
      return Responses.failure([error ?? ErrorDetails(id: 0, message: '')]);
    }
    return Responses.success<T>(payload);
  }
}

abstract class Response<T> {
  bool get isError => errors.isNotEmpty;

  T? get payload;
  List<ErrorDetails> get errors;

  Response<B> map<B>(B Function(T? t) mapper);

  Response<B> flatMap<B>(Response<B> Function(T? t) mapper);

  Future<Response<B>> mapAsync<B>(Future<B> Function(T? t) mapper);

  Future<Response<B>> flatMapAsync<B>(Future<Response<B>> Function(T? t) mapper);

  Response<T> ifSuccess(Function(T? payload) callback);

  Future<Response<T>> ifSuccessAsync(Future Function(T? payload) callback);

  Response<T> ifError(Function(T? payload) callback);

  Future<Response<T>> ifErrorAsync(Future Function(T? payload) callback);
}

class _Success<T> extends Response<T> {
  final T? _payload;

  _Success({T? payload}) : _payload = payload;

  @override
  List<ErrorDetails> get errors => [];

  @override
  T? get payload => _payload;

  @override
  Response<B> map<B>(B Function(T? t) mapper) => _Success(payload: mapper(payload));

  @override
  Response<B> flatMap<B>(Response<B> Function(T? t) mapper) => mapper(payload);

  @override
  Future<Response<B>> flatMapAsync<B>(Future<Response<B>> Function(T? t) mapper) async => await mapper(payload);

  @override
  Future<Response<B>> mapAsync<B>(Future<B> Function(T? t) mapper) async => _Success(payload: await mapper(payload));

  @override
  Response<T> ifSuccess(Function(T?) callback) {
    callback(payload);
    return this;
  }

  @override
  Future<Response<T>> ifSuccessAsync(Future Function(T? payload) callback) async {
    await callback(payload);
    return this;
  }

  @override
  Response<T> ifError(Function(T? payload) callback) => this;

  @override
  Future<Response<T>> ifErrorAsync(Future Function(T? payload) callback) => Future.value(this);
}

class _Failure<T> extends Response<T> {
  final List<ErrorDetails> _errors;

  _Failure({required List<ErrorDetails> errors}) : _errors = errors;

  @override
  List<ErrorDetails> get errors => _errors;

  @override
  T? get payload => null;

  @override
  Response<B> map<B>(B Function(T t) mapper) => _Failure<B>(errors: errors);

  @override
  Response<B> flatMap<B>(Response<B> Function(T t) mapper) => _Failure<B>(errors: errors);

  @override
  Future<Response<B>> flatMapAsync<B>(Future<Response<B>> Function(T t) mapper) =>
      Future.value(_Failure<B>(errors: errors));

  @override
  Future<Response<B>> mapAsync<B>(Future<B> Function(T t) mapper) => Future.value(_Failure(errors: errors));

  @override
  Response<T> ifSuccess(Function(T p1) callback) => this;

  @override
  Future<Response<T>> ifSuccessAsync(Future Function(T payload) callback) => Future.value(this);

  @override
  Response<T> ifError(Function(T? payload) callback) {
    callback(payload);
    return this;
  }

  @override
  Future<Response<T>> ifErrorAsync(Future Function(T? payload) callback) async {
    await callback(payload);
    return this;
  }
}

class _Terminator<T> extends Response<T> {
  final Response response;
  _Terminator({required this.response});

  @override
  List<ErrorDetails> get errors => response.errors;

  @override
  Response<B> flatMap<B>(Response<B> Function(T t) mapper) => _Terminator<B>(response: response);

  @override
  Future<Response<B>> flatMapAsync<B>(Future<Response<B>> Function(T t) mapper) => Future.value(
        _Terminator<B>(response: response),
      );

  @override
  Response<T> ifError(Function(T payload) callback) => this;

  @override
  Future<Response<T>> ifErrorAsync(Future Function(T payload) callback) => Future.value(this);

  @override
  Response<T> ifSuccess(Function(T payload) callback) => this;

  @override
  Future<Response<T>> ifSuccessAsync(Future Function(T payload) callback) => Future.value(this);

  @override
  Response<B> map<B>(B Function(T t) mapper) => _Terminator<B>(response: response);

  @override
  Future<Response<B>> mapAsync<B>(Future<B> Function(T t) mapper) => Future.value(_Terminator<B>(response: response));

  @override
  T get payload => response.payload;
}

extension ResponseTerminator<T> on Response<T> {
  Response<T> ifErrorTerminate() {
    if (!isError) return this;
    return _Terminator<T>(response: this);
  }

  Response<T> ifSuccessTerminate() => !isError ? _Terminator<T>(response: this) : this;
}

extension FutureExtension<B> on Future<Response<B>> {
  Future<Response<T>> mapToResponse<T>(T Function(B? payload) mapper) async {
    var res = await this;
    return res.map(mapper);
  }

  Future<Response<B>> ifError(Function(B? payload) callback) async {
    var res = await this;
    return res.ifError(callback);
  }

  Future<Response<B>> ifErrorTerminate(Function(B? payload) callback) async {
    var res = await this;
    return res.ifError(callback).ifErrorTerminate();
  }

  Future<Response<B>> ifErrorAsync(Future Function(B? payload) callback) async {
    var res = await this;
    return res.ifErrorAsync(callback);
  }

  Future<Response<B>> ifSuccess(Function(B? payload) callback) async {
    var res = await this;
    return res.ifSuccess(callback);
  }

  Future<Response<B>> ifSuccessTerminate(Function(B? payload) callback) async {
    var res = await this;
    return res.ifSuccess(callback).ifSuccessTerminate();
  }

  Future<Response<B>> ifSuccessAsync(Future Function(B? payload) callback) async {
    var res = await this;
    return await res.ifSuccessAsync(callback);
  }

  Future<Response<T>> mapAsyncToResponse<T>(Future<T> Function(B? payload) mapper) async {
    var res = await this;
    return await res.mapAsync(mapper);
  }

  Future<Response<T>> flatMapToResponse<T>(Response<T> Function(B? payload) mapper) async {
    var res = await this;
    return res.flatMap(mapper);
  }

  Future<Response<T>> flatMapAsyncToResponse<T>(Future<Response<T>> Function(B? payload) mapper) async {
    var res = await this;
    return await res.flatMapAsync(mapper);
  }
}
