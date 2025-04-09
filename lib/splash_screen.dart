import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:skyislimit/rest/hive_repo.dart';
import 'package:skyislimit/routes/app_router.gr.dart';
import 'package:skyislimit/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:skyislimit/theme/themes.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<double> _animationLeft;
  late Animation<double> _animationRight;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animationLeft = Tween(begin: -500.0, end: 70.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });

    Timer(const Duration(seconds: 3), () {
      context.router.replace(SearchUsersRoute());
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
      backgroundColor: screenBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
            color: screenBackgroundColor,
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D1117),
                  Color(0xFF161B22),
                ]
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationLeft,
              builder: (context, child) {
                return Positioned(
                  left: _animationLeft.value,
                  top: MediaQuery.of(context).size.height * 0.4,
                  child: child!,
                );
              },
              child: Text(
                "GitHub Explorer",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
