// Custom exception classes for different error scenarios (network, validation, business logic)
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class RouteException extends AppException {
  RouteException(super.message);
}

class AuthenticationException extends AppException {
  AuthenticationException(super.message);
}

class ParseException extends AppException {
  ParseException(super.message);
}
