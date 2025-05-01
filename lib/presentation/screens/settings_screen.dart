import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/data/models/language_model.dart';
import 'package:movieapp/presentation/screens/language_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentLanguage = LanguageModel.fromLocale(currentLocale);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          
          // 언어 설정
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr(context)),
            subtitle: Text('${currentLanguage.flag} ${currentLanguage.name}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LanguageScreen())
              );
            },
          ),
          
          const Divider(),
          
          // 앱 정보
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'app_name'.tr(context),
                applicationVersion: 'Ver 1.0.0',
                applicationIcon: Image.asset(
                  'assets/images/app_logo.png',
                  width: 80,
                  height: 80,
                ),
                children: [
                  const Text('TMDB API를 활용한 영화 정보 앱입니다.'),
                  const SizedBox(height: 8),
                  const Text('© 2025 CHLEE'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}