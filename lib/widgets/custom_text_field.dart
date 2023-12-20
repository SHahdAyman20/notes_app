import 'package:flutter/material.dart';
import 'package:instant_notes_app/const_functions/const.dart';
// i made this class to refactor the code cuz i will make 4 text field
// and now i won't be forced to write the same code of text field 4 timed
// i will just call class 4 times in 4 lines 🤩
class CustomTextField extends StatelessWidget {

  TextInputType type;
  TextInputAction action;
  IconButton? suffixIcon;
  Icon? prefixIcon;
  bool obscureText;
  String hintText;
  TextEditingController controller;
  final  maxLength;
  final  enable;
  FormFieldValidator? validator;
  int? maxLine;

  CustomTextField(
      {super.key,
        required this.type,
        required this.action,
        this.suffixIcon,
        this.obscureText=false,
        required this.hintText,
         required this.controller,
         this.prefixIcon,
         this.validator,
        this.maxLength,
        this.enable,
        required this.maxLine
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
      maxLines: maxLine,
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor), //<-- SEE HERE
          ),
        border:const OutlineInputBorder()
      ),
    );
  }
}
