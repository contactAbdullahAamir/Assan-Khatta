import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

class GroupSettingsPage extends StatefulWidget {
  final group;

  static MaterialPageRoute route(final group) =>
      MaterialPageRoute(builder: (_) => GroupSettingsPage(group: group));

  const GroupSettingsPage({super.key, this.group = const GroupEntity()});

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(GetMembersEvent(widget.group.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Settings'),
      ),
      body: Column(
        children: [
          // Group photo and name
          Container(
            width: double.infinity,
            height: 200, // Adjust height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.group.picture != null
                    ? MemoryImage(base64Decode(widget.group.picture ?? ""))
                    : const AssetImage("assets/images/Profile Pic.png")
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black54,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.group.name ?? 'No name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Group members
          Expanded(
            child: BlocConsumer<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupFailure) {
                  // Log error to the console
                  print('Group Failure: ${state.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is GetMemberSuccess) {
                  // Log success to the console
                  print('Group Members Loaded Successfully');
                  print('Members: ${state.members}');
                }
              },
              builder: (context, state) {
                if (state is GroupLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetMemberSuccess) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.members.length,
                    itemBuilder: (context, index) {
                      final member = state.members[index];
                      final name = member['name'] ?? 'Unknown';
                      final email = member['email'] ?? 'No email';

                      return ListTile(
                        title: Text(name),
                        subtitle: Text(email),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No members available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
