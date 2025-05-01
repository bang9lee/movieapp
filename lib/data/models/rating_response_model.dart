import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/core/utils/logger_utils.dart';

part 'rating_response_model.g.dart';

@JsonSerializable()
class RatingResponseModel {
  @JsonKey(name: 'status_code', defaultValue: 0)
  final int statusCode;
  
  @JsonKey(name: 'status_message', defaultValue: '')
  final String statusMessage;
  
  @JsonKey(name: 'success', defaultValue: false)
  final bool success;
  
  const RatingResponseModel({
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });
  
  factory RatingResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RatingResponseModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing RatingResponseModel', e);
      
      // 기본값으로 객체 반환
      return RatingResponseModel(
        statusCode: JsonUtils.safeInt(json['status_code'], 0),
        statusMessage: JsonUtils.safeString(json['status_message'], '알 수 없는 오류'),
        success: JsonUtils.safeBool(json['success'], false),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$RatingResponseModelToJson(this);
}