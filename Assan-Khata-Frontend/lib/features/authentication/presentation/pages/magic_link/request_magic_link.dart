import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/pages/magic_link/verify_magic_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class RequestMagicLink extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const RequestMagicLink());

  const RequestMagicLink({Key? key}) : super(key: key);

  @override
  State<RequestMagicLink> createState() => _RequestMagicLinkState();
}

class _RequestMagicLinkState extends State<RequestMagicLink> {
  final _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthSuccess) {
              Navigator.push(context, VerifyMagicLink.route());
            }
          }, builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: loadingScreen());
            }
            return Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Request your Magic Link",
                    style: TextStyle(
                      color: AppPallete.secondaryTextColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Textfield(hintText: "Email", controller: _emailController),
                  const SizedBox(height: 40),
                  Button(
                      text: "Request",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthRequestMagicLink(
                              email: _emailController.text.trim()));
                        }
                      }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
