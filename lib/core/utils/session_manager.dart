import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/domain/entities/review.dart';

class SessionManager {
  static const String _sessionBoxName = 'session';
  static const String _guestSessionIdKey = 'guest_session_id';
  static const String _expiresAtKey = 'expires_at';
  
  // 게스트 세션 ID 저장
  static Future<void> saveGuestSession(GuestSessionResponse session) async {
    try {
      final box = await Hive.openBox(_sessionBoxName);
      await box.put(_guestSessionIdKey, session.guestSessionId);
      await box.put(_expiresAtKey, session.expiresAt.toIso8601String());
      Logger.log('게스트 세션이 저장되었습니다: ${session.guestSessionId}');
    } catch (e) {
      Logger.error('게스트 세션 저장 오류', e);
    }
  }
  
  // 게스트 세션 ID 가져오기
  static Future<String?> getGuestSessionId() async {
    try {
      final box = await Hive.openBox(_sessionBoxName);
      final guestSessionId = box.get(_guestSessionIdKey) as String?;
      final expiresAtStr = box.get(_expiresAtKey) as String?;
      
      if (guestSessionId != null && expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        // 만료되지 않았으면 세션 ID 반환
        if (expiresAt.isAfter(DateTime.now())) {
          return guestSessionId;
        }
      }
      return null;
    } catch (e) {
      Logger.error('게스트 세션 ID 가져오기 오류', e);
      return null;
    }
  }
  
  // 게스트 세션 만료 여부 확인
  static Future<bool> isSessionExpired() async {
    try {
      final box = await Hive.openBox(_sessionBoxName);
      final expiresAtStr = box.get(_expiresAtKey) as String?;
      
      if (expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        return expiresAt.isBefore(DateTime.now());
      }
      return true; // 날짜가 없으면 만료된 것으로 간주
    } catch (e) {
      Logger.error('세션 만료 확인 오류', e);
      return true; // 에러 발생 시 만료된 것으로 간주
    }
  }
  
  // 게스트 세션 초기화
  static Future<void> clearSession() async {
    try {
      final box = await Hive.openBox(_sessionBoxName);
      await box.clear();
      Logger.log('게스트 세션이 초기화되었습니다');
    } catch (e) {
      Logger.error('세션 초기화 오류', e);
    }
  }
  
  // 로컬 리뷰 저장 (서버에 저장 실패하거나 테스트용)
  static Future<void> saveLocalReview(int movieId, Review review) async {
    try {
      final box = await Hive.openBox('reviews_$movieId');
      final reviewsList = box.get('local_reviews', defaultValue: <Map<String, dynamic>>[]) as List;
      
      // 리뷰를 Map으로 변환
      final reviewMap = {
        'id': review.id,
        'author': review.author,
        'authorUsername': review.authorUsername,
        'avatarPath': review.avatarPath,
        'content': review.content,
        'createdAt': review.createdAt?.toIso8601String(),
        'rating': review.rating,
      };
      
      // 리스트 맨 앞에 새 리뷰 추가
      reviewsList.insert(0, reviewMap);
      
      // 저장
      await box.put('local_reviews', reviewsList);
      Logger.log('로컬 리뷰가 저장되었습니다: $movieId');
    } catch (e) {
      Logger.error('로컬 리뷰 저장 오류', e);
    }
  }
  
  // 로컬 리뷰 가져오기
  static Future<List<Review>> getLocalReviews(int movieId) async {
    try {
      final box = await Hive.openBox('reviews_$movieId');
      final reviewsList = box.get('local_reviews', defaultValue: <Map<String, dynamic>>[]) as List;
      
      // Map을 Review 객체로 변환
      return reviewsList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return Review(
          id: map['id'] as String,
          author: map['author'] as String,
          authorUsername: map['authorUsername'] as String?,
          avatarPath: map['avatarPath'] as String?,
          content: map['content'] as String,
          createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
          rating: map['rating'] as double?,
        );
      }).toList();
    } catch (e) {
      Logger.error('로컬 리뷰 가져오기 오류', e);
      return [];
    }
  }
}