import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (option, handler) {
      //options.headers["Authorization"] = "Bearer TOKEN"; // Autenticación si es necesario
      return handler.next(option);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Error en la API: ${e.response?.statusCode} ${_dio.options.baseUrl}");
        return handler.next(e);
      }
    ));
  }

  Dio get dio => _dio;
}