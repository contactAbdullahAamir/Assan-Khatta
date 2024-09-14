import 'dart:async';
import 'dart:convert';

import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/core/widgets/search_box.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/bloc/expense_bloc_files/expense_bloc.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/pages/add_contact_page.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../profile_management/presentation/bloc/user_bloc.dart';
import '../../../profile_management/presentation/bloc/user_event.dart';
import '../../../profile_management/presentation/bloc/user_state.dart';
import '../../../wallet_management/domain/enitities/wallet.dart';
import '../../../wallet_management/presentation/bloc/wallet_bloc.dart';
import '../../../wallet_management/presentation/bloc/wallet_event.dart';
import '../../../wallet_management/presentation/bloc/wallet_state.dart';
import '../bloc/expense_bloc_files/expense_event.dart';
import '../bloc/expense_bloc_files/expense_state.dart';
import '../widgets/expense_flow_status.dart';
import 'individual_expense_page.dart';

class ContactHomePage extends StatefulWidget {
  const ContactHomePage({Key? key}) : super(key: key);

  @override
  State<ContactHomePage> createState() => _ContactHomePageState();
}

class _ContactHomePageState extends State<ContactHomePage> {
  late final String userId;
  int incomingAmount = 0;
  int outgoingAmount = 0;

  @override
  void initState() {
    super.initState();
    userId = ""; // Initialize userId
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, appUserState) {
        final UserEntity? user =
            appUserState is AppUserLoggedIn ? appUserState.user : null;

        if (user != null) {
          // Fetch wallet and expenses for the logged-in user
          context.read<WalletBloc>().add(WalletGet(userId: user.id ?? ""));
          context
              .read<ExpenseBloc>()
              .add(GetIncomingExpensesEvent(user.id ?? ""));
          context
              .read<ExpenseBloc>()
              .add(GetOutgoingExpensesEvent(user.id ?? ""));

          if (user.contacts != null && user.contacts!.isNotEmpty) {
            context
                .read<UserBloc>()
                .add(GetMultipleUsersEvent(contactIds: user.contacts!));
          }
        }

        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(user, context),
            floatingActionButton: _buildFloatingActionButton(context),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocConsumer<ExpenseBloc, ExpenseState>(
                listener: (context, state) {
                  if (state is ExpenseError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, expenseState) {
                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      if (walletState is WalletLoading ||
                          expenseState is ExpenseLoading) {
                        return const Center(child: loadingScreen());
                      } else if (walletState is WalletFailure) {
                        return Center(child: Text(walletState.message));
                      } else if (walletState is WalletCreateSuccess ||
                          walletState is WalletCreateSuccess) {
                        final wallet = walletState.wallet;
                        return _ContactHomeContent(wallet: wallet);
                      } else {
                        return const Center(child: Text('No wallet found'));
                      }
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(UserEntity? user, BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppPallete.primaryColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: user?.profilePic != null
                  ? MemoryImage(base64Decode(user?.profilePic ?? ""))
                  : const AssetImage("assets/images/Profile Pic.png")
                      as ImageProvider,
            ),
          ),
        ),
      ),
      title: Text(user?.name ?? "Not Logged in"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 35,
            ),
            color: AppPallete.primaryColor,
            onPressed: () {
              Navigator.of(context).push(NotificationPage.route());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddContactPage(),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      backgroundColor: AppPallete.primaryColor,
      child: const Icon(
        Icons.person_add,
        color: AppPallete.primaryTextColor,
      ),
    );
  }
}

class _ContactHomeContent extends StatelessWidget {
  final WalletEntity wallet;

  const _ContactHomeContent({Key? key, required this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAccountBalance(),
        const SizedBox(height: 20),
        _buildExpenseFlowStatus(),
        const SizedBox(height: 20),
        Expanded(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is ContactsSuccess) {
                final contacts = userState.contacts as List<UserEntity>;
                if (contacts.isEmpty) {
                  return const Center(child: Text('No contacts yet'));
                }
                return _ContactSearchList(allContacts: contacts);
              } else if (userState is UserFailure) {
                return Center(child: Text(userState.message));
              } else if (userState is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('No contacts yet'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccountBalance() {
    return Column(
      children: [
        const Text(
          "Account Balance",
          style: TextStyle(fontSize: 18, color: AppPallete.tertiaryTextColor),
        ),
        Text(
          "RS: ${wallet.balance.toString()}",
          style: const TextStyle(
            fontSize: 50,
            color: AppPallete.secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseFlowStatus() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        int incomingAmount = 0;
        int outgoingAmount = 0;

        if (state is ExpenseLoading) {
          return const Center(child: loadingScreen());
        } else if (state is ExpenseAmountSuccess) {
          incomingAmount =
              state.incomingAmount; // Use incomingAmount from state
          outgoingAmount =
              state.outgoingAmount; // Use outgoingAmount from state
        } else if (state is ExpenseError) {
          return Center(child: Text(state.message));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExpenseFlowStatus(
              iconImage: "assets/images/incoming.png",
              title: "Incoming",
              amount: incomingAmount,
            ),
            const SizedBox(width: 10),
            ExpenseFlowStatus(
              iconImage: "assets/images/outgoing.png",
              title: "Outgoing",
              amount: outgoingAmount,
              color: AppPallete.errorColor,
            ),
          ],
        );
      },
    );
  }
}

class _ContactSearchList extends StatefulWidget {
  final List<UserEntity> allContacts;

  const _ContactSearchList({Key? key, required this.allContacts})
      : super(key: key);

  @override
  _ContactSearchListState createState() => _ContactSearchListState();
}

class _ContactSearchListState extends State<_ContactSearchList> {
  final TextEditingController _searchController = TextEditingController();
  List<UserEntity> _filteredContacts = [];
  Timer? _debounce;
  String _currentQuery = '';

  late final String userId;

  @override
  void initState() {
    super.initState();
    _filteredContacts = widget.allContacts;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_currentQuery != _searchController.text) {
        _currentQuery = _searchController.text;
        _filterContacts();
      }
    });
  }

  void _filterContacts() {
    final query = _currentQuery.toLowerCase();
    setState(() {
      _filteredContacts = widget.allContacts.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        const SizedBox(height: 20),
        Expanded(
          child: _buildContactList(_filteredContacts),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SearchBox(
      searchController: _searchController,
      hintText: "Search Contacts",
    );
  }

  Widget _buildContactList(List<UserEntity> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final user = contacts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualExpensePage(user: user),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user.profilePic != null
                  ? MemoryImage(base64Decode(user.profilePic!))
                  : const AssetImage("assets/images/Profile Pic.png")
                      as ImageProvider,
            ),
            title: Text(user.name ?? "Unnamed User"),
            subtitle: Text(user.email ?? "No email"),
          ),
        );
      },
    );
  }
}
