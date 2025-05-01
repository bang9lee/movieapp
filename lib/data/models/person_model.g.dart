// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => PersonModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      biography: json['biography'] as String? ?? '',
      placeOfBirth: json['place_of_birth'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      popularity: PersonModel._doubleFromJson(json['popularity']),
      knownForDepartment: json['known_for_department'] as String?,
      combinedCredits: json['combined_credits'] == null
          ? null
          : CombinedCreditsModel.fromJson(
              json['combined_credits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'biography': instance.biography,
      'place_of_birth': instance.placeOfBirth,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'popularity': instance.popularity,
      'known_for_department': instance.knownForDepartment,
      'combined_credits': instance.combinedCredits?.toJson(),
    };

CombinedCreditsModel _$CombinedCreditsModelFromJson(
        Map<String, dynamic> json) =>
    CombinedCreditsModel(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => CastCreditModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => CrewCreditModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CombinedCreditsModelToJson(
        CombinedCreditsModel instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };

CastCreditModel _$CastCreditModelFromJson(Map<String, dynamic> json) =>
    CastCreditModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      character: json['character'] as String? ?? '',
      popularity: CastCreditModel._doubleFromJson(json['popularity']),
      voteAverage: CastCreditModel._doubleFromJson(json['vote_average']),
    );

Map<String, dynamic> _$CastCreditModelToJson(CastCreditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'character': instance.character,
      'popularity': instance.popularity,
      'vote_average': instance.voteAverage,
    };

CrewCreditModel _$CrewCreditModelFromJson(Map<String, dynamic> json) =>
    CrewCreditModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
      popularity: CrewCreditModel._doubleFromJson(json['popularity']),
      voteAverage: CrewCreditModel._doubleFromJson(json['vote_average']),
    );

Map<String, dynamic> _$CrewCreditModelToJson(CrewCreditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'department': instance.department,
      'job': instance.job,
      'popularity': instance.popularity,
      'vote_average': instance.voteAverage,
    };
