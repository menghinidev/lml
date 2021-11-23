class PaginationRequest {
  static const int maxPageSize = 30;

  final int pageSize;
  final int pageIndex;

  const PaginationRequest({required this.pageSize, required this.pageIndex});

  Map<String, String> asParameter() {
    var _map = <String, String>{};
    _map.putIfAbsent('pageSize', () => pageSize.toString());
    _map.putIfAbsent('pageIndex', () => pageIndex.toString());
    return _map;
  }
}

class PaginationResponse {
  final int pageSize;
  final int pageIndex;
  final int rowCount;
  final int pageCount;

  const PaginationResponse({
    required this.pageSize,
    required this.pageIndex,
    required this.rowCount,
    required this.pageCount,
  });

  bool get hasAnotherRequest => pageIndex < pageCount - 1;

  PaginationRequest? nextRequest() {
    if (!hasAnotherRequest) return null;
    return PaginationRequest(pageSize: pageSize, pageIndex: pageIndex + 1);
  }
}
