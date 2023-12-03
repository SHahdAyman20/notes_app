import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/notification/notification.dart';
import 'package:instant_notes_app/screens/note/notes_page.dart';
import 'package:instant_notes_app/screens/started_screen.dart';
import 'package:instant_notes_app/shared_preference_singleton/shared_prefernce.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PreferenceUtils.init();
  NoteDatabase.init();
  initNotification();
  //FirebaseCrashlytics.instance.crash();

  FirebaseMessaging.instance.getToken()
      .then((value) {
    print('FCM Token =>$value');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print('Message also contained a notification: ${message.notification!.title}');
      print('Message also contained a notification: ${message.notification!.body}');

    }
    displayNotification(
        title: message.notification!.title!,
      body: message.notification!.body!,
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final color = const Color(0xff2E5962);

  @override
  void initState() {
    super.initState();

    if(Platform.isAndroid){
      requestAndroidPermission();
    }
    displayNotification(
      title: 'Hello!',
      body: 'Welcome you to NotesApp 📝❤',
    );
  }

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
