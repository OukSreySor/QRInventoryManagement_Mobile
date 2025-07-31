import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'snackbar_helper.dart';

void handleDioError(DioException error, BuildContext context) {
  String errorMessage = 'An unexpected error occurred.';

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    errorMessage = 'Connection timed out. Please try again.';
  } else if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;

    if (data != null && data is Map<String, dynamic> && data.containsKey('message')) {
      errorMessage = data['message'];
    } else if (statusCode == 404) {
      errorMessage = 'Resource not found.';
    } else if (statusCode == 500) {
      errorMessage = 'Server error. Please try again later.';
    } else {
      errorMessage = 'Request failed with status code: $statusCode';
    }
  } else if (error.type == DioExceptionType.unknown) {
    errorMessage = 'Network error. Please check your connection.';
  }

  SnackbarHelper.error(errorMessage);
}


  

