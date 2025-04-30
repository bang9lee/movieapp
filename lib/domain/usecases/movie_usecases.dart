import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';
import 'package:movieapp/domain/repositories/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository _repository;

  GetNowPlayingMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1}) {
    return _repository.getNowPlayingMovies(page: page);
  }
}

class GetPopularMoviesUseCase {
  final MovieRepository _repository;

  GetPopularMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1}) {
    return _repository.getPopularMovies(page: page);
  }
}

class GetTopRatedMoviesUseCase {
  final MovieRepository _repository;

  GetTopRatedMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1}) {
    return _repository.getTopRatedMovies(page: page);
  }
}

class GetUpcomingMoviesUseCase {
  final MovieRepository _repository;

  GetUpcomingMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1}) {
    return _repository.getUpcomingMovies(page: page);
  }
}

class GetMovieDetailsUseCase {
  final MovieRepository _repository;

  GetMovieDetailsUseCase(this._repository);

  Future<MovieDetails> execute({required int movieId}) {
    return _repository.getMovieDetails(movieId: movieId);
  }
}

// 영화 검색 유스케이스
class SearchMoviesUseCase {
  final MovieRepository _repository;

  SearchMoviesUseCase(this._repository);

  Future<MoviesResult> execute({required String query, int page = 1}) {
    return _repository.searchMovies(query: query, page: page);
  }
}

// 좋아하는 영화 ID 목록 가져오기 유스케이스
class GetFavoriteMovieIdsUseCase {
  final MovieRepository _repository;

  GetFavoriteMovieIdsUseCase(this._repository);

  Future<List<int>> execute() {
    return _repository.getFavoriteMovieIds();
  }
}

// 영화 좋아요 토글 유스케이스
class ToggleFavoriteMovieUseCase {
  final MovieRepository _repository;

  ToggleFavoriteMovieUseCase(this._repository);

  Future<bool> execute(int movieId) {
    return _repository.toggleFavoriteMovie(movieId);
  }
}

// 영화가 좋아요인지 확인하는 유스케이스
class IsMovieFavoriteUseCase {
  final MovieRepository _repository;

  IsMovieFavoriteUseCase(this._repository);

  Future<bool> execute(int movieId) {
    return _repository.isMovieFavorite(movieId);
  }
}