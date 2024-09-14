import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/Button.dart';
import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/features/wallet_management/presentation/bloc/wallet_bloc.dart';
import 'package:assan_khata_frontend/features/wallet_management/presentation/bloc/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/text_field.dart';
import '../../bloc/wallet_event.dart';
import 'on_board_page_3.dart';

class OnBoardPage2 extends StatefulWidget {
  final UserEntity user;

  const OnBoardPage2({super.key, required this.user});

  static route({required UserEntity user}) => MaterialPageRoute(
        builder: (context) => OnBoardPage2(user: user),
      );

  @override
  State<OnBoardPage2> createState() => _OnBoardPage2State();
}

class _OnBoardPage2State extends State<OnBoardPage2> {
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = widget.user.name.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.primaryColor,
        title: const Text('Add new account'),
        titleTextStyle: const TextStyle(
          color: AppPallete.primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child:
            BlocConsumer<WalletBloc, WalletState>(listener: (context, state) {
          if (state is WalletFailure) {
            showSnackbar(context, state.message);
          }
          if (state is WalletSuccess) {
            Navigator.pushAndRemoveUntil(context,
                OnBoardPage3.route(user: widget.user), (route) => false);
          }
        }, builder: (context, state) {
          if (state is WalletLoading) {
            return Center(
              child: loadingScreen(),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                Container(
                  color: AppPallete.primaryColor,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 250),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(
                              color: AppPallete.secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "RS:" + _amountController.text.trim(),
                            style: TextStyle(
                              color: AppPallete.primaryTextColor,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: AppPallete.primaryTextColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Textfield(
                              hintText: "Name",
                              controller: _nameController,
                            ),
                            SizedBox(height: 20),
                            Textfield(
                              hintText: "Amount",
                              controller: _amountController,
                            ),
                            SizedBox(height: 50),
                            Button(
                                text: "Continue",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    print("USER:" + widget.user.id.toString());
                                    context.read<WalletBloc>().add(WalletCreate(
                                          userId: widget.user.id.toString(),
                                          balance:
                                              _amountController.text.trim(),
                                        ));
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
