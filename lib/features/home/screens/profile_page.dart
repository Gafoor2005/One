import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // AuthCredential credential =AuthCredential(providerId: providerId, signInMethod: signInMethod)
            // final userCredential =
            //     await FirebaseAuth.instance.signInWithCredential(credential);
            // final user = userCredential.user;
            // print(user?.uid);
          },
          child: const Text("Google"),
        ),
      ),
    );
  }
}
