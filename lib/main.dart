import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/screens/note/notes_page.dart';
import 'package:instant_notes_app/screens/started_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final color = const Color(0xff2E5962);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: color,
          secondary: color,
        ),
      ),
      home: FirebaseAuth.instance.currentUser == null?
       const StartedScreen()
          :
      const NotesPage(),
    );
  }
}
