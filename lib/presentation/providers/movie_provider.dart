import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/core/utils/session_manager.dart';
import 'package:movieapp/domain/entities/movie.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/person.dart';
import 'package:movieapp/domain/entities/review.dart';
import 'package:movieapp/presentation/providers/dependency_provider.dart';

// 현재 상영중인 영화 프로바이더
final nowPlayingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getNowPlayingMoviesUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  final result = await useCase.execute(language: language);
  return result.movies;
});

// 인기 영화 프로바이더
final popularMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getPopularMoviesUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  final result = await useCase.execute(language: language);
  return result.movies;
});

// 평점 높은 영화 프로바이더
final topRatedMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getTopRatedMoviesUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  final result = await useCase.execute(language: language);
  return result.movies;
});

// 개봉 예정 영화 프로바이더
final upcomingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(getUpcomingMoviesUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  final result = await useCase.execute(language: language);
  return result.movies;
});

// 영화 상세 정보 프로바이더
final movieDetailsProvider = FutureProvider.family.autoDispose<MovieDetails, int>((ref, movieId) async {
  final useCase = ref.watch(getMovieDetailsUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  return await useCase.execute(movieId: movieId, language: language);
});

// 인물 상세 정보 프로바이더
final personDetailsProvider = FutureProvider.family.autoDispose<Person, int>((ref, personId) async {
  final useCase = ref.watch(getPersonDetailsUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  return await useCase.execute(personId: personId, language: language);
});

// 영화 리뷰 프로바이더
final movieReviewsProvider = FutureProvider.family.autoDispose<ReviewsResult, int>((ref, movieId) async {
  final useCase = ref.watch(getMovieReviewsUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  return await useCase.execute(movieId: movieId, language: language);
});

// 로컬 리뷰 프로바이더 (추가)
final localReviewsProvider = FutureProvider.family.autoDispose<List<Review>, int>((ref, movieId) async {
  return await SessionManager.getLocalReviews(movieId);
});

// 전체 리뷰 프로바이더 (서버 + 로컬)
final allReviewsProvider = FutureProvider.family.autoDispose<List<Review>, int>((ref, movieId) async {
  final serverReviews = await ref.watch(movieReviewsProvider(movieId).future);
  final localReviews = await ref.watch(localReviewsProvider(movieId).future);
  
  // 서버 리뷰와 로컬 리뷰 합치기
  return [...localReviews, ...serverReviews.reviews];
});

// 게스트 세션 관리 Provider (리팩토링)
final guestSessionProvider = FutureProvider<GuestSessionResponse?>((ref) async {
  try {
    // 저장된 세션 확인
    final savedSessionId = await SessionManager.getGuestSessionId();
    
    if (savedSessionId != null) {
      Logger.log('저장된 게스트 세션을 사용합니다: $savedSessionId');
      // 간단한 응답 객체 생성하여 반환
      return GuestSessionResponse(
        success: true,
        guestSessionId: savedSessionId,
        expiresAt: DateTime.now().add(const Duration(hours: 24)), // 임의로 24시간 후 만료로 설정
      );
    }
    
    // 새 세션 생성
    final useCase = ref.watch(createGuestSessionUseCaseProvider);
    final session = await useCase.execute();
    
    // 세션 저장
    await SessionManager.saveGuestSession(session);
    Logger.log('새 게스트 세션이 생성되었습니다: ${session.guestSessionId}');
    
    return session;
  } catch (e) {
    Logger.error('게스트 세션 생성 오류', e);
    return null;
  }
});

// 평점 등록 Provider
final rateMovieProvider = FutureProvider.family.autoDispose<bool, RatingParams>((ref, params) async {
  final useCase = ref.watch(rateMovieUseCaseProvider);
  
  // 게스트 세션 가져오기
  final sessionAsync = await ref.watch(guestSessionProvider.future);
  if (sessionAsync == null) {
    throw Exception("게스트 세션을 생성할 수 없습니다");
  }
  
  return await useCase.execute(
    movieId: params.movieId,
    rating: params.rating,
    guestSessionId: sessionAsync.guestSessionId,
  );
});

// 평점 삭제 Provider (추가)
final deleteRatingProvider = FutureProvider.family.autoDispose<bool, int>((ref, movieId) async {
  final useCase = ref.watch(deleteRatingUseCaseProvider);
  
  // 게스트 세션 가져오기
  final sessionAsync = await ref.watch(guestSessionProvider.future);
  if (sessionAsync == null) {
    throw Exception("게스트 세션을 생성할 수 없습니다");
  }
  
  return await useCase.execute(
    movieId: movieId,
    guestSessionId: sessionAsync.guestSessionId,
  );
});

// 평점 매개변수 클래스
class RatingParams {
  final int movieId;
  final double rating;
  
  RatingParams({required this.movieId, required this.rating});
}

// 검색 쿼리 상태 프로바이더
final searchQueryProvider = StateProvider<String>((ref) => '');

// 영화 검색 결과 프로바이더
final searchResultsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final useCase = ref.watch(searchMoviesUseCaseProvider);
  final query = ref.watch(searchQueryProvider);
  final language = ref.watch(localeProvider.notifier).languageTag;
  
  // 쿼리가 비어있으면 빈 결과 반환
  if (query.trim().isEmpty) {
    return [];
  }
  
  final result = await useCase.execute(query: query, language: language);
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

// 임시 리뷰 저장 프로바이더 (기본값은 빈 리스트)
final tempReviewsProvider = StateProvider.family<List<Review>, int>((ref, movieId) => []);

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