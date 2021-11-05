class ErrorDetails {
  String message;

  ErrorDetails(this.message);

  factory ErrorDetails.fromJSON(Map<String, dynamic> object) {
    return ErrorDetails(
      object['message'],
    );
  }

  @override
  String toString() {
    return 'Error: $message';
  }
}
