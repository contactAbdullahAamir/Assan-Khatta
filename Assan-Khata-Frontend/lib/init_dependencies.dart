import 'package:assan_khata_frontend/features/group_managment/data/datasources/group_remote_datasource.dart';
import 'package:assan_khata_frontend/features/group_managment/domain/usecases/getGroupMembers.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/usecases/tranfer_funds_usecase.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/data/datasources/ex_auth_datasource.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/data/repositories/ex_user_repositories.impl.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/domain/repositories/ex_user_repositories.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/domain/usecases/login_user_usecase.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/presentation/blocs/ex_auth_bloc.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/data/datasourcces/recipe_datasource.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/data/repository/recipe_repository_impl.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/domain/repository/recipe_repository.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/domain/usecase/get_recipes.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/common/api_service.dart';
import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';
import 'features/authentication/data/datasources/remote/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repositories_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/request_magic_link.dart';
import 'features/authentication/domain/usecases/user_login.dart';
import 'features/authentication/domain/usecases/user_signup.dart';
import 'features/authentication/domain/usecases/verify_magic_link.dart';
import 'features/authentication/domain/usecases/verify_otp.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/contact_management/data/datasources/contact_remote_datasource.dart';
import 'features/contact_management/data/datasources/expense_remote_datasource.dart';
import 'features/contact_management/data/datasources/notification_remote_datasource.dart';
import 'features/contact_management/data/repositories/contact_repository_impl.dart';
import 'features/contact_management/data/repositories/expense_respository_impl.dart';
import 'features/contact_management/data/repositories/notification_repositories_impl.dart';
import 'features/contact_management/domain/repositories/contact_repositories.dart';
import 'features/contact_management/domain/repositories/expense_repository.dart';
import 'features/contact_management/domain/repositories/notification_repositories.dart';
import 'features/contact_management/domain/usecases/contact_usecases/accept_request_usercase.dart';
import 'features/contact_management/domain/usecases/contact_usecases/delete_request-usecase.dart';
import 'features/contact_management/domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'features/contact_management/domain/usecases/expense_usecases/delete_expense_usecase.dart';
import 'features/contact_management/domain/usecases/expense_usecases/get_all_expenses_between_users.dart';
import 'features/contact_management/domain/usecases/expense_usecases/get_incoming_amount.dart';
import 'features/contact_management/domain/usecases/expense_usecases/get_outgoing_amount.dart';
import 'features/contact_management/domain/usecases/expense_usecases/get_total_amount_bw_users.dart';
import 'features/contact_management/domain/usecases/expense_usecases/update_expense_usercase.dart';
import 'features/contact_management/domain/usecases/notification_usecases/get_notifications_by_receiver_id.dart';
import 'features/contact_management/domain/usecases/notification_usecases/markasread_notifcation.dart';
import 'features/contact_management/domain/usecases/notification_usecases/send_notification.dart';
import 'features/contact_management/presentation/bloc/contact_bloc_files/contact_bloc.dart';
import 'features/contact_management/presentation/bloc/expense_bloc_files/expense_bloc.dart';
import 'features/contact_management/presentation/bloc/notification_bloc_files/notification_bloc.dart';
import 'features/group_managment/data/repositories/group_repositories_impl.dart';
import 'features/group_managment/domain/repositories/group_repository.dart';
import 'features/group_managment/domain/usecases/create_group_usecase.dart';
import 'features/group_managment/domain/usecases/get_groups_usecase.dart';
import 'features/group_managment/presentation/bloc/group_bloc.dart';
import 'features/profile_management/data/datasources/remote/user_remote_datasouce.dart';
import 'features/profile_management/data/repositories/user_repository_impl.dart';
import 'features/profile_management/domain/repositories/user_repositories.dart';
import 'features/profile_management/domain/usecases/get_all_users.dart';
import 'features/profile_management/domain/usecases/get_user.dart';
import 'features/profile_management/domain/usecases/update_user.dart';
import 'features/profile_management/presentation/bloc/user_bloc.dart';
import 'features/wallet_management/data/datasources/remote/wallet_remote_datasource.dart';
import 'features/wallet_management/data/repositories/wallet_repository_impl.dart';
import 'features/wallet_management/domain/repositories/wallet_repository.dart';
import 'features/wallet_management/domain/usecases/create_wallet.dart';
import 'features/wallet_management/domain/usecases/get_wallet.dart';
import 'features/wallet_management/presentation/bloc/wallet_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Ensure ApiService is registered before other dependencies that rely on it
  serviceLocator.registerLazySingleton<ApiService>(
      () => ApiService(baseUrl: AppSecrets().baseApiUrl()));

  await _initAuth();
  await _initWallet();
  await _initUser();
  await _initNotification();
  await _initContact();
  await _initExpense();
  await _initGroup();
  await _initExAuth();
  await _initRecipe();

  final baseURL = AppSecrets().baseApiUrl();
  // Register baseURL as a constant value, not a factory
  serviceLocator.registerLazySingleton<String>(() => baseURL);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

