import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
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
  
  @JsonKey(name: 'genre_ids', defaultValue: <int>[])
  final List<int> genreIds;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.genreIds,
  });

  static double _doubleFromJson(dynamic value) => JsonUtils.safeDouble(value);
  static int _intFromJson(dynamic value) => JsonUtils.safeInt(value);

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MovieModelFromJson(json);
    } catch (e) {
      print('Error parsing MovieModel: $e');
      print('JSON data: $json');
      // 기본값으로 객체 반환
      return MovieModel(
        id: JsonUtils.safeInt(json['id'], 0),
        title: JsonUtils.safeString(json['title'], '제목 없음'),
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        overview: JsonUtils.safeString(json['overview'], '내용 없음'),
        releaseDate: json['release_date'] as String?,
        voteAverage: JsonUtils.safeDouble(json['vote_average'], 0.0),
        voteCount: JsonUtils.safeInt(json['vote_count'], 0),
        popularity: JsonUtils.safeDouble(json['popularity'], 0.0),
        genreIds: JsonUtils.safeList(json['genre_ids'], 
          (item) => JsonUtils.safeInt(item), <int>[]),
      );
    }
  }

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      popularity: popularity,
      genreIds: genreIds,
    );
  }
}