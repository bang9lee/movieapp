import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/domain/entities/movie.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/presentation/providers/dependency_provider.dart';

// 현재 상영중인 영화 프로바이더
final nowPlayingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getNowPlayingMoviesUseCaseProvider);
  final result = await useCase.execute();
  return result.movies;
});

// 인기 영화 프로바이더
final popularMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getPopularMoviesUseCaseProvider);
  final result = await useCase.execute();
  return result.movies;
});

// 평점 높은 영화 프로바이더
final topRatedMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getTopRatedMoviesUseCaseProvider);
  final result = await useCase.execute();
  return result.movies;
});

// 개봉 예정 영화 프로바이더
final upcomingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getUpcomingMoviesUseCaseProvider);
  final result = await useCase.execute();
  return result.movies;
});

// 영화 상세 정보 프로바이더
final movieDetailsProvider = FutureProvider.family.autoDispose<MovieDetails, int>((ref, movieId) async {
  final useCase = ref.watch(getMovieDetailsUseCaseProvider);
  return await useCase.execute(movieId: movieId);
});