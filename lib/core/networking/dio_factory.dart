import 'package:dio/dio.dart';

class DioFactory {
  static late Dio dio;

  static void init() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    );
    dio = Dio(options);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.post(
      url,
      data: data,
      options: Options(
        headers: headers ??
            {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
      ),
    );
  }

  static Future<Response> postDataWithForm({
    required String url,
    required FormData form,
    String? token,
  }) async {
    return await dio.post(
      url,
      data: form,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    return await dio.put(
      url,
      data: data,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    return await dio.delete(
      url,
      data: data,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
