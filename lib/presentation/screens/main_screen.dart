import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/presentation/screens/favorites_screen.dart';
import 'package:movieapp/presentation/screens/home_screen.dart';
import 'package:movieapp/presentation/screens/search_screen.dart';
import 'package:movieapp/presentation/widgets/bottom_navigation.dart';

// 현재 선택된 네비게이션 인덱스 관리 provider
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with SingleTickerProviderStateMixin {
  // 각 화면을 위한 키 생성 - 상태 유지 목적
  final List<GlobalKey> _tabKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  
  // 탭 컨트롤러 사용
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 탭 컨트롤러와 Provider 상태 동기화
    _tabController.addListener(_handleTabChange);
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  // 탭 변경 시 Provider 상태 업데이트
  void _handleTabChange() {
    if (_tabController.index != ref.read(selectedNavIndexProvider)) {
      ref.read(selectedNavIndexProvider.notifier).state = _tabController.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    
    // Provider 상태가 변경되면 탭 컨트롤러 업데이트
    if (_tabController.index != selectedIndex) {
      _tabController.animateTo(selectedIndex);
    }
    
    // 탭이 변경될 때 호출되는 함수
    void onTabTapped(int index) {
      ref.read(selectedNavIndexProvider.notifier).state = index;
    }
    
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // 스와이프로 탭 전환 비활성화
        children: [
          KeyedSubtree(
            key: _tabKeys[0],
            child: const HomeScreen(),
          ),
          KeyedSubtree(
            key: _tabKeys[1],
            child: const SearchScreen(),
          ),
          KeyedSubtree(
            key: _tabKeys[2],
            child: const FavoritesScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
      ),
    );
  }
}