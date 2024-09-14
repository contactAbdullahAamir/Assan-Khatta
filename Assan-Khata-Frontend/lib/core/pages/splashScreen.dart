import 'package:assan_khata_frontend/core/pages/welcomePage.dart';
import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.secondaryBackgroundColor,
      body: Center(
        child: Container(
          child: Center(
              child: Text(
            'Assan \nKhatta',
            style: TextStyle(
              color: AppPallete.primaryTextColor,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
