/// Thrown by the data layer when an API or parsing error occurs.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error occurred']);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when the device has no connectivity or the request times out.
class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error occurred']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
