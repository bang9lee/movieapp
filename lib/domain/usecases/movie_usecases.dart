import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/movies_result.dart';
import 'package:movieapp/domain/entities/person.dart';
import 'package:movieapp/domain/entities/review.dart';
import 'package:movieapp/domain/repositories/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository _repository;

  GetNowPlayingMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1, required String language}) {
    return _repository.getNowPlayingMovies(page: page, language: language);
  }
}

class GetPopularMoviesUseCase {
  final MovieRepository _repository;

  GetPopularMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1, required String language}) {
    return _repository.getPopularMovies(page: page, language: language);
  }
}

class GetTopRatedMoviesUseCase {
  final MovieRepository _repository;

  GetTopRatedMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1, required String language}) {
    return _repository.getTopRatedMovies(page: page, language: language);
  }
}

class GetUpcomingMoviesUseCase {
  final MovieRepository _repository;

  GetUpcomingMoviesUseCase(this._repository);

  Future<MoviesResult> execute({int page = 1, required String language}) {
    return _repository.getUpcomingMovies(page: page, language: language);
  }
}

class GetMovieDetailsUseCase {
  final MovieRepository _repository;

  GetMovieDetailsUseCase(this._repository);

  Future<MovieDetails> execute({required int movieId, required String language}) {
    return _repository.getMovieDetails(movieId: movieId, language: language);
  }
}

// 영화 검색 유스케이스
class SearchMoviesUseCase {
  final MovieRepository _repository;

  SearchMoviesUseCase(this._repository);

  Future<MoviesResult> execute({required String query, int page = 1, required String language}) {
    return _repository.searchMovies(query: query, page: page, language: language);
  }
}

// 인물 상세 정보 유스케이스
class GetPersonDetailsUseCase {
  final MovieRepository _repository;

  GetPersonDetailsUseCase(this._repository);

  Future<Person> execute({required int personId, required String language}) {
    return _repository.getPersonDetails(personId: personId, language: language);
  }
}

// 영화 리뷰 가져오기 유스케이스
class GetMovieReviewsUseCase {
  final MovieRepository _repository;

  GetMovieReviewsUseCase(this._repository);

  Future<ReviewsResult> execute({required int movieId, int page = 1, required String language}) {
    return _repository.getMovieReviews(movieId: movieId, page: page, language: language);
  }
}

// 게스트 세션 생성 유스케이스
class CreateGuestSessionUseCase {
  final MovieRepository _repository;

  CreateGuestSessionUseCase(this._repository);

  Future<GuestSessionResponse> execute() {
    return _repository.createGuestSession();
  }
}

// 영화 평점 등록 유스케이스
class RateMovieUseCase {
  final MovieRepository _repository;

  RateMovieUseCase(this._repository);

  Future<bool> execute({
    required int movieId, 
    required double rating, 
    required String guestSessionId
  }) {
    return _repository.rateMovie(
      movieId: movieId, 
      rating: rating, 
      guestSessionId: guestSessionId
    );
  }
}

// 영화 평점 삭제 유스케이스
class DeleteRatingUseCase {
  final MovieRepository _repository;

  DeleteRatingUseCase(this._repository);

  Future<bool> execute({
    required int movieId, 
    required String guestSessionId
  }) {
    return _repository.deleteRating(
      movieId: movieId, 
      guestSessionId: guestSessionId
    );
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