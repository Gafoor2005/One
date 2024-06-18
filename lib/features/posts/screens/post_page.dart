import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
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
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late MultiSelectController multiSelectController;
  List<String> tags = ['everyone'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    multiSelectController = MultiSelectController();
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
  Future<void> sendMessageToTopic(String title, String body, String pId) async {
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

  void addPost() async {
    if ((titleController.text != '') && (descriptionController.text != '')) {
      String title = titleController.text.trim().capitalize();
      String description = descriptionController.text.trim().capitalize();
      // sendPushMessage(
      //     titleController.text.trim(), descriptionController.text.trim());
      final pid = await ref.read(postControllerProvider.notifier).shareTextPost(
          context: context, title: title, description: description, tags: tags);
      sendMessageToTopic(title, description, pid);
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
                      : inputIndex == 1
                          ? SizedBox(
                              height: (constraints.maxHeight),
                              child: TextField(
                                autofocus: inputIndex == 1 ? true : false,
                                controller: descriptionController,
                                // scrollPadding: EdgeInsets.all(30),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                                maxLines: 50,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText: "enter sub title here",
                                  hintStyle:
                                      const TextStyle(color: Colors.white30),
                                  fillColor:
                                      const Color.fromRGBO(103, 65, 217, 1),
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
                          : Column(
                              children: [
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tags',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: constraints.maxWidth - 40,
                                  child: MultiSelectDropDown(
                                    // showClearIcon: true,
                                    controller: multiSelectController,
                                    onOptionSelected: (options) {
                                      List<String> res = [];
                                      for (ValueItem e in options) {
                                        res.add(e.value!);
                                      }
                                      tags = res;
                                      debugPrint(tags.toString());
                                    },
                                    options: const <ValueItem>[
                                      ValueItem(
                                          label: '@everyone',
                                          value: 'everyone'),
                                      ValueItem(
                                          label: '@Students', value: 'Student'),
                                      ValueItem(label: '@CE', value: 'CE'),
                                      ValueItem(label: '@EEE', value: 'EEE'),
                                      ValueItem(label: '@ME', value: 'ME'),
                                      ValueItem(label: '@ECE', value: 'ECE'),
                                      ValueItem(label: '@CSE', value: 'CSE'),
                                      ValueItem(label: '@IT', value: 'IT'),
                                      ValueItem(label: '@AIML', value: 'AIML'),
                                      ValueItem(label: '@AIDS', value: 'AIDS'),
                                      ValueItem(label: '@IOT', value: 'IOT'),
                                      ValueItem(
                                          label: '@20Batch', value: '20Batch'),
                                      ValueItem(
                                          label: '@21Batch', value: '21Batch'),
                                      ValueItem(
                                          label: '@22Batch', value: '22Batch'),
                                      ValueItem(
                                          label: '@23Batch', value: '23Batch'),
                                    ],
                                    // maxItems: 2,
                                    // disabledOptions: const [
                                    // ValueItem(label: 'Option 1', value: '1')
                                    // ],
                                    selectedOptions: const [
                                      ValueItem(
                                          label: '@everyone', value: 'everyone')
                                    ],
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    dropdownHeight: 400,
                                    optionTextStyle:
                                        const TextStyle(fontSize: 16),
                                    selectedOptionIcon:
                                        const Icon(Icons.check_circle),
                                  ),
                                ),
                              ],
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
          inputIndex == 1
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
              if (inputIndex < 2) {
                setState(() {
                  inputIndex++;
                });
              } else {
                // SystemChannels.textInput.invokeMethod('TextInput.hide');
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
