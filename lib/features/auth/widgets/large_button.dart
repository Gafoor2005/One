import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LargeButton extends ConsumerWidget {
  final VoidCallback onTap;
  final String text;
  const LargeButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  void tap() {
    onTap();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: tap,
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: 'BlackHanSans'),
        ),
      );
    });
  }
}
