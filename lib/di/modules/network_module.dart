// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:sms_v2/data/autoconfirm_api.dart';
// import 'package:sms_v2/data/call_interceptor.dart';
// import '../../presentation/app/app_constants.dart';
//
// @module
// abstract class RegisterModule {
//   @lazySingleton
//   Dio provideDio(CallInterceptor callInterceptor) {
//     final dio = Dio(BaseOptions(
//         baseUrl: AppConstants.baseUrl,
//         responseType: ResponseType.json,
//         contentType: ContentType.json.toString()));
//     dio.interceptors.add(callInterceptor);
//     dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//
//     //  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
//
//     return dio;
//   }
//
//   @lazySingleton
//   AutoConfirmApi autoConfirmApi(Dio dio) => AutoConfirmApi(dio);
// }
