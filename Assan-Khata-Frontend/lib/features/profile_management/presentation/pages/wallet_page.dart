import 'package:assan_khata_frontend/core/common/cubits/app_user/app_user_state.dart';
import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/features/profile_management/presentation/pages/transfer_funds/select_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/widgets/button.dart';
import '../../../wallet_management/presentation/bloc/wallet_bloc.dart';
import '../../../wallet_management/presentation/bloc/wallet_event.dart';
import '../../../wallet_management/presentation/bloc/wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => WalletPage());

  static void reloadPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      route(),
    );
  }

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _reloadTriggered = false;

  @override
  void initState() {
    super.initState();
    final appUserCubit = context.read<AppUserCubit>();
    final currentState = appUserCubit.state;
    if (currentState is AppUserLoggedIn) {
      context
          .read<WalletBloc>()
          .add(WalletGet(userId: currentState.user.id ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Button(
            onPressed: () {
              Navigator.push(context, SelectUserPage.route());
            },
            text: 'Transfer Funds',
          ),
        ),
        body: BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
          if (state is WalletLoading) {
            return Center(child: loadingScreen());
          } else if (state is WalletCreateSuccess) {
            // Do something with state.wallet

            return Stack(
              children: [
                Image(
                  image: AssetImage(
                    "assets/images/BG.png",
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    // Adjust padding as needed
                    child: Column(
                      children: [
                        Text(
                          'Account Balance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppPallete.tertiaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'RS:${state.wallet.balance}',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 250, left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage("assets/images/wallet.png"),
                            height: 60,
                          ),
                          SizedBox(width: 10),
                          Text("Wallet",
                              style: TextStyle(
                                color: AppPallete.secondaryTextColor,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      Text("RS:${state.wallet.balance}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ],
            );
          } else {
            if (!_reloadTriggered) {
              _reloadTriggered = true;
              Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  WalletPage.reloadPage(context);
                }
              });
            }
            return const Center(child: Text("Loading..."));
          }
        }),
      ),
    );
  }
}
