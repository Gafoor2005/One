import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';

class AccountPageProfile extends ConsumerWidget {
  const AccountPageProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MsUserModel userModel = ref.watch(userProvider) ??
        MsUserModel(
            id: 'id',
            userPrincipalName: 'userPrincipalName',
            displayName: 'displayName',
            givenName: 'givenName',
            surname: 'surname');

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
            backgroundImage: NetworkImage(userModel.photo ??
                "https://firebasestorage.googleapis.com/v0/b/oneapp-af948.appspot.com/o/default%2Fdefaultimages.png?alt=media&token=b406faf9-6450-4055-99d3-6e7e3584e927&_gl=1*1xorfwr*_ga*NDEwNTg1MjYzLjE2ODU0NjIyNDc.*_ga_CW55HF8NVT*MTY5ODY4NDc5MS42Ny4xLjE2OTg2ODQ4NjEuNjAuMC4w"),
            onBackgroundImageError: (exception, stackTrace) =>
                showSnackBar(context, exception.toString()),
            radius: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            userModel.displayName,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${userModel.givenName} ${userModel.surname}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(
            height: 16,
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
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            )
                          : const SizedBox(),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _OtherInfo extends ConsumerWidget {
  const _OtherInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel userModel = UserModel(
        name: 'name',
        profilePic:
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
        uid: 'uid',
        email: 'email',
        isAuthenticated: true,
        year: Batch(fromYear: 2022),
        department: Department.aiml,
        section: Section.a,
        rollNO: 'rollNO');

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
