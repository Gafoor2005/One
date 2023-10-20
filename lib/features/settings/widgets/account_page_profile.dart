import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';

class AccountPageProfile extends ConsumerWidget {
  const AccountPageProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? userModel = ref.watch(userProvider);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(userModel!.profilePic),
            onBackgroundImageError: (exception, stackTrace) =>
                showSnackBar(context, exception.toString()),
            radius: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            userModel.name,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: _OtherInfo(),
          ),
        ],
      ),
    );
  }
}

class _OtherInfo extends ConsumerWidget {
  const _OtherInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel userModel = ref.watch(userProvider)!;
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
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              child: Text("Department"),
            ),
            Flexible(child: Text(userModel.department.name)),
          ],
        ),
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              child: Text("Section"),
            ),
            Flexible(child: Text(userModel.section.name)),
          ],
        ),
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              child: Text("Year"),
            ),
            Flexible(
                child: Text(
                    '${userModel.year.fromYear} - ${userModel.year.toYear}')),
          ],
        ),
      ],
    );
  }
}
