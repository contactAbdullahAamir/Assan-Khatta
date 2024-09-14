import 'dart:convert';

import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/bloc/notification_bloc_files/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/search_box.dart';
import '../../../profile_management/presentation/bloc/user_bloc.dart';
import '../../../profile_management/presentation/bloc/user_event.dart';
import '../../../profile_management/presentation/bloc/user_state.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc_files/notification_event.dart';
import '../bloc/notification_bloc_files/notification_state.dart';

class AddContactPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(
      builder: (context) => const AddContactPage(),
    );
  }

  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  List<UserEntity> _availableUsers = [];
  List<UserEntity> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<UserBloc>().add(GetAllUsersEvent());
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _availableUsers
          .where((user) =>
              (user.name?.toLowerCase().contains(query) ?? false) ||
              (user.email?.toLowerCase().contains(query) ?? false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSuccess) {
          showSnackbar(context, state.success);
        } else if (state is NotificationFailure) {
          showSnackbar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Contact'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBox(
                searchController: _searchController,
                hintText: 'Search a user',
              ),
            ),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserFailure) {
                    showSnackbar(context, userState.message);
                  } else if (userState is ContactsSuccess) {
                    final allUsers = userState.contacts as List<UserEntity>;
                    final currentUser =
                        (context.read<AppUserCubit>().state as AppUserLoggedIn)
                            .user;

                    _availableUsers = allUsers
                        .where((user) =>
                            user.id != currentUser.id &&
                            !currentUser.contacts!.contains(user.id))
                        .toList();

                    if (_filteredUsers.isEmpty &&
                        _searchController.text.isEmpty) {
                      _filteredUsers = _availableUsers;
                    }

                    return ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        final isPending =
                            user.requests?.contains(currentUser.id) ?? false;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profilePic != null
                                ? MemoryImage(base64Decode(user.profilePic!))
                                : const AssetImage(
                                        "assets/images/Profile Pic.png")
                                    as ImageProvider,
                          ),
                          title: Text(user.name ?? 'Unknown'),
                          subtitle: Text(user.email ?? ''),
                          trailing: isPending
                              ? const Text(
                                  'Pending',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    _addContact(currentUser, user);
                                  },
                                ),
                        );
                      },
                    );
                  } else if (userState is UserLoading) {
                    return const Center(child: loadingScreen());
                  } else {
                    return const Center(child: Text('Failed to load users'));
                  }
                  return const Center(child: Text('No users found'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(UserEntity currentUser, UserEntity newContact) {
    final updatedRequestsForNewContact =
        List<String>.from(newContact.requests ?? []);
    if (!updatedRequestsForNewContact.contains(currentUser.id)) {
      updatedRequestsForNewContact.add(currentUser.id!);
    }

    final updatedNewContact = newContact.copyWith(
      requests: updatedRequestsForNewContact,
    );

    context
        .read<UserBloc>()
        .add(UpdateUserEvent(user: updatedNewContact.toJson()));

    try {
      context.read<NotificationBloc>().add(NotificationSend(
            notification: NotificationEntity(
              message: 'sends you a contact request',
              senderId: currentUser.id,
              receiverId: newContact.id,
              type: 'friendRequest',
            ).toJson(),
          ));
    } catch (e) {
      showSnackbar(context, e.toString());
      print('Error sending notification: ${e.toString()}');
    }

    setState(() {
      _availableUsers =
          _availableUsers.where((user) => user.id != newContact.id).toList();
      didChangeDependencies();
      _filterUsers();
    });
  }
}
