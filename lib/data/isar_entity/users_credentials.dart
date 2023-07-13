import 'package:isar/isar.dart';

part 'users_credentials.g.dart';

@Collection()
class UserCredentials {
  Id id = 1;//Isar.autoIncrement;
  String? fcmToken;
  String? imei;
  String? deviceId;
  String? fcmMessage;

}
