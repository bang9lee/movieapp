import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/domain/entities/review.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;
  
  @JsonKey(name: 'author', defaultValue: '')
  final String author;
  
  @JsonKey(name: 'author_details')
  final AuthorDetailsModel? authorDetails;
  
  @JsonKey(name: 'content', defaultValue: '')
  final String content;
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  
  const ReviewModel({
    required this.id,
    required this.author,
    this.authorDetails,
    required this.content,
    this.createdAt,
  });
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ReviewModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing ReviewModel', e);
      
      // 저자 정보 모델 생성 시도
      AuthorDetailsModel? authorDetailsModel;
      if (json['author_details'] != null) {
        try {
          authorDetailsModel = AuthorDetailsModel.fromJson(json['author_details'] as Map<String, dynamic>);
        } catch (e) {
          Logger.error('Error parsing author_details', e);
        }
      }
      
      // 기본값으로 객체 반환
      return ReviewModel(
        id: JsonUtils.safeString(json['id'], ''),
        author: JsonUtils.safeString(json['author'], '익명'),
        authorDetails: authorDetailsModel,
        content: JsonUtils.safeString(json['content'], ''),
        createdAt: json['created_at'] as String?,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
  
  Review toEntity() {
    DateTime? createDate;
    if (createdAt != null && createdAt!.isNotEmpty) {
      try {
        createDate = DateTime.parse(createdAt!);
      } catch (e) {
        Logger.error('Error parsing date', e);
      }
    }
    
    return Review(
      id: id,
      author: author,
      authorUsername: authorDetails?.username,
      avatarPath: authorDetails?.avatarPath,
      content: content,
      createdAt: createDate,
      rating: authorDetails?.rating,
    );
  }
}

@JsonSerializable()
class AuthorDetailsModel {
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'username', defaultValue: '')
  final String username;
  
  @JsonKey(name: 'avatar_path')
  final String? avatarPath;
  
  @JsonKey(name: 'rating', fromJson: _doubleFromJson)
  final double? rating;
  
  static double? _doubleFromJson(dynamic value) {
    if (value == null) return null;
    return JsonUtils.safeDouble(value);
  }
  
  const AuthorDetailsModel({
    required this.name,
    required this.username,
    this.avatarPath,
    this.rating,
  });
  
  factory AuthorDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$AuthorDetailsModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing AuthorDetailsModel', e);
      
      // 기본값으로 객체 반환
      return AuthorDetailsModel(
        name: JsonUtils.safeString(json['name'], ''),
        username: JsonUtils.safeString(json['username'], ''),
        avatarPath: json['avatar_path'] as String?,
        rating: json['rating'] != null ? JsonUtils.safeDouble(json['rating']) : null,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$AuthorDetailsModelToJson(this);
}

@JsonSerializable()
class ReviewsResultModel {
  @JsonKey(name: 'page', defaultValue: 1)
  final int page;
  
  @JsonKey(name: 'results', defaultValue: <ReviewModel>[])
  final List<ReviewModel> results;
  
  @JsonKey(name: 'total_pages', defaultValue: 1)
  final int totalPages;
  
  @JsonKey(name: 'total_results', defaultValue: 0)
  final int totalResults;
  
  const ReviewsResultModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
  
  factory ReviewsResultModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ReviewsResultModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing ReviewsResultModel', e);
      
      // 기본값으로 객체 반환
      return const ReviewsResultModel(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$ReviewsResultModelToJson(this);
  
  ReviewsResult toEntity() {
    return ReviewsResult(
      page: page,
      reviews: results.map((model) => model.toEntity()).toList(),
      totalPages: totalPages,
      totalResults: totalResults,
    );
  }
}

@JsonSerializable()
class GuestSessionResponseModel {
  @JsonKey(name: 'success', defaultValue: false)
  final bool success;
  
  @JsonKey(name: 'guest_session_id', defaultValue: '')
  final String guestSessionId;
  
  @JsonKey(name: 'expires_at')
  final String? expiresAt;
  
  const GuestSessionResponseModel({
    required this.success,
    required this.guestSessionId,
    this.expiresAt,
  });
  
  factory GuestSessionResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$GuestSessionResponseModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing GuestSessionResponseModel', e);
      
      // 기본값으로 객체 반환
      return GuestSessionResponseModel(
        success: JsonUtils.safeBool(json['success'], false),
        guestSessionId: JsonUtils.safeString(json['guest_session_id'], ''),
        expiresAt: json['expires_at'] as String?,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$GuestSessionResponseModelToJson(this);
  
  GuestSessionResponse toEntity() {
    DateTime expiryDate = DateTime.now().add(const Duration(hours: 1)); // 기본 만료시간
    if (expiresAt != null && expiresAt!.isNotEmpty) {
      try {
        expiryDate = DateTime.parse(expiresAt!);
      } catch (e) {
        Logger.error('Error parsing expiry date', e);
      }
    }
    
    return GuestSessionResponse(
      success: success,
      guestSessionId: guestSessionId,
      expiresAt: expiryDate,
    );
  }
}