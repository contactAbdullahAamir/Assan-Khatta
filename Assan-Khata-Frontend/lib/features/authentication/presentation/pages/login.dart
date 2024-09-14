import 'package:assan_khata_frontend/core/pages/layout_page.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/pages/sign_up.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/presentation/blocs/ex_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/socket_service.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../../recipe_app/features/authentication/presentation/blocs/ex_auth_bloc.dart';
import '../../../../recipe_app/features/authentication/presentation/blocs/ex_auth_event.dart';
import '../bloc/auth_state.dart';
import 'magic_link/request_magic_link.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
              if (state is AuthFailure) {
                showSnackbar(context, state.message);
                print(state.message.toString());
              } else if (state is AuthSuccess) {
                SocketService().reconnectSocket(state.success.id.toString());

                // Trigger the ExAuth login
                context.read<ExAuthBloc>().add(
                      ExAuthEventLogin(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );

                // Use a Future to handle the asynchronous operation
                Future.delayed(Duration.zero, () async {
                  try {
                    // Wait for the ExAuthBloc to complete its state change
                    final exState = await context
                        .read<ExAuthBloc>()
                        .stream
                        .firstWhere((state) =>
                            state is ExAuthStateLoginSuccess ||
                            state is ExAuthStateError);

                    /*  if (exState is ExAuthStateLoginSuccess) {
                      // Update the current user with the new token
                      final updatedUser =
                          state.success.copyWith(token: exState.token);
                      // Update the AppUserCubit with the new user information
                      context.read<AppUserCubit>().updateUser(updatedUser);
                      showSnackbar(
                          context, "Successfully Integrated with Recipe App");
                      print("Successfully Integrated with Recipe App");
                    } else if (exState is ExAuthStateError) {
                      showSnackbar(context,
                          "Failed to Integrated with Recipe App: ${(exState as ExAuthStateError).message}");
                      print(
                          "Failed to Integrated with Recipe App: ${(exState as ExAuthStateError).message}");
                    }

                  */
                  } catch (e) {
                    print("Error: $e");
                  }

                  // Navigate after the Future completes
                  Navigator.pushAndRemoveUntil(
                      context, LayoutPage.route(), (route) => false);
                });
              } else {
                print("User not logged in, cannot initialize socket.");
              }
            }, builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: loadingScreen());
              }
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 40),
                    const SizedBox(height: 20),
                    Textfield(hintText: "Email", controller: emailController),
                    const SizedBox(height: 20),
                    Textfield(
                        hintText: "Password",
                        controller: passwordController,
                        isPasswordField: true),
                    const SizedBox(height: 50),
                    Button(
                        text: 'Login',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLogInWithEmail(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                          }
                        }),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        showSnackbar(
                            context, "This Feature is Unavailable right now.");
                      },
                      child: Text('Forgot Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppPallete.primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
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
                      text: 'Login with Magic',
                      onPressed: () {
                        Navigator.push(context, RequestMagicLink.route());
                      },
                      BackgroundColor: AppPallete.transparent,
                      ForegroundColor: AppPallete.secondaryTextColor,
                      icon: "assets/images/Magic Icon.png",
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppPallete.tertiaryTextColor,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, SignUpPage.route());
                            },
                            child: const Text(
                              'Sign Up',
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
            }),
          ),
        ));
  }
}
