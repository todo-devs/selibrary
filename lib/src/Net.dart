import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

abstract class Net {
  static List<Cookie> _cookies;

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
    }

    if (_cookies != null) {
      _cookies.removeWhere((cookie) {
        if (cookie.expires != null) {
          return cookie.expires.isBefore(DateTime.now());
        }
        return false;
      });

      _httpClient.options.headers[HttpHeaders.cookieHeader] =
          _getCookies(_cookies);
    }

    return _httpClient;
  }

  static Future<Response> connection({
    String url,
    Map<String, String> dataMap = null,
    List<Cookie> cookies = null,
    String method = 'GET',
    bool verify = true,
  }) async {
    Map<String, String> formData;

    final http = httpClient;

    if (cookies != null) {
      cookies.removeWhere((cookie) {
        if (cookie.expires != null) {
          return cookie.expires.isBefore(DateTime.now());
        }
        return false;
      });

      http.options.headers[HttpHeaders.cookieHeader] = _getCookies(cookies);
    }

    if (dataMap != null) {
      formData = dataMap;
    }

    if (!verify) {
      (http.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }

    var response = await http.request(
      url,
      queryParameters: formData,
      options: Options(
        method: method,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    _saveCookies(response);

    if (response.headers[HttpHeaders.locationHeader] != null) {
      response = await httpClient.get(response.headers['location'].first);

      _saveCookies(response);
    }

    return response;
  }

  static List<Cookie> get cookies => _cookies;
  static String get cookiesAsString => _getCookies(_cookies);

  static String _getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }

  static void _saveCookies(Response response) {
    if (response != null && response.headers != null) {
      List<String> resCookies = response.headers[HttpHeaders.setCookieHeader];
      if (resCookies != null) {
        _cookies.addAll(
            resCookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }
    }
  }

  static Future<List<int>> getImage(String url) async {
    Response<List<int>> res = await httpClient.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    _saveCookies(res);

    return res.data;
  }

  static Future<File> saveImage({
    String filePath: 'captcha.png',
    List<int> imageAsByte,
  }) async {
    var file = File(filePath);
    return await file.writeAsBytes(imageAsByte);
  }
}
