import 'package:flutter/material.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = false;

// controller always work in background waiting anything to happen
  // so that i should stop them when i close screen
  // the dispose function know mw the screen off

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Sign Up',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 45, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            padding: const EdgeInsets.only(
              top: 50,
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
                //name text field
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Name ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,top: 10,
                  ),
                  child: CustomTextField(
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    hintText: 'Enter your name',
                    prefixIcon:const Icon(Icons.person),
                  ),
                ),
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
                    bottom: 20,top: 10,
                  ),
                  child: CustomTextField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    hintText: 'Enter your email address',
                    prefixIcon:const Icon(Icons.email),
                  ),
                ),
                //password text field
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,top: 10,
                  ),
                  child: CustomTextField(
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    action: TextInputAction.done,
                    hintText: 'Enter password',
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
                  ),
                ),
                // sign up button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.79, 50),
                  ),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;

                    createUserWithEmailAndPassword(email: email, password: password);

                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      // color: Color(0xff656363)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createUserWithEmailAndPassword({
    required String email,
    required String password}) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackBar(
          context,
           message: 'Account Created Successfully');
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(
            context,
            message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context,
            message: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      showSnackBar(context, message: '$e');
    }
  }
}
