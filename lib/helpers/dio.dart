import 'package:dio/dio.dart';

String dioErrorToMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.badResponse:
      return e.response?.data?["message"] ?? "An unknown error occurred";
    case DioExceptionType.cancel:
      return "Request cancelled";
    case DioExceptionType.connectionError:
      return "Connection error";
    case DioExceptionType.unknown:
      return "An unknown error occurred";
    case DioExceptionType.receiveTimeout:
      return "Receive timeout";
    case DioExceptionType.sendTimeout:
      return "Send timeout";
    case DioExceptionType.badCertificate:
      return "Bad certificate";
    case DioExceptionType.connectionTimeout:
      return "Connection timeout";
  }
}

String? getErrorMessage(Object e) {
  if (e is DioException) {
    if (e.response?.statusCode == 404) {
      return "Not found";
    }
    return e.response?.data?['message'] ?? e.response?.data?['error'] ?? "An unknown error occurred";
  }
  return null;
}
