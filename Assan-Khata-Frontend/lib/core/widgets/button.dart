import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final String? icon; // Make the icon optional
  final Color BackgroundColor;
  final Color ForegroundColor;
  final void Function()? onPressed;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.BackgroundColor = AppPallete.primaryColor,
    this.ForegroundColor = AppPallete.primaryTextColor,
    this.icon, // Allow null value for icon
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = BackgroundColor;
    Color foregroundColor = ForegroundColor;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
        shadowColor: MaterialStateProperty.all(AppPallete.transparent),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // Adjust the button size based on content
        children: [
          if (icon != null) ...[
            Image(image: AssetImage(icon!), width: 40), // Show icon if provided
            const SizedBox(width: 20), // Add space between icon and text
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
