import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/api_controller.dart';
import 'package:one/features/home/screens/bio.dart';

class BioPage extends ConsumerStatefulWidget {
  const BioPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BioPageState();
}

class _BioPageState extends ConsumerState<BioPage> {
  void getBio(BuildContext context) {
    ref
        .watch(apiControllerProvider.notifier)
        .getBio(context, ref.watch(userProvider)!.rollNO);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Bio? bio = ref.watch(bioProvider);
    if (bio != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Bio"),
          elevation: 2,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(bio.name),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                // padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade50,
                ),
                clipBehavior: Clip.antiAlias,
                child: const Wrap(spacing: 10, runSpacing: 2, children: []),
              ),
            ],
          ),
        ),
      );
    } else {
      getBio(context);
      return const Scaffold(
        body: Center(child: Text("loading")),
      );
    }
  }
}
