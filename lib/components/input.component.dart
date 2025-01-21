



import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  late final TextEditingController controller;
  final String title;
  final TextInputType inputType;
  bool? obscureText;
  TextCapitalization? textCapitalization;
  int? maxLength;

  InputComponent({required this.controller, required this.title, required this.inputType, this.obscureText, this.textCapitalization, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: inputType == TextInputType.multiline ? null : 1,
        obscureText: obscureText ?? false,
        cursorColor: Colors.white,
        maxLength: maxLength,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: title,
          // hintText: 'Enter text',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // Circular border
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // Circular border
            borderSide: BorderSide(
              color: Colors.grey, // Border color when enabled
              width: 1.5,
            ),
          ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Circular border
              borderSide: BorderSide(
                color: Colors.white, // Border color when focused
                width: 2.0,
              ),
            ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(color: Colors.grey)
        ),
      ),
    );
  }
}