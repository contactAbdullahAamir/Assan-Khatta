import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.primaryBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppPallete.secondaryTextColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Poppins',
        bodyColor: AppPallete.secondaryTextColor,
        displayColor: AppPallete.secondaryTextColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppPallete.primaryColor),
        foregroundColor: WidgetStateProperty.all(AppPallete.primaryTextColor),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )),
        minimumSize: WidgetStateProperty.all(Size(400, 65)),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppPallete.primaryColor, // For text field cursors
      selectionColor: AppPallete.primaryColor.withOpacity(0.3),
      selectionHandleColor: AppPallete.primaryColor,
    ),
    // Set cursor color
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppPallete
          .primaryColor, // Set color for CircularProgressIndicator and LinearProgressIndicator
    ),
  );
}
