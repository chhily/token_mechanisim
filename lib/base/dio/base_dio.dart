import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'base_client.dart';
import 'dio_exception.dart';
import 'dio_helper.dart';

class BaseApiService {
  late Dio dio;

  BaseApiService({Dio? dio}) {
    if (dio != null) {
      this.dio = dio;
    } else {
      this.dio = BaseHttpClient.dio;
    }
  }

  Future<T> onRequest<T>({
    required String path,
    required String method,
    required T Function(Response response) onSuccess,
    Map<String, dynamic>? query,
    Map<String, dynamic> headers = const {},
    dynamic data = const {},
    bool requiredToken = true,
    String? customToken,
    Dio? customDioClient,
    bool autoRefreshToken = true,
  }) async {
    late Response response;

    try {
      final httpOption = Options(method: method, headers: {});

      if (customToken != null) {
        httpOption.headers!['Authorization'] = "bearer $customToken";
      }
      httpOption.headers!.addAll(headers);
      query ??= {};

      if (customDioClient != null) {
        response = await customDioClient.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      } else {
        response = await dio.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      }

      if (response.data != null) {
        debugPrint("Response Status Code: ${response.statusCode}");
        return onSuccess(response);
      } else {
        throw ServerResponseHttpException(response.data['message']);
      }
    } on DioException catch (exception) {
      throw DIOHelper.i.onDioError(exception);
    } on ServerResponseHttpException catch (exception) {
      throw DIOHelper.i.onServerResponseException(exception, response);
    } catch (exception) {
      throw DIOHelper.i.onTypeError(exception);
    }
  }
}
