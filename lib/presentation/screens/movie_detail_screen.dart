import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/domain/entities/video.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/widgets/trailer_player.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  Video? _selectedVideo;
  bool _isPlayingTrailer = false;

  void _playTrailer(Video video) {
    setState(() {
      _selectedVideo = video;
      _isPlayingTrailer = true;
    });
  }

  void _closeTrailer() {
    setState(() {
      _isPlayingTrailer = false;
    });
  }

  // 미사용 메서드 제거됨

  @override
  Widget build(BuildContext context) {
    final movieDetails = ref.watch(movieDetailsProvider(widget.movieId));

    return Scaffold(
      // 앱바를 보이게 수정
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true, // 콘텐츠가 앱바 뒤로 확장
      body: Stack(
        children: [
          movieDetails.when(
            data: (details) => _buildDetails(context, details),
            loading: () => _buildLoading(),
            error: (error, stackTrace) => Center(
              child: Text('영화 정보를 불러오는데 실패했습니다: $error'),
            ),
          ),
          
          // 트레일러 재생 오버레이
          if (_isPlayingTrailer && _selectedVideo != null)
            Positioned.fill(
              child: TrailerPlayer(
                video: _selectedVideo!,
                onClose: _closeTrailer,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 24,
              width: 200,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 16,
              width: 150,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 100,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, MovieDetails details) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, details),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // 영화 제목 및 개봉일
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        details.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      Utils.formatDate(details.releaseDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 태그라인
              if (details.tagline != null && details.tagline!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: Text(
                    details.tagline!,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              
              // 트레일러 버튼 - 첫 번째 트레일러가 있는 경우
              if (details.hasTrailer)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final firstTrailer = details.firstTrailer;
                      if (firstTrailer != null) {
                        _playTrailer(firstTrailer);
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('트레일러 보기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              
              // 러닝타임
              if (details.runtime != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        Utils.formatRuntime(details.runtime),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              
              // 장르 카테고리
              if (details.genres.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: details.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          genre.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              
              // 영화 설명
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '영화 설명',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.overview.isNotEmpty ? details.overview : '영화 설명이 없습니다.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 추가 트레일러 및 비디오 섹션
              if (details.allVideos.isNotEmpty && details.allVideos.length > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비디오',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: details.allVideos.length,
                          itemBuilder: (context, index) {
                            final video = details.allVideos[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: TrailerThumbnail(
                                video: video,
                                onTap: () => _playTrailer(video),
                                width: 200,
                                height: 150,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              
              // 영화 통계 정보
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '영화 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 오버플로우 수정: 카드 높이 증가 및 스크롤 방식 개선
              SizedBox(
                height: 140, // 높이 더 증가 (기존 120에서 140으로)
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildStatCard(
                      context,
                      title: '평점',
                      value: details.voteAverage.toStringAsFixed(1),
                      icon: Icons.star,
                      iconColor: Colors.amber,
                      showRating: true,
                      rating: details.voteAverage / 2, // 10점 만점을 5점 만점으로 변환
                      minWidth: 120, // 최소 너비 지정
                    ),
                    _buildStatCard(
                      context,
                      title: '평점 투표수',
                      value: _formatNumber(details.voteCount), // 숫자 형식 변경
                      icon: Icons.how_to_vote,
                      minWidth: 120,
                    ),
                    _buildStatCard(
                      context,
                      title: '인기점수',
                      value: _formatNumber(details.popularity.toInt()), // 숫자 형식 변경
                      icon: Icons.trending_up,
                      iconColor: Colors.green,
                      minWidth: 120,
                    ),
                    _buildStatCard(
                      context,
                      title: '예산',
                      value: Utils.formatMoney(details.budget),
                      icon: Icons.attach_money,
                      minWidth: 120,
                    ),
                    _buildStatCard(
                      context,
                      title: '수익',
                      value: Utils.formatMoney(details.revenue),
                      icon: Icons.timeline,
                      iconColor: details.revenue > details.budget ? Colors.green : Colors.red,
                      minWidth: 120,
                    ),
                  ],
                ),
              ),
              
              // 제작사 정보
              if (details.productionCompanies.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
                      child: Text(
                        '제작사',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: details.productionCompanies.length,
                        itemBuilder: (context, index) {
                          final company = details.productionCompanies[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 120,
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: company.logoPath != null
                                ? CachedNetworkImage(
                                    imageUrl: Utils.getImageUrl(company.logoPath),
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) => Center(
                                      child: Text(
                                        company.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      company.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  // 큰 숫자를 읽기 쉬운 형식으로 변환 (예: 15000 -> 15K, 2500000 -> 2.5M)
  String _formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = Colors.blue,
    bool showRating = false,
    double rating = 0,
    double minWidth = 120, // 최소 너비 추가
  }) {
    return Container(
      width: minWidth,
      constraints: BoxConstraints(minWidth: minWidth),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Flexible(  // Flexible로 감싸서 오버플로우 방지
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,  // 오버플로우시 ...으로 표시
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(  // 여기도 Flexible로 감싸서 오버플로우 방지
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,  // 오버플로우시 ...으로 표시
              textAlign: TextAlign.center,
            ),
          ),
          if (showRating) ...[
            const SizedBox(height: 4),
            RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 12,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
          ],
        ],
      ),
    );
  }
  
  SliverAppBar _buildAppBar(BuildContext context, MovieDetails details) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false, // 자동 뒤로가기 버튼 비활성화 (앱바에서 처리)
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지
            CachedNetworkImage(
              imageUrl: Utils.getImageUrl(details.backdropPath ?? details.posterPath, size: ImageSize.original),
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
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
            
            // 그라데이션 오버레이
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            // 트레일러 재생 버튼 (배경 이미지 위에 있는 버튼)
            if (details.hasTrailer)
              Center(
                child: GestureDetector(
                  onTap: () {
                    final firstTrailer = details.firstTrailer;
                    if (firstTrailer != null) {
                      _playTrailer(firstTrailer);
                    }
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}