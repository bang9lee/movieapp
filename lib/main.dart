import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/core/theme/app_theme.dart';
import 'package:movieapp/presentation/screens/splash_screen.dart'; // 기존 스플래시 화면 사용
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// 로거 설정
final _logger = Logger('MovieApp');

void main() async {
  // 로거 초기화
  _setupLogging();
  
  // Flutter 엔진 초기화 및 스플래시 화면 유지
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 시스템 UI 설정 (스플래시 화면에서 상태 표시줄, 네비게이션 바 처리)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  try {
    // .env 파일 로드
    await dotenv.load();
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // 언어 설정을 위한 박스 오픈
    await Hive.openBox('settings');
  } catch (e) {
    // 로깅 프레임워크를 사용하여 오류 기록
    _logger.severe('앱 초기화 오류: $e');
  }
  
  // 앱 초기화가 완료되면 스플래시 제거
  FlutterNativeSplash.remove();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 로깅 설정 함수
void _setupLogging() {
  Logger.root.level = Level.ALL; // 모든 로그 레벨 표시
  Logger.root.onRecord.listen((record) {
    // 개발 환경에서는 디버그 콘솔에 로그 출력
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    
    // 심각한 오류는 추가 처리 가능
    if (record.level >= Level.SEVERE) {
      // 예: 서버에 오류 보고, 사용자에게 알림 등
    }
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 설정된 로케일 가져오기
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // 디폴트를 다크모드로 설정
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // 항상 다크모드 사용
      
      // 다국어 지원 설정
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
        Locale('ja', 'JP'), // 일본어
        Locale('zh', 'CN'), // 중국어
      ],
      
      // 기존 스플래시 화면 사용
      home: const SplashScreen(),
    );
  }
}