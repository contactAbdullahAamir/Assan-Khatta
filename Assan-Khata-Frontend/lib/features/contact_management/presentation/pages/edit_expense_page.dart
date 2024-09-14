import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/text_field.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/widgets/Button.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/expense_bloc_files/expense_bloc.dart';
import '../bloc/expense_bloc_files/expense_event.dart';
import '../bloc/expense_bloc_files/expense_state.dart';
import '../bloc/notification_bloc_files/notification_bloc.dart';
import '../bloc/notification_bloc_files/notification_event.dart';

class EditExpensePage extends StatefulWidget {
  final ExpenseEntity expense;

  const EditExpensePage({super.key, this.expense = const ExpenseModel()});

  static route(final ExpenseEntity expense) {
    return MaterialPageRoute(
      builder: (context) => EditExpensePage(expense: expense),
    );
  }

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final String title = 'Edit Expense';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  Uint8List? _imageBytes;
  String? _imageBase64;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    amountController.text = widget.expense.amount.toString();
    descriptionController.text = widget.expense.description!;
    selectedDateTime = widget.expense.createdAt!;
    _imageBase64 = widget.expense.picture;
    _imageBytes = _imageBase64 != null ? base64Decode(_imageBase64!) : null;
    _selectedStatus = widget.expense.status ?? 'pending';
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ';
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageBytes = File(pickedFile.path).readAsBytesSync();
        _imageBase64 = base64Encode(_imageBytes!);
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context) {
    if (_imageBytes != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Receipt'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Image.memory(
                      _imageBytes!,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                    const SizedBox(height: 20),
                    Button(
                      text: "Remove",
                      onPressed: () {
                        setState(() {
                          _imageBytes = null;
                          _imageBase64 = null;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Expense'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: BlocListener<ExpenseBloc, ExpenseState>(
                listener: (context, state) {
                  if (state is AddExpenseSuccess) {
                    showSnackbar(context, 'Expense deleted successfully');
                    try {
                      context.read<NotificationBloc>().add(NotificationSend(
                            notification: NotificationEntity(
                              message: 'deleted an expense',
                              senderId: widget.expense.payer,
                              receiverId: widget.expense.relatedUser,
                              type: 'expenseRequest',
                            ).toJson(),
                          ));
                    } catch (e) {
                      showSnackbar(context, e.toString());
                      print('Error sending notification: ${e.toString()}');
                    }
                    Navigator.pop(
                        context, true); // Dismiss and refresh the previous page
                  } else if (state is ExpenseError) {
                    showSnackbar(context, state.message);
                  }
                },
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 35,
                  ),
                  color: AppPallete.errorColor,
                  onPressed: () {
                    context
                        .read<ExpenseBloc>()
                        .add(DeleteExpenseEvent(widget.expense.id!));
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
              left: 50.0, right: 20.0, bottom: 20.0, top: 20.0),
          child: BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state is AddExpenseSuccess) {
                showSnackbar(context, 'Expense edited successfully');
                try {
                  context.read<NotificationBloc>().add(NotificationSend(
                        notification: NotificationEntity(
                          message: 'edited an expense',
                          senderId: widget.expense.payer,
                          receiverId: widget.expense.relatedUser,
                          type: 'expenseRequest',
                        ).toJson(),
                      ));
                } catch (e) {
                  showSnackbar(context, e.toString());
                  print('Error sending notification: ${e.toString()}');
                }
                Navigator.pop(
                    context, true); // Dismiss and refresh the previous page
              } else if (state is ExpenseError) {
                showSnackbar(context, state.message);
              }
            },
            child: Button(
              text: "Save",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedExpense = ExpenseModel(
                    id: widget.expense.id,
                    amount: int.tryParse(amountController.text) ?? 0,
                    description: descriptionController.text,
                    createdAt: selectedDateTime,
                    picture: _imageBase64,
                    status: _selectedStatus,
                  );

                  context
                      .read<ExpenseBloc>()
                      .add(UpdateExpenseEvent(updatedExpense));
                }
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Textfield(
                    hintText: "Amount",
                    controller: amountController,
                    isNumberField: true,
                  ),
                  const SizedBox(height: 20),
                  Textfield(
                    hintText: "Description",
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => _selectDateTime(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 10),
                              Text(
                                _formatDateTime(selectedDateTime),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => _showImagePickerOptions(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(width: 10),
                              Text(
                                'Add receipt',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 150, // Adjust this value to your preferred width
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                          items: <String>['approved', 'disapproved', 'pending']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                  value[0].toUpperCase() + value.substring(1)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 100),
                      if (_imageBytes != null)
                        GestureDetector(
                          onTap: () => _showFullScreenImage(context),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(_imageBytes!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      // This will push the dropdown and image to the left
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
