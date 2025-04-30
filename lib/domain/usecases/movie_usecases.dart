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