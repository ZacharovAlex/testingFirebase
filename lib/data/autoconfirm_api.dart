// import 'package:crypto_app/data/response/base_response.dart';
// import 'package:crypto_app/data/websocket_response/response.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/http.dart';
//
// part 'autoconfirm_api.g.dart';
//
// @RestApi()
// abstract class AutoConfirmApi {
//   factory AutoConfirmApi(Dio dio) = _AutoConfirmApi;
//
//   @POST('/getSms')
//   @FormUrlEncoded()
//   Future<MyBaseResponse<List<SmsMessages>>> getSms(
//    // @Header("FingerPrint") String modelInfo,
//     @Part() String phoneId,
//     @Part() String offset,
//     @Part() String limit,
//   );
//
//   // @POST('/registration')
//   // @FormUrlEncoded()
//   // Future<MyBaseResponse> registration(
//   //     // @Header("FingerPrint") String modelInfo,
//   //     @Part() String number,
//   //     );
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
