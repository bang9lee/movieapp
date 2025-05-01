// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['id'] as String? ?? '',
      author: json['author'] as String? ?? '',
      authorDetails: json['author_details'] == null
          ? null
          : AuthorDetailsModel.fromJson(
              json['author_details'] as Map<String, dynamic>),
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_details': instance.authorDetails,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

AuthorDetailsModel _$AuthorDetailsModelFromJson(Map<String, dynamic> json) =>
    AuthorDetailsModel(
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      avatarPath: json['avatar_path'] as String?,
      rating: AuthorDetailsModel._doubleFromJson(json['rating']),
    );

Map<String, dynamic> _$AuthorDetailsModelToJson(AuthorDetailsModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'avatar_path': instance.avatarPath,
      'rating': instance.rating,
    };

ReviewsResultModel _$ReviewsResultModelFromJson(Map<String, dynamic> json) =>
    ReviewsResultModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReviewsResultModelToJson(ReviewsResultModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

GuestSessionResponseModel _$GuestSessionResponseModelFromJson(
        Map<String, dynamic> json) =>
    GuestSessionResponseModel(
      success: json['success'] as bool? ?? false,
      guestSessionId: json['guest_session_id'] as String? ?? '',
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$GuestSessionResponseModelToJson(
        GuestSessionResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'guest_session_id': instance.guestSessionId,
      'expires_at': instance.expiresAt,
    };
