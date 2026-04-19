import 'package:json_annotation/json_annotation.dart';
import 'package:van_android_getx/core/services/api/exceptions.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final T? data;
  final int errorCode;
  final String errorMsg;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, String>? headers;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ApiException? error;

  BaseResponse(
      {required this.data,
      required this.errorCode,
      required this.errorMsg,
      this.headers,
      this.error});

// 使用泛型方法的工厂构造方法来创建一个响应实例
  factory BaseResponse.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);

// 使用泛型方法将实例转换为Json
  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
