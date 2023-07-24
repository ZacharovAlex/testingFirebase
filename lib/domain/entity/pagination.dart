import 'package:crypto_app/data/response/sms_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Pagination<T> {
  // @PaginationDataConverter()
  final List<T> data;
  final int total;

  Pagination(this.data, this.total);

  factory Pagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$PaginationToJson(this, toJsonT);
}

class PaginationDataConverter extends JsonConverter<Object, dynamic> {
  @override
  Object fromJson(json) {
    if (json is SmsMessagesList) {
      return SmsMessagesList.fromJson(json as Map<String, dynamic>);
    }
    throw 'Unknown type!';
  }

  const PaginationDataConverter();

  @override
  toJson(Object object) {}
}
