import 'package:flutter/material.dart';

Color primaryColor = const Color(0xff2E5962);

void showSnackBar({required String message}) {
  const context=BuildContext ;
  ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        padding:const EdgeInsets.all(10),
        content: Text(
          message,
          style:const TextStyle(fontSize: 17),
    ),
    backgroundColor: primaryColor,
  ));
}
