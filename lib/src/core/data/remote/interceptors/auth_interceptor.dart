import 'package:dio/dio.dart';

import '../token/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final response = await dio.post('/api/v1/refresh-token', data: {
            'refreshToken': refreshToken,
          });

          final newAccessToken = response.data['accessToken'];
          await TokenManager.saveTokens(newAccessToken, refreshToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          await TokenManager.clearTokens();
        }
      }
    }
    return handler.next(err);
  }
}
