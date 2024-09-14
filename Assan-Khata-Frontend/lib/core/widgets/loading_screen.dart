import 'package:flutter/material.dart';

class loadingScreen extends StatelessWidget {
  const loadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
