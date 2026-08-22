class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

/// The customer already has an active order (server code
/// ACTIVE_ORDER_EXISTS). One active order per customer, across BOTH
/// service types.
class ActiveOrderException implements Exception {
  final String message;
  const ActiveOrderException(this.message);

  @override
  String toString() => message;
}
