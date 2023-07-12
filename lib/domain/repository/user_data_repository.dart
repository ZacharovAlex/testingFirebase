import 'package:crypto_app/data/isar_service.dart';
import 'package:injectable/injectable.dart';

import 'package:telephony/telephony.dart';
import '../../data/local_storage.dart';
import 'dart:async';

@singleton
class Repository {
 // final AutoConfirmApi autoConfirmApi;
  final IsarService _service;
  //final LocalStorage _localStorage;

  Repository(
    //this._service,
    this._service,
  );
  Future<bool> get isLogged async{
    return await _service.getSettings() != null;
  }
  // Future<void> sendSms(SmsMessage message) async {
  //   try {
  //     final result = await autoConfirmApi.sendSms(
  //         message.body ?? 'No text', message.address ?? 'No address', formatDate(message.date));
  //     print(result);
  //   } catch (e) {
  //     throw parseError(e);
  //   }
  // }
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
