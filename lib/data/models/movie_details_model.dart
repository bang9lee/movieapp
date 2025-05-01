import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
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
  
  @JsonKey(name: 'credits')
  final CreditsModel? credits;

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
    this.credits,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MovieDetailsModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing MovieDetailsModel', e);
      Logger.data('MovieDetailsModel JSON', json);
      
      // 기본 비디오 객체
      VideoResultModel? videosModel;
      if (json['videos'] != null) {
        try {
          videosModel = VideoResultModel.fromJson(json['videos'] as Map<String, dynamic>);
        } catch (e) {
          Logger.error('Error parsing videos', e);
        }
      }
      
      // 기본 크레딧 객체
      CreditsModel? creditsModel;
      if (json['credits'] != null) {
        try {
          creditsModel = CreditsModel.fromJson(json['credits'] as Map<String, dynamic>);
        } catch (e) {
          Logger.error('Error parsing credits', e);
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
          Logger.error('Error parsing genres', e);
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
          Logger.error('Error parsing production_companies', e);
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
        credits: creditsModel,
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
      credits: credits?.toEntity(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreditsModel {
  @JsonKey(name: 'cast', defaultValue: <CastModel>[])
  final List<CastModel> cast;
  
  @JsonKey(name: 'crew', defaultValue: <CrewModel>[])
  final List<CrewModel> crew;
  
  const CreditsModel({
    required this.cast,
    required this.crew,
  });
  
  factory CreditsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CreditsModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CreditsModel', e);
      
      // 기본 cast 리스트
      List<CastModel> castList = [];
      if (json['cast'] != null && json['cast'] is List) {
        try {
          castList = (json['cast'] as List)
            .map((castJson) => CastModel.fromJson(castJson as Map<String, dynamic>))
            .toList();
        } catch (e) {
          Logger.error('Error parsing cast', e);
        }
      }
      
      // 기본 crew 리스트
      List<CrewModel> crewList = [];
      if (json['crew'] != null && json['crew'] is List) {
        try {
          crewList = (json['crew'] as List)
            .map((crewJson) => CrewModel.fromJson(crewJson as Map<String, dynamic>))
            .toList();
        } catch (e) {
          Logger.error('Error parsing crew', e);
        }
      }
      
      // 예외 발생 시 기본 값으로 객체 반환
      return CreditsModel(
        cast: castList,
        crew: crewList,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CreditsModelToJson(this);
  
  Credits toEntity() {
    return Credits(
      cast: cast.map((model) => model.toEntity()).toList(),
      crew: crew.map((model) => model.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class CastModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  
  @JsonKey(name: 'character', defaultValue: '')
  final String character;
  
  @JsonKey(name: 'order', defaultValue: 0)
  final int order;
  
  const CastModel({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
    required this.order,
  });
  
  factory CastModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CastModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CastModel', e);
      
      // 예외 발생 시 기본 값으로 객체 반환
      return CastModel(
        id: JsonUtils.safeInt(json['id'], 0),
        name: JsonUtils.safeString(json['name'], '이름 없음'),
        profilePath: json['profile_path'] as String?,
        character: JsonUtils.safeString(json['character'], ''),
        order: JsonUtils.safeInt(json['order'], 0),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CastModelToJson(this);
  
  Cast toEntity() {
    return Cast(
      id: id,
      name: name,
      profilePath: profilePath,
      character: character,
      order: order,
    );
  }
}

@JsonSerializable()
class CrewModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  
  @JsonKey(name: 'department', defaultValue: '')
  final String department;
  
  @JsonKey(name: 'job', defaultValue: '')
  final String job;
  
  const CrewModel({
    required this.id,
    required this.name,
    this.profilePath,
    required this.department,
    required this.job,
  });
  
  factory CrewModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CrewModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CrewModel', e);
      
      // 예외 발생 시 기본 값으로 객체 반환
      return CrewModel(
        id: JsonUtils.safeInt(json['id'], 0),
        name: JsonUtils.safeString(json['name'], '이름 없음'),
        profilePath: json['profile_path'] as String?,
        department: JsonUtils.safeString(json['department'], ''),
        job: JsonUtils.safeString(json['job'], ''),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CrewModelToJson(this);
  
  Crew toEntity() {
    return Crew(
      id: id,
      name: name,
      profilePath: profilePath,
      department: department,
      job: job,
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
      Logger.error('Error parsing GenreModel', e);
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
      Logger.error('Error parsing ProductionCompanyModel', e);
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