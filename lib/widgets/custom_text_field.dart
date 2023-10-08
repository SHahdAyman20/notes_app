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


  CustomTextField(
      {super.key,
        required this.type,
        required this.action,
        this.suffixIcon,
        this.obscureText=false,
        required this.hintText,
         this.controller,
        required this.prefixIcon
      });

  @override
  Widget build(BuildContext context) {
    return  TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      textInputAction: action,
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border:const OutlineInputBorder()
      ),
    );
  }
}
