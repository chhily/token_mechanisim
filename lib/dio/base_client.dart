import 'package:dio/dio.dart';
import 'package:token_mechansim/dio/dio_helper.dart';

class BaseHttpClient {
  static late final Dio dio;

  static void init() {
    final BaseOptions options = BaseOptions(
      baseUrl: "YOUR_BASE_URL_HERE",
      connectTimeout: const Duration(milliseconds: 50000),
      receiveTimeout: const Duration(milliseconds: 50000),
    );

    dio = Dio()
      ..options = options
      ..interceptors.add(DIOHelper.i.defaultInterceptor);
  }
}
