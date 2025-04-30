import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/domain/entities/movies_result.dart';

part 'movies_result_model.g.dart';

@JsonSerializable(explicitToJson: true, checked: true)
class MoviesResultModel {
  @JsonKey(name: 'page', defaultValue: 1)
  final int page;
  
  @JsonKey(name: 'results', defaultValue: <MovieModel>[])
  final List<MovieModel> results;
  
  @JsonKey(name: 'total_pages', defaultValue: 1)
  final int totalPages;
  
  @JsonKey(name: 'total_results', defaultValue: 0)
  final int totalResults;

  const MoviesResultModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResultModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MoviesResultModelFromJson(json);
    } catch (e) {
      print('Error parsing MoviesResultModel: $e');
      print('JSON data: $json');
      // 기본값으로 객체 반환
      return const MoviesResultModel(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0,
      );
    }
  }

  Map<String, dynamic> toJson() => _$MoviesResultModelToJson(this);

  MoviesResult toEntity() {
    return MoviesResult(
      page: page,
      movies: results.map((model) => model.toEntity()).toList(),
      totalPages: totalPages,
      totalResults: totalResults,
    );
  }
}