// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviesResultModel _$MoviesResultModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MoviesResultModel',
      json,
      ($checkedConvert) {
        final val = MoviesResultModel(
          page: $checkedConvert('page', (v) => (v as num?)?.toInt() ?? 1),
          results: $checkedConvert(
              'results',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map(
                          (e) => MovieModel.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  []),
          totalPages:
              $checkedConvert('total_pages', (v) => (v as num?)?.toInt() ?? 1),
          totalResults: $checkedConvert(
              'total_results', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalPages': 'total_pages',
        'totalResults': 'total_results'
      },
    );

Map<String, dynamic> _$MoviesResultModelToJson(MoviesResultModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
