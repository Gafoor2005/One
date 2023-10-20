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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AccountPageProfile(),
          LogOutButton(),
        ],
      ),
    );
  }
}
