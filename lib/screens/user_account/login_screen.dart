import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/screens/note/notes_page.dart';
import 'package:instant_notes_app/screens/user_account/forget_password_screen.dart';
import 'package:instant_notes_app/screens/user_account/register_screen.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = false;

  final emailController= TextEditingController();
  final passwordController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: primaryColor,
        body: ListView(children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Welcome',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign In',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            padding: const EdgeInsets.only(
              top: 60,
              left: 25,
              right: 25,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
                children: [
              //email text field
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Email ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(
                    bottom: 30,top: 10,
                  ),
                  child: CustomTextField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    hintText: 'Enter your email address',
                    prefixIcon:const Icon(Icons.email),
                  ),),
              //password text field
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Password',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 30,top: 10,),
                  child: CustomTextField(
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    action: TextInputAction.done,
                    hintText: 'Enter your password',
                    prefixIcon:const Icon(Icons.lock),
                    obscureText: obscureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        obscureText = !obscureText;
                        setState(() {});
                      },
                      icon: obscureText
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),),
              // forget password ?
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff656363),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ForgetPassword(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // sign in button
              ElevatedButton(
                  onPressed: () {
                    signInWithEmailAndPassword();
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize:
                  Size(MediaQuery.of(context).size.width * 0.79, 50),
                ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      // color: Color(0xff656363)
                    ),
                  ),

              ),
              const SizedBox(
                height: 40,
              ),
              // if you don't have an account sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff2E5962)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterScreen(),
                          ));
                    },
                  ),
                ],
              ),
            ],),
          ),
        ],
        ),
    );
  }
// ...

  void signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showSnackBar(context, message: 'Signed In Successfully ✔️');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const NotesPage()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, message: 'No user found for that email!');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, message: 'Wrong password provided for that user!');
      } else {
        showSnackBar(context, message: 'Invalid Log In');
      }
    } catch (e) {
      print(e);
      showSnackBar(context, message: 'Error signing in: $e');
    }
  }

// ...
}
