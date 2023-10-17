import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/features/home/screens/alerts_page.dart';
import 'package:one/features/home/screens/page1.dart';
import 'package:one/features/home/screens/page2.dart';
import 'package:one/features/home/screens/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget currentBody = const PageOne();

  void changeBody(Widget a) {
    setState(() {
      currentBody = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withAlpha(254),
      // backgroundColor: const Color.fromARGB(255, 107, 58, 244),
      backgroundColor: const Color.fromARGB(255, 161, 141, 219),
      body: currentBody,
      bottomNavigationBar: BottomAppBar(
        // color: const Color.fromRGBO(193, 219, 255, 1),
        color: const Color.fromARGB(255, 15, 16, 77), //  dark mode
        height: 70,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            navItem(
              icon: FontAwesomeIcons.house,
              navTo: const AlertsPage(),
            ),
            navItem(
              icon: FontAwesomeIcons.solidCircleUser,
              navTo: const PageTwo(),
            ),
            navItem(
              icon: FontAwesomeIcons.message,
              navTo: const PostPage(),
            ),
            navItem(
              icon: FontAwesomeIcons.gear,
              navTo: const PageF(),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton navItem({
    required IconData icon,
    required Widget navTo,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (currentBody.toString() != navTo.toString()) {
          changeBody(navTo);
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.square(50),
        maximumSize: const Size.square(50),
        padding: EdgeInsets.zero,
        backgroundColor: currentBody.toString() == navTo.toString()
            ? const Color.fromRGBO(103, 65, 217, 1)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        alignment: Alignment.center,
        // elevation: currentBody.toString() == navTo.toString() ? 0 : 5,
        elevation: 0,
      ),
      child: FaIcon(
        icon,
        color: currentBody.toString() == navTo.toString()
            ? Colors.white
            : const Color.fromRGBO(103, 65, 217, 1),
      ),
    );
  }
}

class PageT extends StatelessWidget {
  const PageT({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PageF extends StatelessWidget {
  const PageF({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// ---------------------------backup code---------------------------
// bottomNavigationBar:  BottomNavigationBar(
//   backgroundColor: Color.fromRGBO(24, 49, 83, 1),
//   // selectedItemColor: Colors.white,
//   showSelectedLabels: false,
//   showUnselectedLabels: false,
//   selectedFontSize: 0,
//   unselectedFontSize: 0,
//   iconSize: 20,
//   items: [
//     BottomNavigationBarItem(
//         activeIcon: Container(
//           margin: EdgeInsets.all(10),
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Color.fromRGBO(103, 65, 217, 1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const FaIcon(
//             FontAwesomeIcons.house,
//             color: Colors.white,
//           ),
//         ),
//         icon: Container(
//           child: const FaIcon(
//             FontAwesomeIcons.house,
//             color: Colors.white,
//           ),
//         ),
//         label: ''),
//     BottomNavigationBarItem(
//         icon: Container(
//           child: const FaIcon(
//             FontAwesomeIcons.circleUser,
//           ),
//         ),
//         label: ''),
//   ],
// ),