
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';


@Freezed(genericArgumentFactories: true)
//@JsonSerializable(genericArgumentFactories: true)
class MyBaseResponse<T> with _$MyBaseResponse<T> {

 factory MyBaseResponse({@JsonKey(name: 'status')required int status,String? description}) = _BaseResponse;

 factory MyBaseResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$MyBaseResponseFromJson(json,fromJsonT);

}