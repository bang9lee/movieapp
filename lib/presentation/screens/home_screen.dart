import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/movie.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/screens/movie_detail_screen.dart';
import 'package:movieapp/presentation/widgets/horizontal_movie_list.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_logo.png',
          height: 92,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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
              // 가장 인기있는 영화 (캐러셀 슬라이더로 변경)
              _buildFeaturedMovieCarousel(ref, context),
              
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

  Widget _buildFeaturedMovieCarousel(WidgetRef ref, BuildContext context) {
    final popularMovies = ref.watch(popularMoviesProvider);
    
    return popularMovies.when(
      data: (movies) {
        if (movies.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // 상위 5개 영화만 캐러셀에 표시
        final carouselMovies = movies.take(5).toList();
        
        return Column(
          children: [
            const SizedBox(height: 16),
            // 캐러셀 슬라이더
            SizedBox(
              height: 250,
              child: CarouselSlider(
                controller: _carouselController,
                slideTransform: const CubeTransform(),
                slideIndicator: CircularSlideIndicator(
                  padding: const EdgeInsets.only(bottom: 16),
                  currentIndicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorBackgroundColor: Colors.grey.shade600,
                ),
                unlimitedMode: true,
                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 5),
                autoSliderTransitionTime: const Duration(milliseconds: 800),
                onSlideChanged: (index) {
                  // 여기서 상태 업데이트를 제거하였습니다
                },
                children: carouselMovies.map((movie) => _buildCarouselItem(context, movie)).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => _buildCarouselLoading(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Movie movie) {
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
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 영화 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: Utils.getImageUrl(movie.backdropPath ?? movie.posterPath, size: ImageSize.original),
                width: double.infinity,
                height: double.infinity,
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
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
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

  Widget _buildCarouselLoading() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}