import 'package:flutter/material.dart';
import 'package:movieapp/core/localization/app_localizations.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // iOS 스타일의 짙은 다크모드 색상
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.grey[900]!,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // 투명 배경으로 Container의 색상이 보이게 함
          selectedItemColor: Colors.white, // 선택된 아이템은 흰색
          unselectedItemColor: Colors.grey[600], // 선택되지 않은 아이템은 회색
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          elevation: 0, // 그림자 제거
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4), 
                child: Icon(Icons.home_rounded),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.home_filled),
              ),
              label: 'home'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.search),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.search),
              ),
              label: 'search'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.favorite_border_rounded),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.favorite_rounded),
              ),
              label: 'favorites'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.settings_outlined),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Icon(Icons.settings),
              ),
              label: 'settings'.tr(context),
            ),
          ],
        ),
      ),
    );
  }
}