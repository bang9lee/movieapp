import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/core/utils/dio_interceptor.dart';
import 'package:movieapp/data/models/movie_details_model.dart';
import 'package:movieapp/data/models/movies_result_model.dart';
import 'package:movieapp/data/models/person_model.dart';
import 'package:movieapp/data/models/rating_response_model.dart';
import 'package:movieapp/data/models/review_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  static ApiClient create() {
  final dio = Dio();
  dio.options = BaseOptions(
    receiveTimeout: const Duration(seconds: 30),
    connectTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
    // 토큰 대신 API 키 사용
    queryParameters: {
      'api_key': ApiConstants.apiKey,
    },
    // 헤더에서 Authorization 제거
    // headers: {
    //   'Authorization': 'Bearer ${ApiConstants.readAccessToken}',
    //   'Content-Type': 'application/json;charset=utf-8',
    // },
    baseUrl: ApiConstants.baseUrl,
  );
  
  // 네트워크 로깅 인터셉터 추가 (디버깅용)
  dio.interceptors.add(LoggingInterceptor());
  
  return ApiClient(dio);
}

  // 현재 상영중인 영화 가져오기 (언어 매개변수 수정)
  @GET(ApiConstants.nowPlayingMovies)
  Future<MoviesResultModel> getNowPlayingMovies({
    @Query('page') int page = 1,
    @Query('language') required String language,
  });

  // 인기 영화 가져오기 (언어 매개변수 수정)
  @GET(ApiConstants.popularMovies)
  Future<MoviesResultModel> getPopularMovies({
    @Query('page') int page = 1,
    @Query('language') required String language,
  });

  // 평점이 높은 영화 가져오기 (언어 매개변수 수정)
  @GET(ApiConstants.topRatedMovies)
  Future<MoviesResultModel> getTopRatedMovies({
    @Query('page') int page = 1,
    @Query('language') required String language,
  });

  // 개봉 예정인 영화 가져오기 (언어 매개변수 수정)
  @GET(ApiConstants.upcomingMovies)
  Future<MoviesResultModel> getUpcomingMovies({
    @Query('page') int page = 1,
    @Query('language') required String language,
  });

  // 영화 상세 정보 가져오기 (언어 매개변수 수정)
  @GET("${ApiConstants.movieDetails}{movieId}")
  Future<MovieDetailsModel> getMovieDetails({
    @Path('movieId') required int movieId,
    @Query('language') required String language,
    @Query('append_to_response') String appendToResponse = 'credits,videos,images,reviews,production_companies',
  });
  
  // 영화 검색하기 (언어 매개변수 수정)
  @GET(ApiConstants.searchMovies)
  Future<MoviesResultModel> searchMovies({
    @Query('query') required String query,
    @Query('page') int page = 1,
    @Query('language') required String language,
  });
  
  // 인물 상세 정보 가져오기 (언어 매개변수 수정)
  @GET("${ApiConstants.personDetails}{personId}")
  Future<PersonModel> getPersonDetails({
    @Path('personId') required int personId,
    @Query('language') required String language,
    @Query('append_to_response') String appendToResponse = 'combined_credits,images',
  });
  
  // 영화 리뷰 가져오기 (언어 매개변수 수정)
  @GET("${ApiConstants.movieDetails}{movieId}/reviews")
  Future<ReviewsResultModel> getMovieReviews({
    @Path('movieId') required int movieId,
    @Query('page') int page = 1,
    @Query('language') required String language,
  });
  
  // 게스트 세션 생성하기
  @GET(ApiConstants.createGuestSession)
  Future<GuestSessionResponseModel> createGuestSession();
  
  // 영화 평점 등록하기 (수정됨: 명확한 명명)
  @POST('/movie/{movieId}/rating')
  Future<RatingResponseModel> rateMovie({
    @Path('movieId') required int movieId,
    @Body() required Map<String, dynamic> rating,
    @Query('guest_session_id') required String guestSessionId,
  });
  
  // 영화 평점 삭제하기 (새로 추가)
  @DELETE('/movie/{movieId}/rating')
  Future<RatingResponseModel> deleteRating({
    @Path('movieId') required int movieId,
    @Query('guest_session_id') required String guestSessionId,
  });
}