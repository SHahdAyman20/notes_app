import 'package:flutter/material.dart';
// i made this class to refactor the code cuz i will make 4 text field
// and now i won't be forced to write the same code of text field 4 timed
// i will just call class 4 times in 4 lines 🤩
class CustomTextField extends StatelessWidget {

  TextInputType type;
  TextInputAction action;
  IconButton? suffixIcon;
  Icon prefixIcon;
  bool obscureText;
  String hintText;
  final controller;
  final maxLength;
  final enable;
  FormFieldValidator? validator;

  CustomTextField(
      {super.key,
        required this.type,
        required this.action,
        this.suffixIcon,
        this.obscureText=false,
        required this.hintText,
         this.controller,
        required this.prefixIcon,
         this.validator,
        this.maxLength,
        this.enable
      });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      enabled: enable,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: type,
      textInputAction: action,
      maxLength: maxLength,
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border:const OutlineInputBorder()
      ),
    );
  }
}
