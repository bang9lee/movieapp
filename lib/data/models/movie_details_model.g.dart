// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsModel _$MovieDetailsModelFromJson(Map<String, dynamic> json) =>
    MovieDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String? ?? '',
      releaseDate: json['release_date'] as String?,
      voteAverage: MovieDetailsModel._doubleFromJson(json['vote_average']),
      voteCount: MovieDetailsModel._intFromJson(json['vote_count']),
      popularity: MovieDetailsModel._doubleFromJson(json['popularity']),
      runtime: MovieDetailsModel._intFromJson(json['runtime']),
      budget: MovieDetailsModel._intFromJson(json['budget']),
      revenue: MovieDetailsModel._intFromJson(json['revenue']),
      tagline: json['tagline'] as String?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) =>
                  ProductionCompanyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      videos: json['videos'] == null
          ? null
          : VideoResultModel.fromJson(json['videos'] as Map<String, dynamic>),
      credits: json['credits'] == null
          ? null
          : CreditsModel.fromJson(json['credits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieDetailsModelToJson(MovieDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'runtime': instance.runtime,
      'budget': instance.budget,
      'revenue': instance.revenue,
      'tagline': instance.tagline,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'production_companies':
          instance.productionCompanies.map((e) => e.toJson()).toList(),
      'videos': instance.videos?.toJson(),
      'credits': instance.credits?.toJson(),
    };

CreditsModel _$CreditsModelFromJson(Map<String, dynamic> json) => CreditsModel(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => CrewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreditsModelToJson(CreditsModel instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };

CastModel _$CastModelFromJson(Map<String, dynamic> json) => CastModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CastModelToJson(CastModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'character': instance.character,
      'order': instance.order,
    };

CrewModel _$CrewModelFromJson(Map<String, dynamic> json) => CrewModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
    );

Map<String, dynamic> _$CrewModelToJson(CrewModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'department': instance.department,
      'job': instance.job,
    };

GenreModel _$GenreModelFromJson(Map<String, dynamic> json) => GenreModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$GenreModelToJson(GenreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductionCompanyModel _$ProductionCompanyModelFromJson(
        Map<String, dynamic> json) =>
    ProductionCompanyModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      logoPath: json['logo_path'] as String?,
      originCountry: json['origin_country'] as String?,
    );

Map<String, dynamic> _$ProductionCompanyModelToJson(
        ProductionCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo_path': instance.logoPath,
      'origin_country': instance.originCountry,
    };
