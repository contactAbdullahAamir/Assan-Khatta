import 'package:assan_khata_frontend/core/common/cubits/app_user/app_user_state.dart';
import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/theme/app_pallete.dart';
import 'package:assan_khata_frontend/core/widgets/Button.dart';
import 'package:assan_khata_frontend/core/widgets/loading_screen.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/bloc/expense_bloc_files/expense_bloc.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/pages/add_expense_page.dart';
import 'package:assan_khata_frontend/features/contact_management/presentation/pages/edit_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../contact_management/presentation/bloc/expense_bloc_files/expense_event.dart';
import '../../../contact_management/presentation/bloc/expense_bloc_files/expense_state.dart';
import 'group_settings_page.dart';

class IndividualGroupPage extends StatefulWidget {
  final group;

  static MaterialPageRoute route(final group) {
    return MaterialPageRoute(
      builder: (context) => IndividualGroupPage(group: group),
    );
  }

  const IndividualGroupPage({
    super.key,
    this.group = const UserEntity(),
  });

  @override
  State<IndividualGroupPage> createState() => _IndividualGroupPageState();
}

class _IndividualGroupPageState extends State<IndividualGroupPage> {
  static var currentUser;

  @override
  Widget build(BuildContext context) {
    final appUserCubit = context.read<AppUserCubit>();
    final currentState = appUserCubit.state;

    if (currentState is AppUserLoggedIn) {
      currentUser = currentState.user.id;
      context.read<ExpenseBloc>().add(
          GetTotalAmountBwUsersEvent(currentState.user.id!, widget.group.id!));
      context.read<ExpenseBloc>().add(getAllExpensesBetweenUsersEvent(
          currentState.user.id!, widget.group.id!));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.group.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle menu item selection
              Navigator.push(context, GroupSettingsPage.route(widget.group));
            },
            itemBuilder: (BuildContext context) {
              return <String>['Settings'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Amount Container
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<ExpenseBloc, ExpenseState>(
                  buildWhen: (previous, current) =>
                      current is ExpenseSuccess || current is ExpenseLoading,
                  builder: (BuildContext context, ExpenseState state) {
                    if (state is ExpenseLoading) {
                      return Center(child: loadingScreen());
                    }
                    if (state is ExpenseSuccess) {
                      num expenseAmount =
                          num.tryParse(state.expenses.toString()) ?? 0;
                      Color bgColor = expenseAmount < 0
                          ? AppPallete.containerColor
                          : AppPallete.secondaryColor;
                      Color textColor = expenseAmount < 0
                          ? AppPallete.errorColor
                          : AppPallete.primaryColor;
                      return Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: bgColor,
                        ),
                        child: Center(
                            child: Text("RS: ${expenseAmount}",
                                style: TextStyle(color: textColor))),
                      );
                    } else if (state is ExpenseLoading) {
                      return Center(child: loadingScreen());
                    } else {
                      return Center(
                          child: Text("Amount not available",
                              style: TextStyle(
                                  color: AppPallete.primaryTextColor)));
                    }
                  },
                ),
              ),
              // Expense Table
              Expanded(
                child: BlocBuilder<ExpenseBloc, ExpenseState>(
                  buildWhen: (previous, current) =>
                      current is AllExpensesSuccess ||
                      current is ExpenseLoading,
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return Center(child: loadingScreen());
                    } else if (state is AllExpensesSuccess) {
                      if (state.expenses.isEmpty) {
                        return Center(child: Text('No expenses to display'));
                      }
                      return ListView.builder(
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          final isIncoming = expense.payer == widget.group.id;
                          return InkWell(
                            onTap: () {
                              // Handle row tap
                              Navigator.push(
                                  context, EditExpensePage.route(expense));
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('MMM d, y')
                                              .format(expense.createdAt!),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateFormat('h:mm a')
                                              .format(expense.createdAt!),
                                          style: TextStyle(
                                              color: AppPallete
                                                  .secondaryTextColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isIncoming ? 'Incoming' : 'Outgoing',
                                          style: TextStyle(
                                            color: isIncoming
                                                ? AppPallete.successColor
                                                : AppPallete.errorColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'RS: ${expense.amount}',
                                          style: TextStyle(
                                            color: isIncoming
                                                ? AppPallete.successColor
                                                : AppPallete.errorColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        'Description: ${expense.description ?? 'N/A'}'),
                                    Text('Status: ${expense.status ?? 'N/A'}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No expenses to display'));
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () {
                        Navigator.push(
                            context,
                            AddExpensePage.route(
                                currentUser, widget.group.id!));
                      },
                      text: 'Incoming',
                    ),
                  ),
                  SizedBox(width: 16), // Add space between buttons
                  Expanded(
                    child: Button(
                      onPressed: () {
                        // Add functionality for the second button
                        Navigator.push(
                            context,
                            AddExpensePage.route(
                                widget.group.id!, currentUser));
                      },
                      text: 'Outgoing',
                      BackgroundColor: AppPallete.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
