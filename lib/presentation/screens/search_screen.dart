import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/presentation/providers/movie_provider.dart';
import 'package:movieapp/presentation/screens/movie_detail_screen.dart';
import 'package:movieapp/presentation/widgets/movie_poster.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 검색창에 포커스
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _clearSearch() {
    _searchController.clear();
    // 빌드 사이클 외부에서 상태 업데이트
    Future.microtask(() {
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(searchStateProvider.notifier).state = SearchState.initial;
    });
  }
  
  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // 빌드 사이클 외부에서 상태 업데이트
      Future.microtask(() {
        ref.read(searchQueryProvider.notifier).state = query;
        ref.read(searchStateProvider.notifier).state = SearchState.searching;
      });
    } else {
      Future.microtask(() {
        ref.read(searchStateProvider.notifier).state = SearchState.initial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);
    final searchResults = ref.watch(searchResultsProvider);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: '영화 제목을 입력하세요',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _clearSearch,
                      color: Colors.grey[400],
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
            ),
            style: const TextStyle(fontSize: 14),
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              // 입력 값이 변경될 때 상태 갱신을 위해 setState 호출
              setState(() {});
            },
          ),
        ),
      ),
      body: searchResults.when(
        data: (movies) {
          // 빌드 메서드 안에서 상태를 직접 업데이트하지 않고 표시 로직만 처리
          if (searchState == SearchState.initial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '영화를 검색해보세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '영화 제목으로 검색하시면 다양한 영화를 찾을 수 있습니다',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          if (movies.isEmpty && searchState == SearchState.searching) {
            // 빌드 사이클 후에 상태 업데이트
            Future.microtask(() {
              if (ref.read(searchStateProvider) == SearchState.searching) {
                ref.read(searchStateProvider.notifier).state = SearchState.empty;
              }
            });
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 70,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"${ref.read(searchQueryProvider)}"에 대한 검색 결과가 없습니다',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '다른 검색어로 시도해보세요',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          if (movies.isNotEmpty && searchState == SearchState.searching) {
            // 빌드 사이클 후에 상태 업데이트
            Future.microtask(() {
              if (ref.read(searchStateProvider) == SearchState.searching) {
                ref.read(searchStateProvider.notifier).state = SearchState.results;
              }
            });
          }
          
          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 70,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"${ref.read(searchQueryProvider)}"에 대한 검색 결과가 없습니다',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '다른 검색어로 시도해보세요',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: MoviePoster(
                        posterPath: movie.posterPath,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () {
          if (searchState == SearchState.initial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '영화를 검색해보세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '영화 제목으로 검색하시면 다양한 영화를 찾을 수 있습니다',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          // 빌드 사이클 후에 상태 업데이트
          Future.microtask(() {
            if (ref.read(searchStateProvider) != SearchState.error) {
              ref.read(searchStateProvider.notifier).state = SearchState.error;
            }
          });
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 70,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  '오류가 발생했습니다',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '검색 중 문제가 발생했습니다: $error',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}