import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/domain/entities/person.dart';

part 'person_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  
  @JsonKey(name: 'biography', defaultValue: '')
  final String biography;
  
  @JsonKey(name: 'place_of_birth')
  final String? placeOfBirth;
  
  @JsonKey(name: 'birthday')
  final String? birthday;
  
  @JsonKey(name: 'deathday')
  final String? deathday;
  
  @JsonKey(name: 'popularity', fromJson: _doubleFromJson)
  final double popularity;
  
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  
  @JsonKey(name: 'combined_credits')
  final CombinedCreditsModel? combinedCredits;
  
  static double _doubleFromJson(dynamic value) => JsonUtils.safeDouble(value);

  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
    required this.biography,
    this.placeOfBirth,
    this.birthday,
    this.deathday,
    required this.popularity,
    this.knownForDepartment,
    this.combinedCredits,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PersonModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing PersonModel', e);
      
      // 베이직 크레딧 모델 생성 시도
      CombinedCreditsModel? creditsModel;
      if (json['combined_credits'] != null) {
        try {
          creditsModel = CombinedCreditsModel.fromJson(json['combined_credits'] as Map<String, dynamic>);
        } catch (e) {
          Logger.error('Error parsing combined_credits', e);
        }
      }
      
      // 기본값으로 객체 반환
      return PersonModel(
        id: JsonUtils.safeInt(json['id'], 0),
        name: JsonUtils.safeString(json['name'], '이름 없음'),
        profilePath: json['profile_path'] as String?,
        biography: JsonUtils.safeString(json['biography'], ''),
        placeOfBirth: json['place_of_birth'] as String?,
        birthday: json['birthday'] as String?,
        deathday: json['deathday'] as String?,
        popularity: JsonUtils.safeDouble(json['popularity'], 0.0),
        knownForDepartment: json['known_for_department'] as String?,
        combinedCredits: creditsModel,
      );
    }
  }

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);

  Person toEntity() {
    final List<PersonCredit> allCredits = [];
    
    // 배우로서의 활동 추가
    if (combinedCredits?.cast != null) {
      allCredits.addAll(combinedCredits!.cast.map((cast) => cast.toEntity()).toList());
    }
    
    // 제작진으로서의 활동 추가
    if (combinedCredits?.crew != null) {
      allCredits.addAll(combinedCredits!.crew.map((crew) => crew.toEntity()).toList());
    }
    
    return Person(
      id: id,
      name: name,
      profilePath: profilePath,
      biography: biography,
      birthplace: placeOfBirth,
      birthday: birthday,
      deathday: deathday,
      popularity: popularity,
      credits: allCredits,
      knownForDepartment: knownForDepartment,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CombinedCreditsModel {
  @JsonKey(name: 'cast', defaultValue: <CastCreditModel>[])
  final List<CastCreditModel> cast;
  
  @JsonKey(name: 'crew', defaultValue: <CrewCreditModel>[])
  final List<CrewCreditModel> crew;
  
  const CombinedCreditsModel({
    required this.cast,
    required this.crew,
  });
  
  factory CombinedCreditsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CombinedCreditsModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CombinedCreditsModel', e);
      
      // 기본값으로 객체 반환
      return const CombinedCreditsModel(
        cast: [],
        crew: [],
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CombinedCreditsModelToJson(this);
}

@JsonSerializable()
class CastCreditModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @JsonKey(name: 'character', defaultValue: '')
  final String character;
  
  @JsonKey(name: 'popularity', fromJson: _doubleFromJson)
  final double popularity;
  
  @JsonKey(name: 'vote_average', fromJson: _doubleFromJson)
  final double voteAverage;
  
  static double _doubleFromJson(dynamic value) => JsonUtils.safeDouble(value);
  
  const CastCreditModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.character,
    required this.popularity,
    required this.voteAverage,
  });
  
  factory CastCreditModel.fromJson(Map<String, dynamic> json) {
    try {
      // 영화 타이틀이 없고 TV 쇼 이름이 있으면 TV 쇼로 처리
      if (json['title'] == null && json['name'] != null) {
        json['title'] = json['name'];
      }
      
      return _$CastCreditModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CastCreditModel', e);
      
      // 기본값으로 객체 반환
      String title = '';
      if (json['title'] != null) {
        title = JsonUtils.safeString(json['title'], '');
      } else if (json['name'] != null) {
        title = JsonUtils.safeString(json['name'], '');
      }
      
      return CastCreditModel(
        id: JsonUtils.safeInt(json['id'], 0),
        title: title,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        releaseDate: json['release_date'] ?? json['first_air_date'] as String?,
        character: JsonUtils.safeString(json['character'], ''),
        popularity: JsonUtils.safeDouble(json['popularity'], 0.0),
        voteAverage: JsonUtils.safeDouble(json['vote_average'], 0.0),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CastCreditModelToJson(this);
  
  PersonCredit toEntity() {
    return PersonCredit(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      character: character,
      department: 'Acting',
      job: null,
      popularity: popularity,
      voteAverage: voteAverage,
    );
  }
}

@JsonSerializable()
class CrewCreditModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @JsonKey(name: 'department', defaultValue: '')
  final String department;
  
  @JsonKey(name: 'job', defaultValue: '')
  final String job;
  
  @JsonKey(name: 'popularity', fromJson: _doubleFromJson)
  final double popularity;
  
  @JsonKey(name: 'vote_average', fromJson: _doubleFromJson)
  final double voteAverage;
  
  static double _doubleFromJson(dynamic value) => JsonUtils.safeDouble(value);
  
  const CrewCreditModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.department,
    required this.job,
    required this.popularity,
    required this.voteAverage,
  });
  
  factory CrewCreditModel.fromJson(Map<String, dynamic> json) {
    try {
      // 영화 타이틀이 없고 TV 쇼 이름이 있으면 TV 쇼로 처리
      if (json['title'] == null && json['name'] != null) {
        json['title'] = json['name'];
      }
      
      return _$CrewCreditModelFromJson(json);
    } catch (e) {
      Logger.error('Error parsing CrewCreditModel', e);
      
      // 기본값으로 객체 반환
      String title = '';
      if (json['title'] != null) {
        title = JsonUtils.safeString(json['title'], '');
      } else if (json['name'] != null) {
        title = JsonUtils.safeString(json['name'], '');
      }
      
      return CrewCreditModel(
        id: JsonUtils.safeInt(json['id'], 0),
        title: title,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        releaseDate: json['release_date'] ?? json['first_air_date'] as String?,
        department: JsonUtils.safeString(json['department'], ''),
        job: JsonUtils.safeString(json['job'], ''),
        popularity: JsonUtils.safeDouble(json['popularity'], 0.0),
        voteAverage: JsonUtils.safeDouble(json['vote_average'], 0.0),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$CrewCreditModelToJson(this);
  
  PersonCredit toEntity() {
    return PersonCredit(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      character: null,
      department: department,
      job: job,
      popularity: popularity,
      voteAverage: voteAverage,
    );
  }
}