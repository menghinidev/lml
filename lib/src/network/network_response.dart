import 'package:lml/src/network/pagination.dart';
import 'package:lml/src/response/error/error_details.dart';
import 'package:lml/src/response/response.dart';

class NetworkResponse<T> {
  T? payload;
  List<ErrorDetails> errors;
  PaginationResponse? pagination;

  NetworkResponse.errorResponse(this.errors);
  NetworkResponse.successfulResponse({required this.payload, this.pagination}) : errors = [];

  bool get isError => errors.isNotEmpty;

  Response<T> toResponse() => isError ? Responses.failure<T>(errors) : Responses.success<T>(payload);
}
