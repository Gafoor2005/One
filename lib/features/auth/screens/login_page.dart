import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/features/auth/widgets/sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void signInWithMicrosoft(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithMicrosoft(context);

    // ref.read(authControllerProvider).signInWithGoogle(context);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(authProvider).authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });

    final isLoading = ref.watch(authControllerProvider);
    // late final User? loginStatus;
    // ref.watch(authStateChangeProvider).whenData((value) => loginStatus = value);

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
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/logo.jpg"),
                      radius: 100,
                    ),
                    const Spacer(),
                    SignInButton(onTap: () {
                      signInWithMicrosoft(context, ref);
                    }),

                    // const LogOutButton(),
                    // Text(
                    //   loginStatus == null
                    //       ? "Loged Out"
                    //       : "logged in as ${loginStatus!.email}",
                    // ),
                    const Spacer(
                      flex: 2,
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