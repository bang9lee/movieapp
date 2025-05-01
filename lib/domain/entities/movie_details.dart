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
  final VideoResult? videos;
  final Credits? credits;  // 크레딧 정보 추가

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
    this.videos,
    this.credits,
  });
  
  // 트레일러가 있는지 확인하는 메서드
  bool get hasTrailer => videos?.hasVideos ?? false;
  
  // 첫 번째 트레일러 가져오기
  Video? get firstTrailer => videos?.firstTrailer;
  
  // 모든 영상 가져오기 (정렬됨)
  List<Video> get allVideos => videos?.allVideos ?? [];
  
  // 감독 정보 가져오기
  List<Crew> get directors => credits?.crew.where((c) => c.job == 'Director').toList() ?? [];
  
  // 주요 출연진 (상위 5명)
  List<Cast> get mainCast => credits?.cast.take(5).toList() ?? [];
}

class Credits {
  final List<Cast> cast;
  final List<Crew> crew;
  
  const Credits({
    required this.cast,
    required this.crew,
  });
}

class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;
  final int order;
  
  const Cast({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
    required this.order,
  });
}

class Crew {
  final int id;
  final String name;
  final String? profilePath;
  final String? department;
  final String? job;
  
  const Crew({
    required this.id,
    required this.name,
    this.profilePath,
    this.department,
    this.job,
  });
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