import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../repository/repository.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isLoading = false;

  Future<void> _isLogin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("User is already logged in.");
      setState(() {
        _isLoading = true;
      });
      final String? refreshToken = await AuthService().refreshToken();
      if (refreshToken != null) {
        print("User's token is refreshed.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Set isLoading false karena currentUser null
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const OnBoardingScreen(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _isLogin();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/splash_screen.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              child: Image.asset(
                color: const Color(0xffEEEEEE),
                "assets/logo_splash.png",
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (_isLoading) // Hanya tampilkan indicator jika sedang loading
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Validasi ke server',style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
