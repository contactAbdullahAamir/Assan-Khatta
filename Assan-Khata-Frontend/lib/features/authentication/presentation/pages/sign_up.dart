import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/button.dart';
import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/core/widgets/text_field.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/pages/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import 'login.dart';
import 'magic_link/request_magic_link.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackbar(context, state.message);
              } else if (state is AuthSuccess) {
                Navigator.push(
                    context,
                    OTPScreen.route(
                        user: state.success,
                        password: passwordController.text.trim()));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: loadingScreen());
              }
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 40),
                    Textfield(hintText: "Name", controller: nameController),
                    const SizedBox(height: 20),
                    Textfield(hintText: "Email", controller: emailController),
                    const SizedBox(height: 20),
                    Textfield(
                        hintText: "Password",
                        controller: passwordController,
                        isPasswordField: true),
                    const SizedBox(height: 50),
                    Button(
                        text: 'Sign Up',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUpWithEmail(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                          }
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      'or with',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPallete.tertiaryTextColor,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Button(
                      text: 'Sign Up with Magic',
                      onPressed: () {
                        Navigator.push(context, RequestMagicLink.route());
                      },
                      BackgroundColor: AppPallete.transparent,
                      ForegroundColor: AppPallete.secondaryTextColor,
                      icon: "assets/images/Magic Icon.png",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppPallete.tertiaryTextColor,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, LoginPage.route());
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: AppPallete.primaryColor,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
