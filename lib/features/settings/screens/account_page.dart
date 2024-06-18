import 'package:flutter/material.dart';
import 'package:one/features/auth/widgets/log_out.dart';
import 'package:one/features/settings/widgets/account_page_profile.dart';
import 'package:routemaster/routemaster.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("You"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.blue.shade50,
              ),
              child: const Column(
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
            ),
            const LogOutButton(),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomAppBar(),
    );
  }
}
