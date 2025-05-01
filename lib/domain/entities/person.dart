class Person {
  final int id;
  final String name;
  final String? profilePath;
  final String? biography;
  final String? birthplace;
  final String? birthday;
  final String? deathday;
  final double popularity;
  final List<PersonCredit> credits;
  final String? knownForDepartment;
  
  const Person({
    required this.id,
    required this.name,
    this.profilePath,
    this.biography,
    this.birthplace,
    this.birthday,
    this.deathday,
    required this.popularity,
    required this.credits,
    this.knownForDepartment,
  });
  
  // 나이 계산 (생일 정보가 있는 경우)
  int? get age {
    if (birthday == null || birthday!.isEmpty) {
      return null;
    }
    
    final birthDate = DateTime.parse(birthday!);
    final today = DateTime.now();
    
    // 사망한 경우 사망일 기준으로 나이 계산
    if (deathday != null && deathday!.isNotEmpty) {
      final deathDate = DateTime.parse(deathday!);
      int age = deathDate.year - birthDate.year;
      if (deathDate.month < birthDate.month || 
          (deathDate.month == birthDate.month && deathDate.day < birthDate.day)) {
        age--;
      }
      return age;
    }
    
    // 현재 기준 나이 계산
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  // 출연작만 필터링
  List<PersonCredit> get actingCredits {
    return credits.where((credit) => credit.department == 'Acting').toList();
  }
  
  // 감독작만 필터링
  List<PersonCredit> get directingCredits {
    return credits.where((credit) => credit.job == 'Director').toList();
  }
  
  // 주요 작품 가져오기 (인기도 기준)
  List<PersonCredit> get topCredits {
    final sortedCredits = List<PersonCredit>.from(credits);
    sortedCredits.sort((a, b) => b.popularity.compareTo(a.popularity));
    return sortedCredits.take(5).toList();
  }
}

class PersonCredit {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? character;
  final String? department;
  final String? job;
  final double popularity;
  final double voteAverage;
  
  const PersonCredit({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.character,
    this.department,
    this.job,
    required this.popularity,
    required this.voteAverage,
  });
  
  // 개봉 연도만 가져오기
  String? get year {
    if (releaseDate == null || releaseDate!.isEmpty) {
      return null;
    }
    return releaseDate!.substring(0, 4);
  }
}