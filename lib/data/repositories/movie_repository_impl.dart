import 'package:movieapp/core/api/api_client.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';
import 'package:movieapp/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiClient _apiClient;

  MovieRepositoryImpl(this._apiClient);

  @override
  Future<MoviesResult> getNowPlayingMovies({int page = 1}) async {
    final result = await _apiClient.getNowPlayingMovies(page: page);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getPopularMovies({int page = 1}) async {
    final result = await _apiClient.getPopularMovies(page: page);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getTopRatedMovies({int page = 1}) async {
    final result = await _apiClient.getTopRatedMovies(page: page);
    return result.toEntity();
  }

  @override
  Future<MoviesResult> getUpcomingMovies({int page = 1}) async {
    final result = await _apiClient.getUpcomingMovies(page: page);
    return result.toEntity();
  }

  @override
  Future<MovieDetails> getMovieDetails({required int movieId}) async {
    final result = await _apiClient.getMovieDetails(movieId: movieId);
    return result.toEntity();
  }
}