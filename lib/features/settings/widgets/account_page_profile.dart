import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class AccountPageProfile extends ConsumerStatefulWidget {
  const AccountPageProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountPageProfileState();
}

class _AccountPageProfileState extends ConsumerState<AccountPageProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('innnit');
  }

  bool dropdown = false;
  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = ref.watch(userProvider);
    return userModel != null
        ? Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8).copyWith(bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Colors.blue.shade50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel.profilePic),
                      onBackgroundImageError: (exception, stackTrace) =>
                          showSnackBar(context, exception.toString()),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _UserTile(),
                    ),
                    (userModel.displayName != null)
                        ? const SizedBox()
                        : IconButton.filledTonal(
                            onPressed: () {
                              Routemaster.of(context).push('/set-displayname');
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.pen,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          dropdown = !dropdown;
                        });
                      },
                      icon: FaIcon(
                        (dropdown)
                            ? FontAwesomeIcons.circleChevronUp
                            : FontAwesomeIcons.circleChevronDown,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                dropdown
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 25,
                          ),
                          const Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userModel.name,
                            style: TextStyle(
                              fontSize: (userModel.name.length > 30) ? 12 : 15,
                              fontFamily: "NotoSans",
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userModel.email,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "NotoSans",
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 18,
                ),
                (userModel.roles != null)
                    ? Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        runSpacing: 10,
                        children: [
                          for (String e in userModel.roles!)
                            (e != 'everyone')
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      e,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  )
                                : const SizedBox(),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          )
        : const Center(
            child: Text("Login to account"),
          );
  }
}

class _UserTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userModel = ref.watch(userProvider)!;
    // log("render");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userModel.displayName != null
            ? Text(
                userModel.displayName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "AlegreyaSans",
                ),
              )
            : const Text(
                "No name",
                style: TextStyle(color: Colors.black45),
              ),
        Text(
          userModel.rollNO,
          style: const TextStyle(
            fontFamily: "Monospace",
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _OtherInfo extends ConsumerWidget {
  const _OtherInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userModel =
        ref.watch(userProvider as ProviderListenable<UserModel>);

    return Column(
      children: [
        // TextButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(Icons.email),
        //   label: Text(userModel!.email),
        // ),
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              child: Text("Roll NO"),
            ),
            Flexible(child: Text(userModel.rollNO)),
          ],
        ),
        const Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text("Department"),
            ),
            Flexible(child: Text("userModel.department.name")),
          ],
        ),
        const Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text("Section"),
            ),
            Flexible(child: Text("userModel.section.name")),
          ],
        ),
        const Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text("Year"),
            ),
            Flexible(child: Text("hello")),
          ],
        ),
      ],
    );
  }
}
