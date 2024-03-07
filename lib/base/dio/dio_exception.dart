abstract class BaseHttpException {
  final String message;

  BaseHttpException(this.message);

  @override
  String toString() => message;
}

class DioErrorHttpException extends BaseHttpException {
  final int? code;

  DioErrorHttpException(String message, {this.code = 200}) : super(message);
}

class ServerErrorHttpException extends BaseHttpException {
  ServerErrorHttpException(String message) : super(message);
}

class ServerResponseHttpException extends BaseHttpException {
  ServerResponseHttpException(String message) : super(message);
}
