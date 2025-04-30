import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // .env 파일에서 값 가져오기
  static String get baseUrl => dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get readAccessToken => dotenv.env['TMDB_READ_ACCESS_TOKEN'] ?? '';
  
  // Image URLs
  static String get imageBaseUrl => dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p/';
  static String get originalImageUrl => "${imageBaseUrl}original";
  static String get w500ImageUrl => "${imageBaseUrl}w500";
  static String get w300ImageUrl => "${imageBaseUrl}w300";
  
  // API Endpoints
  static const String nowPlayingMovies = "/movie/now_playing";
  static const String popularMovies = "/movie/popular";
  static const String topRatedMovies = "/movie/top_rated";
  static const String upcomingMovies = "/movie/upcoming";
  static const String movieDetails = "/movie/";
  static const String searchMovies = "/search/movie"; // 검색 엔드포인트 추가
}

class AppConstants {
  static const int moviesPerPage = 20;
}