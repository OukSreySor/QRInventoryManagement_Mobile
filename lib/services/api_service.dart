import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../utils/handle_dio_error.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.dio;

  Future<T?> get<T>(String path, {Map<String, dynamic>? queryParams, T Function(dynamic data)? fromJson, required BuildContext context}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return fromJson != null ? fromJson(response.data) : response.data;

    } on DioException catch (e) {
      handleDioError(e, context);
      return null;
    }
    
  }

  Future<T?> post<T>(String path, dynamic data, {T Function(dynamic data)? fromJson, required BuildContext context}) async {
    try {

      final response = await _dio.post(path, data: data);
      return fromJson != null ? fromJson(response.data) : response.data;

    } on DioException catch (e) {
      handleDioError(e, context);
      return null;
    }
    
  }

  Future<T?> put<T>(String path, dynamic data, {T Function(dynamic data)? fromJson, required BuildContext context}) async {
    try{
      final response = await _dio.put(path, data: data);
      return fromJson != null ? fromJson(response.data) : response.data;

    } on DioException catch (e) {
      handleDioError(e, context);
      return null;
    }
  }

  Future<T?> delete<T>(String path, {T Function(dynamic data)? fromJson, required BuildContext context}) async {
    try {
      final response = await _dio.delete(path);
      return fromJson != null ? fromJson(response.data) : response.data;

    } on DioException catch (e) {
      handleDioError(e, context);
      return null;
    }
  }
}

