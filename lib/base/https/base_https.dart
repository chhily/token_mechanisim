import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:token_mechansim/base/db/user_db.dart';
import 'package:token_mechansim/base/https/http_exception.dart';
import 'package:token_mechansim/base/helper/log_helper.dart';
import 'package:token_mechansim/view/constants/app_string.dart';

import '../helper/response.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient._internal();
  late final http.Client _client;

  factory HttpClient() => _singleton;

  HttpClient._internal() : _client = http.Client();

  Future<dynamic> fetchData(String url,
      {Map<String, String>? params, bool isToken = true}) async {
    dynamic responseJson;

    String? token = await UserDB().getToken();
    if (params == null) {
      params = {"token": token.toString()};
    } else {
      params["token"] = token.toString();
    }

    var uri = Uri.parse("${AppConfig.BASE_URL}/$url")
        .replace(queryParameters: params);

    try {
      logMessage("Api Request GET = $uri");
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 30));
      logMessage("Response status code = ${response.statusCode}");
      responseJson = await _handleResponse(response, url, params, isToken);
    } on SocketException {
      _noInternetConnection();
    } catch (e) {
      _onRequestTimeOut(e.toString());
    }
    return responseJson;
  }

  Future<dynamic> patchData(
    String url, {
    Map<String, dynamic>? body,
    File? file,
    List<File>? files,
    bool isToken = false,
    bool isSearchFace = false,
    String method = "PATCH",
    bool isAvatar = false,
    String? contentTypeHeader,
  }) async {
    // Implementation for patchData method
  }

  Future<dynamic> postData(String url,
      {dynamic body, bool isToken = true}) async {
    // Implementation for postData method
  }

  dynamic _handleResponse(http.Response response, String url,
      Map<String, String>? params, bool isToken) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        if (isToken) {
          return await _checkTokenExpiredAndInvalid(responseJson, url, params);
        }
        return responseJson;
      case 401:
      case 402:
        return await _refreshToken();
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server : ${response.statusCode}');
    }
  }

  Future<dynamic> _checkTokenExpiredAndInvalid(
      dynamic response, String url, Map<String, String>? params) async {
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.status == 401) {
      await _refreshToken();
      return fetchData(url, params: params, isToken: true);
    } else if (baseResponse.status == 402) {
      _showConfirmLogout();
      return false;
    } else if (baseResponse.message
        .toString()
        .toLowerCase()
        .contains("error validate token")) {
      _clearAndLogout();
      return false;
    } else {
      return baseResponse;
    }
  }

  _refreshToken() async {
    // Implementation for _refreshToken method
    bool isRefreshSuccess = true;
    if (isRefreshSuccess) {
    } else {
      _clearAndLogout();
    }
  }

  _showConfirmLogout() async {
    // Implementation for _showConfirmLogout method
  }

  Future<void> _clearAndLogout() async {
    // Implementation for _clearAndLogout method
    await UserDB().clearUserDB();
    //  logOut();
  }

  Future<void> _loginAgain() async {
    // Implementation for _loginAgain method
    await UserDB().clearUserDB();
    // redirect to login page
  }

  void _noInternetConnection() {
    // Implementation for _noInternetConnection method
    // show toast
    throw FetchDataException("No internet connection");
  }

  void _onRequestTimeOut(String msg) {
    // Implementation for _onRequestTimeOut method
    if (msg.contains("TimeoutException")) {
      // show toast
      throw FetchDataException("Time out");
    }
  }
}
