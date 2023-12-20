import 'package:flutter/material.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/screens/user_account/login/page/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StartedScreen extends StatefulWidget {
  const StartedScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StartedScreenState();
  }
}

class StartedScreenState extends State<StartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
        Image.asset(
          'assets/started screen.png',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Align(
          alignment:  Alignment(0, 0.85.sp),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.7.sp,
                  60.sp,
              ),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
            ),
            child: Text(
              'Get Started ➡',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),
            ),
          ),
        )
      ]),
    );
  }
}
