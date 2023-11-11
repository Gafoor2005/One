// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

import 'package:one/core/common/loader.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/features/auth/controller/auth_controller.dart';

import 'core/common/user_tile.dart';

class NotifPayload {
  final String pid;
  final String name;
  final String uid;
  final String profilePic;
  final String email;
  NotifPayload({
    required this.pid,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.email,
  });

  NotifPayload copyWith({
    String? pid,
    String? name,
    String? uid,
    String? profilePic,
    String? email,
  }) {
    return NotifPayload(
      pid: pid ?? this.pid,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'email': email,
    };
  }

  factory NotifPayload.fromMap(Map<String, dynamic> map) {
    return NotifPayload(
      pid: map['pid'] as String,
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotifPayload.fromJson(String source) =>
      NotifPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotifPayload(pid: $pid, name: $name, uid: $uid, profilePic: $profilePic, email: $email)';
  }

  @override
  bool operator ==(covariant NotifPayload other) {
    if (identical(this, other)) return true;

    return other.pid == pid &&
        other.name == name &&
        other.uid == uid &&
        other.profilePic == profilePic &&
        other.email == email;
  }

  @override
  int get hashCode {
    return pid.hashCode ^
        name.hashCode ^
        uid.hashCode ^
        profilePic.hashCode ^
        email.hashCode;
  }
}

final messageArgumentsProvider =
    StateProvider<MessageArguments?>((ref) => null);

class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  MessageArguments({
    required this.message,
    required this.openedApplication,
  });
}

class Notif extends ConsumerStatefulWidget {
  final RemoteMessage? message;
  const Notif({
    super.key,
    this.message,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotifState();
}

class _NotifState extends ConsumerState<Notif> {
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  late UserModel sender;
  void getSenderInfo(NotifPayload payload) {
    ref.watch(getUserDataProvider(payload.uid)).whenData((data) {
      sender = data;
      print('watched $sender');
      if (isLoading) {
        isLoading = false;
        setState(() {});
      }
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    late RemoteMessage message;
    if (widget.message == null) {
      message = ref.watch(messageArgumentsProvider)!.message;
    } else {
      message = widget.message!;
    }

    NotifPayload? payload;
    payload = NotifPayload.fromMap(message.data);
    getSenderInfo(payload);
    print('watch compled');
    print('payload ${payload.uid}');

    return isLoading
        ? const Loader()
        : Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              titleSpacing: 0,

              leading: IconButton(
                onPressed: () => Routemaster.of(context).pop(),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 40,
                ),
              ),
              leadingWidth: 55,
              title: UserTile(user: sender),
              // backgroundColor: Colors.grey.shade200,
              elevation: 20,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 20,
                      child: calculateDifference(message.sentTime!) == 0
                          ? Text(
                              'Today',
                              style: Theme.of(context).textTheme.labelSmall,
                            )
                          : const Text("not Today"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(payload.profilePic),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sender.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              sender.rollNO,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(
                      //       blurRadius: 20,
                      //       spreadRadius: -16,
                      //       offset: Offset(2, 3))
                      // ],
                      border: Border.all(width: 2, color: Colors.black12),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${message.notification?.title} ",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              "${message.notification?.body} ",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: const Color.fromARGB(255, 18, 97, 0),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          DateFormat('jm')
                              .format(message.sentTime!)
                              .toLowerCase(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
