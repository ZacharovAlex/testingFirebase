
import 'package:crypto_app/data/isar_entity/messages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'response.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class MyResponse{

 final User user;
final List<SmsMessages> msgs;

  MyResponse(this.user, this.msgs);
 factory MyResponse.fromJson(Map<String, dynamic> json) => _$MyResponseFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$MyResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User{

 final String telegramId;
 final Stock stock;
 final Device device;
 final App app;

  User(this.telegramId, this.stock, this.device, this.app);
 factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$UserToJson(this);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Stock{

 final String apiPublic;
 final String apiPrivate;

  Stock( this.apiPublic, this.apiPrivate);
 factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$StockToJson(this);
}
@JsonSerializable(fieldRename: FieldRename.snake)
class Device{

 final String id;
 final String agent;

 Device(this.id, this.agent);
 factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
@JsonSerializable(fieldRename: FieldRename.snake)
class App{

 final String version;

 App(this.version);
 factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$AppToJson(this);
}
@JsonSerializable(fieldRename: FieldRename.snake)
class SmsMessages{
 final String? incomingNumber;
 final String? body;
 final String? timestamp;
 SmsMessages(this.incomingNumber, this.body, this.timestamp);
 factory SmsMessages.fromJson(Map<String, dynamic> json) => _$SmsMessagesFromJson(json);

 /// Connect the generated [_$PersonToJson] function to the `toJson` method.
 Map<String, dynamic> toJson() => _$SmsMessagesToJson(this);
}







