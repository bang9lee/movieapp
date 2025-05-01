import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/presentation/providers/dependency_provider.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/screens/main_screen.dart';
import 'package:movieapp/presentation/screens/movie_detail_screen.dart';
import 'package:movieapp/presentation/widgets/movie_poster.dart';
import 'package:shimmer/shimmer.dart';

// 좋아요한 영화의 상세 정보를 가져오는 프로바이더
final favoriteMoviesProvider = FutureProvider.autoDispose<List<MovieDetails>>((ref) async {
  final favoriteIds = ref.watch(favoriteMovieIdsProvider);
  final movieDetailsUseCase = ref.watch(getMovieDetailsUseCaseProvider);
  final language = ref.watch(localeProvider.notifier).languageTag; // 현재 언어 설정 가져오기
  
  if (favoriteIds.isEmpty) {
    return [];
  }
  
  // 각 영화의 상세 정보를 병렬로 가져옴
  final List<Future<MovieDetails>> futures = [];
  for (final id in favoriteIds) {
    futures.add(movieDetailsUseCase.execute(movieId: id, language: language));
  }
  
  return await Future.wait(futures);
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMoviesAsync = ref.watch(favoriteMoviesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // 탭 인덱스를 홈으로 변경
            ref.read(selectedNavIndexProvider.notifier).state = 0;
          },
        ),
      ),
      body: favoriteMoviesAsync.when(
        data: (movies) {
          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_favorites'.tr(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'favorites_tip'.tr(context),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          MoviePoster(
                            posterPath: movie.posterPath,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                // 빌드 사이클 외부에서 상태 업데이트
                                Future.microtask(() {
                                  ref.read(favoriteMovieIdsProvider.notifier).toggleFavorite(movie.id);
                                    // 추가: 좋아요 상태 관련 Provider 갱신
                                  // ignore: unused_result
                                  ref.refresh(isMovieFavoriteProvider(movie.id));
                                  // 추가: 갱신 후 즉시 목록도 갱신
                                  // ignore: unused_result
                                  ref.refresh(favoriteMoviesProvider);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      movie.releaseDate != null ? movie.releaseDate!.substring(0, 4) : "",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: 9,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 70,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'error_occurred'.tr(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'favorites_error'.tr(context).replaceFirst('{error}', error.toString()),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}