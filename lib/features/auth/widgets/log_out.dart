import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/main.dart';
import 'package:one/router.dart';

class LogOutButton extends ConsumerWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

  void logOut(WidgetRef ref) {
    loginStatus = false;
    if (ref.watch(userProvider)?.roles != null) {
      for (String topic in ref.watch(userProvider)!.roles!) {
        FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }
    }
    aadOAuth.logout();
    ref.read(RouteProvider.notifier).setRoute(loggedOutRoute);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Builder(builder: (context) {
        return ElevatedButton.icon(
          onPressed: () => logOut(ref),
          icon: const Icon(Icons.logout_sharp, color: Colors.blue),
          label: const Text(
            'LogOut',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 5,
          ),
        );
      }),
    );
  }
}
