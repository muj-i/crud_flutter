import 'dart:developer';
import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';
import '../network_response.dart';

class GetRequest {
  static Dio dio = Dio();

  static Future<NetworkResponse> execute(String url) async {
    try {
      // check if access token is expired
      // if (TokenKeeper.accessToken != null) {
      //   if (RefreshTokenService.isTokenExpired()) {
      //     await RefreshTokenService
      //         .refreshAccessToken(); // refresh token if expired
      //   }
      // }
      dio.interceptors.add(
        AwesomeDioInterceptor(
          // Disabling headers and timeout would minimize the logging output.
          // Optional, defaults to true
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,

          // Optional, defaults to the 'log' function in the 'dart:developer' package.
          logger: debugPrint,
        ),
      );

      Response response = await dio.get(
        url,
        // options: Options(
        // headers: {
        //   'Authorization': 'Bearer ${TokenKeeper.accessToken.toString()}'
        // },
        // ),
      );

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
        // return execute(url); // retry the original request
        return NetworkResponse(false, e.response!.statusCode!, null);
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