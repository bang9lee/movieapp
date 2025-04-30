import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/core/utils/json_utils.dart';
import 'package:movieapp/domain/entities/video.dart';

part 'video_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoResultModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  
  @JsonKey(name: 'results', defaultValue: <VideoModel>[])
  final List<VideoModel> results;
  
  const VideoResultModel({
    required this.id,
    required this.results,
  });
  
  factory VideoResultModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$VideoResultModelFromJson(json);
    } catch (e) {
      print('Error parsing VideoResultModel: $e');
      
      // 기본 비디오 리스트 생성 시도
      List<VideoModel> videosList = [];
      if (json['results'] != null && json['results'] is List) {
        try {
          videosList = (json['results'] as List)
            .map((videoJson) => 
              videoJson is Map<String, dynamic> 
                ? VideoModel.fromJson(videoJson)
                : const VideoModel(
                    id: '',
                    key: '',
                    name: '알 수 없는 비디오',
                    site: 'youtube',
                    size: 0,
                    type: '',
                    official: false,
                    publishedAt: '',
                  )
            )
            .toList();
        } catch (e) {
          print('Error parsing video results: $e');
        }
      }
      
      // 기본값으로 객체 반환
      return VideoResultModel(
        id: JsonUtils.safeInt(json['id'], 0),
        results: videosList,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$VideoResultModelToJson(this);
  
  VideoResult toEntity() {
    return VideoResult(
      id: id,
      videos: results.map((model) => model.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class VideoModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;
  
  @JsonKey(name: 'key', defaultValue: '')
  final String key;
  
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  
  @JsonKey(name: 'site', defaultValue: 'youtube')
  final String site;
  
  @JsonKey(name: 'size', defaultValue: 0)
  final int size;
  
  @JsonKey(name: 'type', defaultValue: '')
  final String type;
  
  @JsonKey(name: 'official', defaultValue: false)
  final bool official;
  
  @JsonKey(name: 'published_at', defaultValue: '')
  final String publishedAt;
  
  const VideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
  });
  
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$VideoModelFromJson(json);
    } catch (e) {
      print('Error parsing VideoModel: $e');
      // 기본값으로 객체 반환
      return VideoModel(
        id: JsonUtils.safeString(json['id'], ''),
        key: JsonUtils.safeString(json['key'], ''),
        name: JsonUtils.safeString(json['name'], '알 수 없는 비디오'),
        site: JsonUtils.safeString(json['site'], 'youtube'),
        size: JsonUtils.safeInt(json['size'], 0),
        type: JsonUtils.safeString(json['type'], ''),
        official: JsonUtils.safeBool(json['official'], false),
        publishedAt: JsonUtils.safeString(json['published_at'], ''),
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
  
  Video toEntity() {
    return Video(
      id: id,
      key: key,
      name: name,
      site: site,
      size: size,
      type: type,
      official: official,
      publishedAt: publishedAt,
    );
  }
  
  // 트레일러인지 확인하는 메서드
  bool get isTrailer => type.toLowerCase() == 'trailer';
  
  // 티저인지 확인하는 메서드
  bool get isTeaser => type.toLowerCase() == 'teaser';
  
  // 유튜브 동영상인지 확인하는 메서드
  bool get isYoutube => site.toLowerCase() == 'youtube';
}