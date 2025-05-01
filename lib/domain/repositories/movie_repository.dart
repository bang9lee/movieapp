import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';
import 'package:movieapp/domain/entities/person.dart';
import 'package:movieapp/domain/entities/review.dart';

abstract class MovieRepository {
  /// 현재 상영중인 영화 가져오기
  Future<MoviesResult> getNowPlayingMovies({int page = 1, required String language});
  
  /// 인기 영화 가져오기
  Future<MoviesResult> getPopularMovies({int page = 1, required String language});
  
  /// 평점이 높은 영화 가져오기
  Future<MoviesResult> getTopRatedMovies({int page = 1, required String language});
  
  /// 개봉 예정인 영화 가져오기
  Future<MoviesResult> getUpcomingMovies({int page = 1, required String language});
  
  /// 영화 상세 정보 가져오기
  Future<MovieDetails> getMovieDetails({required int movieId, required String language});
  
  /// 영화 검색하기
  Future<MoviesResult> searchMovies({required String query, int page = 1, required String language});
  
  /// 인물 상세 정보 가져오기
  Future<Person> getPersonDetails({required int personId, required String language});
  
  /// 영화 리뷰 가져오기
  Future<ReviewsResult> getMovieReviews({required int movieId, int page = 1, required String language});
  
  /// 게스트 세션 생성하기
  Future<GuestSessionResponse> createGuestSession();
  
  /// 영화 평가하기
  Future<bool> rateMovie({
    required int movieId, 
    required double rating, 
    required String guestSessionId
  });
  
  /// 영화 평점 삭제하기
  Future<bool> deleteRating({
    required int movieId,
    required String guestSessionId
  });
  
  /// 좋아하는 영화 목록 가져오기
  Future<List<int>> getFavoriteMovieIds();
  
  /// 영화를 좋아요에 추가/제거
  Future<bool> toggleFavoriteMovie(int movieId);
  
  /// 특정 영화가 좋아요 목록에 있는지 확인
  Future<bool> isMovieFavorite(int movieId);
}