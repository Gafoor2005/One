import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LargeButton extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final String? buttonIcon;
  const LargeButton(
      {super.key, required this.onTap, required this.text, this.buttonIcon});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LargeButtonState();
}

class _LargeButtonState extends ConsumerState<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox(
        width: 276,
        height: 62,
        child: TextButton(
          onPressed: widget.onTap,
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 35, 21, 192),
            disabledBackgroundColor: const Color(0xFFDEDEDE),
            // backgroundColor: isDisabled
            //     ? const Color(0xFFDEDEDE)
            //     : const Color.fromARGB(255, 35, 21, 192),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.buttonIcon != null
                  ? SizedBox(
                      width: 20,
                      child: SvgPicture.asset(
                        "assets/icons/${widget.buttonIcon}.svg",
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: widget.buttonIcon != null ? 10 : 0,
              ),
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontVariations: [
                    FontVariation('ital', 0),
                    FontVariation('slnt', 0),
                    FontVariation('wght', 800)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
