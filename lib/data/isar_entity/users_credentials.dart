import 'package:isar/isar.dart';

part 'users_credentials.g.dart';

@Collection()
class UserCredentials {
  Id id = 1;//Isar.autoIncrement;
  String? token;
  String? imei;
  String? deviceId;
  String? fcmToken;

}
