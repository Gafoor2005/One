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
              child: Column(
                children: [
                  const AccountPageProfile(),
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
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shadowColor: Colors.black,
                    surfaceTintColor: Colors.white,
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          title: const Text("Bio"),
                          onTap: () {
                            // Routemaster.of(context).push("/bio");
                          },
                          trailing: const Icon(Icons.navigate_next_rounded),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.event_available_rounded,
                            color: Colors.black,
                          ),
                          title: const Text("attendance"),
                          onTap: () {
                            Routemaster.of(context).push("/set-pass");
                          },
                          trailing: const Icon(Icons.navigate_next_rounded),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.assignment,
                            color: Colors.black,
                          ),
                          title: const Text("marks"),
                          onTap: () {},
                          trailing: const Icon(Icons.navigate_next_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const LogOutButton(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
