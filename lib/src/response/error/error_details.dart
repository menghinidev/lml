class ErrorDetails {
  final int id;
  final String message;

  ErrorDetails({required this.id, this.message = ''});

  factory ErrorDetails.fromJSON(Map<String, dynamic> object) {
    return ErrorDetails(
      id: object['id'],
      message: object['message'],
    );
  }

  @override
  String toString() {
    return '''Error ID: $id
    Error Message: $message''';
  }
}
