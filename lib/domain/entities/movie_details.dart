import 'package:movieapp/domain/entities/video.dart';

class MovieDetails {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final int? runtime;
  final int budget;
  final int revenue;
  final String? tagline;
  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;
  final VideoResult? videos;  // 비디오 정보 추가

  const MovieDetails({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    this.runtime,
    required this.budget,
    required this.revenue,
    this.tagline,
    required this.genres,
    required this.productionCompanies,
    this.videos,  // 비디오 정보 추가
  });
  
  // 트레일러가 있는지 확인하는 메서드
  bool get hasTrailer => videos?.hasVideos ?? false;
  
  // 첫 번째 트레일러 가져오기
  Video? get firstTrailer => videos?.firstTrailer;
  
  // 모든 영상 가져오기 (정렬됨)
  List<Video> get allVideos => videos?.allVideos ?? [];
}

class Genre {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });
}

class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String? originCountry;

  const ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });
}