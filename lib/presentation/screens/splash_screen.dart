import 'package:flutter/material.dart';
import 'package:movieapp/presentation/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화 (1초 동안)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 페이드인 효과를 위한 애니메이션 (이즈인 커브)
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // 애니메이션 시작
    _controller.forward();

    // 2초 후 메인 화면으로 이동
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/app_logo.png',
            width: MediaQuery.of(context).size.width * 0.7, // 이미지 크기를 화면 너비의 70%로 설정
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}