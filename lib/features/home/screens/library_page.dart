import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController(viewportFraction: 1);

    return PageView.builder(
      itemCount: 10,
      controller: _controller,
      itemBuilder: (context, index) {
        return ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            double factor = 1;
            if (_controller.position.hasContentDimensions) {
              factor = 1 - (_controller.page! - index).abs();
            }

            return Center(
              child: SizedBox(
                height: 70 + (factor * 20),
                width: 278,
                child: Card(
                  color: Color.fromRGBO(160, 200, ((1 - factor) * 255).toInt(),
                      factor * factor * factor),
                  shadowColor: Colors.transparent,
                  // elevation: 1,
                  child: Center(
                    child: Text(
                      'Card $index',
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