Future<void> _initAuth() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(
      () => AuthRemoteDataSource(apiService: serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator()));

  serviceLocator
      .registerFactory(() => UserSignUp(repository: serviceLocator()));

  serviceLocator.registerFactory(() => UserLogin(repository: serviceLocator()));

  serviceLocator.registerFactory(() => VerifyOtp(repository: serviceLocator()));

  serviceLocator
      .registerFactory(() => RequestMagicLink(repository: serviceLocator()));

  serviceLocator
      .registerFactory(() => VerifyMagicLink(repository: serviceLocator()));

  serviceLocator.registerFactory(() => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        appUserCubit: serviceLocator(),
        verifyOtp: serviceLocator(),
        requestMagicLink: serviceLocator(),
        verifyMagicLink: serviceLocator(),
      ));
}

Future<void> _initWallet() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => WalletRemoteDatasource(
        apiService: serviceLocator(),
      ));

  serviceLocator.registerFactory<WalletRepository>(() => WalletRepositoryImpl(
        walletRemoteDatasource: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => CreateWallet(
        serviceLocator(),
      ));
  serviceLocator.registerFactory(() => GetWallet(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => TransferFundsUseCase(
        walletRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => WalletBloc(
        createWallet: serviceLocator(),
        GetWallet: serviceLocator(),
        TransferFundsUseCaseinstance: serviceLocator(),
      ));
}

Future<void> _initUser() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => UserRemoteDatasouce(
        serviceLocator(),
      ));

  serviceLocator.registerFactory<UserRepository>(() => UserRepositoryImpl(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UpdateUser(
        userRepository: serviceLocator(),
      ));
  serviceLocator.registerFactory(() => GetUser(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetAllUsers(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UserBloc(
        updateUser: serviceLocator(),
        getUser: serviceLocator(),
        getAllUsers: serviceLocator(),
      ));
}

Future<void> _initNotification() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => NotificationRemoteDatasource(
        serviceLocator(),
      ));

  serviceLocator
      .registerFactory<NotificationRepository>(() => NotificationRepositoryImpl(
            serviceLocator(),
          ));

  serviceLocator.registerFactory(() => SendNotification(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetNotificationsByReceiverId(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => MarkAsReadNotificationUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => NotificationBloc(
        sendNotification: serviceLocator(),
        getNotificationsByReceiverId: serviceLocator(),
        markAsReadNotificationUseCase: serviceLocator(),
      ));
}

Future<void> _initContact() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => ContactRemoteDataSource(
        serviceLocator(),
      ));

  serviceLocator.registerFactory<ContactRepository>(() => ContactRepositoryImpl(
        contactDataSource: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AcceptRequestUseCase(
        serviceLocator(),
      ));
  serviceLocator.registerFactory(() => DeleteRequestUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ContactBloc(
        acceptRequestUseCase: serviceLocator(),
        deleteRequestUseCase: serviceLocator(),
      ));
}

Future<void> _initExpense() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => ExpenseRemoteDatasource(
        serviceLocator(),
      ));

  serviceLocator.registerFactory<ExpenseRepository>(() => ExpenseRepositoryImpl(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetIncomingAmount(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetOutgoingAmountAmount(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetTotalAmountBwUsers(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetAllExpensesBetweenUsers(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AddExpenseUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UpdateExpenseUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => DeleteExpenseUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ExpenseBloc(
        getIncomingAmount: serviceLocator(),
        getOutgoingAmountAmount: serviceLocator(),
        getTotalAmountBwUsers: serviceLocator(),
        getAllExpensesBetweenUsers: serviceLocator(),
        addExpenseUseCase: serviceLocator(),
        updateExpenseUseCase: serviceLocator(),
        deleteExpenseUseCase: serviceLocator(),
      ));
}

Future<void> _initGroup() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => GroupRemoteDatasource(
        serviceLocator(),
      ));

  serviceLocator.registerFactory<GroupRepository>(() => GroupRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => CreateGroupUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetGroupUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetGroupMemberUseCase(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GroupBloc(
        createGroup: serviceLocator(),
        getGroup: serviceLocator(),
        getGroupMembers: serviceLocator(),
      ));
}

Future<void> _initExAuth() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => ExAuthDatasource(
        apiService: serviceLocator(),
      ));

  serviceLocator.registerFactory<ExUserRepository>(() => ExUserRepositoryImpl(
        dataSource: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => LoginUserUsecase(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ExAuthBloc(
        loginUserUsecase: serviceLocator(),
      ));
}

Future<void> _initRecipe() async {
  // Ensure ApiService is already registered before using it
  serviceLocator.registerFactory(() => RecipeDatasource(
        apiService: serviceLocator(),
      ));

  serviceLocator.registerFactory<RecipeRepository>(() => RecipeRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => GetRecipeUsecase(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => RecipeBloc(
        getRecipeUsecase: serviceLocator(),
      ));
}
