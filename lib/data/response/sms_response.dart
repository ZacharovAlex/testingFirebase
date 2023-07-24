import 'package:crypto_app/data/websocket_response/response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_response.g.dart';

@JsonSerializable()
class SmsResponse {
  final String? status;
  //final Result result;
  final List<SmsMessagesList> result;


  SmsResponse(
    this.status, this.result,
  );

  factory SmsResponse.fromJson(Map<String, dynamic> json) => _$SmsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SmsResponseToJson(this);
}

// @JsonSerializable(fieldRename: FieldRename.snake)
// class Result {
//   final List<SmsMessages> data;
//
//   Result(this.data);
//
//   factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ResultToJson(this);
// }

@JsonSerializable()
class SmsMessagesList {
  //final int? id;
  final DateTime date;
  final String incomingNumber;
  final String body;
  final String timeStamp;
  final bool? hasConfirmed;
  final String? reason;
 // DateTime get  formattedTimestamp => DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp),isUtc: true);

  SmsMessagesList(this.incomingNumber, this.body, this.hasConfirmed, this.reason, this.date, this.timeStamp);

  factory SmsMessagesList.fromJson(Map<String, dynamic> json) => _$SmsMessagesListFromJson(json);

  Map<String, dynamic> toJson() => _$SmsMessagesListToJson(this);
}
