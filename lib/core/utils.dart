import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 276,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.black,
        content: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/error_circle.svg",
            ),
            Text(text),
          ],
        ),
      ),
    );
}
