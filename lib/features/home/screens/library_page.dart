import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('library'));
  }
}

// class MyDrawerTile extends StatelessWidget {
//   const MyDrawerTile({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Routemaster.of(context).push('/notif');
//       },
//       child: const Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 5,
//             ),
//             child: FaIcon(
//               FontAwesomeIcons.bell,
//               size: 20,
//             ),
//           ),
//           Text('Notifications'),
//         ],
//       ),
//     );
//   }
// }
