import 'package:crypto_app/data/isar_entity/messages.dart';
import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/data/isar_entity/users_credentials.dart';
import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:injectable/injectable.dart';

@singleton
class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
    initial();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    final isar = await db;
    var oldSettings = await isar.userSettings.get(1);
    if (oldSettings == null) {
      // print('OLDSETTINGS $oldSettings');
      // await initial();
      isar.writeTxnSync(() => isar.userSettings.putSync(newSettings));
    }
    oldSettings = await isar.userSettings.get(1);
    if (oldSettings != null) {
      if (newSettings.url != '') {
        oldSettings.url = newSettings.url;
      }
      if (newSettings.privateApi != '') {
        oldSettings.privateApi = newSettings.privateApi;
      }
      if (newSettings.publicApi != '') {
        oldSettings.publicApi = newSettings.publicApi;
      }
      if (newSettings.telegram != '') {
        oldSettings.telegram = newSettings.telegram;
      }
      isar.writeTxnSync(() => isar.userSettings.putSync(oldSettings!));
    }
  }

  Future<void> updateStartSessionTime(DateTime time) async {
    final isar = await db;
    final message = await isar.userSettings.get(1);

    message!.startSessionTime = time;
    isar.writeTxnSync<int>(() => isar.userSettings.putSync(message));
  }

  Future<void> addMessages(Messages message) async {
    final isar = await db;
    //  isar.writeTxnSync<int>(() isar.messages.putSync(message);
    isar.writeTxnSync(() => isar.messages.putSync(message));
  }

  Future<List<Messages>> getAllMessages() async {
    final isar = await db;
    return await isar.messages.where().findAll();
  }

  Future<void> updateMessageStatus(int id, bool status) async {
    final isar = await db;
    final message = await isar.messages.get(id);
    print('message - ${message}  ${message?.status!}');
    print('ID $id new status $status ');
    message!.status = status;
    isar.writeTxnSync(() => isar.messages.putSync(message));
    final updateMessage = await isar.messages.get(id);
    print('NEW STATUS ID $id status ${updateMessage!.status}');
  }

  Future<void> updateMessageStatusCode(int id, String statusCode) async {
    print('Update statuscode $id $statusCode');
    final isar = await db;
    final message = await isar.messages.get(id);
    print('message : ${message?.statusCode}');
    message!.statusCode = statusCode;
    isar.writeTxnSync(() => isar.messages.putSync(message));
  }

  Future<List<Messages>> getAllMessagesToSend() async {
    final isar = await db;
    return await isar.messages.filter().statusEqualTo(false).findAll();
  }

  Future<bool> ifMessageExist(int timeMessage) async {
    final isar = await db;
    final result = await isar.messages.filter().timestampEqualTo(timeMessage).findFirst();
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<Messages>> listenNotSendingMessages() async* {
    final isar = await db;
    yield* isar.messages.filter().statusEqualTo(false).watch();
  }

  Stream<List<Messages>> listenToMessages() async* {
    final isar = await db;
    yield* isar.messages.where().watch();
  }

  Future<void> deleteMessages() async {
    final isar = await db;
    isar.writeTxn(() => isar.messages.clear());
  }

  Stream<UserSettings?> listenToSettings() async* {
    final isar = await db;
    yield* isar.userSettings.watchObject(1);
  }

  Stream<String?> listenToUrl() async* {
    final isar = await db;
    final settings = await isar.userSettings.filter().idEqualTo(1).findFirst();
    yield settings?.url;
  }

  Stream<String?> listenToPublic() async* {
    final isar = await db;
    final settings = await isar.userSettings.filter().idEqualTo(1).findFirst();
    yield settings?.publicApi;
  }

  Stream<String?> listenToPrivat() async* {
    final isar = await db;
    final settings = await isar.userSettings.filter().idEqualTo(1).findFirst();
    yield settings?.privateApi;
  }

  Stream<String?> listenToTelegram() async* {
    final isar = await db;
    final settings = await isar.userSettings.filter().idEqualTo(1).findFirst();
    yield settings?.telegram;
  }

  Future<UserSettings?> getSettings() async {
    final isar = await db;
    print('Start get settings');
    return await isar.userSettings.where().idEqualTo(1).findFirst(); //.asStream();
  }

  Future<UserCredentials?> getCredentials() async {
    final isar = await db;
    print('Start get settings');
    final credentials = await isar.userCredentials.where().idEqualTo(1).findFirst();
    return credentials;
    // if (credentials==null){
    //   return UserCredentials()..imei = await getImei()..deviceId = await getDeviceName()..token='12345';
    // }else{
    //   return credentials;
    // }
  }

  // Future<String?> getDeviceId() async {
  //   final isar = await db;
  //   print('Start get settings');
  //   final settings = await isar.userSettings.where().idEqualTo(1).findFirst();
  //   return settings.imei;//.asStream();
  // }

  Future<void> initial() async {
    if (await getCredentials() == null) {
      print('BD NULL!!! start inittiate!!');
      final isar = await db;
      final initialCredentials = UserCredentials()
        ..imei = await getImei()
        ..deviceId = await getDeviceName()
        ..fcmToken = await getFcmToken() ?? 'no fcmToken';

      isar.writeTxnSync(() => isar.userCredentials.putSync(initialCredentials));
      print('finish put credentials');
    }
  }

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> updateFcmToken(String fcmToken) async {
    final isar = await db;
    final message = await isar.userCredentials.get(1);

    message!.fcmToken = fcmToken;
    isar.writeTxnSync<int>(() => isar.userCredentials.putSync(message));
  }

//TEST
  Future<void> updateMessage(String push) async {
    final isar = await db;
    final message = await isar.userCredentials.get(1);

    message!.fcmMessage = push;
    isar.writeTxnSync<int>(() => isar.userCredentials.putSync(message));
  }

//TEST
  // FirebaseMessaging.instance.getToken().then(updateFcmToken);

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserSettingsSchema, UserCredentialsSchema, MessagesSchema],
        inspector: true,
        directory: dir.path,
        name: 'processingBase',
      );
    }

    return Future.value(Isar.getInstance("processingBase"));
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return '${androidInfo.brand} ${androidInfo.manufacturer} ${androidInfo.model}';
  }

  // Future<String> getImei() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //
  //       return androidInfo.fingerprint;
  //     }

  Future<String> getImei() async {
    final _deviceImeiPlugin = DeviceImei();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    try {
      final imeiNo = await DeviceInformation.deviceIMEINumber;
      print('imei $imeiNo');
      return imeiNo;

      // localStorage.setImei(imeiNo);
    } on PlatformException catch (e) {
      //var permission = await Permission.phone.status;
      DeviceInfo? dInfo = await _deviceImeiPlugin.getDeviceInfo();
      String? imei = await _deviceImeiPlugin.getDeviceImei();
      // String imei = await DeviceImei.getImei();
      if (imei != null) {
        return imei;
      } else {
        return (androidInfo.fingerprint);
      }
    }
  }
}
