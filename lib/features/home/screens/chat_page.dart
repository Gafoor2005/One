import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(
            fontFamily: "BlackHanSans",
            // fontSize: 24,
          ),
        ),
      ),
      body: const SafeArea(
          child: Column(
        children: [
          ChatTile(
            id: '313564',
            lastMessage: '345644sklmfle',
          )
        ],
      )),
    );
  }
}

class ChatTile extends ConsumerWidget {
  final String id;
  final int? unRead;
  final String lastMessage;
  const ChatTile({
    super.key,
    required this.id,
    this.unRead,
    required this.lastMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity.compact,
      // tileColor: Color.fromARGB(255, 164, 208, 239),
      // splashColor: Colors.black45,
      onTap: () {},
      leading: const CircleAvatar(
        backgroundColor: Colors.black,
        backgroundImage: AssetImage('assets/defalutUser.jpg'),
        radius: 24,
      ),
      title: const Text(
        // ref.watch(getMsUserDataProvider("hei")).
        'Gafoor',
        style: TextStyle(
          fontFamily: "AlegreyaSans",
          fontWeight: FontWeight.w800,
          fontSize: 20,
          height: .5,
        ),
      ),
      subtitle: const Text(
        'hey how are you?',
        style: TextStyle(
          fontFamily: "NotoSans",
          fontSize: 12,
          height: .5,
        ),
      ),
      // titleAlignment: ListTileTitleAlignment.bottom,
      trailing: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   '2 mins ago',
            // ),
            CircleAvatar(
              backgroundColor: Colors.green.shade900,
              radius: 12,
              child: const Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
