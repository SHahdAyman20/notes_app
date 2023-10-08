import 'package:flutter/material.dart';
import 'package:instant_notes_app/screens/note/notes_page.dart';
import 'package:instant_notes_app/screens/user_account/login_screen.dart';

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
          alignment: const Alignment(0, 0.85),
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
                  MediaQuery.of(context).size.width * 0.7,
                  60,
              ),
             // backgroundColor: const Color(0xff4678FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
            ),
            child: const Text(
              'Get Started  ➡️',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
