import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/api/api_client.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';
import 'package:movieapp/domain/entities/person.dart';
import 'package:movieapp/domain/entities/review.dart';
import 'package:movieapp/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiClient _apiClient;
  final String _favoriteBoxName = 'favorites';
  
  MovieRepositoryImpl(this._apiClient) {
    _initHive();
  }
  
  // Hive 초기화 (로컬 스토리지)
  Future<void> _initHive() async {
    try {
      if (!Hive.isBoxOpen(_favoriteBoxName)) {
        await Hive.openBox<int>(_favoriteBoxName);
      }
    } catch (e) {
      Logger.error('Hive 초기화 오류', e);
    }
  }

  @override
  Future<MoviesResult> getNowPlayingMovies({int page = 1, required String language}) async {
    final result = await _apiClient.getNowPlayingMovies(page: page, language: language);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getPopularMovies({int page = 1, required String language}) async {
    final result = await _apiClient.getPopularMovies(page: page, language: language);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getTopRatedMovies({int page = 1, required String language}) async {
    final result = await _apiClient.getTopRatedMovies(page: page, language: language);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getUpcomingMovies({int page = 1, required String language}) async {
    final result = await _apiClient.getUpcomingMovies(page: page, language: language);
    return result.toEntity();
  }

  @override
  Future<MovieDetails> getMovieDetails({required int movieId, required String language}) async {
    final result = await _apiClient.getMovieDetails(movieId: movieId, language: language);
    return result.toEntity();
  }
  
  @override
  Future<MoviesResult> searchMovies({required String query, int page = 1, required String language}) async {
    final result = await _apiClient.searchMovies(query: query, page: page, language: language);
    return result.toEntity();
  }
  
  @override
  Future<Person> getPersonDetails({required int personId, required String language}) async {
    final result = await _apiClient.getPersonDetails(personId: personId, language: language);
    return result.toEntity();
  }
  
  @override
  Future<ReviewsResult> getMovieReviews({required int movieId, int page = 1, required String language}) async {
    final result = await _apiClient.getMovieReviews(movieId: movieId, page: page, language: language);
    return result.toEntity();
  }
  
  @override
  Future<GuestSessionResponse> createGuestSession() async {
    final result = await _apiClient.createGuestSession();
    return result.toEntity();
  }
  
  @override
  Future<bool> rateMovie({
    required int movieId, 
    required double rating, 
    required String guestSessionId
  }) async {
    try {
      final response = await _apiClient.rateMovie(
        movieId: movieId, 
        rating: {'value': rating}, 
        guestSessionId: guestSessionId
      );
      Logger.log('평점 등록 응답: ${response.statusMessage}');
      return response.success;
    } catch (e) {
      Logger.error('평점 등록 오류', e);
      return false;
    }
  }
  
  @override
  Future<bool> deleteRating({
    required int movieId,
    required String guestSessionId
  }) async {
    try {
      final response = await _apiClient.deleteRating(
        movieId: movieId,
        guestSessionId: guestSessionId
      );
      return response.success;
    } catch (e) {
      Logger.error('평점 삭제 오류', e);
      return false;
    }
  }
  
  @override
  Future<List<int>> getFavoriteMovieIds() async {
    try {
      final box = await Hive.openBox<int>(_favoriteBoxName);
      return box.values.toList();
    } catch (e) {
      Logger.error('좋아요 목록 가져오기 오류', e);
      return [];
    }
  }
  
  @override
  Future<bool> toggleFavoriteMovie(int movieId) async {
    try {
      final box = await Hive.openBox<int>(_favoriteBoxName);
      
      // 이미 좋아요한 영화인지 확인
      final List<int> favoriteIds = box.values.toList();
      final int existingIndex = favoriteIds.indexOf(movieId);
      
      if (existingIndex >= 0) {
        // 이미 좋아요한 영화라면 제거
        await box.deleteAt(existingIndex);
        return false; // 좋아요 취소됨
      } else {
        // 좋아요 추가
        await box.add(movieId);
        return true; // 좋아요 추가됨
      }
    } catch (e) {
      Logger.error('좋아요 토글 오류', e);
      return false;
    }
  }
  
  @override
  Future<bool> isMovieFavorite(int movieId) async {
    try {
      final box = await Hive.openBox<int>(_favoriteBoxName);
      final List<int> favoriteIds = box.values.toList();
      return favoriteIds.contains(movieId);
    } catch (e) {
      Logger.error('좋아요 확인 오류', e);
      return false;
    }
  }
}