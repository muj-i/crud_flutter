import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../utils/logger.dart';
import '../network_response.dart';

class DeleteRequest {
  static Dio dio = Dio();

  static Future<NetworkResponse> execute(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      // check if access token is expired
      // if (TokenKeeper.accessToken != null) {
      //   if (RefreshTokenService.isTokenExpired()) {
      //     await RefreshTokenService
      //         .refreshAccessToken(); // refresh token if expired
      //   }
      // }
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer ${TokenKeeper.accessToken.toString()}'
          },
        ),
        data: jsonEncode(body),
      );

      logger.w(response.statusCode.toString());
      logger.w(jsonEncode(response.data));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(true, response.statusCode!, response.data);
      } else {
        logger.e(response.statusCode.toString());
        return NetworkResponse(false, response.statusCode!, null);
      }
    } catch (e) {
      //  dio errors handle
      if (e is DioException && e.response?.statusCode == 401) {
        // if the error is due to token expiry (401), refresh token and retry the request
        logger.e(e.response?.statusCode.toString());
        // await RefreshTokenService.refreshAccessToken();
        return execute(url, body); // retry the original request
      } else if (e is DioException && e.response?.statusCode == 404) {
        logger.e(e.response?.statusCode.toString());
        return NetworkResponse(false, e.response!.statusCode!, null);
      } else if (e is DioException && e.error is SocketException) {
        logger.e(e.error.toString());
        return NetworkResponse(false, 7, null);
      } else {
        logger.e(e.toString());
        return NetworkResponse(false, -1, null);
      }
    }
  }
}