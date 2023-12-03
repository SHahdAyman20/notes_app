import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// now i created this object =>flutterLocalNotificationsPlugin
// and will use it in all app
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

 void initNotification() async {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
   // initialize Settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  // initialize Settings for IOS
  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings();
  // collect in it all initialization for all platforms
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      );

  await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
  );

  if(Platform.isAndroid){
    requestAndroidPermission();

  }
  if(Platform.isAndroid){
    requestIosPermission();
  }
}

 void displayNotification({required String title,required String body}) async{
   const AndroidNotificationDetails androidNotificationDetails =
// this is android channel => responsible for slice notifications for
   //categories .. for example in facebook, there is categories in notifications
   // likes/comments/shares/lives/..etc , and this benefit for if i get bored
   // from likes category and did block notifications, i will block just 1 category

   // in this i determine the priority for the notification i want
   // and if i haven't, i will make it default
   AndroidNotificationDetails(
     'default',
     'Default channel ',
       channelDescription: 'your channel description',
       importance: Importance.max,
       priority: Priority.high,
   );

   const NotificationDetails notificationDetails =
   NotificationDetails(android: androidNotificationDetails);
   await flutterLocalNotificationsPlugin.show(
       title.hashCode + body.hashCode,
       title,
       body,
       notificationDetails,
   );
 }

 void requestAndroidPermission(){
// call the flutter plugin and tell it to =>resolvePlatformSpecificImplementation
 //and make AndroidFlutterLocalNotificationsPlugin & requestNotificationsPermission
   flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.requestNotificationsPermission();
 }

void requestIosPermission() async {
// call the flutter plugin and tell it to =>resolvePlatformSpecificImplementation
  //and make IOSFlutterLocalNotificationsPlugin & requestPermissions

   await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(sound: true,);
}
