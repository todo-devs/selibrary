import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:selibrary/src/utils/utils.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

abstract class Net {
  static Dio _httpClient;

  static Dio get httpClient {
    if (_httpClient == null) {
      _httpClient = Dio();

      _httpClient.options.headers[HttpHeaders.acceptHeader] =
          'text/html,application/xhtml+xml,application/xml;application/json;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9';

      _httpClient.options.headers[HttpHeaders.acceptLanguageHeader] =
          'es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3';

      _httpClient.options.headers[HttpHeaders.acceptEncodingHeader] =
          'gzip, deflate, br';

      _httpClient.options.headers[HttpHeaders.userAgentHeader] =
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36';

      _httpClient.options.headers[HttpHeaders.connectionHeader] = 'keep-alive';

      (_httpClient.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };

      _httpClient.interceptors
          .add(CookieManager(CookieJar(ignoreExpires: true)));
    }

    return _httpClient;
  }

  static Future<Response> connection({
    String url,
    Map<String, String> dataMap = null,
    String method = 'GET',
    formData = false,
  }) async {
    final http = httpClient;

    try {
      Response response;

      if (formData) {
        response = await http.request(
          url,
          data: FormData.fromMap(dataMap),
          options: Options(
            method: method,
            validateStatus: (status) {
              return status < 400;
            },
          ),
        );
      } else {
        response = await http.request(
          url,
          queryParameters: dataMap,
          options: Options(
            method: method,
            validateStatus: (status) {
              return status < 400;
            },
          ),
        );
      }

      if (response.headers[HttpHeaders.locationHeader] != null) {
        response = await http.get(response.headers['location'].first);
      }

      return response;
    } on DioError catch (e) {
      throw CommunicationException(e.message);
    }
  }

  static Future<List<int>> getImage(String url) async {
    try {
      final http = httpClient;

      Response<List<int>> res = await http.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      return res.data;
    } on DioError catch (e) {
      throw CommunicationException(e.message);
    }
  }
}
