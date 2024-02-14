import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/features/home/screens/home_page.dart';
import 'package:one/features/settings/screens/account_page.dart';
import 'package:one/notif.dart';
import 'package:routemaster/routemaster.dart';

import 'chat_page.dart';
import 'library_page.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<HomeFrame> createState() => _HomeFrameState();
}

class _HomeFrameState extends ConsumerState<HomeFrame> {
  int currentIndex = 0;
  void setCurrentIndex(int i) {
    setState(() {
      currentIndex = i;
    });
  }

  // void a() async {
  //   String? b = await aadOAuth.getAccessToken();
  //   log(b!);
  // }

  // String? _token;
  String? initialMessage;
  // ignore: unused_field
  bool _resolved = false;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) => setState(
            () {
              if (message == null) return;
              _resolved = true;
              initialMessage = message.data.toString();
              // ref.read(messageArgumentsProvider.notifier).update((state) =>
              //     MessageArguments(message: message, openedApplication: true));
              // Routemaster.of(context).push('/notif');
              final data = NotifPayload.fromMap(message.data);
              Routemaster.of(context).push('post/${data.pid}');
            },
          ),
        );

    FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.onMessage.listen((message) {
      // showFlutterNotification(message);
      log('new message reciveed in foreground');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
      print("message : ${message.data}");
      // ref
      //     .read(messageArgumentsProvider.notifier)
      //     .update((state) => MessageArguments(
      //           message: message,
      //           openedApplication: true,
      //         ));
      // Routemaster.of(context).push('/notif');
      final data = NotifPayload.fromMap(message.data);
      Routemaster.of(context).push('post/${data.pid}');
    });
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
        }
        break;
      case 'unsubscribe':
        {
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            print(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // a();
    // Routemaster.of(context).push('/more-info');
    aadOAuth.hasCachedAccountInformation.then((value) => log(value.toString()));
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        width: 280,
        backgroundColor: Color.fromARGB(255, 245, 255, 237),
        child: SafeArea(
          child: Column(
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  ListTile(
                    onTap: () {
                      Routemaster.of(context).push('/add-news');
                    },
                    title: Text(
                      'add News',
                      style: TextStyle(fontFamily: "AlegreyaSans"),
                    ),
                    leading: Icon(Icons.newspaper),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text(
                      'News',
                      style: TextStyle(fontFamily: "AlegreyaSans"),
                    ),
                    leading: Icon(Icons.newspaper),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text(
                      'Events',
                      style: TextStyle(fontFamily: "AlegreyaSans"),
                    ),
                    leading: Icon(Icons.event),
                  ),
                  ListTile(
                    title: Text('clubs'),
                  ),
                  ListTile(
                    title: Text('library'),
                  ),
                  ListTile(
                    title: Text('feed back'),
                  ),
                  ListTile(
                    title: Text('about'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IndexedStack(
            index: currentIndex,
            children: const [
              // AlertsPage(),
              HomePage(),
              ChatPage(),
              LibraryPage(),
              AccountPage(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 21,
              right: 21,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            clipBehavior: Clip.hardEdge,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                currentIndex: currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                type: BottomNavigationBarType.fixed,
                // selectedItemColor: Colors.white,
                items: [
                  navItem('home'),
                  navItem('chat'),
                  navItem('library'),
                  navItem('person'),
                ],
                onTap: (value) {
                  if (currentIndex != value) {
                    setCurrentIndex(value);
                  }
                },
                enableFeedback: true,
              ),
            ),
          ),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 8,
      //   currentIndex: currentIndex,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   selectedFontSize: 0,
      //   unselectedFontSize: 0,
      //   // backgroundColor: Colors.grey.shade300,
      //   // backgroundColor: Colors.white,
      //   selectedItemColor: Colors.white,
      //   items: [
      //     navItem(Icons.home_rounded, 'home'),
      //     navItem(Icons.person, 'you'),
      //   ],
      //   onTap: (value) {
      //     if (currentIndex != value) {
      //       setCurrentIndex(value);
      //     }
      //   },
      //   enableFeedback: true,
      // ),
    );
  }

  BottomNavigationBarItem navItem(String icon) => BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          'assets/icons/${icon}_filled.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        icon: SvgPicture.asset(
          'assets/icons/$icon.svg',
          colorFilter: const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
        ),
        label: icon,
      );
}
