import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/data/models/language_model.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';

// 현재 보고 있는 영화 ID를 추적하기 위한 Provider
final currentMovieIdProvider = StateProvider<int?>((ref) => null);

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('language'.tr(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: LanguageModel.supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = LanguageModel.supportedLanguages[index];
          final isSelected = language.languageCode == currentLocale.languageCode;
          
          return ListTile(
            leading: Text(
              language.flag,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              language.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected 
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              // 이전 로케일 저장
              final oldLocale = currentLocale;
              
              // 언어 변경
              ref.read(localeProvider.notifier).setLocale(language.toLocale());
              
              // 데이터 새로고침 (언어 변경 시 모든 데이터 다시 로드)
              if (oldLocale != language.toLocale()) {
                ref.invalidate(nowPlayingMoviesProvider);
                ref.invalidate(popularMoviesProvider);
                ref.invalidate(topRatedMoviesProvider);
                ref.invalidate(upcomingMoviesProvider);
                
                // 현재 보고있는 영화가 있다면 해당 상세 정보도 갱신
                final currentMovieId = ref.read(currentMovieIdProvider);
                if (currentMovieId != null) {
                  ref.invalidate(movieDetailsProvider(currentMovieId));
                  
                  // 리뷰도 갱신
                  ref.invalidate(movieReviewsProvider(currentMovieId));
                }
                
                // 인물 정보도 갱신
                final currentPersonId = ref.read(currentPersonIdProvider.notifier).state;
                if (currentPersonId != null) {
                  ref.invalidate(personDetailsProvider(currentPersonId));
                }
              }
              
              // 이전 화면으로 돌아가기
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

// 현재 보고 있는 인물 ID를 추적하기 위한 Provider
final currentPersonIdProvider = StateProvider<int?>((ref) => null);