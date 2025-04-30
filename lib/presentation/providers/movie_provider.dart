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

// 검색 쿼리 상태 프로바이더
final searchQueryProvider = StateProvider<String>((ref) => '');

// 영화 검색 결과 프로바이더
final searchResultsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(searchMoviesUseCaseProvider);
  final query = ref.watch(searchQueryProvider);
  
  // 쿼리가 비어있으면 빈 결과 반환
  if (query.trim().isEmpty) {
    return [];
  }
  
  final result = await useCase.execute(query: query);
  return result.movies;
});

// 검색 상태 프로바이더 (검색 중인지, 결과가 있는지 등)
final searchStateProvider = StateProvider<SearchState>((ref) => SearchState.initial);

// 좋아하는 영화 ID 목록 프로바이더
final favoriteMovieIdsProvider = StateNotifierProvider<FavoriteMoviesNotifier, List<int>>((ref) {
  return FavoriteMoviesNotifier(ref);
});

// 특정 영화가 좋아요인지 확인하는 프로바이더
final isMovieFavoriteProvider = FutureProvider.family<bool, int>((ref, movieId) async {
  final useCase = ref.watch(isMovieFavoriteUseCaseProvider);
  return await useCase.execute(movieId);
});

// 좋아하는 영화 목록 상태 관리 NotifierProvider
class FavoriteMoviesNotifier extends StateNotifier<List<int>> {
  final Ref _ref;
  
  FavoriteMoviesNotifier(this._ref) : super([]) {
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final useCase = _ref.read(getFavoriteMovieIdsUseCaseProvider);
    final favorites = await useCase.execute();
    state = favorites;
  }
  
  Future<bool> toggleFavorite(int movieId) async {
    try {
      final useCase = _ref.read(toggleFavoriteMovieUseCaseProvider);
      final isFavorite = await useCase.execute(movieId);
      
      // 안전하게 상태 업데이트
      final currentState = state;
      if (isFavorite) {
        // 좋아요 추가 (중복되지 않게)
        if (!currentState.contains(movieId)) {
          state = [...currentState, movieId];
        }
      } else {
        // 좋아요 제거
        state = currentState.where((id) => id != movieId).toList();
      }
      
      return isFavorite;
    } catch (e) {
      // 에러 발생 시 상태 갱신 (디버그용)
      await _loadFavorites();
      rethrow;
    }
  }
}

// 검색 상태를 나타내는 enum
enum SearchState {
  initial,    // 초기 상태
  searching,  // 검색 중
  results,    // 결과 있음
  empty,      // 결과 없음
  error       // 오류 발생
}