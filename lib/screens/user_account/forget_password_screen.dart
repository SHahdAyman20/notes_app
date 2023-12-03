import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Forget Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 35, color: Colors.white),
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
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email),
                      validator: (email){
                        if(email.isEmpty){
                          return 'this field is required!';
                        }
                        else if(!email.toString().contains('@')){
                          return 'Email must contain "@" ';
                        }
                        else if(!email.toString().contains('.')){
                          return 'Email must contain "." ';
                        }
                      },
                    ),
                  ),
                  // reset password button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.79, 50),
                    ),
                    onPressed: () async {
                      if( formKey.currentState!.validate()){}
                      resetPassword();
                    },
                    child: const Text(
                      'Reset Password',
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
      ),
    );
  }

  void resetPassword() async {
    String email = emailController.text;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showPasswordResetDialog();
  }

  void showPasswordResetDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      title: 'Reset Password',
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      desc: ' Please check your Gmail 📧 and click on link 🔗 to reset the password\n',
      descTextStyle:const TextStyle(
        fontSize: 22,
      ),
    ).show();
  }
}
//*showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Reset Password',
//           style: TextStyle(
//             color: primaryColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//           ),
//         ),
//         content: const Text(
//           'Please check your Gmail 📧 and click on link 🔗 to reset the password',
//           style: TextStyle(
//             fontSize: 22,
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );*/