import 'package:assan_khata_frontend/features/group_managment/presentation/pages/individual_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../../../core/widgets/search_box.dart';
import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';
import 'create_group_page.dart';

class GroupHomePage extends StatefulWidget {
  const GroupHomePage({super.key});

  @override
  State<GroupHomePage> createState() => _GroupHomePageState();
}

class _GroupHomePageState extends State<GroupHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<GroupEntity> _filteredGroups = [];
  List<GroupEntity> _allGroups = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterGroups);
    _loadGroups();
  }

  void _loadGroups() {
    final currentState = context.read<AppUserCubit>().state;
    if (currentState is AppUserLoggedIn) {
      final currentUserId = currentState.user.id;
      if (currentUserId != null) {
        context.read<GroupBloc>().add(GetGroupsEvent(currentUserId));
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGroups);
    _searchController.dispose();
    super.dispose();
  }

  void _filterGroups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = _allGroups.where((group) {
        return group.name?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Groups'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result =
                await Navigator.of(context).push(CreateGroupPage.route());
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: AppPallete.primaryColor,
          child: const Icon(
            Icons.group_add,
            color: AppPallete.primaryTextColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SearchBox(searchController: _searchController),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    if (state is GroupLoading) {
                      return Center(child: loadingScreen());
                    } else if (state is GetGroupSuccess) {
                      _allGroups = state.groups;
                      _filteredGroups = _searchController.text.isEmpty
                          ? List.from(_allGroups)
                          : _filteredGroups;
                      return ListView.builder(
                        itemCount: _filteredGroups.length,
                        itemBuilder: (context, index) {
                          final group = _filteredGroups[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: group.picture != null
                                  ? NetworkImage(group.picture!)
                                  : const AssetImage(
                                          'assets/images/Profile Pic.png')
                                      as ImageProvider,
                            ),
                            title: Text(group.name ?? 'No name'),
                            subtitle:
                                Text(group.description ?? 'No description'),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                  context, IndividualGroupPage.route(group));
                              print('Tapped on group: ${group.name}');
                              // Handle navigation or other actions
                            },
                          );
                        },
                      );
                    } else if (state is GroupFailure) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text('No groups found'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
