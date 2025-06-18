class BaseException {
  final String message;

  BaseException(this.message);
}

class UnauthorizedException extends BaseException {
  UnauthorizedException(super.message);
}

class ServerException extends BaseException {
  ServerException(super.message);
}

class ServerNotReachedException extends BaseException {
  ServerNotReachedException(super.message);
}

class RouteNotFoundException extends BaseException {
  RouteNotFoundException(super.message);
}

class NoInternetException extends BaseException {
  NoInternetException(super.message);
}

class TimeoutException extends BaseException {
  TimeoutException(super.message);
}

class BadCertificateException extends BaseException {
  BadCertificateException(super.message);
}

class RequestCancelledException extends BaseException {
  RequestCancelledException(super.message);
}

class ConnectionErrorException extends BaseException {
  ConnectionErrorException(super.message);
}

class GeneralException extends BaseException {
  GeneralException(super.message);
}
