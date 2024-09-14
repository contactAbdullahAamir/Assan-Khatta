import 'package:assan_khata_frontend/core/pages/splashScreen.dart';
import 'package:assan_khata_frontend/features/group_managment/presentation/bloc/group_bloc.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/presentation/blocs/ex_auth_bloc.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/common/notification_service.dart';
import 'core/theme/theme.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/contact_management/presentation/bloc/contact_bloc_files/contact_bloc.dart';
import 'features/contact_management/presentation/bloc/expense_bloc_files/expense_bloc.dart';
import 'features/contact_management/presentation/bloc/notification_bloc_files/notification_bloc.dart';
import 'features/profile_management/presentation/bloc/user_bloc.dart';
import 'features/wallet_management/presentation/bloc/wallet_bloc.dart';
import 'init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  await setupNotifications();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
          BlocProvider<WalletBloc>(create: (_) => serviceLocator<WalletBloc>()),
          BlocProvider(create: (_) => serviceLocator<UserBloc>()),
          BlocProvider(create: (_) => serviceLocator<NotificationBloc>()),
          BlocProvider(create: (_) => serviceLocator<ContactBloc>()),
          BlocProvider(create: (_) => serviceLocator<ExpenseBloc>()),
          BlocProvider(create: (_) => serviceLocator<GroupBloc>()),
          BlocProvider(create: (_) => serviceLocator<ExAuthBloc>()),
          BlocProvider(create: (_) => serviceLocator<RecipeBloc>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Assan Khatta',
      theme: AppTheme.lightTheme,
      home: Splashscreen(), // Replace with your actual home page
      // Add other app-wide configurations here, like routes
    );
  }
}
