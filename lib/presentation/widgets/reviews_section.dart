import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/core/localization/app_localizations.dart';
import 'package:movieapp/core/utils/logger_utils.dart';
import 'package:movieapp/core/utils/session_manager.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/domain/entities/review.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsSection extends ConsumerWidget {
  final int movieId;

  const ReviewsSection({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 서버 리뷰와 로컬 리뷰를 함께 표시
    final allReviewsAsync = ref.watch(allReviewsProvider(movieId));

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'reviews'.tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showReviewDialog(context, ref);
                },
                child: Text(
                  'write_review'.tr(context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          allReviewsAsync.when(
            data: (reviews) {
              if (reviews.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.reviews_outlined, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'no_reviews'.tr(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'no_reviews_desc'.tr(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...reviews.take(3).map((review) => _buildReviewItem(context, review)),
                  if (reviews.length > 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton(
                        onPressed: () {
                          _showAllReviews(context, reviews);
                        },
                        child: Text(
                          '${'see_all'.tr(context)} (${reviews.length})',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey[850]!,
              highlightColor: Colors.grey[800]!,
              child: Column(
                children: List.generate(
                  2,
                  (index) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'error_loading'.tr(context),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, Review review) {
    // DateTime? formattedDate 계산
    DateTime? date;
    if (review.createdAt != null) {
      date = review.createdAt;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 아바타 (기본 아이콘 또는 이미지)
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[800],
                backgroundImage: review.avatarPath != null
                    ? NetworkImage(Utils.getImageUrl(review.avatarPath))
                    : null,
                child: review.avatarPath == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (review.authorUsername != null &&
                        review.authorUsername!.isNotEmpty)
                      Text(
                        '@${review.authorUsername}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                  ],
                ),
              ),
              if (date != null)
                Text(
                  DateFormat('yyyy.MM.dd').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
          if (review.hasRating) ...[
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: review.rating! / 2, // 10점 만점을 5점 만점으로 변환
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 16,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
          ],
          const SizedBox(height: 12),
          Text(
            review.content,
            style: const TextStyle(fontSize: 14),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 모든 리뷰 보기
  void _showAllReviews(BuildContext context, List<Review> reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'reviews'.tr(context),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${reviews.length})',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewItem(context, reviews[index]);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 리뷰 작성 다이얼로그
  void _showReviewDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController reviewController = TextEditingController();
    double rating = 0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              title: Text('write_review'.tr(stateContext)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('your_rating'.tr(stateContext)),
                    const SizedBox(height: 8),
                    Center(
                      child: RatingBar.builder(
                        initialRating: rating,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'review_hint'.tr(stateContext),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('cancel'.tr(stateContext)),
                ),
                Consumer(
                  builder: (consumerContext, consumerRef, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (rating <= 0) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('평점을 선택해주세요'.tr(context))),
                          );
                          return;
                        }

                        if (reviewController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('리뷰 내용을 입력해주세요'.tr(context))),
                          );
                          return;
                        }

                        // 로딩 다이얼로그 표시
                        showDialog(
                          context: dialogContext,
                          barrierDismissible: false,
                          builder: (loadingContext) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        try {
                          // 평점 등록 시도
                          final params = RatingParams(
                            movieId: movieId,
                            rating: rating * 2, // 5점 만점을 10점 만점으로 변환
                          );
                          
                          // 서버 API 호출 - result 변수는 사용하므로 유지
                          await consumerRef.read(
                            rateMovieProvider(params).future,
                          );

                          // 성공적으로 등록된 경우 리뷰 생성
                          final newReview = Review(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            author: '나', // 또는 익명
                            content: reviewController.text,
                            createdAt: DateTime.now(),
                            rating: rating * 2, // 5점 만점을 10점 만점으로 변환
                          );

                          // 로컬에 저장
                          await SessionManager.saveLocalReview(movieId, newReview);
                          
                          // 로컬 리뷰 목록 갱신 - 결과를 무시해도 되는 경우 ignore 주석 추가
                          // ignore: unused_result
                          consumerRef.refresh(localReviewsProvider(movieId));
                          // ignore: unused_result
                          consumerRef.refresh(allReviewsProvider(movieId));

                          // mounted 체크 추가 (BuildContext 비동기 사용 경고 수정)
                          if (!dialogContext.mounted) return;

                          // 로딩 다이얼로그 닫기
                          Navigator.of(dialogContext).pop();
                          
                          // 리뷰 다이얼로그 닫기
                          Navigator.of(dialogContext).pop();

                          if (!context.mounted) return;
                          
                          // 성공 메시지
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('리뷰가 등록되었습니다'.tr(context))),
                          );
                          
                        } catch (e) {
                          Logger.error('리뷰 등록 오류', e);
                          
                          // 오류가 나도 로컬에는 저장
                          final newReview = Review(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            author: '나', // 또는 익명
                            content: reviewController.text,
                            createdAt: DateTime.now(),
                            rating: rating * 2, // 5점 만점을 10점 만점으로 변환
                          );
                          
                          // 로컬에 저장
                          await SessionManager.saveLocalReview(movieId, newReview);
                          
                          // 로컬 리뷰 목록 갱신 - 결과를 무시해도 되는 경우 ignore 주석 추가
                          // ignore: unused_result
                          consumerRef.refresh(localReviewsProvider(movieId));
                          // ignore: unused_result
                          consumerRef.refresh(allReviewsProvider(movieId));
                          
                          // mounted 체크 추가
                          if (!dialogContext.mounted) return;
                          
                          // 로딩 다이얼로그 닫기
                          Navigator.of(dialogContext).pop();
                          
                          // 리뷰 다이얼로그 닫기
                          Navigator.of(dialogContext).pop();
                          
                          // mounted 체크 추가
                          if (!context.mounted) return;
                          
                          // 리뷰 등록은 성공했지만 평점 등록에 실패했다는 메시지
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('리뷰는 등록되었지만 평점 등록에 실패했습니다'.tr(context))),
                          );
                        }
                      },
                      child: Text('submit'.tr(stateContext)),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}