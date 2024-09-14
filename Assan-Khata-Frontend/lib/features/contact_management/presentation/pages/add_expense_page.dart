import 'dart:convert';
import 'dart:io';

import 'package:assan_khata_frontend/core/utils/show_snackbar.dart';
import 'package:assan_khata_frontend/core/widgets/text_field.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/Button.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/expense_bloc_files/expense_bloc.dart';
import '../bloc/expense_bloc_files/expense_event.dart';
import '../bloc/expense_bloc_files/expense_state.dart';
import '../bloc/notification_bloc_files/notification_bloc.dart';
import '../bloc/notification_bloc_files/notification_event.dart';

class AddExpensePage extends StatefulWidget {
  final String selectedUserId;
  final String currentUserId;

  const AddExpensePage(
      {super.key, this.selectedUserId = "", this.currentUserId = ""});

  static route(final String selectedUserId, final String currentUserId) {
    return MaterialPageRoute(
      builder: (context) => AddExpensePage(
          selectedUserId: selectedUserId, currentUserId: currentUserId),
    );
  }

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final String title = 'Add Expense';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  File? _image;
  String? _imageBase64;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  ExpenseModel expense = const ExpenseModel();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now().subtract(Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
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
        _image = File(pickedFile.path);
      });

      // Convert image to base64 string
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        _imageBase64 = base64Image;
      });

      print("Image stored as base64 string. Length: ${_imageBase64!.length}");
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
    if (_image != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Receipt'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Image.file(_image!),
                const SizedBox(height: 20),
                Button(
                    text: "Remove",
                    onPressed: () {
                      setState(() {
                        _image = null;
                        _imageBase64 = null;
                        Navigator.pop(context);
                      });
                    })
              ]),
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
          title: const Text('Add Expense'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
              left: 50.0, right: 20.0, bottom: 20.0, top: 20.0),
          child: BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state is AddExpenseSuccess) {
                showSnackbar(context, 'Expense added successfully');
                try {
                  context.read<NotificationBloc>().add(NotificationSend(
                        notification: NotificationEntity(
                          message: 'added a new Expense',
                          senderId: expense.payer,
                          receiverId: expense.relatedUser,
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
                if (_formKey.currentState!.validate() &&
                    widget.selectedUserId != "" &&
                    widget.currentUserId != "") {
                  expense = ExpenseModel(
                    payer: widget.currentUserId,
                    relatedUser: widget.selectedUserId,
                    amount: int.parse(amountController.text.trim()),
                    description: descriptionController.text.trim(),
                    createdAt: selectedDateTime,
                    picture: _imageBase64,
                    type: "individual",
                  );
                  context.read<ExpenseBloc>().add(AddExpenseEvent(expense));
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
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Text(
                                _formatDateTime(selectedDateTime),
                                style: TextStyle(fontSize: 16),
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
                          child: Row(
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
                  if (_image != null)
                    GestureDetector(
                      onTap: () => _showFullScreenImage(context),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
