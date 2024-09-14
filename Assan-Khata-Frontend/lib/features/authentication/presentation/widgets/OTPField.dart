import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const OtpField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 50, // Adjust space between fields
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold // Adjusted dot size
            ),
        decoration: InputDecoration(
          hintText: "●",
          // Grey dot
          hintStyle: TextStyle(
            fontSize: 30, // Adjusted dot size
            color: AppPallete.tertiaryTextColor,
          ),
          border: InputBorder.none,
          // Remove the underline
          enabledBorder: InputBorder.none,
          // Remove the underline when enabled
          focusedBorder: InputBorder.none,
          // Remove the underline when focused
          counterText: "", // Remove the character counter
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
