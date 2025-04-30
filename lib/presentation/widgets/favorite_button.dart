import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';

class FavoriteButton extends ConsumerWidget {
  final int movieId;
  final Color? color;
  final double size;
  final bool hasBorder;
  
  const FavoriteButton({
    super.key,
    required this.movieId,
    this.color,
    this.size = 24.0,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(isMovieFavoriteProvider(movieId));
    
    return favoriteState.when(
      data: (isFavorite) {
        return InkWell(
          onTap: () {
            // 빌드 사이클 외부에서 상태 업데이트
            Future.microtask(() {
              ref.read(favoriteMovieIdsProvider.notifier).toggleFavorite(movieId);
             // 강제로 isMovieFavoriteProvider를 새로고침하여 UI 업데이트 보장
              // ignore: unused_result
              ref.refresh(isMovieFavoriteProvider(movieId));
            });
          },
          borderRadius: BorderRadius.circular(size),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isFavorite
                ? _buildFavoriteButton(
                    key: const ValueKey('favorite'),
                    icon: Icons.favorite,
                    color: Colors.red,
                  )
                : _buildFavoriteButton(
                    key: const ValueKey('not-favorite'),
                    icon: Icons.favorite_border,
                    color: color ?? Colors.white,
                  ),
          ),
        );
      },
      loading: () => _buildFavoriteButton(
        icon: Icons.favorite_border,
        color: Colors.grey,
      ),
      error: (_, __) => _buildFavoriteButton(
        icon: Icons.favorite_border,
        color: Colors.grey,
      ),
    );
  }
  
  Widget _buildFavoriteButton({
    required IconData icon,
    required Color color,
    Key? key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(8),
      decoration: hasBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              color: Colors.black.withOpacity(0.5),
            )
          : null,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}