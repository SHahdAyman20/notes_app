import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/screens/user_account/register/manager/register_cubit.dart';
import 'package:instant_notes_app/screens/user_account/register/manager/register_state.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationPasswordController = TextEditingController();


  bool obscureTextPassword = false;
  bool obscureTextConfirmation = true;

  final formKey = GlobalKey<FormState>();

  final cubit = RegisterCubit();

// controller always work in background waiting anything to happen
  // so that i should stop them when i close screen
  // the dispose function know mw the screen off

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmationPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) => onStateChange(state),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: Form(
            key: formKey,
            child: Expanded(
              child: ListView(
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
                            bottom: 20,
                            top: 10,
                          ),
                          child: CustomTextField(
                            maxLine: 1,
                            controller: nameController,
                            type: TextInputType.name,
                            action: TextInputAction.next,
                            hintText: 'Enter your name',
                            prefixIcon: const Icon(Icons.person),
                            validator: (name) {
                              if (name.isEmpty) {
                                return 'Please enter your name';
                              }
                            },
                          ),
                        ),
                        //phone number text field
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Phone Number ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: CustomTextField(
                            maxLine: 1,

                            controller: phoneController,
                            type: TextInputType.number,
                            action: TextInputAction.next,
                            maxLength: 11,
                            hintText: 'Enter your Phone Number',
                            prefixIcon: const Icon(Icons.phone),
                            validator: (phone) {
                              if (phone.isEmpty) {
                                return 'Please enter your number';
                              } else if (phone.length < 11) {
                                return 'complete your phone number!';
                              }
                            },
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
                            bottom: 20,
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            top: 10,
                          ),
                          child: CustomTextField(
                            maxLine: 1,

                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            action: TextInputAction.next,
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock),
                            obscureText: obscureTextPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                obscureTextPassword = !obscureTextPassword;
                                setState(() {});
                              },
                              icon: obscureTextPassword
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
                        //confirmation password text field
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            top: 10,
                          ),
                          child: CustomTextField(
                            maxLine: 1,

                            controller: confirmationPasswordController,
                            type: TextInputType.visiblePassword,
                            action: TextInputAction.done,
                            hintText: 'Confirm your password',
                            prefixIcon: const Icon(Icons.lock),
                            obscureText: obscureTextConfirmation,
                            suffixIcon: IconButton(
                              onPressed: () {
                                obscureTextConfirmation = !obscureTextConfirmation;
                                setState(() {});
                              },
                              icon: obscureTextConfirmation
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            validator: (pass) {
                              if (pass.isEmpty) {
                                return 'This field is required!';
                              } else if (pass.toString().length < 8) {
                                return 'this password too weak !';
                              } else if(pass != passwordController.text){
                                return 'please check your password!';
                              }
                            },
                          ),
                        ),
                        // sign up button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.79, 50),
                          ),
                          onPressed: () {
                            String email = emailController.text;
                            String password = passwordController.text;
              
                            //TODO
                            cubit.createUserWithEmailAndPassword(
                                email: email, password: password);
              
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                               color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onRegisterSuccess() {
    cubit.saveUserDate(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
    ); //TODO

    showSnackBar(message: 'Account Created Successfully');
    Navigator.pop(context);
  }

  void showSnackBar({required String message}) {
    //  const context=BuildContext ;
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

    if (state is RegisterSuccessState) {
      onRegisterSuccess();
    } else if (state is RegisterFailureState) {
      showSnackBar(message: state.errorMessage);
    }
  }
}
