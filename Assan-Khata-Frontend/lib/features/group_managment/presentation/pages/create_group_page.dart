import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/Button.dart';
import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_state.dart';
import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  static route() {
    return MaterialPageRoute(builder: (_) => const CreateGroupPage());
  }

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
        ),
        body: BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupLoading) {
              Center(
                child: loadingScreen(),
              );
            } else if (state is GroupSuccess) {
              showSnackbar(context, "Group created successfully");
              Navigator.pop(context);
            } else if (state is GroupFailure) {
              showSnackbar(context, state.message);
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 70,
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Textfield(
                        hintText: "Name",
                        controller: nameController,
                      ),
                      const SizedBox(height: 20),
                      Textfield(
                        hintText: "Description",
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<AppUserCubit, AppUserState>(
                        builder: (context, state) {
                          if (state is AppUserLoggedIn) {
                            return Button(
                              text: "Create",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final groupEntity = GroupEntity(
                                    name: nameController.text.trim(),
                                    description:
                                        descriptionController.text.trim(),
                                    createdBy: state.user.id,
                                  );
                                  BlocProvider.of<GroupBloc>(context).add(
                                    CreateGroupEvent(groupEntity),
                                  );
                                }
                              },
                            );
                          } else {
                            return const Center(
                                child: Text("User not logged in"));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
