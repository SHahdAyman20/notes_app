import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/screens/note/page/notes_page.dart';
import 'package:instant_notes_app/screens/user_account/forget_password_screen.dart';
import 'package:instant_notes_app/screens/user_account/login/manager/login_cubit.dart';
import 'package:instant_notes_app/screens/user_account/login/manager/login_state.dart';
import 'package:instant_notes_app/screens/user_account/register/screen/register_screen.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool obscureText = false;

  final cubit = LoginCubit();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) => onStateChange(state),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: Form(
            key: formKey,
            child: ListView(
              children: [
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
                          bottom: 30,
                          top: 10,
                        ),
                        child: CustomTextField(
                          maxLine: 1,
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          action: TextInputAction.next,
                          hintText: 'Enter your email address',
                          prefixIcon: const Icon(Icons.email),
                          validator: (email) {
                            if (email.isEmpty) {
                              return 'this field is required!';
                            } else if (!email.toString().contains('@')) {
                              return 'Email must contain "@" ';
                            } else if (!email.toString().contains('.')) {
                              return 'Email must contain "." ';
                            }
                          },
                        ),
                      ),
                      //password text field
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                          top: 10,
                        ),
                        child: CustomTextField(
                          controller: passwordController,
                          maxLine: 1,
                          type: TextInputType.visiblePassword,
                          action: TextInputAction.done,
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
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
                          validator: (pass) {
                            if (pass.isEmpty) {
                              return 'This field is required!';
                            } else if (pass.toString().length < 8) {
                              return 'this password too weak !';
                            }
                          },
                        ),
                      ),
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
                          cubit.signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            pass: passwordController.text.trim(),
                          );
                          if (formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.79, 50),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                             color: Colors.white
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
                                  color: Color(0xff2E5962)),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navToNotesScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const NotesPage()),
      (route) => false,
    );
  }

  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(10),
      content: Text(
        message,
        style: const TextStyle(fontSize: 17),
      ),
      backgroundColor: primaryColor,
    ));
  }

  void onStateChange(state) {
    print('state ==> $state');
    print('state ==> ${state.runtimeType}');

    if (state is LoginSuccessState) {
      showSnackBar(message: state.successMessage);
      navToNotesScreen();
    } else if (state is LoginFailureState) {
      showSnackBar(message: state.errorMessage);
    }
  }
}
