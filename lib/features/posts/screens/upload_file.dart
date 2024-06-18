import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/posts/controller/post_controller.dart';
import 'package:one/notif.dart';
import 'package:http/http.dart' as http;

class UploadFile extends ConsumerWidget {
  const UploadFile({super.key});

  Future<void> sendMessageToTopic(String title, String body, String pId,
      WidgetRef ref, List<String> tags) async {
    // Create a new FCM client.
    final UserModel user = ref.watch(userProvider)!;
    if (tags.isEmpty) return;
    String condition = "";
    if (tags.length == 1) {
      condition = '\'${tags[0]}\' in topics';
    } else {
      for (int i = 0; i < tags.length; i++) {
        if (i == tags.length - 1) {
          condition += '\'${tags[i]}\' in topics';
          continue;
        }
        condition += '\'${tags[i]}\' in topics || ';
      }
    }
    log(condition);
    final data = {
      // 'condition': '\'CSE\' in topics || \'allAlerts\' in topics',
      // 'to': '/topics/allAlerts',
      'condition': condition,
      'notification': {
        'title': title,
        'body': body,
      },
      // 'data': NotifPayload(
      //   pid: pId,
      //   uid: user.uid,
      //   profilePic:
      //       'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
      //   email: user.email,
      //   name: user.name,
      // ).toMap(),
    };

    String url = dotenv.env['FCM_LEGACY_API_POST_URI']!;
    try {
      print("data");
      print(jsonEncode(data));
      final result = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'key=${dotenv.env['FCM_LEGACY_API_AUTHORIZATION']}'
        },
      );
      print(jsonDecode(result.body));
      // return jsonDecode(result.body);
    } catch (e) {
      print(e);
      // return {'error': e};
    }
  }

  void onTap(WidgetRef ref, BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.extension);
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      final storageRef =
          FirebaseStorage.instance.ref('uploads/${time}.${file.extension}');
      log(file.toString());
      await storageRef.putData(file.bytes!);
      final attachment = await storageRef.getDownloadURL();

      final pid = await ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: "new file",
            description: "download to viwe flie",
            tags: ['everyone'],
            attachment: attachment,
          );
      sendMessageToTopic(
          'new file', 'download to viwe flie', pid, ref, ['everyone']);
    } else {
      log('not seleted photo');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("upload files"),
        elevation: 10,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () => onTap(ref, context),
                  icon: FaIcon(
                    FontAwesomeIcons.upload,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    'upload a file',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
