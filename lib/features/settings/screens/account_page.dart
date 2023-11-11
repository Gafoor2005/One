import 'package:flutter/material.dart';
import 'package:one/features/auth/widgets/log_out.dart';
import 'package:one/features/settings/widgets/account_page_profile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AccountPageProfile(),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20),
              //   decoration: BoxDecoration(
              //     color: Colors.black,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Column(
              //     children: [
              //       ListTile(
              //         leading: FaIcon(
              //           FontAwesomeIcons.gear,
              //           color: Colors.white,
              //         ),
              //         title: Text(
              //           'general',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //       ListTile(
              //         leading: FaIcon(
              //           FontAwesomeIcons.gear,
              //           color: Colors.white,
              //         ),
              //         title: Text(
              //           'accout settings',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          LogOutButton(),
        ],
      ),
    );
  }
}
