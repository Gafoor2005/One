import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/auth/screens/login_page.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyPage extends ConsumerStatefulWidget {
  const PolicyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PolicyPageState();
}

class _PolicyPageState extends ConsumerState<PolicyPage> {
  String body = '';
  void loadStr() async {
    body = await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SvgPicture.asset(
                  'assets/icons/privacy-policy.svg',
                ),
              ),
              const Text(
                "OneApp privacy policy",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'AlegreyaSans',
                ),
              ),
              (body.isEmpty)
                  ? const SizedBox(width: 100, height: 100, child: Loader())
                  : Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Text(
                            body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    'mailto:developers@gecgudlavallerumic.in'));
                              },
                              child: Text(
                                "developers@gecgudlavallerumic.in",
                                style: TextStyle(
                                  fontFamily: "NotoSans",
                                  color: Colors.blue.shade900,
                                  fontSize: 12,
                                ),
                              )),
                        ],
                      ),
                    ),
              Wrap(
                spacing: 20,
                children: [
                  TextButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse(
                          "https://github.com/Gafoor2005/One/blob/main/PRIVACY-POLICY.md"));
                    },
                    child: const Text("Privacy Policy"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .watch(acceptedPolicyProvider.notifier)
                          .update((state) => true);
                      Routemaster.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text("agree"),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
