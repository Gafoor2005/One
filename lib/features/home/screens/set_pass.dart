import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/home/screens/api_controller.dart';
import 'package:routemaster/routemaster.dart';

class SetPassword extends ConsumerStatefulWidget {
  const SetPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetPasswordState();
}

class _SetPasswordState extends ConsumerState<SetPassword> {
  late TextEditingController t;
  bool isEmpty = true;
  @override
  void initState() {
    super.initState();
    t = TextEditingController();
    t.addListener(() {
      if (t.text.isEmpty != isEmpty) {
        setState(() {
          isEmpty = t.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    t.dispose();
  }

  void tap() {
    final mytext = t.text;

    t.clear();
    // log("tap");
    ref.watch(passProvider.notifier).update((state) => mytext);
    Routemaster.of(context).replace('/attendance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "enter ecap password",
              style: TextStyle(
                fontFamily: "BlackHanSans",
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(21),
              child: TextField(
                controller: t,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.black,
                    hintText: "we'll not share",
                    hintStyle: TextStyle(color: Colors.black12)),
                style: const TextStyle(fontFamily: "BlackHanSans"),
                textAlign: TextAlign.center,
                autofocus: true,
              ),
            ),
            ElevatedButton(
              onPressed: (isEmpty) ? null : () => tap(),
              child: const Text("Next"),
            )
          ],
        ),
      )),
    );
  }
}
