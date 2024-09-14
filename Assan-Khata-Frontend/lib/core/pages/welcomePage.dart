import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/pages/sign_up.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/login.dart';
import '../widgets/button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage('assets/images/receipt.png'),
                      width: 350),
                  SizedBox(height: 20),
                  // Adding space between the image and text
                  Text(
                    'Know where your money goes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Adding space between the text elements
                  Text(
                    'Track your transaction easily,\nwith friends and groups',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppPallete.tertiaryTextColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Button(
                    text: 'Sign Up',
                    onPressed: () =>
                        Navigator.push(context, SignUpPage.route())),
                SizedBox(height: 20),
                Button(
                  text: 'Login',
                  onPressed: () {
                    Navigator.push(context, LoginPage.route());
                  },
                  BackgroundColor: AppPallete.secondaryColor,
                  ForegroundColor: AppPallete.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
