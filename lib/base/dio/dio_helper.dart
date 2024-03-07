// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_exception.dart';

class DIOHelper {
  DIOHelper._init();
  static DIOHelper? _instance;

  static DIOHelper get i => _instance ??= DIOHelper._init();

  static const String SOMETHING_WRONG = "Something went wrong";

  static const String CONNECTION_ERROR = "Connection error";

  static const String TIMEOUT_ERROR = "Connection timeout";

  static const String UNEXPECTED_ERROR = "Oops, Something went wrong";

  static const String SERVER_ERROR = "Server error";

  String onTypeError(dynamic exception) {
    ///Logic or syntax error on some condition
    debugPrint(
        "Type Error :=> ${exception.toString()}\nStackTrace:  ${exception.stackTrace.toString()}");
    return SOMETHING_WRONG;
  }

  void logDioError(DioException exception) {
    String errorMessage = "Dio error :=> ${exception.requestOptions.path}";
    if (exception.response != null) {
      errorMessage += ", Response: => ${exception.response!.data.toString()}";
    } else {
      errorMessage += ", ${exception.message}";
    }

    debugPrint("Http Log: Server error test :=> $errorMessage");
  }

  DioErrorHttpException onDioError(DioException exception) {
    logDioError(exception);
    if (exception.error is SocketException) {
      ///Socket exception mostly from internet connection or host
      return DioErrorHttpException(CONNECTION_ERROR);
    } else if (exception.type == DioExceptionType.connectionTimeout) {
      ///Connection timeout due to internet connection or server not responding
      return DioErrorHttpException(TIMEOUT_ERROR);
    } else if (exception.type == DioExceptionType.badResponse) {
      ///Error that range from 400-500
      String serverMessage;
      if (exception.response!.data is Map) {
        serverMessage = exception.response?.data["message"] ?? UNEXPECTED_ERROR;
      } else {
        serverMessage = UNEXPECTED_ERROR;
      }
      return DioErrorHttpException(serverMessage,
          code: exception.response!.statusCode);
    }
    throw DioErrorHttpException(UNEXPECTED_ERROR);
  }

  ServerResponseHttpException onServerResponseException(
      dynamic exception, Response response) {
    debugPrint(
        "Http Log: Server error :=> ${response.requestOptions.path}:=> $exception");
    return ServerResponseHttpException(exception.toString());
  }

  String handleExceptionError(dynamic error, [String path = ""]) {
    debugPrint(
        "Exception caught [${error.runtimeType}][$path]: ${error.toString()}");
    String errorMessage = UNEXPECTED_ERROR;
    //Dio Error
    if (error is DioException) {
      if (error.error is SocketException) {
        errorMessage = CONNECTION_ERROR;
      } else if (error.type == DioExceptionType.connectionTimeout) {
        errorMessage = TIMEOUT_ERROR;
      } else if (error.type == DioExceptionType.badResponse) {
        debugPrint("Dio Response error on: ${error.requestOptions.path}");
        if (error.response!.statusCode == 502) {
          errorMessage = "${error.response!.statusCode}: $SERVER_ERROR";
        } else {
          errorMessage = "${error.response!.statusCode}: $UNEXPECTED_ERROR";
        }
      }
      return errorMessage;
      //Json convert error
    } else if (error is TypeError) {
      debugPrint(error.stackTrace.toString());
      return errorMessage;
      //Error message from server
    } else if (error is ArgumentError) {
      throw errorMessage;
    } else {
      return error.toString();
    }
  }

  static JsonDecoder decoder = const JsonDecoder();
  static JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  final InterceptorsWrapper defaultInterceptor = InterceptorsWrapper(
    onRequest: (RequestOptions options,
        RequestInterceptorHandler requestInterceptorHandler) async {
      _logRequest(options);
      requestInterceptorHandler.next(options);
    },
    onResponse: (Response response,
        ResponseInterceptorHandler responseInterceptorHandler) async {
      _logResponse(response);
      responseInterceptorHandler.next(response);
    },
    onError: (DioException error,
        ErrorInterceptorHandler errorInterceptorHandler) async {
      errorInterceptorHandler.reject(error);
    },
  );

  static void _logResponse(Response response) {
    prettyPrintJson(response.data);
  }

  static void _logRequest(RequestOptions options) {
    httpLog("${options.method}: ${options.path},"
        "query: ${options.queryParameters},"
        "data: ${options.data},");
  }

  static void httpLog([dynamic log, dynamic additional = ""]) {
    if (kDebugMode) debugPrint("Http request Log: $log $additional");
  }

  static void prettyPrintJson(dynamic input) {
    var prettyString = encoder.convert(input);
    prettyString.split('\n').forEach((element) => debugPrint(element));
  }
}
