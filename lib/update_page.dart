import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Update Available',
                style: TextStyle(
                  fontFamily: 'BlackHanSans',
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                width: 250,
                child: Text(
                  "download latest version apk from assets in github releases",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://github.com/Gafoor2005/One/releases/latest"));
                  },
                  child: const Text("download")),
            ],
          ),
        ),
      ),
    );
  }
}
