import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/theme/app_theme.dart';
import 'package:movieapp/presentation/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// YoutubePlayerIframe 초기화 방식이 변경되어 더 이상 초기화가 필요하지 않습니다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // .env 파일 로드
  await dotenv.load();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // 디폴트를 다크모드로 설정
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // 항상 다크모드 사용
      home: const HomeScreen(),
    );
  }
}