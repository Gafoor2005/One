import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/posts/controller/post_controller.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:one/notif.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  final InputBorder myInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(0),
    borderSide: const BorderSide(
      style: BorderStyle.none,
      color: Colors.white70,
      width: 2,
    ),
  );

  /// This function uses the new ``HTTP v1 api``
  ///
  /// you need an `OAuth token` to send messages through this api.
  /// OAuth access token is passed in header of http request as Authorization : ``'Bearer <OAuth access token>'``
  ///
  /// you can find the OAuth token in `OAuth playground website` https://developers.google.com/oauthplayground
  ///
  /// the OAuth Access tokens will ``expire after 24hrs`` (or after some time)
  ///
  /// so, there is a `refresh token to generate a new OAuth access token`. these refresh tokens do not expire easily
  ///
  /// but i did'nt found any way to regenerate OAuth tokens in flutter
  Future<void> sendPushMessage(String title, String body) async {
    // if (_token == null) {
    //   print('Unable to send FCM message, no token exists.');
    //   return;
    // }
    // String? _token = await FirebaseMessaging.instance.getToken();
    String accessToken = dotenv.env['FCM_OAUTH_ACCESS_TOKEN']!;
    final data = {
      "message": {
        "topic": "allAlerts",
        "data": {"via": "FlutterFire Cloud Messaging!!!", "count": "HELLO"},
        "notification": {"title": title, "body": body},
        "android": {"direct_boot_ok": true}
      }
    };
    try {
      await http.post(
        Uri.parse(dotenv.env['FCM_HTTP_V1_API_POST_URI']!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  /// this function is using the old depricated `fcm legacy api`
  ///
  /// the support for this will be removed by google on ``june 2024``
  ///
  /// you only need a `server key for authentication` as ``key=<serverkey>``
  /// this server key can be found on firebase console under cloud messaging section.
  Future<void> sendMessageToTopic(String title, String body) async {
    // Create a new FCM client.
    final UserModel user = ref.watch(userProvider)!;

    final data = {
      'to': '/topics/allAlerts',
      'notification': {
        'title': title,
        'body': body,
      },
      'data': NotifPayload(
              uid: user.uid,
              profilePic: user.profilePic,
              email: user.email,
              name: user.name)
          .toMap(),
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

  void addPost() {
    if ((titleController.text != '') && (descriptionController.text != '')) {
      String title = titleController.text.trim().capitalize();
      String description = descriptionController.text.trim().capitalize();
      // sendPushMessage(
      //     titleController.text.trim(), descriptionController.text.trim());
      sendMessageToTopic(title, description);
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: title,
            description: description,
          );
    } else {
      showSnackBar(context, "fill the fields");
    }
  }

  int inputIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.blue.shade500,
      ),
      backgroundColor: const Color.fromARGB(255, 161, 141, 219),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //   child: Text(
                  //     "Post",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 25,
                  //     ),
                  //   ),
                  // ),
                  inputIndex == 0
                      ? SizedBox(
                          height: (constraints.maxHeight),
                          child: TextField(
                            autofocus: inputIndex == 0 ? true : false,
                            controller: titleController,
                            scrollPadding: const EdgeInsets.all(30),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                ),
                            maxLines: 50,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Enter Title",
                              hintStyle: const TextStyle(color: Colors.white30),
                              fillColor: const Color.fromRGBO(103, 65, 217, 1),
                              focusColor: Colors.white,
                              filled: true,
                              focusedBorder: myInputBorder,
                              enabledBorder: myInputBorder.copyWith(),
                              border: myInputBorder.copyWith(),
                              contentPadding: const EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 20,
                                bottom: 0,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: (constraints.maxHeight),
                          child: TextField(
                            autofocus: inputIndex == 1 ? true : false,
                            controller: descriptionController,
                            // scrollPadding: EdgeInsets.all(30),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                            maxLines: 50,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "enter sub title here",
                              hintStyle: const TextStyle(color: Colors.white30),
                              fillColor: const Color.fromRGBO(103, 65, 217, 1),
                              focusColor: Colors.white,
                              filled: true,
                              focusedBorder: myInputBorder,
                              enabledBorder: myInputBorder.copyWith(),
                              border: myInputBorder.copyWith(),
                              contentPadding: const EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 20,
                                bottom: 0,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inputIndex != 0
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      inputIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.square(50),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const FaIcon(FontAwesomeIcons.arrowLeft),
                )
              : const SizedBox(),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (inputIndex < 1) {
                setState(() {
                  inputIndex++;
                });
              } else {
                addPost();
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.square(50),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const FaIcon(FontAwesomeIcons.arrowRight),
          ),
        ],
      ),
    );
  }
}
