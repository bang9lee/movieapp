import 'package:movieapp/domain/entities/movie.dart';

class MoviesResult {
  final int page;
  final List<Movie> movies;
  final int totalPages;
  final int totalResults;

  const MoviesResult({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });
}