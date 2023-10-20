import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  // final bool isFromLogin;
  final VoidCallback onTap;
  const SignInButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  void signIn() {
    // print('tapped');
    onTap();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Builder(builder: (context) {
        return ElevatedButton.icon(
          onPressed: signIn,
          icon: Image.asset(
            'assets/google.png',
            width: 35,
          ),
          label: const Text(
            'Continue with Google',
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
