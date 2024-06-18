import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/error_text.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/firebase_options.dart';
import 'package:one/router.dart';
import 'package:one/update_page.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(
//   RemoteMessage message,
// ) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // await setupFlutterNotifications(); // removed due to redendency
//   // showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   debugPrint('Handling a background message ${message.messageId}');
// }

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

final navkey = GlobalKey<NavigatorState>(debugLabel: 'nav key');

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _MyAppState.handleLocalOpenApp,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  isFlutterLocalNotificationsInitialized = true;
}

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;

//   if (notification != null && android != null && !kIsWeb) {
//     debugPrint("showing flutter notif");
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           // icon: 'launch_background',
//           // icon: 'ic_launcher', // optional else AndroidInitializationSettings.defaultIcon will be used
//           // ongoing: true, // will not be cleared unitl open app
//           styleInformation: BigTextStyleInformation(notification.body ?? ''),
//         ),
//       ),
//       payload: jsonEncode(message.toMap()),
//     );
//   }
// }

late bool loginStatus;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class Environment {
  static const String clientId = String.fromEnvironment('clientId');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load(fileName: ".env");
  } else {}
  // loginStatus = await aadOAuth.hasCachedAccountInformation;
  // log('message');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    // await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // await setupFlutterNotifications();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  static void handleLocalOpenApp(NotificationResponse response) {
    // RemoteMessage message =
    //     RemoteMessage.fromMap(jsonDecode(response.payload ?? '{}'));
    // log(message.notification?.title ?? 'nono');
    // TODO add a condition to not display if sender-id is me
    // navkey.currentState!.push(MaterialPageRoute(
    //     builder: (context) => Notif(
    //           message: message,
    //         )));
  }

  UserModel? userModel;

  Future<void> getData(WidgetRef ref, User data, BuildContext context) async {
    try {
      if (ref.watch(userProvider) == null) {
        final a = await ref
            .watch(authRepositoryProvider)
            .getCurrentUserData(data.uid);
        if (a == null) {
          log("Account not found > logging out");
          await ref.watch(authControllerProvider.notifier).logout(ref);
        } else {
          userModel = await a.first;
        }
        ref.read(userProvider.notifier).update((state) => userModel);
        // setState(() {});
      } else {
        userModel = ref.read(userProvider);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  bool init = true;
  Future<void> getAppVersion() async {
    final yamlString = await rootBundle.loadString('pubspec.yaml');
    final parsedYaml = loadYaml(yamlString);
    try {
      final response = await http
          .get(Uri.parse("https://github.com/Gafoor2005/One/releases/latest"));
      // log(response.body.toString());
      var document = parser.parse(response.body);
      String letest = document
          .querySelector(
              '#repo-content-pjax-container > div > nav > ol > li.breadcrumb-item.breadcrumb-item-selected > a')!
          .innerHtml;
      letest = letest.split('v')[1].trim();
      // log(letest);
      // log(letest.length.toString());
      String us = parsedYaml['version'];
      us = us.split('+')[0];
      // // final String letest = presentYaml['version'];
      // log(us);
      // log(us.length.toString());
      // log(letest.compareTo(us).toString());
      if (letest.compareTo(us) == 1) {
        if (navkey.currentState != null) {
          navkey.currentState!.push(
              MaterialPageRoute(builder: (context) => const UpdatePage()));
        } else {
          Timer(const Duration(seconds: 5), () {
            navkey.currentState!.push(
                MaterialPageRoute(builder: (context) => const UpdatePage()));
          });
        }
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getAppVersion();
    });
  }

  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(authControllerProvider.notifier).addListener((state) {
      setState(() {
        isSigningIn = state;
      });
    });
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final connected = connectivity != ConnectivityResult.none;
        // final connected = false;
        if (connected) {
          return child;
        }
        return MaterialApp(
          builder: (context, child) => Scaffold(
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(microseconds: 500),
                child: connected
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: const BoxDecoration(
                          color: Colors.white60,
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(15),
                            width: connected ? 0 : 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: connected
                                  ? const Color(0xFF00EE44)
                                  : const Color(0xFFEE4400),
                            ),
                            duration: const Duration(milliseconds: 350),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: connected
                                  ? const SizedBox()
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'OFFLINE',
                                          style: TextStyle(
                                            fontFamily: "AlegreyaSans",
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        SizedBox(
                                          width: 12.0,
                                          height: 12.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
      child: ref.watch(authStateChangeProvider).when(
            data: (data) => MaterialApp.router(
              title: 'One app',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 0, 35, 68),
                ),
                scaffoldBackgroundColor: const Color(0xFAFFFFFF),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarColor:
                        Color.fromARGB(255, 234, 234, 234),
                  ),
                ),
              ),
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) {
                  if (data != null && !isSigningIn) {
                    getData(ref, data, context);
                    if (userModel != null) {
                      return loggedInRoute;
                    }
                  }
                  return loggedOutRoute;
                },
                navigatorKey: navkey,
              ),
              routeInformationParser: const RoutemasterParser(),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? topic) {
  _messageCount++;
  return jsonEncode({
    'message': {
      'topic': topic,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
      'android': {
        'direct_boot_ok': true,
      }
    },
  });
}
