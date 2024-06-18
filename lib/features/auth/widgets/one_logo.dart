import 'package:flutter/material.dart';

class OneLogo extends StatelessWidget {
  const OneLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.black,
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: const Text(
            "1",
            style: TextStyle(
              fontFamily: "BlackHanSans",
              fontSize: 40,
              height: 0,
            ),
          ),
        ),
        Text(
          "NE",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 48,
            fontVariations: [
              FontVariation('ital', 0),
              FontVariation('slnt', 0),
              FontVariation('wght', 900)
            ],
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

// listening stream provider
// ref.watch(authStateChangeProvider).when(
//   data: (data) => Text(data.toString()),
//   error: (error, stackTrace) => Text('err: $error , stackTrace: $stackTrace'),
//   loading: () => const CircularProgressIndicator(),
// ),
