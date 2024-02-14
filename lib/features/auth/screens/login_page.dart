import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/features/auth/widgets/large_button.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// FirebaseAuth firebaseAuth =
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  /// ### this handles signin and navigation to hame page if success
  void signInWithMicrosoft(BuildContext context, WidgetRef ref) async {
    // ref.read(authControllerProvider.notifier).signInWithMicrosoft(context);

    // firebaseAuth.tenantId = "df7217c9-cec8-4cc2-8e6a-a1cfbfadb321";

    ref.read(authControllerProvider.notifier).signInWithMS(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    aadOAuth.hasCachedAccountInformation.then((value) => log(value.toString()));
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Loader()
            : SafeArea(
                child: Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/logo.jpg"),
                            radius: 30,
                          ),
                          const ColoredBox(
                            color: Colors.black,
                            child: SizedBox(
                              height: 40,
                              width: 2,
                            ),
                          ),
                          Image.asset(
                            "assets/devloopers.png",
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      child: Text(
                        "1",
                        style: TextStyle(
                          fontFamily: "BlackHanSans",
                          fontSize: 100,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "One App",
                      style: TextStyle(
                        fontFamily: "BlackHanSans",
                        fontSize: 24,
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: LargeButton(
                        text: "Sign in",
                        onTap: () {
                          signInWithMicrosoft(context, ref);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

// listening stream provider
// ref.watch(authStateChangeProvider).when(
//   data: (data) => Text(data.toString()),
//   error: (error, stackTrace) => Text('err: $error , stackTrace: $stackTrace'),
//   loading: () => const CircularProgressIndicator(),
// ),
