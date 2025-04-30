import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/movie.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/screens/movie_detail_screen.dart';
import 'package:movieapp/presentation/widgets/horizontal_movie_list.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center (child: Text('오늘의 영화')),
        
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Future.wait으로 모든 future를 await 처리
          await Future.wait([
            ref.refresh(nowPlayingMoviesProvider.future),
            ref.refresh(popularMoviesProvider.future),
            ref.refresh(topRatedMoviesProvider.future),
            ref.refresh(upcomingMoviesProvider.future),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 가장 인기있는 영화 (헤더)
              _buildFeaturedMovie(ref, context),
              
              // 현재 상영중인 영화
              nowPlayingMovies.when(
                data: (movies) => HorizontalMovieList(
                  title: '현재 상영중',
                  movies: movies,
                ),
                loading: () => const HorizontalMovieList(
                  title: '현재 상영중',
                  movies: null,
                  isLoading: true,
                ),
                error: (error, stackTrace) => const Center(
                  child: Text('영화를 불러오는데 실패했습니다.'),
                ),
              ),
              
              // 인기 영화
              popularMovies.when(
                data: (movies) => HorizontalMovieList(
                  title: '인기순',
                  movies: movies,
                  showRank: true,
                ),
                loading: () => const HorizontalMovieList(
                  title: '인기순',
                  movies: null,
                  isLoading: true,
                ),
                error: (error, stackTrace) => const Center(
                  child: Text('영화를 불러오는데 실패했습니다.'),
                ),
              ),
              
              // 평점 높은 영화
              topRatedMovies.when(
                data: (movies) => HorizontalMovieList(
                  title: '평점 높은순',
                  movies: movies,
                ),
                loading: () => const HorizontalMovieList(
                  title: '평점 높은순',
                  movies: null,
                  isLoading: true,
                ),
                error: (error, stackTrace) => const Center(
                  child: Text('영화를 불러오는데 실패했습니다.'),
                ),
              ),
              
              // 개봉 예정 영화
              upcomingMovies.when(
                data: (movies) => HorizontalMovieList(
                  title: '개봉예정',
                  movies: movies,
                ),
                loading: () => const HorizontalMovieList(
                  title: '개봉예정',
                  movies: null,
                  isLoading: true,
                ),
                error: (error, stackTrace) => const Center(
                  child: Text('영화를 불러오는데 실패했습니다.'),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedMovie(WidgetRef ref, BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    
    return nowPlayingMovies.when(
      data: (movies) {
        if (movies.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // 첫 번째 영화를 메인 영화로 사용
        final featuredMovie = movies.first;
        return _buildFeaturedMovieCard(context, featuredMovie);
      },
      loading: () => _buildFeaturedMovieLoading(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildFeaturedMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // 영화 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: Utils.getImageUrl(movie.backdropPath ?? movie.posterPath, size: ImageSize.original),
                width: MediaQuery.of(context).size.width - 40,
                height: 250,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    color: Colors.grey[800],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
            
            // 그라데이션 레이어
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // withOpacity를 사용하되 lint 경고 무시
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // 영화 정보
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today, color: Colors.grey[300], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.releaseDate != null ? movie.releaseDate!.substring(0, 4) : '정보 없음',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // "가장 인기있는" 배지
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  // withOpacity를 사용하되 lint 경고 무시
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '가장 인기있는',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMovieLoading() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}