import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/data/models/movie_details_model.dart';
import 'package:movieapp/data/models/movies_result_model.dart';

part 'api_client.g.dart';

// const를 제거하고 일반 RestApi로 변경
@RestApi(baseUrl: "")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  static ApiClient create() {
    final dio = Dio();
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer ${ApiConstants.readAccessToken}',
      },
      baseUrl: ApiConstants.baseUrl, // 여기서 baseUrl 설정
    );
    return ApiClient(dio);
  }

  // 현재 상영중인 영화 가져오기
  @GET(ApiConstants.nowPlayingMovies)
  Future<MoviesResultModel> getNowPlayingMovies({
    @Query('page') int page = 1,
    @Query('language') String language = 'ko-KR',
  });

  // 인기 영화 가져오기
  @GET(ApiConstants.popularMovies)
  Future<MoviesResultModel> getPopularMovies({
    @Query('page') int page = 1,
    @Query('language') String language = 'ko-KR',
  });

  // 평점이 높은 영화 가져오기
  @GET(ApiConstants.topRatedMovies)
  Future<MoviesResultModel> getTopRatedMovies({
    @Query('page') int page = 1,
    @Query('language') String language = 'ko-KR',
  });

  // 개봉 예정인 영화 가져오기
  @GET(ApiConstants.upcomingMovies)
  Future<MoviesResultModel> getUpcomingMovies({
    @Query('page') int page = 1,
    @Query('language') String language = 'ko-KR',
  });

  // 영화 상세 정보 가져오기
  @GET("${ApiConstants.movieDetails}{movieId}")
  Future<MovieDetailsModel> getMovieDetails({
    @Path('movieId') required int movieId,
    @Query('language') String language = 'ko-KR',
    @Query('append_to_response') String appendToResponse = 'credits,videos,images,reviews,production_companies',
  });
  
  // 영화 검색하기 (새로 추가)
  @GET(ApiConstants.searchMovies)
  Future<MoviesResultModel> searchMovies({
    @Query('query') required String query,
    @Query('page') int page = 1,
    @Query('language') String language = 'ko-KR',
  });
}