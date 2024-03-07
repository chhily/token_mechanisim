class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error during requesting :");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Requested : ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorized : ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input : ");
}

class AuthenticationException extends AppException {
  AuthenticationException([String? message])
      : super(message, "Authentication Failed : ");
}
