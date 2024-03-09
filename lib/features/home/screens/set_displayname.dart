import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SetDisplayName extends ConsumerStatefulWidget {
  const SetDisplayName({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetDisplayNameState();
}

class _SetDisplayNameState extends ConsumerState<SetDisplayName> {
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
    log("tap");
    ref.watch(authControllerProvider.notifier).setDisplayName(mytext);
    Routemaster.of(context).pop();
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
              "set Display Name",
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
                    hintText: "a short name",
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
