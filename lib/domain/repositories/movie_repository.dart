import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';

abstract class MovieRepository {
  /// 현재 상영중인 영화 가져오기
  Future<MoviesResult> getNowPlayingMovies({int page = 1});
  
  /// 인기 영화 가져오기
  Future<MoviesResult> getPopularMovies({int page = 1});
  
  /// 평점이 높은 영화 가져오기
  Future<MoviesResult> getTopRatedMovies({int page = 1});
  
  /// 개봉 예정인 영화 가져오기
  Future<MoviesResult> getUpcomingMovies({int page = 1});
  
  /// 영화 상세 정보 가져오기
  Future<MovieDetails> getMovieDetails({required int movieId});
  
  /// 영화 검색하기 (새로 추가)
  Future<MoviesResult> searchMovies({required String query, int page = 1});
  
  /// 좋아하는 영화 목록 가져오기 (새로 추가)
  Future<List<int>> getFavoriteMovieIds();
  
  /// 영화를 좋아요에 추가/제거 (새로 추가)
  Future<bool> toggleFavoriteMovie(int movieId);
  
  /// 특정 영화가 좋아요 목록에 있는지 확인 (새로 추가)
  Future<bool> isMovieFavorite(int movieId);
}