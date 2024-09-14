import 'dart:convert'; // For base64 decoding

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/common/socket_service.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../profile_management/presentation/bloc/user_bloc.dart';
import '../../../profile_management/presentation/bloc/user_state.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/contact_bloc_files/contact_bloc.dart';
import '../bloc/contact_bloc_files/contact_event.dart';
import '../bloc/notification_bloc_files/notification_bloc.dart';
import '../bloc/notification_bloc_files/notification_event.dart';
import '../bloc/notification_bloc_files/notification_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static route() {
    return MaterialPageRoute(builder: (context) => const NotificationPage());
  }

  static void reloadPage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  }

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _fetchNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackbar(context, 'Swipe left to delete notification');
    });
  }

  void _fetchNotifications() {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context
        .read<NotificationBloc>()
        .add(NotificationGet(userId: userId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationGetSuccess) {
            final unreadNotifications = state.notifications
                .where((notification) => notification.isRead == false)
                .toList();

            if (unreadNotifications.isEmpty) {
              return const Center(child: Text('No new notifications'));
            }

            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is ContactsSuccess) {
                  final users = userState.contacts;

                  return ListView.builder(
                    key: ValueKey(unreadNotifications.length),
                    itemCount: unreadNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = unreadNotifications[index];
                      final userId = notification.senderId;

                      final user = users.firstWhere(
                        (user) => user.id == userId,
                        orElse: () => UserEntity(),
                      );

                      return Dismissible(
                        key: ValueKey(notification.id),
                        background: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red,
                            ),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          context.read<NotificationBloc>().add(
                              MarkAsReadNotificationEvent(
                                  notificationId: notification.id!));
                          _handleDeleteNotification(notification);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: user.profilePic != null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: MemoryImage(
                                      base64Decode(user.profilePic!),
                                    ),
                                    backgroundColor: Colors.grey.shade200,
                                  )
                                : const CircleAvatar(
                                    radius: 30,
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(
                              '${user.name} ${notification.message}' ??
                                  'No message',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: notification.type == 'friendRequest'
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        _handleNotificationResponse(
                                            notification);
                                      },
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                } else if (userState is UserFailure) {
                  return Center(child: Text(userState.message));
                }
                return const Center(child: Text('Loading notifications...'));
              },
            );
          } else if (state is NotificationFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  void _handleNotificationResponse(NotificationEntity notification) {
    final userId = notification.receiverId;
    final contactId = notification.senderId;

    if (userId != null && contactId != null) {
      try {
        context.read<ContactBloc>().add(AcceptRequestEvent(userId, contactId));

        context.read<NotificationBloc>().add(
            MarkAsReadNotificationEvent(notificationId: notification.id ?? ''));
        _fetchNotifications();
        NotificationPage.reloadPage(context);
      } catch (e) {
        print('Error handling notification response: $e');
      }
    } else {
      print('Invalid userId or contactId');
    }
  }

  void _handleDeleteNotification(NotificationEntity notification) {
    final userId = notification.receiverId;
    final contactId = notification.senderId;

    if (userId != null && contactId != null) {
      try {
        context.read<ContactBloc>().add(DeleteRequestEvent(userId, contactId));
        context.read<NotificationBloc>().add(
            MarkAsReadNotificationEvent(notificationId: notification.id ?? ''));
        _fetchNotifications();
        NotificationPage.reloadPage(context);
      } catch (e) {
        print('Error handling delete notification: $e');
      }
    } else {
      print('Invalid userId or contactId for deletion');
    }
  }
}
