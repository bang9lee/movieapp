import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/person.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/screens/language_screen.dart';
import 'package:movieapp/presentation/screens/movie_detail_screen.dart';
import 'package:movieapp/presentation/widgets/movie_poster.dart';
import 'package:shimmer/shimmer.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  final int personId;

  const PersonDetailScreen({
    super.key,
    required this.personId,
  });

  @override
  ConsumerState<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 현재 보고 있는 인물 ID 설정 (언어 변경 시 데이터 갱신용)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentPersonIdProvider.notifier).state = widget.personId;
    });
  }

  @override
  void dispose() {
    // 현재 보고 있는 인물 ID 초기화
    ref.read(currentPersonIdProvider.notifier).state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personDetails = ref.watch(personDetailsProvider(widget.personId));

    return Scaffold(
      body: personDetails.when(
        data: (person) => _buildPersonDetails(context, person),
        loading: () => _buildLoadingUI(),
        error: (error, stack) => _buildErrorUI(context, error),
      ),
    );
  }

  Widget _buildLoadingUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // AppBar 공간
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 32,
                width: 200,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 16,
                width: 100,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'error_loading'.tr(context),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('retry'.tr(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonDetails(BuildContext context, Person person) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, person),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // 인물 기본 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              if (person.knownForDepartment != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    _getDepartmentName(context, person.knownForDepartment!),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              
              // 인물 핵심 정보 (생년월일, 출생지 등)
              const SizedBox(height: 16),
              _buildInfoSection(context, person),
              
              // 인물 소개
              if (person.biography != null && person.biography!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'biography'.tr(context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        person.biography!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'no_biography'.tr(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              
              // 주요 작품
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'known_for'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTopCredits(context, person),
              
              // 전체 필모그래피
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'filmography'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // 연기 작품
              if (person.actingCredits.isNotEmpty)
                _buildCreditSection(
                  context,
                  'acting'.tr(context),
                  person.actingCredits,
                ),
              
              // 감독 작품
              if (person.directingCredits.isNotEmpty)
                _buildCreditSection(
                  context,
                  'directing'.tr(context),
                  person.directingCredits,
                ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, Person person) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // 공유 기능 (나중에 구현)
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 프로필 이미지
            Hero(
              tag: 'person_profile_${person.id}',
              child: CachedNetworkImage(
                imageUrl: Utils.getImageUrl(person.profilePath),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900]),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.person, size: 50),
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
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Person person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (person.birthday != null)
            _buildInfoRow(
              context,
              'birthday'.tr(context),
              _formatDate(person.birthday!),
            ),
          
          if (person.age != null)
            _buildInfoRow(
              context,
              'age'.tr(context),
              '${person.age} ${person.deathday != null ? '(${'deathday'.tr(context)}: ${_formatDate(person.deathday!)})' : ''}',
            ),
          
          if (person.birthplace != null)
            _buildInfoRow(
              context,
              'birthplace'.tr(context),
              person.birthplace!,
            ),
          
          _buildInfoRow(
            context,
            'popularity'.tr(context),
            person.popularity.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCredits(BuildContext context, Person person) {
    final topCredits = person.topCredits;
    
    if (topCredits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'no_data'.tr(context),
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }
    
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: topCredits.length,
        itemBuilder: (context, index) {
          final credit = topCredits[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movieId: credit.id),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MoviePoster(
                      posterPath: credit.posterPath,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    credit.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    credit.year != null ? credit.year! : 'no_data'.tr(context),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreditSection(BuildContext context, String title, List<PersonCredit> credits) {
    // 연도별로 내림차순 정렬
    final sortedCredits = List<PersonCredit>.from(credits);
    sortedCredits.sort((a, b) {
      if (a.releaseDate == null || a.releaseDate!.isEmpty) {
        return 1; // null 또는 빈 값은 뒤로
      }
      if (b.releaseDate == null || b.releaseDate!.isEmpty) {
        return -1; // null 또는 빈 값은 뒤로
      }
      return b.releaseDate!.compareTo(a.releaseDate!);
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedCredits.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final credit = sortedCredits[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movieId: credit.id),
                  ),
                );
              },
              leading: SizedBox(
                width: 40,
                child: credit.year != null
                    ? Text(
                        credit.year!,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const Text('-'),
              ),
              title: Text(
                credit.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: credit.character != null && credit.character!.isNotEmpty
                  ? Text(
                      '${credit.character} (${credit.department})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    )
                  : credit.job != null
                      ? Text(
                          credit.job!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        )
                      : null,
              trailing: const Icon(Icons.chevron_right),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy년 MM월 dd일').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getDepartmentName(BuildContext context, String department) {
    switch (department) {
      case 'Acting':
        return 'acting'.tr(context);
      case 'Directing':
        return 'directing'.tr(context);
      case 'Writing':
        return 'writing'.tr(context);
      case 'Production':
        return 'production'.tr(context);
      default:
        return department;
    }
  }
}