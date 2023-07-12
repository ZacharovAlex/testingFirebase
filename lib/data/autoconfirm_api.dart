// import 'package:dio/dio.dart';
// import 'package:retrofit/http.dart';
// import 'package:sms_v2/data/response/base_response.dart';
//
// part 'autoconfirm_api.g.dart';
//
// @RestApi()
// abstract class AutoConfirmApi {
//   factory AutoConfirmApi(Dio dio) = _AutoConfirmApi;
//
//   @POST('/sms')
//   @FormUrlEncoded()
//   Future<MyBaseResponse> sendSms(
//    // @Header("FingerPrint") String modelInfo,
//     @Part() String smsText,
//     @Part() String sender,
//     @Part() String time,
//   );
//
//   @POST('/registration')
//   @FormUrlEncoded()
//   Future<MyBaseResponse> registration(
//       // @Header("FingerPrint") String modelInfo,
//       @Part() String number,
//       );
//
//   // @POST('/healthcheck')
//   // @FormUrlEncoded()
//   // Future<MyBaseResponse> healthCheck(
//   //     // @Header("FingerPrint") String modelInfo,
//   //     @Part() String user_api_public,
//   //     @Part() String user_api_private,
//   //     @Part() String user_telegram_id,
//   //     );
//
//
// }
