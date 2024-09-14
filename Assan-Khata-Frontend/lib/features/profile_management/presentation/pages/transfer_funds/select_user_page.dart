import 'dart:async';
import 'dart:convert';

import 'package:assan_khata_frontend/core/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../../../../core/common/entities/user.dart';
import '../../../../../core/utils/show_snackbar.dart';
import '../../../../../core/widgets/Button.dart';
import '../../../../../core/widgets/loading_screen.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../../contact_management/domain/entities/notification_entity.dart';
import '../../../../contact_management/presentation/bloc/notification_bloc_files/notification_bloc.dart';
import '../../../../contact_management/presentation/bloc/notification_bloc_files/notification_event.dart';
import '../../../../wallet_management/presentation/bloc/wallet_bloc.dart';
import '../../../../wallet_management/presentation/bloc/wallet_event.dart';
import '../../../../wallet_management/presentation/bloc/wallet_state.dart';
import '../../bloc/user_bloc.dart';
import '../../bloc/user_event.dart';
import '../../bloc/user_state.dart';

class SelectUserPage extends StatefulWidget {
  const SelectUserPage({super.key});

  static route() {
    return MaterialPageRoute(
      builder: (context) => const SelectUserPage(),
    );
  }

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  List<UserEntity> _availableUsers = [];
  int _walletBalance = 0;
  final ValueNotifier<List<UserEntity>> _filteredUsers = ValueNotifier([]);
  final TextEditingController _searchController = TextEditingController();
  late StreamSubscription<WalletState> _walletSubscription;

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
    _searchController.addListener(_filterUsers);

    // Set up the wallet subscription
    _walletSubscription = context.read<WalletBloc>().stream.listen((state) {
      if (state is WalletSuccess) {
        showSnackbar(context, 'Transfer Successful');
        Navigator.pop(context, true);
      } else if (state is WalletFailure) {
        showSnackbar(context, state.message);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    _filteredUsers.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    _filteredUsers.value = _availableUsers.where((user) {
      return user.name?.toLowerCase().contains(query) ?? false;
    }).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<UserBloc>().add(GetAllUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBox(
              hintText: 'Search users',
              searchController: _searchController,
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserFailure) {
                  return Center(child: Text(userState.message));
                } else if (userState is ContactsSuccess) {
                  final allUsers = userState.contacts as List<UserEntity>;
                  final currentUser =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user;

                  _availableUsers = allUsers
                      .where((user) => user.id != currentUser.id)
                      .toList();
                  _filteredUsers.value = _availableUsers;

                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      if (walletState is WalletCreateSuccess) {
                        _walletBalance = walletState.wallet.balance!;
                      }

                      return ValueListenableBuilder<List<UserEntity>>(
                        valueListenable: _filteredUsers,
                        builder: (context, filteredUsers, child) {
                          return ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      _buildImageProvider(user.profilePic),
                                ),
                                title: Text(user.name ?? 'Unknown'),
                                subtitle: Text(user.email ?? ''),
                                onTap: () {
                                  _showTransferModal(
                                    context,
                                    user,
                                    currentUser,
                                    _walletBalance,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (userState is UserLoading) {
                  return const Center(child: loadingScreen());
                } else {
                  return const Center(child: Text('No users found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildImageProvider(String? base64String) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        final decodedBytes = base64Decode(base64String);
        return MemoryImage(decodedBytes);
      } else {
        return const AssetImage("assets/images/Profile Pic.png");
      }
    } catch (e) {
      print('Error decoding image: $e');
      return const AssetImage("assets/images/Profile Pic.png");
    }
  }

  void _showTransferModal(BuildContext context, UserEntity selectedUser,
      UserEntity currentUser, int walletBalance) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Transfer to ${selectedUser.name}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Textfield(
                  hintText: 'Amount',
                  controller: amountController,
                  isNumberField: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Wallet Balance: \$${walletBalance.toString()}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Button(
                    onPressed: () {
                      final amount = int.tryParse(amountController.text) ?? 0;
                      if (amount > 0) {
                        context.read<WalletBloc>().add(TransferFunds(
                              currentUser.id ?? "",
                              selectedUser.email ?? "",
                              amount,
                            ));
                        context.read<WalletBloc>().stream.listen((state) {
                          if (state is WalletSuccess) {
                            _sendNotification(
                                selectedUser, currentUser, amount);
                          } else {
                            showSnackbar(context, 'Invalid amount');
                          }
                        });
                      }
                      ;
                    },
                    text: 'Transfer',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendNotification(
      UserEntity selectedUser, UserEntity currentUser, int amount) {
    try {
      context.read<NotificationBloc>().add(NotificationSend(
            notification: NotificationEntity(
              message: 'sends you Rs: ${amount.toString()}',
              senderId: currentUser.id,
              receiverId: selectedUser.id,
              type: 'message',
            ).toJson(),
          ));
    } catch (e) {
      showSnackbar(context, e.toString());
      print('Error sending notification: ${e.toString()}');
    }
  }
}
