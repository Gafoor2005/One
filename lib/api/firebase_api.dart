// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print("0000000000000000000000000000000000000000000");
//   print("title: ${message.notification?.title}");
//   print("body: ${message.notification?.body}");
//   print("data: ${message.data}");

//   // navigatorKey.currentState?.pushNamed(
//   //   '/notif',
//   //   arguments: message,
//   // );
// }

// class FirebaseApi extends StatelessWidget {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   void handleMessage(RemoteMessage? message) {
//     print("000000000000000000000000000000000000000000011");
//     if (message == null) return;

//     Router.;
//   }

//   Future initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   }

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token: $fCMToken');
//     await initPushNotifications();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
