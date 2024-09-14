import 'dart:convert';
import 'dart:io';

import 'package:assan_khata_frontend/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:assan_khata_frontend/core/common/cubits/app_user/app_user_state.dart';
import 'package:assan_khata_frontend/core/common/socket_service.dart';
import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/Button.dart';
import 'package:assan_khata_frontend/core/widgets/text_field.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/pages/login.dart';
import 'package:assan_khata_frontend/features/profile_management/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    print("Attempting to pick image");
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        // Update the user's profilePic
        final appUserCubit = context.read<AppUserCubit>();
        final currentState = appUserCubit.state;
        if (currentState is AppUserLoggedIn) {
          final updatedUser =
              currentState.user.copyWith(profilePic: base64Image);
          appUserCubit.updateUser(updatedUser);

          // Convert updatedUser to Map<String, dynamic>
          final userMap = updatedUser.toJson();

          // Dispatch the UpdateUserEvent with the map
          context.read<UserBloc>().add(UpdateUserEvent(user: userMap));

          // Listen for changes in the UserBloc state
          // Listen for changes in the UserBloc state
          context.read<UserBloc>().stream.listen((userState) {
            if (userState is UserSuccess) {
              showSnackbar(context, userState.success.first.toString());
              // You might want to update the UI here with a message
            } else if (userState is UserFailure) {
              showSnackbar(context, userState.message);
              // You might want to show an error message in the UI
            }
          });

          print("Image picked and saved successfully");
        }
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showEditNameBottomSheet() {
    final appUserCubit = context.read<AppUserCubit>();
    final currentState = appUserCubit.state;
    if (currentState is AppUserLoggedIn) {
      _nameController.text = currentState.user.name ?? '';

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Textfield(
                  controller: _nameController,
                  hintText: 'Full Name',
                ),
                SizedBox(height: 40),
                Button(
                  text: 'Save',
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final updatedUser = currentState.user.copyWith(
                        name: _nameController.text,
                      );
                      appUserCubit.updateUser(updatedUser);
                      // Convert updatedUser to Map<String, dynamic>
                      final userMap = updatedUser.toJson();

                      // Dispatch the UpdateUserEvent with the map
                      context
                          .read<UserBloc>()
                          .add(UpdateUserEvent(user: userMap));

                      // Listen for changes in the UserBloc state
                      // Listen for changes in the UserBloc state
                      context.read<UserBloc>().stream.listen((userState) {
                        if (userState is UserSuccess) {
                          showSnackbar(
                              context, userState.success.first.toString());
                          // You might want to update the UI here with a message
                        } else if (userState is UserFailure) {
                          showSnackbar(context, userState.message);
                          // You might want to show an error message in the UI
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _logout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Log out?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppPallete.tertiaryTextColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      BackgroundColor: AppPallete.secondaryButtonColor,
                      ForegroundColor: AppPallete.primaryColor,
                      text: 'No',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Button(
                      onPressed: () {
                        SocketService().disconnectSocket();
                        Navigator.pop(context); // Close the bottom sheet
                        _performLogout(context); // Perform logout
                      },
                      text: 'Yes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Release the app user
    final appUserCubit = context.read<AppUserCubit>();
    appUserCubit.updateUser(null);

    // Navigate to login page
    Navigator.pushAndRemoveUntil(
      context,
      LoginPage.route(),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppPallete.tertiaryColor,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<AppUserCubit, AppUserState>(
                      builder: (context, state) {
                        final profilePic = state is AppUserLoggedIn
                            ? state.user.profilePic
                            : null;
                        return GestureDetector(
                          onTap: () {
                            Vibration.vibrate(duration: 50);
                            print("Tapped on image");

                            _pickImage();
                          },
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppPallete.primaryColor,
                                width: 3,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ClipOval(
                                child: profilePic != null
                                    ? Image.memory(
                                        base64Decode(profilePic),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Image(
                                        image: AssetImage(
                                            "assets/images/Profile Pic.png"),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    BlocBuilder<AppUserCubit, AppUserState>(
                        builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full Name",
                            style: TextStyle(
                              color: AppPallete.tertiaryTextColor,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            state is AppUserLoggedIn
                                ? state.user.name!
                                : "Not logged in",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      );
                    }),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        _showEditNameBottomSheet();
                        // Add your logic here
                        print('Tapped on edit'); // Debug print
                      },
                      child: Image(
                        image: AssetImage("assets/images/edit.png"),
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppPallete.primaryBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        Navigator.push(context, WalletPage.route());
                        // Add your logic here
                        print('Tapped on account'); // Debug print
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/images/wallet.png"),
                              height: 60,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Account",
                              style: TextStyle(
                                color: AppPallete.secondaryTextColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        // Add your logic here
                        showSnackbar(
                            context, "This Feature is unavailable right now");
                        print('Tapped on settings'); // Debug print
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/images/setting.png"),
                              height: 60,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Settings",
                              style: TextStyle(
                                color: AppPallete.secondaryTextColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        _logout(context);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/images/logout.png"),
                              height: 60,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Log out",
                              style: TextStyle(
                                color: AppPallete.secondaryTextColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
