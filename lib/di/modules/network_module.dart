// import 'dart:io';
//
// import 'package:crypto_app/data/autoconfirm_api.dart';
// import 'package:crypto_app/data/isar_service.dart';
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import '../../presentation/app/app_constants.dart';
//
// @module
// abstract class RegisterModule {
//   IsarService service = IsarService();
//
//   @lazySingleton
//   Future<Dio> provideDio() async{
//     final settings = await service.getSettings();
//     final dio = Dio(BaseOptions(
//         baseUrl: settings?.url??'no url',//AppConstants.baseUrl,
//         responseType: ResponseType.json,
//         contentType: ContentType.json.toString()));
//    // dio.interceptors.add(callInterceptor);
//   //  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//
//     //  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
//
//     return dio;
//   }
//
//   @lazySingleton
//   AutoConfirmApi autoConfirmApi(Dio dio) => AutoConfirmApi(dio);
// }
