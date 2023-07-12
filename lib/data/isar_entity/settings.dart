import 'package:isar/isar.dart';

part 'settings.g.dart';

@Collection()
class UserSettings {
  Id id = 1;//Isar.autoIncrement;
  late String? url;
  late String? publicApi;
  late String? privateApi;
  late String? telegram;
   DateTime? startSessionTime;

 // late String? token;
   // String? imei;
   // String? deviceId;

}


// @Collection()
// class SettingsUrl {
//   Id id = 1;//Isar.autoIncrement;
//   late String url;
// }
//
// @Collection()
// class SettingsPublicApi {
//   Id id = 1;//Isar.autoIncrement;
//   late String publicApi;
//
// }
//
// @Collection()
// class SettingsPrivateApi {
//   Id id = 1;//Isar.autoIncrement;
//   late String privateApi;
//
// }
//
// @Collection()
// class SettingsTelegram {
//   Id id = 1;//Isar.autoIncrement;
//   late String telegram;
//
// }