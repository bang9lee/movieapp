import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/movie_details.dart';
import 'package:movieapp/presentation/screens/person_detail_screen.dart';

class CreditsSection extends StatelessWidget {
  final MovieDetails movie;

  const CreditsSection({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    // 추출: 영화 크레딧 정보에서 cast와 crew를 추출
    final credits = movie.credits;
    if (credits == null || (credits.cast.isEmpty && credits.crew.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 출연진 섹션
        if (credits.cast.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'cast'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (credits.cast.length > 10)
                  GestureDetector(
                    onTap: () {
                      // 전체 출연진 보기 화면으로 이동
                      _showAllCredits(context, 'cast'.tr(context), credits.cast);
                    },
                    child: Text(
                      'see_all'.tr(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: credits.cast.length > 10 ? 10 : credits.cast.length,
              itemBuilder: (context, index) {
                final cast = credits.cast[index];
                return _buildCastItem(context, cast);
              },
            ),
          ),
        ],
        
        // 제작진 섹션 (감독, 각본가 등 주요 제작진만 표시)
        if (credits.crew.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'crew'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_getKeyCrewMembers(credits.crew).length > 10)
                  GestureDetector(
                    onTap: () {
                      // 전체 제작진 보기 화면으로 이동
                      _showAllCredits(context, 'crew'.tr(context), _getKeyCrewMembers(credits.crew));
                    },
                    child: Text(
                      'see_all'.tr(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getKeyCrewMembers(credits.crew).length > 10 ? 10 : _getKeyCrewMembers(credits.crew).length,
              itemBuilder: (context, index) {
                final crew = _getKeyCrewMembers(credits.crew)[index];
                return _buildCrewItem(context, crew);
              },
            ),
          ),
        ],
      ],
    );
  }

  // 주요 제작진만 필터링 (감독, 각본가, 제작자 등)
  List<Crew> _getKeyCrewMembers(List<Crew> allCrew) {
    final keyPositions = ['Director', 'Writer', 'Screenplay', 'Producer', 'Executive Producer'];
    
    // 중복 제거를 위한 맵 (같은 사람이 여러 역할을 맡은 경우)
    final Map<int, Crew> keyCrewMap = {};
    
    // 먼저 감독을 추가
    for (final crew in allCrew) {
      if (crew.job == 'Director') {
        keyCrewMap[crew.id] = crew;
      }
    }
    
    // 그 다음 각본가 관련 포지션
    for (final crew in allCrew) {
      if ((crew.job == 'Writer' || crew.job == 'Screenplay') && !keyCrewMap.containsKey(crew.id)) {
        keyCrewMap[crew.id] = crew;
      }
    }
    
    // 그 다음 프로듀서 관련 포지션
    for (final crew in allCrew) {
      if (keyPositions.contains(crew.job) && !keyCrewMap.containsKey(crew.id)) {
        keyCrewMap[crew.id] = crew;
      }
    }
    
    // 모든 제작진 반환 (상위 10명만 보여주는건 UI에서 처리)
    return keyCrewMap.values.toList();
  }

  Widget _buildCastItem(BuildContext context, Cast cast) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailScreen(personId: cast.id),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 출연자 프로필 사진
            CircleAvatar(
              radius: 35,
              backgroundImage: cast.profilePath != null
                ? CachedNetworkImageProvider(
                    Utils.getImageUrl(cast.profilePath, size: ImageSize.w300)
                  )
                : null,
              backgroundColor: Colors.grey[800],
              child: cast.profilePath == null 
                ? const Icon(Icons.person, size: 30, color: Colors.white) 
                : null,
            ),
            const SizedBox(height: 8),
            // 배우 이름
            Text(
              cast.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            // 역할 이름
            Text(
              cast.character ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrewItem(BuildContext context, Crew crew) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailScreen(personId: crew.id),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 제작진 프로필 사진
            CircleAvatar(
              radius: 35,
              backgroundImage: crew.profilePath != null
                ? CachedNetworkImageProvider(
                    Utils.getImageUrl(crew.profilePath, size: ImageSize.w300)
                  )
                : null,
              backgroundColor: Colors.grey[800],
              child: crew.profilePath == null 
                ? const Icon(Icons.person, size: 30, color: Colors.white) 
                : null,
            ),
            const SizedBox(height: 8),
            // 제작진 이름
            Text(
              crew.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            // 직책
            Text(
              crew.job ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 전체 출연진/제작진 보기
  void _showAllCredits(BuildContext context, String title, List<dynamic> credits) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${credits.length})',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: credits.length,
                    itemBuilder: (context, index) {
                      final dynamic item = credits[index];
                      // Cast와 Crew를 타입에 따라 다르게 표시
                      if (item is Cast) {
                        return _buildCreditsListItem(
                          context,
                          name: item.name,
                          profilePath: item.profilePath,
                          role: item.character ?? '',
                          personId: item.id,
                        );
                      } else if (item is Crew) {
                        return _buildCreditsListItem(
                          context,
                          name: item.name,
                          profilePath: item.profilePath,
                          role: item.job ?? '',
                          personId: item.id,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  // 전체 보기에서 사용할 리스트 아이템
  Widget _buildCreditsListItem(
    BuildContext context, {
    required String name,
    required String? profilePath,
    required String role,
    required int personId,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: profilePath != null
          ? CachedNetworkImageProvider(Utils.getImageUrl(profilePath, size: ImageSize.w300))
          : null,
        backgroundColor: Colors.grey[800],
        child: profilePath == null 
          ? const Icon(Icons.person, size: 25, color: Colors.white) 
          : null,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        role,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[400],
        ),
      ),
      onTap: () {
        Navigator.pop(context); // 바텀 시트 닫기
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailScreen(personId: personId),
          ),
        );
      },
    );
  }
}