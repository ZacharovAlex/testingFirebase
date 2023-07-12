import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'messages.g.dart';
@JsonSerializable()
@Collection()
class Messages{
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  String? incoming_number;
  String? body;
  String? date;
  String? statusCode;
  bool? status;
  int? timestamp;

}
