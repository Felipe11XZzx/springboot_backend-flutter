import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  final logger = Logger();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    headers: {
      'Accept': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.d('Request URL: ${options.baseUrl}${options.path}');
        logger.d('Request Method: ${options.method}');
        logger.d('Request Headers: ${options.headers}');
        logger.d('Request Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.d('Response Status: ${response.statusCode}');
        logger.d('Response Headers: ${response.headers}');
        logger.d('Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        logger.e(
            'API Error: ${e.response?.statusCode} ${_dio.options.baseUrl}${e.requestOptions.path}');
        logger.e('Error Response: ${e.response?.data}');
        logger.e('Error Headers: ${e.response?.headers}');
        logger.e('Error Message: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
