/// 앱 전반에서 사용할 로깅 유틸리티
class Logger {
  // 개발 모드 여부 (실제 앱에서는 환경 변수나 빌드 설정으로 전환)
  static const bool _isDev = true;
  
  // 일반 로그
  static void log(String message) {
    if (_isDev) {
      // ignore: avoid_print
      print('[LOG] $message');
    }
  }
  
  // 에러 로그
  static void error(String message, [dynamic error]) {
    if (_isDev) {
      // ignore: avoid_print
      print('[ERROR] $message');
      if (error != null) {
        // ignore: avoid_print
        print('[ERROR DETAILS] $error');
      }
    }
  }
  
  // 디버그 로그
  static void debug(String message) {
    if (_isDev) {
      // ignore: avoid_print
      print('[DEBUG] $message');
    }
  }
  
  // 데이터 로깅
  static void data(String tag, dynamic data) {
    if (_isDev) {
      // ignore: avoid_print
      print('[DATA] $tag: $data');
    }
  }
}