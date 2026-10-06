import 'package:dio/dio.dart';

String dioErrorToMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.badResponse:
      final data = e.response?.data;
      if (data is Map) {
        return data["message"]?.toString() ?? "An unknown error occurred";
      }
      return data?.toString() ?? "An unknown error occurred";
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
    case DioExceptionType.transformTimeout:
      return "Transform timeout";
  }
}

String? getErrorMessage(Object e) {
  if (e is DioException) {
    if (e.response?.statusCode == 404) {
      return "Not found";
    }
    final data = e.response?.data;
    if (data is Map) {
      return data['message']?.toString() ?? data['error']?.toString() ?? "An unknown error occurred";
    }
    return data?.toString() ?? "An unknown error occurred";
  }
  return null;
}
