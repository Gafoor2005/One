import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/widgets/sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

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

    return Scaffold(
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Column(
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Image.asset("assets/logo.jpg"),
                  const Spacer(),
                  const SignInButton(),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
    );
  }
}
