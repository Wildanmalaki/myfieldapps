import 'package:MyField/views/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Pastikan import ini ada untuk timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenTugas10State();
}

class _SplashScreenTugas10State extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>LoginPage()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo_myfield.png",
              width: 300,
              height: 300,
            ),
            
             SizedBox(height: 5),

            Text(
              "Selamat Datang di Aplikasi Kami",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}