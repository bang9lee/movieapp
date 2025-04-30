class VideoResult {
  final int id;
  final List<Video> videos;
  
  const VideoResult({
    required this.id,
    required this.videos,
  });
  
  // 트레일러만 필터링하는 메서드
  List<Video> get trailers {
    return videos.where((video) => 
      video.isTrailer && video.isYoutube).toList();
  }
  
  // 티저만 필터링하는 메서드
  List<Video> get teasers {
    return videos.where((video) => 
      video.isTeaser && video.isYoutube).toList();
  }
  
  // 모든 영상(트레일러 우선)
  List<Video> get allVideos {
    // 공식 트레일러를 먼저, 그 다음 티저, 그 다음 나머지 비디오를 반환
    final List<Video> result = [];
    
    // 공식 트레일러를 먼저 추가
    result.addAll(videos.where((video) => 
      video.isTrailer && video.official && video.isYoutube));
    
    // 비공식 트레일러 추가
    result.addAll(videos.where((video) => 
      video.isTrailer && !video.official && video.isYoutube));
      
    // 공식 티저 추가
    result.addAll(videos.where((video) => 
      video.isTeaser && video.official && video.isYoutube));
      
    // 비공식 티저 추가
    result.addAll(videos.where((video) => 
      video.isTeaser && !video.official && video.isYoutube));
      
    // 나머지 유튜브 영상 추가
    result.addAll(videos.where((video) => 
      !video.isTrailer && !video.isTeaser && video.isYoutube));
      
    return result;
  }
  
  // 첫 번째 트레일러 가져오기 (없으면 null)
  Video? get firstTrailer {
    final trailerList = trailers;
    return trailerList.isNotEmpty ? trailerList.first : null;
  }
  
  // 트레일러 또는 티저 존재 여부
  bool get hasVideos => videos.any((video) => video.isYoutube);
}

class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  
  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
  });
  
  // 트레일러인지 확인하는 메서드
  bool get isTrailer => type.toLowerCase() == 'trailer';
  
  // 티저인지 확인하는 메서드
  bool get isTeaser => type.toLowerCase() == 'teaser';
  
  // 유튜브 동영상인지 확인하는 메서드
  bool get isYoutube => site.toLowerCase() == 'youtube';
  
  // 유튜브 썸네일 URL 생성
  String get thumbnailUrl => 'https://img.youtube.com/vi/$key/mqdefault.jpg';
  
  // 유튜브 동영상 URL 생성
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}