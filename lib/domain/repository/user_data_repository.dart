import 'package:crypto_app/data/autoconfirm_api.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/data/response/base_response.dart';
import 'package:crypto_app/data/response/sms_response.dart';
import 'package:crypto_app/data/websocket_response/response.dart';
import 'package:crypto_app/domain/entity/pagination.dart';
import 'package:crypto_app/errors/error_parser.dart';

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import 'package:telephony/telephony.dart';
import '../../data/local_storage.dart';
import 'dart:async';

@singleton
class Repository {
  //final AutoConfirmApi autoConfirmApi;
  final IsarService _service;
  final dio = Dio();
  //final LocalStorage _localStorage;

  Repository(
    this._service,
  );
  Future<bool> get isLogged async{
    return await _service.getSettings() != null;
  }
 // void configureDio() {
    // Set default configs
    // dio.options.baseUrl = 'https://api.pub.dev';
    // dio.options.connectTimeout = Duration(seconds: 5);
    // dio.options.receiveTimeout = Duration(seconds: 3);

    // Or create `Dio` with a `BaseOptions` instance.
    // final options = BaseOptions(
    //   baseUrl: 'https://api.pub.dev',
    //   connectTimeout: Duration(seconds: 5),
    //   receiveTimeout: Duration(seconds: 3),
    //
    // );

  //}
  // Future<MyBaseResponse<List<SmsMessages>>>? getSms() async {
  //   print('repository get sms');
  //   try {
  //     final result = await autoConfirmApi.getSms('4364673463','0','50');
  //     print(result);
  //     return result;
  //
  //   } catch (e) {
  //     throw parseError(e);
  //   }
  // }

  Future<SmsResponse> getListSms(String? offsetId,String? firstDate,String? lastDate,int limit) async {
    if (firstDate!=null) {
      firstDate = firstDate.replaceRange(firstDate.length - 1, null, 'Z');
    }
    if (lastDate!=null) {
      lastDate = lastDate.replaceRange(lastDate.length - 1, null, 'Z');
    }
   final settings = await _service.getSettings();
   final credentials = await _service.getCredentials();
   final imei = credentials?.imei;
  // final SmsResponse testresponse;
   final url = settings?.url??'no url';
    try {
      print('start get SMSSS url = $url offset : $offsetId, limit : $limit от $firstDate do $lastDate');
      final response = await dio.post('$url/getSms', data: {'phoneId': 'danil555', 'firstDate':firstDate,'lastDate':lastDate, 'timestampOffset': offsetId,'limit': limit});//TODO CHANGE imei!!
      print('responseeee :  ${response.data}');
      //return SmsResponse.fromJson(response.data);
     // testresponse = SmsResponse.fromJson(response.data);
     // print('6666666666  RESPONSE : count:  ${testresponse.result.length}  status: ${testresponse.result[1].hasConfirmed}  timestamp  ${testresponse.result[1].timeStamp} formatted ${testresponse.result[1].formattedTimestamp}');
      return SmsResponse.fromJson(response.data);
    } catch (e) {
      print('error $e');
      throw parseError(e);
    }
  }
  //
  // Future<void> registration(String telephoneNumber) async {
  //   try {
  //     final result = await autoConfirmApi.registration(telephoneNumber);
  //     print(result);
  //   } catch (e) {
  //     throw parseError(e);
  //   }
  // }

  // Future<MyBaseResponse> pingHealthCheck(String publicApi,String privateApi,String telegram) async {
  //   try {
  //     final result = await autoConfirmApi.healthCheck(publicApi, privateApi, telegram);
  //     return result;
  //   } catch (e) {
  //     throw parseError(e);
  //   }
  // }
//   Future<bool> isLogged() async{
//     return await _service.getSettings() != null;
// }

  // String get publicApi => _localStorage.getPublicApi()??'No public Api';
  //
  // String get privateApi => _localStorage.getPrivateApi()??'No private Api';
  //
  // String get telegram => _localStorage.getUserTelegram()??'No telegram';
  //
  // String get imei => _localStorage.getTelephoneImei()??'No imei';
  //
  // String get deviceName => _localStorage.getDeviceName()??'No device name';

}
