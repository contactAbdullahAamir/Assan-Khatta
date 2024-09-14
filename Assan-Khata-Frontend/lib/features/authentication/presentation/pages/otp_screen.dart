import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../../wallet_management/presentation/pages/on_board_pages/on_board_page_1.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/OTPField.dart';

class OTPScreen extends StatefulWidget {
  final UserEntity user;
  final String password;

  const OTPScreen({super.key, required this.user, required this.password});

  static route({required UserEntity user, required String password}) =>
      MaterialPageRoute(
          builder: (context) => OTPScreen(
                user: user,
                password: password,
              ));

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 180.0, left: 20, right: 20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackbar(context, state.message);
              } else if (state is AuthSuccess) {
                if (state.success != null) {
                  // Log in the user after OTP verification
                  context.read<AuthBloc>().add(AuthLogInWithEmail(
                        email: widget.user.email.toString(),
                        password: widget.password,
                      ));
                  print("otp USer:" + widget.user.toString());
                  Navigator.pushAndRemoveUntil(
                      context,
                      OnBoardPage1.route(user: state.success),
                      (route) => false); // Clear the stack
                }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter your Verification Code",
                      style: TextStyle(
                        color: AppPallete.secondaryTextColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: List.generate(
                        6,
                        (index) {
                          return OtpField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            nextFocusNode: index < 5
                                ? _focusNodes[index + 1]
                                : FocusNode(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    RichText(
                        text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'We sent a verification code to your email ',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppPallete
                                .secondaryTextColor, // Regular text color
                          ),
                        ),
                        TextSpan(
                          text: widget.user.email,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppPallete.primaryColor,
                            fontWeight:
                                FontWeight.bold, // Optional: make it bold
                          ),
                        ),
                        const TextSpan(
                          text: '. You can check your inbox.',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppPallete
                                .secondaryTextColor, // Regular text color
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignUpWithEmail(
                              name: widget.user.name.toString(),
                              email: widget.user.email.toString(),
                              password: widget.password.toString()));
                        },
                        child: const Text(
                          'I didn\'t receive the code? Send again',
                          style: TextStyle(
                              color: AppPallete.primaryColor,
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        )),
                    const SizedBox(height: 40),
                    Button(
                        text: 'Verify',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final otpCode = _otpControllers
                                .map((e) => e.text)
                                .reduce((value, element) => value + element);
                            print('OTP Code: $otpCode'); // Debug log
                            context.read<AuthBloc>().add(AuthVerifyEmail(
                                email: widget.user.email.toString(),
                                code: otpCode));
                          }
                        }),
                    const SizedBox(height: 20),
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
