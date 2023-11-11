import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          // icon: Image.asset(
          //   'assets/google.png',
          //   width: 35,
          // ),
          icon: SvgPicture.asset(
            'assets/microsoft.svg',
            width: 35,
          ),
          label: const Text(
            'Login with Microsoft',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 5,
          ),
        );
      }),
    );
  }
}
