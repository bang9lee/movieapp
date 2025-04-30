import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/data/models/video_model.dart';
import 'package:movieapp/domain/entities/movie_details.dart';

part 'movie_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetailsModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'overview', defaultValue: '')
  final String overview;
  
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @JsonKey(name: 'vote_average', fromJson: _doubleFromJson)
  final double voteAverage;
  
  @JsonKey(name: 'vote_count', fromJson: _intFromJson)
  final int voteCount;
  
  @JsonKey(name: 'popularity', fromJson: _doubleFromJson)
  final double popularity;

  @JsonKey(name: 'runtime', fromJson: _intFromJson)
  final int runtime;
  
  @JsonKey(name: 'budget', fromJson: _intFromJson)
  final int budget;
  
  @JsonKey(name: 'revenue', fromJson: _intFromJson)
  final int revenue;
  
  @JsonKey(name: 'tagline')
  final String? tagline;
  
  @JsonKey(name: 'genres', defaultValue: <GenreModel>[])
  final List<GenreModel> genres;
  
  @JsonKey(name: 'production_companies', defaultValue: <ProductionCompanyModel>[])
  final List<ProductionCompanyModel> productionCompanies;
  
  @JsonKey(name: 'videos')
  final VideoResultModel? videos;

  static double _doubleFromJson(dynamic value) => JsonUtils.safeDouble(value);
  static int _intFromJson(dynamic value) => JsonUtils.safeInt(value);

  const MovieDetailsModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.runtime,
    required this.budget,
    required this.revenue,
    this.tagline,
    required this.genres,
    required this.productionCompanies,
    this.videos,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MovieDetailsModelFromJson(json);
    } catch (e) {
      print('Error parsing MovieDetailsModel: $e');
      print('JSON data: $json');
      
      // 기본 비디오 객체
      VideoResultModel? videosModel;
      if (json['videos'] != null) {
        try {
          videosModel = VideoResultModel.fromJson(json['videos'] as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing videos: $e');
        }
      }
      
      // 기본 genres 리스트
      List<GenreModel> genresList = [];
      if (json['genres'] != null && json['genres'] is List) {
        try {
          genresList = (json['genres'] as List)
            .map((genreJson) => GenreModel.fromJson(genreJson as Map<String, dynamic>))
            .toList();
        } catch (e) {
          print('Error parsing genres: $e');
        }
      }
      
      // 기본 production_companies 리스트
      List<ProductionCompanyModel> companiesList = [];
      if (json['production_companies'] != null && json['production_companies'] is List) {
        try {
          companiesList = (json['production_companies'] as List)
            .map((companyJson) => ProductionCompanyModel.fromJson(companyJson as Map<String, dynamic>))
            .toList();
        } catch (e) {
          print('Error parsing production_companies: $e');
        }
      }
      
      // 예외 발생 시 기본 값으로 객체 반환
      return MovieDetailsModel(
        id: JsonUtils.safeInt(json['id'], 0),
        title: JsonUtils.safeString(json['title'], '제목 없음'),
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        overview: JsonUtils.safeString(json['overview'], '내용 없음'),
        releaseDate: json['release_date'] as String?,
        voteAverage: JsonUtils.safeDouble(json['vote_average'], 0.0),
        voteCount: JsonUtils.safeInt(json['vote_count'], 0),
        popularity: JsonUtils.safeDouble(json['popularity'], 0.0),
        runtime: JsonUtils.safeInt(json['runtime'], 0),
        budget: JsonUtils.safeInt(json['budget'], 0),
        revenue: JsonUtils.safeInt(json['revenue'], 0),
        tagline: json['tagline'] as String?,
        genres: genresList,
        productionCompanies: companiesList,
        videos: videosModel,
      );
    }
  }

  Map<String, dynamic> toJson() => _$MovieDetailsModelToJson(this);

  MovieDetails toEntity() {
    return MovieDetails(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      popularity: popularity,
      runtime: runtime,
      budget: budget,
      revenue: revenue,
      tagline: tagline,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      productionCompanies: productionCompanies.map((company) => company.toEntity()).toList(),
      videos: videos?.toEntity(),
    );
  }
}

@JsonSerializable()
class GenreModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$GenreModelFromJson(json);
    } catch (e) {
      print('Error parsing GenreModel: $e');
      // 기본값으로 객체 반환
      return GenreModel(
        id: JsonUtils.safeInt(json['id'], 0),
        name: JsonUtils.safeString(json['name'], '알 수 없음'),
      );
    }
  }

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  Genre toEntity() {
    return Genre(
      id: id,
      name: name,
    );
  }
}

@JsonSerializable()
class ProductionCompanyModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  
  @JsonKey(name: 'origin_country')
  final String? originCountry;

  const ProductionCompanyModel({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ProductionCompanyModelFromJson(json);
    } catch (e) {
      print('Error parsing ProductionCompanyModel: $e');
      // 기본값으로 객체 반환
      return ProductionCompanyModel(
        id: JsonUtils.safeInt(json['id'], 0),
        name: JsonUtils.safeString(json['name'], '알 수 없음'),
        logoPath: json['logo_path'] as String?,
        originCountry: json['origin_country'] as String?,
      );
    }
  }

  Map<String, dynamic> toJson() => _$ProductionCompanyModelToJson(this);

  ProductionCompany toEntity() {
    return ProductionCompany(
      id: id,
      name: name,
      logoPath: logoPath,
      originCountry: originCountry,
    );
  }
}