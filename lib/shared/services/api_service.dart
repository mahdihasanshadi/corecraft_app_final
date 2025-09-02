import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
        connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      dio.LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // final token = Get.find<AuthController>().token;
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          handler.next(options);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  void _handleError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        Get.snackbar('Error', AppConstants.networkError);
        break;
      case dio.DioExceptionType.badResponse:
        _handleResponseError(error.response);
        break;
      case dio.DioExceptionType.cancel:
        break;
      case dio.DioExceptionType.connectionError:
        Get.snackbar('Error', AppConstants.networkError);
        break;
      default:
        Get.snackbar('Error', AppConstants.unknownError);
    }
  }

  void _handleResponseError(dio.Response? response) {
    if (response == null) return;

    switch (response.statusCode) {
      case 400:
        Get.snackbar('Error', 'Bad request');
        break;
      case 401:
        Get.snackbar('Error', 'Unauthorized');
        // Handle logout
        break;
      case 403:
        Get.snackbar('Error', 'Forbidden');
        break;
      case 404:
        Get.snackbar('Error', 'Not found');
        break;
      case 500:
        Get.snackbar('Error', AppConstants.serverError);
        break;
      default:
        Get.snackbar('Error', AppConstants.unknownError);
    }
  }

  // GET request
  Future<dio.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<dio.Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<dio.Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<dio.Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<dio.Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on dio.DioException catch (e) {
      rethrow;
    }
  }
}
