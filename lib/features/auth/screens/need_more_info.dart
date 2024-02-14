import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:one/features/auth/widgets/large_button.dart';
import 'package:one/router.dart';
import 'package:routemaster/routemaster.dart';

class NeedMoreInfo extends ConsumerStatefulWidget {
  const NeedMoreInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NeedMoreInfoState();
}

class _NeedMoreInfoState extends ConsumerState<NeedMoreInfo> {
  late TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }

  bool isEnabled = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void onTap(MsUserModel userModel) {
    isEnabled = false;
    setState(() {});
    log("message");
    ref
        .watch(authRepositoryProvider)
        .setDisplayName(userModel, controller.text);
    ref.read(routeProvider.notifier).setRoute(loggedInRoute);
    Routemaster.of(context).replace('/');
  }

  final InputBorder? theBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 5, color: Color.fromRGBO(0, 0, 0, 0.69)),
    gapPadding: 1,
  );
  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = ref.watch(userProvider);
    return userModel != null
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text(
                      "setup your account",
                      style:
                          TextStyle(fontFamily: "BlackHanSans", fontSize: 24),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel.profilePic),
                      onBackgroundImageError: (exception, stackTrace) =>
                          showSnackBar(context, exception.toString()),
                      radius: 64,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'userModel.name',
                      style: TextStyle(fontFamily: "BlackHanSans"),
                    ),
                    Text(
                      userModel.email.split('@')[0],
                      style: const TextStyle(
                          fontFamily: "BlackHanSans", color: Colors.black26),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Enter Display name",
                          style: TextStyle(
                            fontFamily: "BlackHanSans",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: TextField(
                        enabled: isEnabled,
                        controller: controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'BlackHanSans'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(240, 240, 240, 1),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3),
                          hintText: "short name",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: theBorder,
                          border: theBorder,
                          focusedBorder: theBorder,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: LargeButton(
                        onTap: () {},
                        text: "Next <Disabled>",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text("No data found"),
          );
  }
}
