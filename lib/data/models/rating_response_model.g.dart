// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponseModel _$RatingResponseModelFromJson(Map<String, dynamic> json) =>
    RatingResponseModel(
      statusCode: (json['status_code'] as num?)?.toInt() ?? 0,
      statusMessage: json['status_message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );

Map<String, dynamic> _$RatingResponseModelToJson(
        RatingResponseModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
      'success': instance.success,
    };
