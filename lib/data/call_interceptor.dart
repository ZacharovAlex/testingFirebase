// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'local_storage.dart';
//
// const _maxRetryAttempt = 2;
//
// @injectable
// class CallInterceptor extends QueuedInterceptor {
//   int _retryAttempt = 0;
//   final LocalStorage _storage;
//   CallInterceptor(this._storage);
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler)  {
//     final token = _storage.getToken();
//    // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6MSwiUGFzc3dvcmQiOiIiLCJFeHBpcmVzQXQiOiIyMDI0LTAyLTI2VDE0OjI1OjQ2LjU0OTQ1MDk0MloifQ.2drOTmAZ6CmMqKlM5Ll_QI3dQiWPoMSXV3Lb7XEib64';
//     if (token != null) {
//       options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
//     }
//     return handler.next(options);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     _retryAttempt = 0;
//     super.onResponse(response, handler);
//   }
//
//   @override
//   Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
//     // switch (err.response?.statusCode) {
//     //   case 401:
//     //     {
//     //       if (_retryAttempt++ < _maxRetryAttempt) {
//     //         await _tryToRestoreToken(err, handler);
//     //       } else {
//     //         await _navigateToSignInPage(err, handler);
//     //       }
//     //       break;
//     //     }
//     //   default:
//     //     handler.next(err);
//     // }
//     handler.next(err);
//   }
//
//   Future<void> _tryToRestoreToken(DioError err, ErrorInterceptorHandler handler) async {
//     // try {
//     //   final refreshToken = await _storage.getRefreshToken();
//     //   if (refreshToken != null) {
//     //     final res = await authApi.refreshToken(refreshToken);
//     //
//     //     await _storage.saveToken(res.token);
//     //     await _storage.saveRefreshToken(res.refreshToken);
//     //
//     //     final options = err.requestOptions;
//     //     final response = await _dio.fetch<dynamic>(options);
//     //     handler.resolve(response);
//     //   } else {
//     //     await _navigateToSignInPage(err, handler);
//     //   }
//     // } catch (e) {
//     //   logger.e(e);
//     //   await _navigateToSignInPage(err, handler);
//     // }
//   }
//
//   Future<void> _navigateToSignInPage(DioError err, ErrorInterceptorHandler handler) async {
//     // handler.next(err);
//     // _retryAttempt = 0;
//     // await _storage.clear();
//     // await mainNavigatorKey.currentState
//     //     ?.pushAndRemoveUntil(AppRouter.defaultRoute((_) => const WelcomeScreen()), (route) => false);
//   }
// }
