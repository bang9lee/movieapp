import 'package:dio/dio.dart';
import 'package:movieapp/core/utils/logger_utils.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.log('┌── 요청 정보 ──────────────────────────────────────────');
    Logger.log('│ URL: ${options.method} ${options.uri}');
    Logger.log('│ Headers: ${options.headers}');
    if (options.data != null) {
      Logger.log('│ 요청 데이터: ${options.data}');
    }
    Logger.log('└───────────────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.log('┌── 응답 정보 ──────────────────────────────────────────');
    Logger.log('│ URL: ${response.requestOptions.method} ${response.requestOptions.uri}');
    Logger.log('│ 상태 코드: ${response.statusCode}');
    Logger.log('│ 응답 데이터: ${response.data}');
    Logger.log('└───────────────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error('┌── 요청 오류 ──────────────────────────────────────────');
    Logger.error('│ URL: ${err.requestOptions.method} ${err.requestOptions.uri}');
    Logger.error('│ 상태 코드: ${err.response?.statusCode}');
    Logger.error('│ 오류 타입: ${err.type}');
    if (err.response != null) {
      Logger.error('│ 응답 데이터: ${err.response?.data}');
    }
    Logger.error('│ 오류 메시지: ${err.message}');
    Logger.error('└───────────────────────────────────────────────────────');
    super.onError(err, handler);
  }
}