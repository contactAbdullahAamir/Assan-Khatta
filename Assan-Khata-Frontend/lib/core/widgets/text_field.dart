import 'package:flutter/material.dart';

import '../theme/app_pallete.dart';

class Textfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPasswordField;
  final bool isNumberField;

  const Textfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPasswordField = false,
    this.isNumberField = false,
  });

  @override
  _TextfieldState createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField ? _isObscured : false,
      keyboardType:
          widget.isNumberField ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: AppPallete.tertiaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.all(20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppPallete.tertiaryTextColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPallete.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '${widget.hintText} cannot be empty';
        }
        return null;
      },
    );
  }
}
