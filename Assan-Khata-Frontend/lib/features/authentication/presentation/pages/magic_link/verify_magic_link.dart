import 'package:assan_khata_frontend/core/pages/layout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/loading_screen.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class VerifyMagicLink extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const VerifyMagicLink());

  const VerifyMagicLink({super.key});

  @override
  State<VerifyMagicLink> createState() => _VerifyMagicLinkState();
}

class _VerifyMagicLinkState extends State<VerifyMagicLink> {
  final _linkController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Link Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                  context, LayoutPage.route(), (route) => false);
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
                    "Enter your Magic Link",
                    style: TextStyle(
                      color: AppPallete.secondaryTextColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Textfield(hintText: "Link", controller: _linkController),
                  const SizedBox(height: 40),
                  Button(
                      text: "Verify",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                              AuthVerifyMagicLink(token: _linkController.text));
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
