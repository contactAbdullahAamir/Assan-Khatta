import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:flutter/material.dart';

class OnBoardPage3 extends StatefulWidget {
  final UserEntity user;

  const OnBoardPage3({super.key, required this.user});

  static route({required UserEntity user}) => MaterialPageRoute(
        builder: (context) => OnBoardPage3(user: user),
      );

  @override
  State<OnBoardPage3> createState() => _OnBoardPage3State();
}

class _OnBoardPage3State extends State<OnBoardPage3> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/success.png"), height: 150),
            SizedBox(height: 20),
            Text('You are all set!', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
