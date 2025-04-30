import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/api/api_client.dart';
import 'package:movieapp/data/repositories/movie_repository_impl.dart';
import 'package:movieapp/domain/repositories/movie_repository.dart';
import 'package:movieapp/domain/usecases/movie_usecases.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.create();
});

// Repository Provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MovieRepositoryImpl(apiClient);
});

// Use Cases Providers
final getNowPlayingMoviesUseCaseProvider = Provider<GetNowPlayingMoviesUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetNowPlayingMoviesUseCase(repository);
});

final getPopularMoviesUseCaseProvider = Provider<GetPopularMoviesUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetPopularMoviesUseCase(repository);
});

final getTopRatedMoviesUseCaseProvider = Provider<GetTopRatedMoviesUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetTopRatedMoviesUseCase(repository);
});

final getUpcomingMoviesUseCaseProvider = Provider<GetUpcomingMoviesUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetUpcomingMoviesUseCase(repository);
});

final getMovieDetailsUseCaseProvider = Provider<GetMovieDetailsUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetMovieDetailsUseCase(repository);
});

// 영화 검색 유스케이스 Provider
final searchMoviesUseCaseProvider = Provider<SearchMoviesUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return SearchMoviesUseCase(repository);
});

// 좋아하는 영화 목록 가져오기 유스케이스 Provider
final getFavoriteMovieIdsUseCaseProvider = Provider<GetFavoriteMovieIdsUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return GetFavoriteMovieIdsUseCase(repository);
});

// 영화 좋아요 토글 유스케이스 Provider
final toggleFavoriteMovieUseCaseProvider = Provider<ToggleFavoriteMovieUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return ToggleFavoriteMovieUseCase(repository);
});

// 영화가 좋아요인지 확인하는 유스케이스 Provider
final isMovieFavoriteUseCaseProvider = Provider<IsMovieFavoriteUseCase>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return IsMovieFavoriteUseCase(repository);
});