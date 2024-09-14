import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/widgets/Button.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';
import 'on_board_page_2.dart';

class OnBoardPage1 extends StatefulWidget {
  final UserEntity user;

  const OnBoardPage1({super.key, required this.user});

  static route({required UserEntity user}) => MaterialPageRoute(
        builder: (context) => OnBoardPage1(user: user),
      );

  @override
  State<OnBoardPage1> createState() => _OnBoardPage1State();
}

class _OnBoardPage1State extends State<OnBoardPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                SizedBox(height: 80),
                Text(
                  "Let\'s setup your account!",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Your account can be your imaginary wallet.",
                  style: TextStyle(
                    color: AppPallete.secondaryTextColor,
                    fontSize: 18,
                  ),
                )
              ],
            )),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Button(
                text: 'Let\'s go',
                onPressed: () {
                  print("onboard User:" + widget.user.toString());
                  Navigator.push(
                      context, OnBoardPage2.route(user: widget.user));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
