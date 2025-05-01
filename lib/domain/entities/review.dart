class Review {
  final String id;
  final String author;
  final String? authorUsername;
  final String? avatarPath;
  final String content;
  final DateTime? createdAt;
  final double? rating;
  
  const Review({
    required this.id,
    required this.author,
    this.authorUsername,
    this.avatarPath,
    required this.content,
    this.createdAt,
    this.rating,
  });
  
  // 평점이 있는지 확인
  bool get hasRating => rating != null && rating! > 0;
}

class ReviewsResult {
  final int page;
  final List<Review> reviews;
  final int totalPages;
  final int totalResults;
  
  const ReviewsResult({
    required this.page,
    required this.reviews,
    required this.totalPages,
    required this.totalResults,
  });
}

class GuestSessionResponse {
  final bool success;
  final String guestSessionId;
  final DateTime expiresAt;
  
  const GuestSessionResponse({
    required this.success,
    required this.guestSessionId,
    required this.expiresAt,
  });
}